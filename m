Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbaBDXmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:42:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:18780 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754792AbaBDXmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:42:11 -0500
Date: Tue, 4 Feb 2014 18:42:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Smith <dsmith@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Igor Zhbanov <i.zhbanov@samsung.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] exec: Fix use after free of tracepoint
 trace_sched_process_exec
Message-ID: <20140204184208.6f4f22a8@gandalf.local.home>
In-Reply-To: <20140204182852.43ffa442@gandalf.local.home>
References: <20140204120500.041b5175@gandalf.local.home>
	<CA+55aFyObrVGXqncNboMzybeevPBOtAUcn-zur_B26VHJ1CEcg@mail.gmail.com>
	<20140204182852.43ffa442@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014 18:28:52 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> At least this patch keeps the ugliness with the code. I could even
> encapsulate that in a static inline function to remove the ugliness out
> of exec_binprm().

New version that moves all the ugliness into a static inline helper
function.

I'll start testing this and the added helper, and if there's no
problems or arguments from you, I'll post them tomorrow.

-- Steve

diff --git a/fs/exec.c b/fs/exec.c
index e1529b4..06101e9 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1407,6 +1407,36 @@ int search_binary_handler(struct linux_binprm *bprm)
 }
 EXPORT_SYMBOL(search_binary_handler);
 
+static __always_inline void
+do_trace_sched_process_exec(pid_t old_pid, struct linux_binprm *bprm)
+{
+	char *pathname;
+	char *tmp;
+
+	/*
+	 * We can't use bprm->filename here because it can be freed
+	 * within the search_binary_handler() call (by mm_release()
+	 * waking up the cgroup call_usermodehelper parent, that
+	 * will free what bprm->filename points to). Instead, if
+	 * the sched_process_exec tracepoint is enabled, we need
+	 * to create the pathname from the file dentry pointer.
+	 */
+	if (tracepoint_enabled(sched_process_exec)) {
+		tmp = (char*)__get_free_page(GFP_TEMPORARY);
+		if (tmp)
+			pathname = dentry_path_raw(bprm->file->f_dentry,
+						   tmp, PAGE_SIZE);
+		else
+			pathname = ERR_PTR(-ENOMEM);
+		if (IS_ERR(pathname))
+			trace_sched_process_exec(current, old_pid,
+						 "//error-no-mem");
+		else
+			trace_sched_process_exec(current, old_pid, pathname);
+		free_page((unsigned long)tmp);
+	}
+}
+
 static int exec_binprm(struct linux_binprm *bprm)
 {
 	pid_t old_pid, old_vpid;
@@ -1421,7 +1451,7 @@ static int exec_binprm(struct linux_binprm *bprm)
 	ret = search_binary_handler(bprm);
 	if (ret >= 0) {
 		audit_bprm(bprm);
-		trace_sched_process_exec(current, old_pid, bprm);
+		do_trace_sched_process_exec(old_pid, bprm);
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 		proc_exec_connector(current);
 	}
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 67e1bbf..520ba9a 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -282,18 +282,18 @@ TRACE_EVENT(sched_process_fork,
 TRACE_EVENT(sched_process_exec,
 
 	TP_PROTO(struct task_struct *p, pid_t old_pid,
-		 struct linux_binprm *bprm),
+		 const char *pathname),
 
-	TP_ARGS(p, old_pid, bprm),
+	TP_ARGS(p, old_pid, pathname),
 
 	TP_STRUCT__entry(
-		__string(	filename,	bprm->filename	)
+		__string(	filename,	pathname	)
 		__field(	pid_t,		pid		)
 		__field(	pid_t,		old_pid		)
 	),
 
 	TP_fast_assign(
-		__assign_str(filename, bprm->filename);
+		__assign_str(filename, pathname);
 		__entry->pid		= p->pid;
 		__entry->old_pid	= old_pid;
 	),
