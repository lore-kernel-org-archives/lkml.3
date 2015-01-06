Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbbAFWfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:35:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:2943 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbbAFWe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:34:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="508388185"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] perf, x86, uncore, hsw-ep: Handle systems with only two SBOXes
Date: Tue,  6 Jan 2015 14:34:35 -0800
Message-Id: <1420583675-9163-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

There was another report of a boot failure with a #GP fault in the
uncore SBOX initialization. The earlier work around was not enough
for this system.

The boot was failing while trying to initialize the third SBOX.

This patch detects parts with only two SBOXes and limits the number
of SBOX units to two there.

Stable material, as it affects boot problems on 3.18.

Cc: stable@vger.kernel.org
Tested-by: Andreas Oehler <andreas@oehler-net.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.h       |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 18eb78b..863d9b0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -17,7 +17,7 @@
 #define UNCORE_PCI_DEV_TYPE(data)	((data >> 8) & 0xff)
 #define UNCORE_PCI_DEV_IDX(data)	(data & 0xff)
 #define UNCORE_EXTRA_PCI_DEV		0xff
-#define UNCORE_EXTRA_PCI_DEV_MAX	2
+#define UNCORE_EXTRA_PCI_DEV_MAX	3
 
 /* support up to 8 sockets */
 #define UNCORE_SOCKET_MAX		8
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index 745b158..21af6149e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -891,6 +891,7 @@ void snbep_uncore_cpu_init(void)
 enum {
 	SNBEP_PCI_QPI_PORT0_FILTER,
 	SNBEP_PCI_QPI_PORT1_FILTER,
+	HSWEP_PCI_PCU_3,
 };
 
 static int snbep_qpi_hw_config(struct intel_uncore_box *box, struct perf_event *event)
@@ -2026,6 +2027,17 @@ void hswep_uncore_cpu_init(void)
 {
 	if (hswep_uncore_cbox.num_boxes > boot_cpu_data.x86_max_cores)
 		hswep_uncore_cbox.num_boxes = boot_cpu_data.x86_max_cores;
+
+	/* Detect 6-8 core systems with only two SBOXes */
+	if (uncore_extra_pci_dev[0][HSWEP_PCI_PCU_3]) {
+		u32 capid4;
+
+		pci_read_config_dword(uncore_extra_pci_dev[0][HSWEP_PCI_PCU_3],
+				      0x94, &capid4);
+		if (((capid4 >> 6) & 0x3) == 0)
+			hswep_uncore_sbox.num_boxes = 2;
+	}
+
 	uncore_msr_uncores = hswep_msr_uncores;
 }
 
@@ -2287,6 +2299,11 @@ static DEFINE_PCI_DEVICE_TABLE(hswep_uncore_pci_ids) = {
 		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
 						   SNBEP_PCI_QPI_PORT1_FILTER),
 	},
+	{ /* PCU.3 (for Capability registers) */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2fc0),
+		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
+						   HSWEP_PCI_PCU_3),
+	},
 	{ /* end: all zeroes */ }
 };
 
-- 
1.9.3

