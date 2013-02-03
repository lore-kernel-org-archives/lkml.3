Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3BCTRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:17:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50706 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3BCTRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:17:14 -0500
Date: Sun, 3 Feb 2013 11:16:55 -0800
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-d75f717e19fe595e7efbf67de195ada8d89dfbbe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mathieu.desnoyers@efficios.com, viro@ZenIV.linux.org.uk,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, rostedt@goodmis.org,
        viro@ZenIV.linux.org.uk, srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20130123225523.GY4939@ZenIV.linux.org.uk>
References: <20130123225523.GY4939@ZenIV.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Remove tracepoint sample code
Git-Commit-ID: d75f717e19fe595e7efbf67de195ada8d89dfbbe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 03 Feb 2013 11:17:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d75f717e19fe595e7efbf67de195ada8d89dfbbe
Gitweb:     http://git.kernel.org/tip/d75f717e19fe595e7efbf67de195ada8d89dfbbe
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 25 Jan 2013 09:46:36 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 25 Jan 2013 11:22:11 -0500

tracing: Remove tracepoint sample code

The tracepoint sample code was used to teach developers how to
create their own tracepoints. But now the trace_events have been
added as a higher level that is used directly by developers today.

Only the trace_event code should use the tracepoint interface
directly and no new tracepoints should be added.

Besides, the example had a race condition with the use of the
 ->d_name.name dentry field, as pointed out by Al Viro.

Best just to remove the code so it wont be used by other developers.

Link: http://lkml.kernel.org/r/20130123225523.GY4939@ZenIV.linux.org.uk

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 samples/Kconfig                                |  6 ---
 samples/Makefile                               |  2 +-
 samples/tracepoints/Makefile                   |  6 ---
 samples/tracepoints/tp-samples-trace.h         | 11 -----
 samples/tracepoints/tracepoint-probe-sample.c  | 57 --------------------------
 samples/tracepoints/tracepoint-probe-sample2.c | 44 --------------------
 samples/tracepoints/tracepoint-sample.c        | 57 --------------------------
 7 files changed, 1 insertion(+), 182 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index 7b6792a..6181c2c 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -5,12 +5,6 @@ menuconfig SAMPLES
 
 if SAMPLES
 
-config SAMPLE_TRACEPOINTS
-	tristate "Build tracepoints examples -- loadable modules only"
-	depends on TRACEPOINTS && m
-	help
-	  This build tracepoints example modules.
-
 config SAMPLE_TRACE_EVENTS
 	tristate "Build trace_events examples -- loadable modules only"
 	depends on EVENT_TRACING && m
diff --git a/samples/Makefile b/samples/Makefile
index 5ef08bb..1a60c62 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,4 +1,4 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/ \
+obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ \
 			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/
