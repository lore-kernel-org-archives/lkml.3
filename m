Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3BXG2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 01:28:37 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:55295 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3BXG2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 01:28:36 -0500
Subject: Re: prctl(PR_SET_MM)
To: akpm@linux-foundation.org (Andrew Morton)
Date: Sun, 24 Feb 2013 17:28:33 +1100 (EST)
Cc: rostedt@goodmis.org, oleg@redhat.com, palves@redhat.com, oleg@redhat.com,
        palves@redhat.com, dvlasenk@redhat.com, jan.kratochvil@redhat.com,
        xemul@parallels.com, fweisbec@gmail.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20130222142603.987c6e3c.akpm@linux-foundation.org>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="%--multipart-mixed-boundary-2.83095.1361687313--%"
Message-Id: <20130224062833.EFCE259205C@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--%--multipart-mixed-boundary-2.83095.1361687313--%
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Dear Andrew,

Andrew Morton <akpm@linux-foundation.org> Wrote:
> Well OK.  Put all that on top of a patch, add suitable signoffs and
> cc's and send it along?

The purpose of this patch is to allow privileged processes to set
their own per-memory memory-region fields:

      start_code, end_code, start_data, end_data, start_brk, brk,
      start_stack, arg_start, arg_end, env_start, env_end.

This functionality is needed by any application or package that
needs to reconstruct Linux processes, that is, to start them in
any way other than by means of an "execve()" from an executable
file.  This includes:

1. Restoring processes from a checkpoint-file (by all potential
   user-level checkpointing packages, not only CRIU's).
2. Restarting processes on another node after process migration.
3. Starting duplicated copies of a running process (for reliability
   and high-availablity).
4. Starting a process from an executable format that is not supported
   by Linux, thus requiring a "manual execve" by a user-level utility.
5. Similarly, starting a process from a networked and/or crypted
   executable that, for confidentiality, licensing or other reasons,
   may not be written to the local file-systems.

The code that does that was already included in the Linux kernel by
the CRIU group, in the form of "prctl(PR_SET_MM)", but prior to this
was enclosed within their private "#ifdef CONFIG_CHECKPOINT_RESTORE",
which is normally disabled.

It was not clear from your answer, Andrew, whether you prefer to
remove the "#ifdef CONFIG_CHECKPOINT_RESTORE" altogether from the
said code, or to enclose it in a new configuration option that is
enabled by default.   I therefore attach two alternative patches
to choose from: the first removes the #ifdef altogether while the
second introduces a new option.

Signed-off-by: Amnon Shiloh.

Best Regards,
Amnon.


> On Fri, 22 Feb 2013 12:18:01 +1100 (EST)
> u3557@miso.sublimeip.com (Amnon Shiloh) wrote:
> 
> > The code in "kernel/sys.c" that is currently within
> > CONFIG_CHECKPOINT_RESTORE is in fact, as I explain below,
> > one possible solution to a general issue, required by a wide
> > class of applications.  It just so happened that the CRIU group
> > were the first to place this, or an equivalent code, in the kernel,
> > that allows a privileged process to set its 11 per-process memory-region
> > fields:
> >      start_code, end_code, start_data, end_data, start_brk, brk,
> >      start_stack, arg_start, arg_end, env_start, env_end.
> > 
> > 
> > Contrary to the rest of the CHECKPOINT_RESTORE code, which is specific
> > to the CRIU package, the code in "kernel/sys.c" (or its equivalent) is
> > needed by ANY application or package that needs to reconstruct Linux
> > processes, that means, starting them from the middle rather than from
> > an executable file.
> > 
> > That includes user-level checkpointing (any, not just CRIU's),
> > process-migration (to other computers, as my own package does)
> > and process duplication (for high-availability/reliability) -
> > in fact even for starting a process from an executable format
> > that is not supported by Linux, thus requiring a "manual execve"
> > by a user-level utility.
> > 
> > My first preference is to remove that "#ifdef CONFIG_CHECKPOINT_RESTORE"
> > altogether.  Note that there are no security issues because this code
> > is already restricted to "capable(CAP_SYS_RESOURCE)".
> > Short of that is the proposed patch.
> 
> Well OK.  Put all that on top of a patch, add suitable signoffs and
> cc's and send it along?
> 

--%--multipart-mixed-boundary-2.83095.1361687313--%
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Description: unified diff output, ASCII text
Content-Disposition: attachment; filename="option2"

diff -Naur linux-3.8/init/Kconfig option2/init/Kconfig
--- linux-3.8/init/Kconfig	2013-02-19 10:28:34.000000000 +1030
+++ option2/init/Kconfig	2013-02-24 13:57:02.000000000 +1030
@@ -991,6 +991,7 @@
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support" if EXPERT
 	default n
+	select MM_FIELDS_SETTING
 	help
 	  Enables additional kernel features in a sake of checkpoint/restore.
 	  In particular it adds auxiliary prctl codes to setup process text,
@@ -999,6 +1000,22 @@
 
 	  If unsure, say N here.
 
+config MM_FIELDS_SETTING
+	bool "Allow modifying per-process memory-region fields"
+	default y
+	help
+	   Support "prctl(PR_SET_MM)" which allows applications to modify
+	   the following in their "mm_struct":
+
+	      start_code, end_code, start_data, end_data, start_brk, brk,
+	      start_stack, arg_start, arg_end, env_start, env_end.
+
+	    Also to modify their executable file ("/proc/self/exe").
+
+	    This option is needed for reconstructing processes (such as when
+	    restoring a process from a checkpoint; duplicating a process;
+	    or migrating it to another computer).
+
 menuconfig NAMESPACES
 	bool "Namespaces support" if EXPERT
 	default !EXPERT
diff -Naur linux-3.8/kernel/sys.c option2/kernel/sys.c
--- linux-3.8/kernel/sys.c	2013-02-19 10:28:34.000000000 +1030
+++ option2/kernel/sys.c	2013-02-24 10:37:08.000000000 +1030
@@ -1788,7 +1788,7 @@
 	return mask;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#ifdef CONFIG_MM_FIELDS_SETTING
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
 	struct fd exe;
@@ -1981,18 +1981,22 @@
 	up_read(&mm->mmap_sem);
 	return error;
 }
+#else /* CONFIG_MM_FIELDS_SETTING */
 
-static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
-{
-	return put_user(me->clear_child_tid, tid_addr);
-}
-
-#else /* CONFIG_CHECKPOINT_RESTORE */
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
 	return -EINVAL;
 }
+#endif
+
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
+{
+	return put_user(me->clear_child_tid, tid_addr);
+}
+
+#else
 static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
 {
 	return -EINVAL;

--%--multipart-mixed-boundary-2.83095.1361687313--%
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Description: unified diff output, ASCII text
Content-Disposition: attachment; filename="option1"

diff -Naur linux-3.8/kernel/sys.c option1/kernel/sys.c
--- linux-3.8/kernel/sys.c	2013-02-19 10:28:34.000000000 +1030
+++ option1/kernel/sys.c	2013-02-24 10:47:45.000000000 +1030
@@ -1788,7 +1788,6 @@
 	return mask;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
 	struct fd exe;
@@ -1982,17 +1981,12 @@
 	return error;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
 {
 	return put_user(me->clear_child_tid, tid_addr);
 }
-
-#else /* CONFIG_CHECKPOINT_RESTORE */
-static int prctl_set_mm(int opt, unsigned long addr,
-			unsigned long arg4, unsigned long arg5)
-{
-	return -EINVAL;
-}
+#else
 static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
 {
 	return -EINVAL;

--%--multipart-mixed-boundary-2.83095.1361687313--%--
