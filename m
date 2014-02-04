Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaBDX25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:28:57 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:44767 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754728AbaBDX2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:28:55 -0500
Date: Tue, 4 Feb 2014 18:28:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Smith <dsmith@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Igor Zhbanov <i.zhbanov@samsung.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] exec: Fix use after free of tracepoint
 trace_sched_process_exec
Message-ID: <20140204182852.43ffa442@gandalf.local.home>
In-Reply-To: <CA+55aFyObrVGXqncNboMzybeevPBOtAUcn-zur_B26VHJ1CEcg@mail.gmail.com>
References: <20140204120500.041b5175@gandalf.local.home>
	<CA+55aFyObrVGXqncNboMzybeevPBOtAUcn-zur_B26VHJ1CEcg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014 12:18:53 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> That's too ugly to live.

New patch. Not as ugly. Well, I think this one lacks ugly enough to be
worth living for.

It's dependent on another patch that adds a helper function for
tracepoints, that allows users to implicitly use static_key of a
tracepoint to see if it is enabled or not. Basically, it's:

#define tracepoint_enabled(name) \
	static_key_false(&__tracepoint_##name.key)

This uses the same key that the tracepoint has when it is enabled. It
may be enabled before or after the tracepoint is, but in cases like
these, it doesn't really matter.

At least this patch keeps the ugliness with the code. I could even
encapsulate that in a static inline function to remove the ugliness out
of exec_binprm().

Note, this still requires some comments added to the code.

Butt-ugly-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/fs/exec.c b/fs/exec.c
index e1529b4..f7902aef 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1421,7 +1421,22 @@ static int exec_binprm(struct linux_binprm *bprm)
 	ret = search_binary_handler(bprm);
 	if (ret >= 0) {
 		audit_bprm(bprm);
-		trace_sched_process_exec(current, old_pid, bprm);
+		if (tracepoint_enabled(sched_process_exec)) {
+			char *tmp = (char*)__get_free_page(GFP_TEMPORARY);
+			char *pathname;
+
+			if (tmp)
+				pathname = dentry_path_raw(bprm->file->f_dentry,
+							   tmp, PAGE_SIZE);
+			else
+				pathname = ERR_PTR(-ENOMEM);
+			if (IS_ERR(pathname))
+				trace_sched_process_exec(current, old_pid,
+							 "//error-no-mem");
+			else
+				trace_sched_process_exec(current, old_pid, pathname);
+			free_page((unsigned long)tmp);
+		}
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
