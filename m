Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaCWOUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 10:20:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:57834 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaCWOUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 10:20:35 -0400
Message-Id: <20140323141939.911487677@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 14:20:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Tejun Heo <tj@kernel.org>
Subject: [patch 1/2] workqueue: Provide destroy_delayed_work_on_stack()
References: <20140323141648.703530841@linutronix.de>
Content-Disposition: inline;
 filename=workqueue-add-destroy-delayed-work-on-stack.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a delayed or deferrable work is on stack we need to tell debug
objects that we are destroying the timer and the work. Otherwise we
leak the tracking object.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    2 ++
 kernel/workqueue.c        |    7 +++++++
 2 files changed, 9 insertions(+)

Index: tip/include/linux/workqueue.h
===================================================================
--- tip.orig/include/linux/workqueue.h
+++ tip/include/linux/workqueue.h
@@ -191,6 +191,7 @@ struct execute_work {
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 extern void __init_work(struct work_struct *work, int onstack);
 extern void destroy_work_on_stack(struct work_struct *work);
+extern void destroy_delayed_work_on_stack(struct delayed_work *work);
 static inline unsigned int work_static(struct work_struct *work)
 {
 	return *work_data_bits(work) & WORK_STRUCT_STATIC;
@@ -198,6 +199,7 @@ static inline unsigned int work_static(s
 #else
 static inline void __init_work(struct work_struct *work, int onstack) { }
 static inline void destroy_work_on_stack(struct work_struct *work) { }
+static inline void destroy_delayed_work_on_stack(struct delayed_work *work) { }
 static inline unsigned int work_static(struct work_struct *work) { return 0; }
 #endif
 
Index: tip/kernel/workqueue.c
===================================================================
--- tip.orig/kernel/workqueue.c
+++ tip/kernel/workqueue.c
@@ -516,6 +516,13 @@ void destroy_work_on_stack(struct work_s
 }
 EXPORT_SYMBOL_GPL(destroy_work_on_stack);
 
+void destroy_delayed_work_on_stack(struct delayed_work *work)
+{
+	destroy_timer_on_stack(&work->timer);
+	debug_object_free(&work->work, &work_debug_descr);
+}
+EXPORT_SYMBOL_GPL(destroy_delayed_work_on_stack);
+
 #else
 static inline void debug_work_activate(struct work_struct *work) { }
 static inline void debug_work_deactivate(struct work_struct *work) { }


