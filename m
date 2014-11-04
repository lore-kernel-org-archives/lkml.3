Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaKDBA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:00:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:11456 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbaKDBAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:00:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,310,1413270000"; 
   d="scan'208";a="616484632"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] perf, x86, uncore: Fix IRP uncore register offsets on Haswell EP
Date: Mon,  3 Nov 2014 17:00:27 -0800
Message-Id: <1415062828-19759-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415062828-19759-1-git-send-email-andi@firstfloor.org>
References: <1415062828-19759-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The counter register offsets for the IRP box PMU for Haswell-EP
were incorrect. The offsets actually changed over IvyBridge EP.

Fix them to the correct values. For this we need to fork the read
function from the IVB and use an own counter array.

Thanks to Patrick Lu.

Tested-by: patrick.lu@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index 286c692..04e9a83 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -2033,13 +2033,27 @@ static struct intel_uncore_type hswep_uncore_imc = {
 	SNBEP_UNCORE_PCI_COMMON_INIT(),
 };
 
+static unsigned hswep_uncore_irp_ctrs[] = {0xa0, 0xa8, 0xb0, 0xb8};
+
+static u64 hswep_uncore_irp_read_counter(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct pci_dev *pdev = box->pci_dev;
+	struct hw_perf_event *hwc = &event->hw;
+	u64 count = 0;
+
+	pci_read_config_dword(pdev, hswep_uncore_irp_ctrs[hwc->idx], (u32 *)&count);
+	pci_read_config_dword(pdev, hswep_uncore_irp_ctrs[hwc->idx] + 4, (u32 *)&count + 1);
+
+	return count;
+}
+
 static struct intel_uncore_ops hswep_uncore_irp_ops = {
 	.init_box	= snbep_uncore_pci_init_box,
 	.disable_box	= snbep_uncore_pci_disable_box,
 	.enable_box	= snbep_uncore_pci_enable_box,
 	.disable_event	= ivbep_uncore_irp_disable_event,
 	.enable_event	= ivbep_uncore_irp_enable_event,
-	.read_counter	= ivbep_uncore_irp_read_counter,
+	.read_counter	= hswep_uncore_irp_read_counter,
 };
 
 static struct intel_uncore_type hswep_uncore_irp = {
-- 
1.9.3

