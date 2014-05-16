Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbaEPNek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:34:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54148 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaEPNei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:34:38 -0400
Date: Fri, 16 May 2014 06:33:43 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a553b142b8effbfcbba24ebbf8c07a1a86d32ce6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, joro@8bytes.org, peterz@infradead.org,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, joro@8bytes.org,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154336.372289825@linutronix.de>
References: <20140507154336.372289825@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] iommu: dmar: Provide arch specific irq allocation
Git-Commit-ID: a553b142b8effbfcbba24ebbf8c07a1a86d32ce6
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

Commit-ID:  a553b142b8effbfcbba24ebbf8c07a1a86d32ce6
Gitweb:     http://git.kernel.org/tip/a553b142b8effbfcbba24ebbf8c07a1a86d32ce6
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:11 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:19 +0200

iommu: dmar: Provide arch specific irq allocation

ia64 and x86 share this driver. x86 is moving to a different irq
allocation and ia64 keeps its private irq_create/destroy stuff.

Use macros to redirect to one or the other. Yes, macros to avoid
include hell.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Joerg Roedel <joro@8bytes.org>
Cc: x86@kernel.org
Cc: linux-ia64@vger.kernel.org
Cc: iommu@lists.linux-foundation.org
Link: http://lkml.kernel.org/r/20140507154336.372289825@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/include/asm/irq_remapping.h | 2 ++
 arch/x86/include/asm/irq_remapping.h  | 3 +++
 drivers/iommu/dmar.c                  | 6 +++---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/include/asm/irq_remapping.h b/arch/ia64/include/asm/irq_remapping.h
index a8687b1..e3b3556 100644
--- a/arch/ia64/include/asm/irq_remapping.h
+++ b/arch/ia64/include/asm/irq_remapping.h
@@ -1,4 +1,6 @@
 #ifndef __IA64_INTR_REMAPPING_H
 #define __IA64_INTR_REMAPPING_H
 #define irq_remapping_enabled 0
+#define dmar_alloc_hwirq	create_irq
+#define dmar_free_hwirq		destroy_irq
 #endif
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index d806b22..b7747c4 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -103,4 +103,7 @@ static inline bool setup_remapped_irq(int irq,
 }
 #endif /* CONFIG_IRQ_REMAP */
 
+#define dmar_alloc_hwirq()	irq_alloc_hwirq(-1)
+#define dmar_free_hwirq		irq_free_hwirq
+
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 3ce1f62..9a4f05e 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -994,7 +994,7 @@ static void free_iommu(struct intel_iommu *iommu)
 	if (iommu->irq) {
 		free_irq(iommu->irq, iommu);
 		irq_set_handler_data(iommu->irq, NULL);
-		destroy_irq(iommu->irq);
+		dmar_free_hwirq(iommu->irq);
 	}
 
 	if (iommu->qi) {
@@ -1550,7 +1550,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 	if (iommu->irq)
 		return 0;
 
-	irq = create_irq();
+	irq = dmar_alloc_hwirq();
 	if (irq <= 0) {
 		pr_err("IOMMU: no free vectors\n");
 		return -EINVAL;
@@ -1563,7 +1563,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 	if (ret) {
 		irq_set_handler_data(irq, NULL);
 		iommu->irq = 0;
-		destroy_irq(irq);
+		dmar_free_hwirq(irq);
 		return ret;
 	}
 
