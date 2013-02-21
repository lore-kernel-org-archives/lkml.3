Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3BUHqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 02:46:42 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:11200 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3BUHql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 02:46:41 -0500
Subject: Re: prctl(PR_SET_MM)
To: gorcunov@openvz.org (Cyrill Gorcunov)
Date: Thu, 21 Feb 2013 18:46:39 +1100 (EST)
Cc: rostedt@goodmis.org (Steven Rostedt), u3557@dialix.com.au,
        oleg@redhat.com (Oleg Nesterov), palves@redhat.com (Pedro Alves),
        dvlasenk@redhat.com (Denys Vlasenko),
        jan.kratochvil@redhat.com (Jan Kratochvil),
        xemul@parallels.com (Pavel Emelyanov),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org (Andrew Morton)
Reply-To: u3557@dialix.com.au
In-Reply-To: <20130220105109.GW20312@moon>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="%--multipart-mixed-boundary-1.47414.1361432799--%"
Message-Id: <20130221074639.4880D592064@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--%--multipart-mixed-boundary-1.47414.1361432799--%
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Cyrill Gorcunov wrote:

>> Another possibility is to have a dual #if:
>>
>> #if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_MM_FIELDS_SETTING)
>
> Thus this approach looks preferred. And MM_FIELDS_SETTING will be y by default.
> Mind to cook a patch and lets see if community accept it? Don't forget to
> CC Andrew Morton.

Very well, patch attached.

Amnon.

--%--multipart-mixed-boundary-1.47414.1361432799--%
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Description: unified diff output, ASCII text
Content-Disposition: attachment; filename="patch-mm-fields-setting"

diff -Naur before/init/Kconfig after/init/Kconfig
--- before/init/Kconfig	2013-02-19 10:28:34.000000000 +1030
+++ after/init/Kconfig	2013-02-21 18:03:48.000000000 +1030
@@ -999,6 +999,22 @@
 
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
diff -Naur before/kernel/sys.c after/kernel/sys.c
--- before/kernel/sys.c	2013-02-19 10:28:34.000000000 +1030
+++ after/kernel/sys.c	2013-02-21 17:19:10.000000000 +1030
@@ -1788,7 +1788,7 @@
 	return mask;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_MM_FIELDS_SETTING)
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
 	struct fd exe;
@@ -1981,18 +1981,22 @@
 	up_read(&mm->mmap_sem);
 	return error;
 }
+#else /* CONFIG_CHECKPOINT_RESTORE || CONFIG_MM_FIELDS_SETTING */
 
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

--%--multipart-mixed-boundary-1.47414.1361432799--%--
