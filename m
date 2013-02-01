Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3BAC4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 21:56:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:25639 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab3BAC4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 21:56:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="285092148"
Subject: [PATCH] x86/io_apic: Do not unmask the masked-irq when migrating
 irq in ack_apic_level()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: agordeev@redhat.com, yinghai@kernel.org, joerg.roedel@amd.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Feb 2013 20:05:14 +0800
Message-ID: <1359720314.1223.32.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In ack_apic_level(), when there is pending affinity setting for current irq,
ioapic_irqd_mask()/ioapic_irqd_unmask() will try to mask the irq and do the
irq affinity setting.

But at this time, it is possibility that the irq has been masked, in this case,
we should not unmask it directly in ioapic_irqd_unmask().

One real case is one threaded interrupt with ONE_SHOT, the irq has been masked in
handle_fasteoi_irq().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b739d39..5c0fe25 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2429,7 +2429,8 @@ static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
 {
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(irqd_is_setaffinity_pending(data))) {
-		mask_ioapic(cfg);
+		if (!irqd_irq_masked(data))
+			mask_ioapic(cfg);
 		return true;
 	}
 	return false;
@@ -2467,7 +2468,13 @@ static inline void ioapic_irqd_unmask(struct irq_data *data,
 		 */
 		if (!io_apic_level_ack_pending(cfg))
 			irq_move_masked_irq(data);
-		unmask_ioapic(cfg);
+		/*
+		 * For the threaded interrupt with ONE_SHOT flag,
+		 * the irq has been masked in handle_fasteoi_irq().
+		 * We should be careful not to unmask it here.
+		 */
+		if (!irqd_irq_masked(data))
+			unmask_ioapic(cfg);
 	}
 }
 #else
-- 
1.7.0.4



