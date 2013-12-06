Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161354Ab3LFWDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:03:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759474Ab3LFVyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:54:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kim Phillips <kim.phillips@linaro.org>
Subject: [PATCH 3.10 46/58] clockevents: Add module refcount
Date: Fri,  6 Dec 2013 13:52:17 -0800
Message-Id: <20131206214849.158812163@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit ccf33d6880f39a35158fff66db13000ae4943fac upstream.

We want to be able to remove clockevent modules as well. Add a
refcount so we don't remove a module with an active clock event
device.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143436.307435149@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kim Phillips <kim.phillips@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/clockchips.h   |    3 +++
 kernel/time/clockevents.c    |    1 +
 kernel/time/tick-broadcast.c |    3 +++
 kernel/time/tick-common.c    |    4 ++++
 4 files changed, 11 insertions(+)

--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -30,6 +30,7 @@ enum clock_event_nofitiers {
 #include <linux/notifier.h>
 
 struct clock_event_device;
+struct module;
 
 /* Clock event mode commands */
 enum clock_event_mode {
@@ -83,6 +84,7 @@ enum clock_event_mode {
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
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -392,6 +392,7 @@ void clockevents_exchange_device(struct
 	 * released list and do a notify add later.
 	 */
 	if (old) {
+		module_put(old->owner);
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -19,6 +19,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
+#include <linux/module.h>
 
 #include "tick-internal.h"
 
@@ -74,6 +75,8 @@ void tick_install_broadcast_device(struc
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
 	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return;
+	if (!try_module_get(dev->owner))
+		return;
 
 	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
 	if (cur)
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 
 #include <asm/irq_regs.h>
 
@@ -261,6 +262,9 @@ void tick_check_new_device(struct clock_
 			goto out_bc;
 	}
 
+	if (!try_module_get(newdev->owner))
+		return;
+
 	/*
 	 * Replace the eventually existing device by the new
 	 * device. If the current device is the broadcast device, do


