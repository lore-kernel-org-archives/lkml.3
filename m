Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaKHSSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:18:12 -0500
Received: from mga14.intel.com ([192.55.52.115]:19509 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbaKHSSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:18:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413534333"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part3 v3 33/38] x86, irq: Move check of cfg->move_in_progress into send_cleanup_vector()
Date: Sun,  9 Nov 2014 02:13:33 +0800
Message-Id: <1415470418-10874-34-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move check of cfg->move_in_progress into send_cleanup_vector() to
prepare for simplifying struct irq_cfg.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/vector.c       |   10 ++++++++--
 arch/x86/platform/uv/uv_irq.c       |    3 +--
 drivers/iommu/amd_iommu.c           |    3 +--
 drivers/iommu/intel_irq_remapping.c |    3 +--
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index d56b4611c75a..76c82170f04f 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -495,7 +495,7 @@ static struct irq_chip vector_chip = {
 };
 
 #ifdef CONFIG_SMP
-void send_cleanup_vector(struct irq_cfg *cfg)
+static void __send_cleanup_vector(struct irq_cfg *cfg)
 {
 	cpumask_var_t cleanup_mask;
 
@@ -513,6 +513,12 @@ void send_cleanup_vector(struct irq_cfg *cfg)
 	cfg->move_in_progress = 0;
 }
 
+void send_cleanup_vector(struct irq_cfg *cfg)
+{
+	if (cfg->move_in_progress)
+		__send_cleanup_vector(cfg);
+}
+
 asmlinkage __visible void smp_irq_move_cleanup_interrupt(void)
 {
 	unsigned vector, me;
@@ -583,7 +589,7 @@ static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
 	me = smp_processor_id();
 
 	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
-		send_cleanup_vector(cfg);
+		__send_cleanup_vector(cfg);
 }
 
 void irq_complete_move(struct irq_cfg *cfg)
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index 854e610a085f..66d531e71c9a 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -63,8 +63,7 @@ uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0) {
 		uv_program_mmr(cfg, data->chip_data);
-		if (cfg->move_in_progress)
-			send_cleanup_vector(cfg);
+		send_cleanup_vector(cfg);
 	}
 
 	return ret;
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 236cc7ee0b85..02cb3637eb43 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4331,8 +4331,7 @@ static int amd_ir_set_affinity(struct irq_data *data,
 	 * at the new destination. So, time to cleanup the previous
 	 * vector allocation.
 	 */
-	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
+	send_cleanup_vector(cfg);
 
 	return IRQ_SET_MASK_OK_DONE;
 }
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 5bd9e6570099..d3bfe3528504 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -947,8 +947,7 @@ intel_ir_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	 * at the new destination. So, time to cleanup the previous
 	 * vector allocation.
 	 */
-	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
+	send_cleanup_vector(cfg);
 
 	return IRQ_SET_MASK_OK_DONE;
 }
-- 
1.7.10.4

