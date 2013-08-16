Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3HPSry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:47:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40378 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3HPSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:47:50 -0400
Date: Fri, 16 Aug 2013 11:47:07 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-899396cf7b4b31e08be358411ad5c0c066069ebc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1375856245-10717-1-git-send-email-zheng.z.yan@intel.com>
References: <1375856245-10717-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel/uncore:
  Add auxiliary pci device support
Git-Commit-ID: 899396cf7b4b31e08be358411ad5c0c066069ebc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Aug 2013 11:47:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  899396cf7b4b31e08be358411ad5c0c066069ebc
Gitweb:     http://git.kernel.org/tip/899396cf7b4b31e08be358411ad5c0c066069ebc
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:17:23 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Aug 2013 17:55:48 +0200

perf/x86/intel/uncore: Add auxiliary pci device support

The QPI uncore boxes have two pairs of MATCH/MASK registers that
user to filter packet traffic serviced by QPI link layer. These
registers are in auxiliary PCI devices.

This patch changes the meaning of (struct pci_device_id)->driver_data.
The first 8 bits are device index of the same uncore type, the second
8 bytes are uncore type index. Auxiliary PCI device's type is defined
as UNCORE_EXTRA_PCI_DEV(0xff)

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1375856245-10717-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 111 ++++++++++++++------------
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   9 +++
 2 files changed, 68 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index cad791d..7ce9b35 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -6,6 +6,8 @@ static struct intel_uncore_type **pci_uncores = empty_uncore;
 /* pci bus to socket mapping */
 static int pcibus_to_physid[256] = { [0 ... 255] = -1, };
 
+static struct pci_dev *extra_pci_dev[UNCORE_SOCKET_MAX][UNCORE_EXTRA_PCI_DEV_MAX];
+
 static DEFINE_RAW_SPINLOCK(uncore_box_lock);
 
 /* mask of cpus that collect uncore events */
@@ -807,43 +809,43 @@ static struct intel_uncore_type *snbep_pci_uncores[] = {
 static DEFINE_PCI_DEVICE_TABLE(snbep_uncore_pci_ids) = {
 	{ /* Home Agent */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_HA),
-		.driver_data = SNBEP_PCI_UNCORE_HA,
+		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_HA, 0),
 	},
 	{ /* MC Channel 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_IMC0),
-		.driver_data = SNBEP_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_IMC, 0),
 	},
 	{ /* MC Channel 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_IMC1),
-		.driver_data = SNBEP_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_IMC, 1),
 	},
 	{ /* MC Channel 2 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_IMC2),
-		.driver_data = SNBEP_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_IMC, 2),
 	},
 	{ /* MC Channel 3 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_IMC3),
-		.driver_data = SNBEP_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_IMC, 3),
 	},
 	{ /* QPI Port 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_QPI0),
-		.driver_data = SNBEP_PCI_UNCORE_QPI,
+		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_QPI, 0),
 	},
 	{ /* QPI Port 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_QPI1),
-		.driver_data = SNBEP_PCI_UNCORE_QPI,
+		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_QPI, 1),
 	},
 	{ /* R2PCIe */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_R2PCIE),
-		.driver_data = SNBEP_PCI_UNCORE_R2PCIE,
+		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_R2PCIE, 0),
 	},
 	{ /* R3QPI Link 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_R3QPI0),
-		.driver_data = SNBEP_PCI_UNCORE_R3QPI,
+		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_R3QPI, 0),
 	},
 	{ /* R3QPI Link 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_R3QPI1),
-		.driver_data = SNBEP_PCI_UNCORE_R3QPI,
+		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_R3QPI, 1),
 	},
 	{ /* end: all zeroes */ }
 };
@@ -1256,71 +1258,71 @@ static struct intel_uncore_type *ivt_pci_uncores[] = {
 static DEFINE_PCI_DEVICE_TABLE(ivt_uncore_pci_ids) = {
 	{ /* Home Agent 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe30),
-		.driver_data = IVT_PCI_UNCORE_HA,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_HA, 0),
 	},
 	{ /* Home Agent 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe38),
-		.driver_data = IVT_PCI_UNCORE_HA,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_HA, 1),
 	},
 	{ /* MC0 Channel 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb4),
-		.driver_data = IVT_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 0),
 	},
 	{ /* MC0 Channel 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb5),
-		.driver_data = IVT_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 1),
 	},
 	{ /* MC0 Channel 3 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb0),
-		.driver_data = IVT_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 2),
 	},
 	{ /* MC0 Channel 4 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb1),
-		.driver_data = IVT_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 3),
 	},
 	{ /* MC1 Channel 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef4),
-		.driver_data = IVT_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 4),
 	},
 	{ /* MC1 Channel 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef5),
-		.driver_data = IVT_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 5),
 	},
 	{ /* MC1 Channel 3 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef0),
-		.driver_data = IVT_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 6),
 	},
 	{ /* MC1 Channel 4 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef1),
-		.driver_data = IVT_PCI_UNCORE_IMC,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 7),
 	},
 	{ /* QPI0 Port 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe32),
-		.driver_data = IVT_PCI_UNCORE_QPI,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_QPI, 0),
 	},
 	{ /* QPI0 Port 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe33),
-		.driver_data = IVT_PCI_UNCORE_QPI,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_QPI, 1),
 	},
 	{ /* QPI1 Port 2 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe3a),
-		.driver_data = IVT_PCI_UNCORE_QPI,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_QPI, 2),
 	},
 	{ /* R2PCIe */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe34),
-		.driver_data = IVT_PCI_UNCORE_R2PCIE,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R2PCIE, 0),
 	},
 	{ /* R3QPI0 Link 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe36),
-		.driver_data = IVT_PCI_UNCORE_R3QPI,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R3QPI, 0),
 	},
 	{ /* R3QPI0 Link 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe37),
-		.driver_data = IVT_PCI_UNCORE_R3QPI,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R3QPI, 1),
 	},
 	{ /* R3QPI1 Link 2 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe3e),
-		.driver_data = IVT_PCI_UNCORE_R3QPI,
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R3QPI, 2),
 	},
 	{ /* end: all zeroes */ }
 };
