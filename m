Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbaEPNda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:33:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaEPNd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:33:28 -0400
Date: Fri, 16 May 2014 06:32:37 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-0a2db49dc4fe2873f857617d320c37b6bfe40255@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        tony.luck@intel.com
In-Reply-To: <20140507154335.252789823@linutronix.de>
References: <20140507154335.252789823@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: uv: Use irq_alloc/free_hwirq()
Git-Commit-ID: 0a2db49dc4fe2873f857617d320c37b6bfe40255
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

Commit-ID:  0a2db49dc4fe2873f857617d320c37b6bfe40255
Gitweb:     http://git.kernel.org/tip/0a2db49dc4fe2873f857617d320c37b6bfe40255
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:08 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:19 +0200

x86: uv: Use irq_alloc/free_hwirq()

No functional change. The request to allocate the irq above
NR_IRQS_LEGACY is completely pointless as the implementation enforces
that the dynamic allocations are above the GSI interrupts, which
includes the legacy PIT irqs.

This does not replace the requirement to move x86 to irq domains, but
it limits the mess to some degree.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20140507154335.252789823@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/platform/uv/uv_irq.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index acf7752..b233681 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -238,11 +238,9 @@ uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
 		 unsigned long mmr_offset, int limit)
 {
-	int irq, ret;
+	int ret, irq = irq_alloc_hwirq(uv_blade_to_memory_nid(mmr_blade));
 
-	irq = create_irq_nr(NR_IRQS_LEGACY, uv_blade_to_memory_nid(mmr_blade));
-
-	if (irq <= 0)
+	if (!irq)
 		return -EBUSY;
 
 	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset,
@@ -250,7 +248,7 @@ int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
 	if (ret == irq)
 		uv_set_irq_2_mmr_info(irq, mmr_offset, mmr_blade);
 	else
-		destroy_irq(irq);
+		irq_free_hwirq(irq);
 
 	return ret;
 }
@@ -285,6 +283,6 @@ void uv_teardown_irq(unsigned int irq)
 			n = n->rb_right;
 	}
 	spin_unlock_irqrestore(&uv_irq_lock, irqflags);
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 }
 EXPORT_SYMBOL_GPL(uv_teardown_irq);
