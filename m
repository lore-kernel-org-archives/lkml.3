Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab3K1Oql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:46:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35225 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3K1Oqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:46:38 -0500
Date: Thu, 28 Nov 2013 06:46:08 -0800
From: tip-bot for Mark Rutland <tipbot@zytor.com>
Message-ID: <tip-08332dff8adebb74171e98e008d6c20de6658c42@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        catalin.marinas@arm.com, mark.rutland@arm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, tglx@linutronix.de, mark.rutland@arm.com
In-Reply-To: <1385648500-29048-1-git-send-email-mark.rutland@arm.com>
References: <1385648500-29048-1-git-send-email-mark.rutland@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irqchip: Gic: fix boot for chained gics
Git-Commit-ID: 08332dff8adebb74171e98e008d6c20de6658c42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 28 Nov 2013 06:46:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08332dff8adebb74171e98e008d6c20de6658c42
Gitweb:     http://git.kernel.org/tip/08332dff8adebb74171e98e008d6c20de6658c42
Author:     Mark Rutland <mark.rutland@arm.com>
AuthorDate: Thu, 28 Nov 2013 14:21:40 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 28 Nov 2013 15:41:53 +0100

irqchip: Gic: fix boot for chained gics

As of c0114709ed: "irqchip: gic: Perform the gic_secondary_init() call
via CPU notifier", booting on a platform with chained gics (e.g.
Realview EB ARM11MPCore) will result in the gic_cpu_notifier being
registered twice, corrupting the cpu notifier list and rendering the
platform unbootable.

This patch ensures that we only register the notifier for the first
gic, allowing platforms with chained gics to boot. At the same time we
limit the pointlessly duplicated calls to set_smp_cross_call and
set_handle_irq to the first gic registered.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com
Cc: rob.herring@calxeda.com
Cc: olof@lixom.net
Link: http://lkml.kernel.org/r/1385648500-29048-1-git-send-email-mark.rutland@arm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-gic.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index d0e9480..e219a5bf 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -814,12 +814,13 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 	if (WARN_ON(!gic->domain))
 		return;
 
+	if (gic_nr == 0) {
 #ifdef CONFIG_SMP
-	set_smp_cross_call(gic_raise_softirq);
-	register_cpu_notifier(&gic_cpu_notifier);
+		set_smp_cross_call(gic_raise_softirq);
+		register_cpu_notifier(&gic_cpu_notifier);
 #endif
-
-	set_handle_irq(gic_handle_irq);
+		set_handle_irq(gic_handle_irq);
+	}
 
 	gic_chip.flags |= gic_arch_extn.flags;
 	gic_dist_init(gic);
