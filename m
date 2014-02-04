Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaBDRFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:05:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:40501 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754010AbaBDRFF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:05:05 -0500
Date: Tue, 4 Feb 2014 12:05:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Smith <dsmith@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Igor Zhbanov <i.zhbanov@samsung.com>,
        Christoph Hellwig <hch@infradead.org>, Paul Menage <menage@google.com>
Subject: [RFC][PATCH] exec: Fix use after free of tracepoint
 trace_sched_process_exec
Message-ID: <20140204120500.041b5175@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor reported garbage in a trace that looked like this:

           login-1718  [000] ...1  1340.195118: sched_process_exec: filename=/bin/login pid=1718 old_pid=1718
 systemd-cgroups-2061  [006] ...1  1341.672207: sched_process_exec: filename=/usr/lib/systemd/systemd-cgroups-agent pid=2061 old_pid=2061
 systemd-cgroups-2063  [004] ...1  1341.673437: sched_process_exec: filename=ÀÈûÉ pid=2063 old_pid=2063

See the junk in the last line for filename.

Investigating this, I found that the problem is where the tracepoint
lies. In exec.c exec_binprm() we have:

	ret = search_binary_handler(bprm);
	if (ret >= 0) {
		audit_bprm(bprm);
		trace_sched_process_exec(current, old_pid, bprm);

The tracepoint uses bprm->filename to record the process that was
executed. The problem is that the handlers called in
search_binary_handler() can release the process' old memory for the
new memory. The bprm->filename is not in this memory, but the issue is
when this happens, if the parent used a vfork() it will wake up at
that moment. To explain exactly what happens, we have this:

cgroup_release_agent()
 agentbuf = kstrdup();
 argv[0] = argentbuf;
 call_usermodehelper(argv[0],...,UMH_WAIT_EXEC);
  call_usermodehelper_setup()
    sub_info->path = path; (argv[0] from parameter)
    sub_info->work = __call_usermodehelper;
  call_usermodehelper_exec()
    queue_work(subinfo->work);
    wait_for_completion();

Now the work gets called:

__call_usermodehelper
  kernel_thread(call_helper, CLONE_VFORK);

Notice the VFORK flag. This means that the parent will sleep till the
child exits or execs.

call_helper()
  ____call_usermodehelper()
    do_execve(subinfo->path)
      filename = subinfo->path; (filename is allocated agentbuf)
      do_execve_common(filename)
        bprm->filename = filename;
        exec_bprm(bprm)
          search_binary_handler(bprm)
            fmt->load_binary() (load_elf_binary);
              load_elf_binary()
                flush_old_exec()
                  exec_mmap()
                    mm_release()
                      if (tsk->vfork_done)
                         complete_vfork_done(tsk);

Here we wake up the parent. The one that called
kthread_thread(call_helper). Now that one continues to run:

 	case UMH_WAIT_EXEC:
		if (pid < 0)
			sub_info->retval = pid;
		umh_complete(sub_info);

Now this wakes up the process that's waiting for completion. Which
continues to run and does:

		kfree(agentbuf);

This is what bprm->filename points to.

When the search_binary_handler() returns, (with a possibility that
filename has been freed), when it calls the tracepoint, the tracepoint
will record bogus data. Luckily it didn't crash the kernel.

Adding a few strategic trace_printks, we can see this happening:

     kworker/3:1-51    [003] ....    59.700772: cgroup_release_agent: agentbuf = ffff880114fc28c0 /usr/lib/systemd/systemd-cgroups-agent
 systemd-cgroups-1925  [005] ....    59.700866: do_execve_common.isra.25: calling search_binary_handler (bprm->filename=ffff880114fc28c0 /usr/lib/systemd/systemd-cgroups-agent
 systemd-cgroups-1925  [005] ....    59.700867: search_binary_handler: fmt->load_binary = load_misc_binary+0x0/0x302
 systemd-cgroups-1925  [005] ....    59.700868: search_binary_handler: fmt->load_binary = load_script+0x0/0x1e8
 systemd-cgroups-1925  [005] ....    59.700868: search_binary_handler: fmt->load_binary = load_elf_binary+0x0/0x179b
 systemd-cgroups-1925  [005] ....    59.700876: flush_old_exec: calling exec_mmap bprm->filename=ffff880114fc28c0 /usr/lib/systemd/systemd-cgroups-agent
 systemd-cgroups-1925  [005] ....    59.700876: flush_old_exec: calling mm_release
 systemd-cgroups-1925  [005] ....    59.700876: mm_release: tsk->vfork_done = ffff880000091d68
     kworker/3:1-51    [003] ....    59.700904: cgroup_release_agent: freeing agentbuf
 systemd-cgroups-1925  [005] ....    59.700911: do_execve_common.isra.25: back from binary (bprm->filename=ffff880114fc28c0 @$üÿÿ/systemd/systemd-cgroups-agent
 systemd-cgroups-1925  [005] ...1    59.700912: sched_process_exec: filename=@$üÿÿ/systemd/systemd-cgroups-agent pid=1925 old_pid=1925


The junk starts after "freeing agentbuf"

Now to fix this we need to save the filename before calling
search_binary_handler(). But we don't want to save it if we are not
tracing. Why slow everyone else down?  To prevent this, I added
a static key branch (nop or unconditional jump) that gets enabled when
the tracepoint sched_process_exec is registered, and disabled when the
tracepoint is unregistered.

When the tracepoint is registered, the filename will be allocated by a
kstrdup and freed after the call. If filename fails to allocate, we
simply fall back to brpm->tcomm (just the name, not the path).

This works, but is rather ugly. Looking for any other suggestions here.

Reported-by: Igor Zhbanov <i.zhbanov@samsung.com>
[ I'm assuming this is the right person. All I have is a nick "IZh" on IRC]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/fs/exec.c b/fs/exec.c
index e1529b4..9bb1b0f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1407,9 +1407,22 @@ int search_binary_handler(struct linux_binprm *bprm)
 }
 EXPORT_SYMBOL(search_binary_handler);
 
+static struct static_key sched_process_exec_key = STATIC_KEY_INIT_FALSE;
+
+void sched_process_exec_key_reg(void)
+{
+	static_key_slow_inc(&sched_process_exec_key);
+}
+
+void sched_process_exec_key_unreg(void)
+{
+	static_key_slow_dec(&sched_process_exec_key);
+}
+
 static int exec_binprm(struct linux_binprm *bprm)
 {
 	pid_t old_pid, old_vpid;
+	char *filename;
 	int ret;
 
 	/* Need to fetch pid before load_binary changes it */
@@ -1418,10 +1431,34 @@ static int exec_binprm(struct linux_binprm *bprm)
 	old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
 	rcu_read_unlock();
 
-	ret = search_binary_handler(bprm);
+	/*
+	 * When the sched_process_exec tracepoint is activated, it
+	 * enables the static key sched_process_exec_key to do some more
+	 * work. The issue is that the tracepoint wants to record the
+	 * filename of the bprm but only if search_binary_handler() returns
+	 * without an error. The problem is that the search_binary_handler()
+	 * may call mm_release() which can wake up the parent that did a vfork
+	 * (see cgroup call_usermodehelper()) and the parent may free bprm->filename.
+	 *
+	 * The filename must be saved before calling search_binary_handler().
+	 * But as this is only needed for tracing, only do this work if
+	 * the tracepoint is enabled.
+	 *
+	 * The static key usage removes conditional branches as well.
+	 */ 
+	if (static_key_false(&sched_process_exec_key)) {
+		/* If filename fails to alloc, just use tcomm */
+		filename = kstrdup(bprm->filename, GFP_KERNEL);
+		ret = search_binary_handler(bprm);
+		if (ret >= 0)
+			trace_sched_process_exec(current, old_pid,
+						 filename ? filename : bprm->tcomm);
+		kfree(filename);
+	} else
+		ret = search_binary_handler(bprm);
+
 	if (ret >= 0) {
 		audit_bprm(bprm);
-		trace_sched_process_exec(current, old_pid, bprm);
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 		proc_exec_connector(current);
 	}
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 67e1bbf..a7eaa06 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -276,30 +276,35 @@ TRACE_EVENT(sched_process_fork,
 		__entry->child_comm, __entry->child_pid)
 );
 
+extern void sched_process_exec_key_reg(void);
+extern void sched_process_exec_key_unreg(void);
+
 /*
  * Tracepoint for exec:
  */
-TRACE_EVENT(sched_process_exec,
+TRACE_EVENT_FN(sched_process_exec,
 
-	TP_PROTO(struct task_struct *p, pid_t old_pid,
-		 struct linux_binprm *bprm),
+	TP_PROTO(struct task_struct *p, pid_t old_pid, char *filename),
 
-	TP_ARGS(p, old_pid, bprm),
+	TP_ARGS(p, old_pid, filename),
 
 	TP_STRUCT__entry(
-		__string(	filename,	bprm->filename	)
+		__string(	filename,	filename	)
 		__field(	pid_t,		pid		)
 		__field(	pid_t,		old_pid		)
 	),
 
 	TP_fast_assign(
-		__assign_str(filename, bprm->filename);
+		__assign_str(filename, filename);
 		__entry->pid		= p->pid;
 		__entry->old_pid	= old_pid;
 	),
 
 	TP_printk("filename=%s pid=%d old_pid=%d", __get_str(filename),
-		  __entry->pid, __entry->old_pid)
+		  __entry->pid, __entry->old_pid),
+
+	sched_process_exec_key_reg,
+	sched_process_exec_key_unreg
 );
 
 /*
