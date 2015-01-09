Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbbAIMd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:33:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60209 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074AbbAIMd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:33:26 -0500
Date: Fri, 9 Jan 2015 04:32:49 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-5306c31c5733cb4a79cc002e0c3ad256fd439614@git.kernel.org>
Cc: zheng.z.yan@intel.com, peterz@infradead.org, ak@linux.intel.com,
        hpa@zytor.com, stable@vger.kernel.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        andreas@oehler-net.de, mingo@kernel.org, acme@kernel.org
Reply-To: peterz@infradead.org, zheng.z.yan@intel.com, eranian@google.com,
        ak@linux.intel.com, hpa@zytor.com, stable@vger.kernel.org,
        mingo@kernel.org, andreas@oehler-net.de, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, acme@kernel.org
In-Reply-To: <1420583675-9163-1-git-send-email-andi@firstfloor.org>
References: <1420583675-9163-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/uncore/hsw-ep:
  Handle systems with only two SBOXes
Git-Commit-ID: 5306c31c5733cb4a79cc002e0c3ad256fd439614
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

Commit-ID:  5306c31c5733cb4a79cc002e0c3ad256fd439614
Gitweb:     http://git.kernel.org/tip/5306c31c5733cb4a79cc002e0c3ad256fd439614
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 6 Jan 2015 14:34:35 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 9 Jan 2015 11:12:30 +0100

perf/x86/uncore/hsw-ep: Handle systems with only two SBOXes

There was another report of a boot failure with a #GP fault in the
uncore SBOX initialization. The earlier work around was not enough
for this system.

The boot was failing while trying to initialize the third SBOX.

This patch detects parts with only two SBOXes and limits the number
of SBOX units to two there.

Stable material, as it affects boot problems on 3.18.

Tested-by: Andreas Oehler <andreas@oehler-net.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Yan, Zheng <zheng.z.yan@intel.com>
Link: http://lkml.kernel.org/r/1420583675-9163-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