@@ -3167,16 +3169,24 @@ static bool pcidrv_registered;
 /*
  * add a pci uncore device
  */
-static int uncore_pci_add(struct intel_uncore_type *type, struct pci_dev *pdev)
+static int uncore_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
-	int i, phys_id;
+	struct intel_uncore_type *type;
+	int phys_id;
 
 	phys_id = pcibus_to_physid[pdev->bus->number];
 	if (phys_id < 0)
 		return -ENODEV;
 
+	if (UNCORE_PCI_DEV_TYPE(id->driver_data) == UNCORE_EXTRA_PCI_DEV) {
+		extra_pci_dev[phys_id][UNCORE_PCI_DEV_IDX(id->driver_data)] = pdev;
+		pci_set_drvdata(pdev, NULL);
+		return 0;
+	}
+
+	type = pci_uncores[UNCORE_PCI_DEV_TYPE(id->driver_data)];
 	box = uncore_alloc_box(type, 0);
 	if (!box)
 		return -ENOMEM;
@@ -3185,21 +3195,11 @@ static int uncore_pci_add(struct intel_uncore_type *type, struct pci_dev *pdev)
 	 * for performance monitoring unit with multiple boxes,
 	 * each box has a different function id.
 	 */
-	for (i = 0; i < type->num_boxes; i++) {
-		pmu = &type->pmus[i];
-		if (pmu->func_id == pdev->devfn)
-			break;
-		if (pmu->func_id < 0) {
-			pmu->func_id = pdev->devfn;
-			break;
-		}
-		pmu = NULL;
-	}
-
-	if (!pmu) {
-		kfree(box);
-		return -EINVAL;
-	}
+	pmu = &type->pmus[UNCORE_PCI_DEV_IDX(id->driver_data)];
+	if (pmu->func_id < 0)
+		pmu->func_id = pdev->devfn;
+	else
+		WARN_ON_ONCE(pmu->func_id != pdev->devfn);
 
 	box->phys_id = phys_id;
 	box->pci_dev = pdev;
@@ -3217,9 +3217,22 @@ static int uncore_pci_add(struct intel_uncore_type *type, struct pci_dev *pdev)
 static void uncore_pci_remove(struct pci_dev *pdev)
 {
 	struct intel_uncore_box *box = pci_get_drvdata(pdev);
-	struct intel_uncore_pmu *pmu = box->pmu;
-	int cpu, phys_id = pcibus_to_physid[pdev->bus->number];
+	struct intel_uncore_pmu *pmu;
+	int i, cpu, phys_id = pcibus_to_physid[pdev->bus->number];
 
+	box = pci_get_drvdata(pdev);
+	if (!box) {
+		for (i = 0; i < UNCORE_EXTRA_PCI_DEV_MAX; i++) {
+			if (extra_pci_dev[phys_id][i] == pdev) {
+				extra_pci_dev[phys_id][i] = NULL;
+				break;
+			}
+		}
+		WARN_ON_ONCE(i >= UNCORE_EXTRA_PCI_DEV_MAX);
+		return;
+	}
+
+	pmu = box->pmu;
 	if (WARN_ON_ONCE(phys_id != box->phys_id))
 		return;
 
@@ -3240,12 +3253,6 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 	kfree(box);
 }
 
-static int uncore_pci_probe(struct pci_dev *pdev,
-			    const struct pci_device_id *id)
-{
-	return uncore_pci_add(pci_uncores[id->driver_data], pdev);
-}
-
 static int __init uncore_pci_init(void)
 {
 	int ret;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 47b3d00..ede5a8c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -12,6 +12,15 @@
 #define UNCORE_PMC_IDX_FIXED		UNCORE_PMC_IDX_MAX_GENERIC
 #define UNCORE_PMC_IDX_MAX		(UNCORE_PMC_IDX_FIXED + 1)
 
+#define UNCORE_PCI_DEV_DATA(type, idx)	((type << 8) | idx)
+#define UNCORE_PCI_DEV_TYPE(data)	((data >> 8) & 0xff)
+#define UNCORE_PCI_DEV_IDX(data)	(data & 0xff)
+#define UNCORE_EXTRA_PCI_DEV		0xff
+#define UNCORE_EXTRA_PCI_DEV_MAX	0
+
+/* support up to 8 sockets */
+#define UNCORE_SOCKET_MAX		8
+
 #define UNCORE_EVENT_CONSTRAINT(c, n) EVENT_CONSTRAINT(c, n, 0xff)
 
 /* SNB event control */
