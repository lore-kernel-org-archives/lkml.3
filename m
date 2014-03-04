Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbaCDQqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:46:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41593 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCDQmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:42:39 -0500
Date: Tue, 4 Mar 2014 08:40:40 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-49f3fbc7b8576fd578f3504c65aae9b8a212d0f6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux-arm-kernel@lists.infradead.org, peterz@infradead.org,
        haojian.zhuang@gmail.com, linux@arm.linux.org.uk,
        eric.y.miao@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, peterz@infradead.org,
        haojian.zhuang@gmail.com, linux@arm.linux.org.uk,
        eric.y.miao@gmail.com, tglx@linutronix.de
In-Reply-To: <20140223212737.214342433@linutronix.de>
References: <20140223212737.214342433@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] arm: mmp:
  Remove pointless fiddling with irq internals
Git-Commit-ID: 49f3fbc7b8576fd578f3504c65aae9b8a212d0f6
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

Commit-ID:  49f3fbc7b8576fd578f3504c65aae9b8a212d0f6
Gitweb:     http://git.kernel.org/tip/49f3fbc7b8576fd578f3504c65aae9b8a212d0f6
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:13 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:52 +0100

arm: mmp: Remove pointless fiddling with irq internals

The pm-mmp2 and pm-pxa910 power management related irq_set_wake
callbacks fiddle pointlessly with the irq actions for no reason except
for lack of understanding how the wakeup mechanism works.

On supsend the core disables all interrupts lazily, i.e. it does not
mask them at the irq controller level. So any interrupt which is
firing during suspend will mark the corresponding interrupt line as
pending. Just before the core powers down it checks whether there are
interrupts pending from interrupt lines which are marked as wakeup
sources and if so it aborts the suspend and resends the interrupts.
If there was no interrupt at this point, the cpu goes into suspend
with these interrupts unmasked.

The IRQF_NO_SUSPEND flag for interrupt actions is a totally different
mechanism. That allows the device driver to prevent the core from
disabling the interrupt despite the fact that it is not marked as a
wakeup source. This has nothing to do with the case at hand. It was
introduced for special cases where lazy disable is not possible.

Remove the nonsense along with the braindamaged boundary check. The
core code does NOT call these functions out of boundary.

Add a FIXME comment to an unhandled error path which merily printks
some useless blurb instead of returning a proper error code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: arm <linux-arm-kernel@lists.infradead.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Link: http://lkml.kernel.org/r/20140223212737.214342433@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-mmp/pm-mmp2.c   | 16 +---------------
 arch/arm/mach-mmp/pm-pxa910.c | 20 ++++----------------
 2 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-mmp/pm-mmp2.c b/arch/arm/mach-mmp/pm-mmp2.c
index 461a191..43b1a51 100644
--- a/arch/arm/mach-mmp/pm-mmp2.c
+++ b/arch/arm/mach-mmp/pm-mmp2.c
@@ -27,22 +27,8 @@
 
 int mmp2_set_wake(struct irq_data *d, unsigned int on)
 {
-	int irq = d->irq;
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long data = 0;
-
-	if (unlikely(irq >= nr_irqs)) {
-		pr_err("IRQ nubmers are out of boundary!\n");
-		return -EINVAL;
-	}
-
-	if (on) {
-		if (desc->action)
-			desc->action->flags |= IRQF_NO_SUSPEND;
-	} else {
-		if (desc->action)
-			desc->action->flags &= ~IRQF_NO_SUSPEND;
-	}
+	int irq = d->irq;
 
 	/* enable wakeup sources */
 	switch (irq) {
diff --git a/arch/arm/mach-mmp/pm-pxa910.c b/arch/arm/mach-mmp/pm-pxa910.c
index 48981ca..04c9daf 100644
--- a/arch/arm/mach-mmp/pm-pxa910.c
+++ b/arch/arm/mach-mmp/pm-pxa910.c
@@ -27,22 +27,8 @@
 
 int pxa910_set_wake(struct irq_data *data, unsigned int on)
 {
-	int irq = data->irq;
-	struct irq_desc *desc = irq_to_desc(data->irq);
 	uint32_t awucrm = 0, apcr = 0;
-
-	if (unlikely(irq >= nr_irqs)) {
-		pr_err("IRQ nubmers are out of boundary!\n");
-		return -EINVAL;
-	}
-
-	if (on) {
-		if (desc->action)
-			desc->action->flags |= IRQF_NO_SUSPEND;
-	} else {
-		if (desc->action)
-			desc->action->flags &= ~IRQF_NO_SUSPEND;
-	}
+	int irq = data->irq;
 
 	/* setting wakeup sources */
 	switch (irq) {
@@ -115,9 +101,11 @@ int pxa910_set_wake(struct irq_data *data, unsigned int on)
 		if (irq >= IRQ_GPIO_START && irq < IRQ_BOARD_START) {
 			awucrm = MPMU_AWUCRM_WAKEUP(2);
 			apcr |= MPMU_APCR_SLPWP2;
-		} else
+		} else {
+			/* FIXME: This should return a proper error code ! */
 			printk(KERN_ERR "Error: no defined wake up source irq: %d\n",
 				irq);
+		}
 	}
 
 	if (on) {
