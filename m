Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3E0Jzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:55:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35530 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab3E0Jzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:55:31 -0400
Date: Mon, 27 May 2013 02:55:16 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-ccf33d6880f39a35158fff66db13000ae4943fac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143436.307435149@linutronix.de>
References: <20130425143436.307435149@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents: Add module refcount
Git-Commit-ID: ccf33d6880f39a35158fff66db13000ae4943fac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ccf33d6880f39a35158fff66db13000ae4943fac
Gitweb:     http://git.kernel.org/tip/ccf33d6880f39a35158fff66db13000ae4943fac
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:49 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:17 +0200

clockevents: Add module refcount

We want to be able to remove clockevent modules as well. Add a
refcount so we don't remove a module with an active clock event
device.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143436.307435149@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h   | 3 +++
 kernel/time/clockevents.c    | 1 +
 kernel/time/tick-broadcast.c | 3 +++
 kernel/time/tick-common.c    | 4 ++++
 4 files changed, 11 insertions(+)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 2f498f6..ae1193b 100644
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
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 0e3a844..89e394c 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -357,6 +357,7 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	 * released list and do a notify add later.
 	 */
 	if (old) {
+		module_put(old->owner);
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 3500caa..0e374cd 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -19,6 +19,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
+#include <linux/module.h>
 
 #include "tick-internal.h"
 
@@ -73,6 +74,8 @@ void tick_install_broadcast_device(struct clock_event_device *dev)
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
 	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return;
+	if (!try_module_get(dev->owner))
+		return;
 
 	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
 	if (cur)
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 84c7cfc..433a1e1 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 
 #include <asm/irq_regs.h>
 
@@ -257,6 +258,9 @@ void tick_check_new_device(struct clock_event_device *newdev)
 			goto out_bc;
 	}
 
+	if (!try_module_get(newdev->owner))
+		return;
+
 	/*
 	 * Replace the eventually existing device by the new
 	 * device. If the current device is the broadcast device, do
