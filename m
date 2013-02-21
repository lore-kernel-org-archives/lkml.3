Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3BUIAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:00:34 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:41243 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3BUIAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:00:32 -0500
Date: Thu, 21 Feb 2013 12:00:28 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, u3557@dialix.com.au,
        Oleg Nesterov <oleg@redhat.com>, Pedro Alves <palves@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: prctl(PR_SET_MM)
Message-ID: <20130221080028.GE1740@moon>
References: <20130220105109.GW20312@moon>
 <20130221074639.4880D592064@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130221074639.4880D592064@miso.sublimeip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 06:46:39PM +1100, Amnon Shiloh wrote:
> Cyrill Gorcunov wrote:
> 
> >> Another possibility is to have a dual #if:
> >>
> >> #if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_MM_FIELDS_SETTING)
> >
> > Thus this approach looks preferred. And MM_FIELDS_SETTING will be y by default.
> > Mind to cook a patch and lets see if community accept it? Don't forget to
> > CC Andrew Morton.
> 
> Very well, patch attached.

Wouldn't the below do the same trick but eliminate OR in preproc code?
---
From: Amnon Shiloh <u3557@miso.sublimeip.com>
Subject: prctl: Make PR_SET_MM being depend on own CONFIG_MM_FIELDS_SETTING

...

Signed-off-by: Amnon Shiloh <u3557@miso.sublimeip.com>
---
 init/Kconfig |   17 +++++++++++++++++
 kernel/sys.c |   16 ++++++++--------
 2 files changed, 25 insertions(+), 8 deletions(-)

Index: linux-2.6.git/init/Kconfig
===================================================================
--- linux-2.6.git.orig/init/Kconfig
+++ linux-2.6.git/init/Kconfig
@@ -991,6 +991,7 @@ endif # CGROUPS
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support" if EXPERT
 	default n
+	select MM_FIELDS_SETTING
 	help
 	  Enables additional kernel features in a sake of checkpoint/restore.
 	  In particular it adds auxiliary prctl codes to setup process text,
@@ -999,6 +1000,22 @@ config CHECKPOINT_RESTORE
 
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
Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1788,7 +1788,7 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#ifdef CONFIG_MM_FIELDS_SETTING
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
 	struct fd exe;
@@ -1981,23 +1981,23 @@ out:
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
 static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
 {
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	return put_user(me->clear_child_tid, tid_addr);
+#else
 	return -EINVAL;
-}
 #endif
+}
 
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
