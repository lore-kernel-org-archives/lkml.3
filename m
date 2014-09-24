Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaIXPBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:01:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59918 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaIXPBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:01:44 -0400
Date: Wed, 24 Sep 2014 08:01:08 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-521e8bac67a71a6544274f39d5c61473e0e54ac0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        acme@kernel.org, bhelgaas@google.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, bhelgaas@google.com,
        tglx@linutronix.de
In-Reply-To: <20140917090616.GA11281@quad>
References: <20140917090616.GA11281@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel/uncore:
  Update support for client uncore IMC PMU
Git-Commit-ID: 521e8bac67a71a6544274f39d5c61473e0e54ac0
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

Commit-ID:  521e8bac67a71a6544274f39d5c61473e0e54ac0
Gitweb:     http://git.kernel.org/tip/521e8bac67a71a6544274f39d5c61473e0e54ac0
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 17 Sep 2014 11:06:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:48:25 +0200

perf/x86/intel/uncore: Update support for client uncore IMC PMU

This patch restructures the memory controller (IMC) uncore PMU support
for client SNB/IVB/HSW processors. The main change is that it can now
cope with more than one PCI device ID per processor model. There are
many flavors of memory controllers for each processor. They have
different PCI device ID, yet they behave the same w.r.t. the memory
controller PMU that we are interested in.

The patch now supports two distinct memory controllers for IVB
processors: one for mobile, one for desktop.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140917090616.GA11281@quad
Cc: ak@linux.intel.com
Cc: kan.liang@intel.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c | 69 +++++++++++++++++------
 include/linux/pci_ids.h                           |  1 +
 2 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c
index e0e934c..3001015 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c
@@ -460,6 +460,10 @@ static const struct pci_device_id ivb_uncore_pci_ids[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IVB_IMC),
 		.driver_data = UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
 	},
+	{ /* IMC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IVB_E3_IMC),
+		.driver_data = UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
+	},
 	{ /* end: all zeroes */ },
 };
 
@@ -486,34 +490,63 @@ static struct pci_driver hsw_uncore_pci_driver = {
 	.id_table	= hsw_uncore_pci_ids,
 };
 
-int snb_uncore_pci_init(void)
+struct imc_uncore_pci_dev {
+	__u32 pci_id;
+	struct pci_driver *driver;
+};
+#define IMC_DEV(a, d) \
+	{ .pci_id = PCI_DEVICE_ID_INTEL_##a, .driver = (d) }
+
+static const struct imc_uncore_pci_dev desktop_imc_pci_ids[] = {
+	IMC_DEV(SNB_IMC, &snb_uncore_pci_driver),
+	IMC_DEV(IVB_IMC, &ivb_uncore_pci_driver),    /* 3rd Gen Core processor */
+	IMC_DEV(IVB_E3_IMC, &ivb_uncore_pci_driver), /* Xeon E3-1200 v2/3rd Gen Core processor */
+	IMC_DEV(HSW_IMC, &hsw_uncore_pci_driver),    /* 4th Gen Core Processor */
+	{  /* end marker */ }
+};
+
+
+#define for_each_imc_pci_id(x, t) \
+	for (x = (t); (x)->pci_id; x++)
+
+static struct pci_driver *imc_uncore_find_dev(void)
 {
-	int ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_SNB_IMC);
-	if (ret)
-		return ret;
-	uncore_pci_uncores = snb_pci_uncores;
-	uncore_pci_driver = &snb_uncore_pci_driver;
-	return 0;
+	const struct imc_uncore_pci_dev *p;
+	int ret;
+
+	for_each_imc_pci_id(p, desktop_imc_pci_ids) {
+		ret = snb_pci2phy_map_init(p->pci_id);
+		if (ret == 0)
+			return p->driver;
+	}
+	return NULL;
 }
 
-int ivb_uncore_pci_init(void)
+static int imc_uncore_pci_init(void)
 {
-	int ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_IVB_IMC);
-	if (ret)
-		return ret;
+	struct pci_driver *imc_drv = imc_uncore_find_dev();
+
+	if (!imc_drv)
+		return -ENODEV;
+
 	uncore_pci_uncores = snb_pci_uncores;
-	uncore_pci_driver = &ivb_uncore_pci_driver;
+	uncore_pci_driver = imc_drv;
+
 	return 0;
 }
 
+int snb_uncore_pci_init(void)
+{
+	return imc_uncore_pci_init();
+}
+
+int ivb_uncore_pci_init(void)
+{
+	return imc_uncore_pci_init();
+}
 int hsw_uncore_pci_init(void)
 {
-	int ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_HSW_IMC);
-	if (ret)
-		return ret;
-	uncore_pci_uncores = snb_pci_uncores;
-	uncore_pci_driver = &hsw_uncore_pci_driver;
-	return 0;
+	return imc_uncore_pci_init();
 }
 
 /* end of Sandy Bridge uncore support */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6ed0bb7..3102b7e 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2536,6 +2536,7 @@
 #define PCI_DEVICE_ID_INTEL_EESSC	0x0008
 #define PCI_DEVICE_ID_INTEL_SNB_IMC	0x0100
 #define PCI_DEVICE_ID_INTEL_IVB_IMC	0x0154
+#define PCI_DEVICE_ID_INTEL_IVB_E3_IMC	0x0150
 #define PCI_DEVICE_ID_INTEL_HSW_IMC	0x0c00
 #define PCI_DEVICE_ID_INTEL_PXHD_0	0x0320
 #define PCI_DEVICE_ID_INTEL_PXHD_1	0x0321
