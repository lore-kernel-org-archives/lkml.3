Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaKZXWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:22:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59211 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaKZXWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:22:19 -0500
Date: Wed, 26 Nov 2014 15:21:26 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-0b05539ff0e79690037dc888dbe0c0339c0a3b20@git.kernel.org>
Cc: konrad.wilk@oracle.com, bp@alien8.de, benh@kernel.crashing.org,
        tglx@linutronix.de, bhelgaas@google.com, gregkh@linuxfoundation.org,
        tony.luck@intel.com, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        joro@8bytes.org, jiang.liu@linux.intel.com, rjw@rjwysocki.net,
        mingo@kernel.org, rdunlap@infradead.org, hpa@zytor.com,
        jroedel@suse.de
Reply-To: jroedel@suse.de, rdunlap@infradead.org, hpa@zytor.com,
        mingo@kernel.org, rjw@rjwysocki.net, jiang.liu@linux.intel.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, tony.luck@intel.com,
        yinghai@kernel.org, benh@kernel.crashing.org, bhelgaas@google.com,
        tglx@linutronix.de, gregkh@linuxfoundation.org, konrad.wilk@oracle.com,
        bp@alien8.de
In-Reply-To: <1416901802-24211-34-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-34-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Move check of cfg->
 move_in_progress into send_cleanup_vector()
Git-Commit-ID: 0b05539ff0e79690037dc888dbe0c0339c0a3b20
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

Commit-ID:  0b05539ff0e79690037dc888dbe0c0339c0a3b20
Gitweb:     http://git.kernel.org/tip/0b05539ff0e79690037dc888dbe0c0339c0a3b20
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:57 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:49 +0100

x86, irq: Move check of cfg->move_in_progress into send_cleanup_vector()

Move check of cfg->move_in_progress into send_cleanup_vector() to
prepare for simplifying struct irq_cfg.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: iommu@lists.linux-foundation.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>
Link: http://lkml.kernel.org/r/1416901802-24211-34-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/apic/vector.c       | 10 ++++++++--
 arch/x86/platform/uv/uv_irq.c       |  3 +--
 drivers/iommu/amd_iommu.c           |  3 +--
 drivers/iommu/intel_irq_remapping.c |  3 +--
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 436a340..a5ce2ee 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -495,7 +495,7 @@ static struct irq_chip lapic_controller = {
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
index c237ed3..b242e0a 100644
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
index 2e8bbe5..a5c59b4 100644
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
index acff849..f6da3b2 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -997,8 +997,7 @@ intel_ir_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	 * at the new destination. So, time to cleanup the previous
 	 * vector allocation.
 	 */
-	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
+	send_cleanup_vector(cfg);
 
 	return IRQ_SET_MASK_OK_DONE;
 }
