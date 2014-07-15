Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbaGOLBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:01:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53103 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbaGOLBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:01:49 -0400
Date: Tue, 15 Jul 2014 04:01:10 -0700
From: "tip-bot for Rafael J. Wysocki" <tipbot@zytor.com>
Message-ID: <tip-d709f7bcbb3ab01704fa7b37a2e4b981cf3783c1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rafael.j.wysocki@intel.com, aubrey.li@linux.intel.com,
        gnomes@lxorguk.ukuu.org.uk, dmitry.torokhov@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, aubrey.li@linux.intel.com,
        gnomes@lxorguk.ukuu.org.uk, dmitry.torokhov@gmail.com,
        tglx@linutronix.de
In-Reply-To: <4679574.kGUnqAuNl9@vostro.rjw.lan>
References: <4679574.kGUnqAuNl9@vostro.rjw.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] PM / sleep / irq: Do not suspend wakeup interrupts
Git-Commit-ID: d709f7bcbb3ab01704fa7b37a2e4b981cf3783c1
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

Commit-ID:  d709f7bcbb3ab01704fa7b37a2e4b981cf3783c1
Gitweb:     http://git.kernel.org/tip/d709f7bcbb3ab01704fa7b37a2e4b981cf3783c1
Author:     Rafael J. Wysocki <rafael.j.wysocki@intel.com>
AuthorDate: Thu, 10 Jul 2014 23:37:54 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 15 Jul 2014 12:57:26 +0200

PM / sleep / irq: Do not suspend wakeup interrupts

If an IRQ has been configured for wakeup via enable_irq_wake(), the
driver who has done that must be prepared for receiving interrupts
after suspend_device_irqs() has returned, so there is no need to
"suspend" such IRQs.  Moreover, if drivers using enable_irq_wake()
actually want to receive interrupts after suspend_device_irqs() has
returned, they need to add IRQF_NO_SUSPEND to the IRQ flags while
requesting the IRQs, which shouldn't be necessary (it also goes a bit
too far, as IRQF_NO_SUSPEND causes the IRQ to be ignored by
suspend_device_irqs() all the time regardless of whether or not it
has been configured for signaling wakeup).

For the above reasons, make __disable_irq() ignore IRQ descriptors
with IRQD_WAKEUP_STATE set when its suspend argument is true which
effectively causes them to behave like IRQs with IRQF_NO_SUSPEND
set.

This also allows IRQs configured for wakeup via enable_irq_wake()
to work as wakeup interrupts for the "freeze" (suspend-to-idle)
sleep mode automatically just like for any other sleep states.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Li Aubrey <aubrey.li@linux.intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Link: http://lkml.kernel.org/r/4679574.kGUnqAuNl9@vostro.rjw.lan
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3dc6a61..88657d7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -385,7 +385,8 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 {
 	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
+		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND) ||
+		    irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
 			return;
 		desc->istate |= IRQS_SUSPENDED;
 	}
