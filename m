Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3BCT3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:29:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50874 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3BCT3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:29:54 -0500
Date: Sun, 3 Feb 2013 11:29:38 -0800
From: tip-bot for Andy Lutomirski <luto@amacapital.net>
Message-ID: <tip-af8d102f999a41c0189bd2cce488bac2ee88c29b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.williamson@redhat.com, luto@amacapital.net, gleb@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, prarit@redhat.com,
        dzickus@redhat.com
Reply-To: gleb@redhat.com, luto@amacapital.net, mingo@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, prarit@redhat.com, dzickus@redhat.com
In-Reply-To: <2011b943a886fd7c46079eb10bc24fc130587503.1359759303.git.luto@amacapital.net>
References: <2011b943a886fd7c46079eb10bc24fc130587503.1359759303.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/intel/irq_remapping:
  Clean up x2apic opt-out security warning mess
Git-Commit-ID: af8d102f999a41c0189bd2cce488bac2ee88c29b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 03 Feb 2013 11:29:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af8d102f999a41c0189bd2cce488bac2ee88c29b
Gitweb:     http://git.kernel.org/tip/af8d102f999a41c0189bd2cce488bac2ee88c29b
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Fri, 1 Feb 2013 14:57:43 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 3 Feb 2013 12:13:48 +0100

x86/intel/irq_remapping: Clean up x2apic opt-out security warning mess

Current kernels print this on my Dell server:

   ------------[ cut here ]------------
   WARNING: at drivers/iommu/intel_irq_remapping.c:542
   intel_enable_irq_remapping+0x7b/0x27e()
   Hardware name: PowerEdge R620
   Your BIOS is broken and requested that x2apic be disabled
   This will leave your machine vulnerable to irq-injection attacks
   Use 'intremap=no_x2apic_optout' to override BIOS request
   [...]
   Enabled IRQ remapping in xapic mode
   x2apic not enabled, IRQ remapping is in xapic mode

This is inconsistent with itself -- interrupt remapping is *on*.

Fix the mess by making the warnings say what they mean and my
making sure that compatibility format interrupts (the dangerous
ones) are disabled if x2apic is present regardless of BIOS
settings.

With this patch applied, the output is:

  Your BIOS is broken and requested that x2apic be disabled.
  This will slightly decrease performance.
  Use 'intremap=no_x2apic_optout' to override BIOS request.
  Enabled IRQ remapping in xapic mode
  x2apic not enabled, IRQ remapping is in xapic mode

This should make us as or more secure than we are now and
replace a rather scary warning with a much less scary warning on
silly but functional systems.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Link: http://lkml.kernel.org/r/2011b943a886fd7c46079eb10bc24fc130587503.1359759303.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/iommu/intel_irq_remapping.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 7ca4947..f3b8f23 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -429,11 +429,22 @@ static void iommu_set_irq_remapping(struct intel_iommu *iommu, int mode)
 
 	/* Enable interrupt-remapping */
 	iommu->gcmd |= DMA_GCMD_IRE;
+	iommu->gcmd &= ~DMA_GCMD_CFI;  /* Block compatibility-format MSIs */
 	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
 
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (sts & DMA_GSTS_IRES), sts);
 
+	/*
+	 * With CFI clear in the Global Command register, we should be
+	 * protected from dangerous (i.e. compatibility) interrupts
+	 * regardless of x2apic status.  Check just to be sure.
+	 */
+	if (sts & DMA_GSTS_CFIS)
+		WARN(1, KERN_WARNING
+			"Compatibility-format IRQs enabled despite intr remapping;\n"
+			"you are vulnerable to IRQ injection.\n");
+
 	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
@@ -530,20 +541,24 @@ static int __init intel_irq_remapping_supported(void)
 static int __init intel_enable_irq_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
+	bool x2apic_present;
 	int setup = 0;
 	int eim = 0;
 
+	x2apic_present = x2apic_supported();
+
 	if (parse_ioapics_under_ir() != 1) {
 		printk(KERN_INFO "Not enable interrupt remapping\n");
-		return -1;
+		goto error;
 	}
 
-	if (x2apic_supported()) {
+	if (x2apic_present) {
 		eim = !dmar_x2apic_optout();
-		WARN(!eim, KERN_WARNING
-			   "Your BIOS is broken and requested that x2apic be disabled\n"
-			   "This will leave your machine vulnerable to irq-injection attacks\n"
-			   "Use 'intremap=no_x2apic_optout' to override BIOS request\n");
+		if (!eim)
+			printk(KERN_WARNING
+				"Your BIOS is broken and requested that x2apic be disabled.\n"
+				"This will slightly decrease performance.\n"
+				"Use 'intremap=no_x2apic_optout' to override BIOS request.\n");
 	}
 
 	for_each_drhd_unit(drhd) {
@@ -582,7 +597,7 @@ static int __init intel_enable_irq_remapping(void)
 		if (eim && !ecap_eim_support(iommu->ecap)) {
 			printk(KERN_INFO "DRHD %Lx: EIM not supported by DRHD, "
 			       " ecap %Lx\n", drhd->reg_base_addr, iommu->ecap);
-			return -1;
+			goto error;
 		}
 	}
 
@@ -598,7 +613,7 @@ static int __init intel_enable_irq_remapping(void)
 			printk(KERN_ERR "DRHD %Lx: failed to enable queued, "
 			       " invalidation, ecap %Lx, ret %d\n",
 			       drhd->reg_base_addr, iommu->ecap, ret);
-			return -1;
+			goto error;
 		}
 	}
 
@@ -637,6 +652,11 @@ error:
 	/*
 	 * handle error condition gracefully here!
 	 */
+
+	if (x2apic_present)
+		WARN(1, KERN_WARNING
+			"Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
+
 	return -1;
 }
 