diff --git a/samples/tracepoints/Makefile b/samples/tracepoints/Makefile
deleted file mode 100644
index 36479ad..0000000
--- a/samples/tracepoints/Makefile
+++ /dev/null
@@ -1,6 +0,0 @@
-# builds the tracepoint example kernel modules;
-# then to use one (as root):  insmod <module_name.ko>
-
-obj-$(CONFIG_SAMPLE_TRACEPOINTS) += tracepoint-sample.o
-obj-$(CONFIG_SAMPLE_TRACEPOINTS) += tracepoint-probe-sample.o
-obj-$(CONFIG_SAMPLE_TRACEPOINTS) += tracepoint-probe-sample2.o
diff --git a/samples/tracepoints/tp-samples-trace.h b/samples/tracepoints/tp-samples-trace.h
deleted file mode 100644
index 4d46be9..0000000
--- a/samples/tracepoints/tp-samples-trace.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef _TP_SAMPLES_TRACE_H
-#define _TP_SAMPLES_TRACE_H
-
-#include <linux/proc_fs.h>	/* for struct inode and struct file */
-#include <linux/tracepoint.h>
-
-DECLARE_TRACE(subsys_event,
-	TP_PROTO(struct inode *inode, struct file *file),
-	TP_ARGS(inode, file));
-DECLARE_TRACE_NOARGS(subsys_eventb);
-#endif
diff --git a/samples/tracepoints/tracepoint-probe-sample.c b/samples/tracepoints/tracepoint-probe-sample.c
deleted file mode 100644
index 744c0b9..0000000
--- a/samples/tracepoints/tracepoint-probe-sample.c
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
- * tracepoint-probe-sample.c
- *
- * sample tracepoint probes.
- */
-
-#include <linux/module.h>
-#include <linux/file.h>
-#include <linux/dcache.h>
-#include "tp-samples-trace.h"
-
-/*
- * Here the caller only guarantees locking for struct file and struct inode.
- * Locking must therefore be done in the probe to use the dentry.
- */
-static void probe_subsys_event(void *ignore,
-			       struct inode *inode, struct file *file)
-{
-	path_get(&file->f_path);
-	dget(file->f_path.dentry);
-	printk(KERN_INFO "Event is encountered with filename %s\n",
-		file->f_path.dentry->d_name.name);
-	dput(file->f_path.dentry);
-	path_put(&file->f_path);
-}
-
-static void probe_subsys_eventb(void *ignore)
-{
-	printk(KERN_INFO "Event B is encountered\n");
-}
-
-static int __init tp_sample_trace_init(void)
-{
-	int ret;
-
-	ret = register_trace_subsys_event(probe_subsys_event, NULL);
-	WARN_ON(ret);
-	ret = register_trace_subsys_eventb(probe_subsys_eventb, NULL);
-	WARN_ON(ret);
-
-	return 0;
-}
-
-module_init(tp_sample_trace_init);
-
-static void __exit tp_sample_trace_exit(void)
-{
-	unregister_trace_subsys_eventb(probe_subsys_eventb, NULL);
-	unregister_trace_subsys_event(probe_subsys_event, NULL);
-	tracepoint_synchronize_unregister();
-}
-
-module_exit(tp_sample_trace_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mathieu Desnoyers");
-MODULE_DESCRIPTION("Tracepoint Probes Samples");
diff --git a/samples/tracepoints/tracepoint-probe-sample2.c b/samples/tracepoints/tracepoint-probe-sample2.c
deleted file mode 100644
index 9fcf990..0000000
--- a/samples/tracepoints/tracepoint-probe-sample2.c
+++ /dev/null
@@ -1,44 +0,0 @@
-/*
- * tracepoint-probe-sample2.c
- *
- * 2nd sample tracepoint probes.
- */
-
-#include <linux/module.h>
-#include <linux/fs.h>
-#include "tp-samples-trace.h"
-
-/*
- * Here the caller only guarantees locking for struct file and struct inode.
- * Locking must therefore be done in the probe to use the dentry.
- */
-static void probe_subsys_event(void *ignore,
-			       struct inode *inode, struct file *file)
-{
-	printk(KERN_INFO "Event is encountered with inode number %lu\n",
-		inode->i_ino);
-}
-
-static int __init tp_sample_trace_init(void)
-{
-	int ret;
-
-	ret = register_trace_subsys_event(probe_subsys_event, NULL);
-	WARN_ON(ret);
-
-	return 0;
-}
-
-module_init(tp_sample_trace_init);
-
-static void __exit tp_sample_trace_exit(void)
-{
-	unregister_trace_subsys_event(probe_subsys_event, NULL);
-	tracepoint_synchronize_unregister();
-}
-
-module_exit(tp_sample_trace_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mathieu Desnoyers");
-MODULE_DESCRIPTION("Tracepoint Probes Samples");
diff --git a/samples/tracepoints/tracepoint-sample.c b/samples/tracepoints/tracepoint-sample.c
deleted file mode 100644
index f4d89e0..0000000
--- a/samples/tracepoints/tracepoint-sample.c
+++ /dev/null
@@ -1,57 +0,0 @@
-/* tracepoint-sample.c
- *
- * Executes a tracepoint when /proc/tracepoint-sample is opened.
- *
- * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
- *
- * This file is released under the GPLv2.
- * See the file COPYING for more details.
- */
-
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/proc_fs.h>
-#include "tp-samples-trace.h"
-
-DEFINE_TRACE(subsys_event);
-DEFINE_TRACE(subsys_eventb);
-
-struct proc_dir_entry *pentry_sample;
-
-static int my_open(struct inode *inode, struct file *file)
-{
-	int i;
-
-	trace_subsys_event(inode, file);
-	for (i = 0; i < 10; i++)
-		trace_subsys_eventb();
-	return -EPERM;
-}
-
-static const struct file_operations mark_ops = {
-	.open = my_open,
-	.llseek = noop_llseek,
-};
-
-static int __init sample_init(void)
-{
-	printk(KERN_ALERT "sample init\n");
-	pentry_sample = proc_create("tracepoint-sample", 0444, NULL,
-		&mark_ops);
-	if (!pentry_sample)
-		return -EPERM;
-	return 0;
-}
-
-static void __exit sample_exit(void)
-{
-	printk(KERN_ALERT "sample exit\n");
-	remove_proc_entry("tracepoint-sample", NULL);
-}
-
-module_init(sample_init)
-module_exit(sample_exit)
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mathieu Desnoyers");
-MODULE_DESCRIPTION("Tracepoint sample");
