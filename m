Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab3DYUci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:32:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:46027 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759366Ab3DYUbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:50 -0400
Message-Id: <20130425143436.307435149@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 12/15] clockevents: Add module refcount
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline; filename=clockevents-add-module-refcount.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to be able to remove clockevent modules as well. Add a
refcount so we don't remove a module with an active clock event
device.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h   |    3 +++
 kernel/time/clockevents.c    |    1 +
 kernel/time/tick-broadcast.c |    3 +++
 kernel/time/tick-common.c    |    4 ++++
 4 files changed, 11 insertions(+)

Index: tip/include/linux/clockchips.h
===================================================================
--- tip.orig/include/linux/clockchips.h
+++ tip/include/linux/clockchips.h
@@ -16,6 +16,7 @@
 #include <linux/notifier.h>
 
 struct clock_event_device;
+struct module;
 
 /* Clock event mode commands */
 enum clock_event_mode {
@@ -83,6 +84,7 @@ enum clock_event_nofitiers {
  * @irq:		IRQ number (only for non CPU local devices)
  * @cpumask:		cpumask to indicate for which CPUs this device works
  * @list:		list head for the management code
+ * @owner:		module reference
  */
 struct clock_event_device {
 	void			(*event_handler)(struct clock_event_device *);
@@ -112,6 +114,7 @@ struct clock_event_device {
 	int			irq;
 	const struct cpumask	*cpumask;
 	struct list_head	list;
+	struct module		*owner;
 } ____cacheline_aligned;
 
 /*
Index: tip/kernel/time/clockevents.c
===================================================================
--- tip.orig/kernel/time/clockevents.c
+++ tip/kernel/time/clockevents.c
@@ -357,6 +357,7 @@ void clockevents_exchange_device(struct 
 	 * released list and do a notify add later.
 	 */
 	if (old) {
+		module_put(old->owner);
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
Index: tip/kernel/time/tick-broadcast.c
===================================================================
--- tip.orig/kernel/time/tick-broadcast.c
+++ tip/kernel/time/tick-broadcast.c
@@ -19,6 +19,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
+#include <linux/module.h>
 
 #include "tick-internal.h"
 
@@ -73,6 +74,8 @@ void tick_install_broadcast_device(struc
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
 	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return;
+	if (!try_module_get(dev->owner))
+		return;
 
 	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
 	if (cur)
Index: tip/kernel/time/tick-common.c
===================================================================
--- tip.orig/kernel/time/tick-common.c
+++ tip/kernel/time/tick-common.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 
 #include <asm/irq_regs.h>
 
@@ -254,6 +255,9 @@ void tick_check_new_device(struct clock_
 			goto out_bc;
 	}
 
+	if (!try_module_get(newdev->owner))
+		return;
+
 	/*
 	 * Replace the eventually existing device by the new
 	 * device. If the current device is the broadcast device, do


