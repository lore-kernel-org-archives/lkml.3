Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab3KFNWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:22:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48951 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab3KFNUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:20:24 -0500
Date: Wed, 6 Nov 2013 05:19:51 -0800
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-d1e8f4a8365d16fd179cb8cad5b4d20aafd0a695@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1383197815-17706-1-git-send-email-zheng.z.yan@intel.com>
References: <1383197815-17706-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel/uncore:
  Add filter support for IvyBridge-EP QPI boxes
Git-Commit-ID: d1e8f4a8365d16fd179cb8cad5b4d20aafd0a695
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:19:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1e8f4a8365d16fd179cb8cad5b4d20aafd0a695
Gitweb:     http://git.kernel.org/tip/d1e8f4a8365d16fd179cb8cad5b4d20aafd0a695
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Thu, 31 Oct 2013 13:36:54 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:34:29 +0100

perf/x86/intel/uncore: Add filter support for IvyBridge-EP QPI boxes

The encoding for filter registers of IvyBridge-EP uncore QPI boxes is
completely the same as SandyBridge-EP.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com
Cc: "Yan Zheng" <zheng.z.yan@intel.com>
Link: http://lkml.kernel.org/r/1383197815-17706-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 61 ++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 4118f9f..6da3999 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1099,6 +1099,24 @@ static struct attribute *ivt_uncore_qpi_formats_attr[] = {
 	&format_attr_umask.attr,
 	&format_attr_edge.attr,
 	&format_attr_thresh8.attr,
+	&format_attr_match_rds.attr,
+	&format_attr_match_rnid30.attr,
+	&format_attr_match_rnid4.attr,
+	&format_attr_match_dnid.attr,
+	&format_attr_match_mc.attr,
+	&format_attr_match_opc.attr,
+	&format_attr_match_vnw.attr,
+	&format_attr_match0.attr,
+	&format_attr_match1.attr,
+	&format_attr_mask_rds.attr,
+	&format_attr_mask_rnid30.attr,
+	&format_attr_mask_rnid4.attr,
+	&format_attr_mask_dnid.attr,
+	&format_attr_mask_mc.attr,
+	&format_attr_mask_opc.attr,
+	&format_attr_mask_vnw.attr,
+	&format_attr_mask0.attr,
+	&format_attr_mask1.attr,
 	NULL,
 };
 
@@ -1312,17 +1330,30 @@ static struct intel_uncore_type ivt_uncore_imc = {
 	IVT_UNCORE_PCI_COMMON_INIT(),
 };
 
+static struct intel_uncore_ops ivt_uncore_qpi_ops = {
+	.init_box	= ivt_uncore_pci_init_box,
+	.disable_box	= snbep_uncore_pci_disable_box,
+	.enable_box	= snbep_uncore_pci_enable_box,
+	.disable_event	= snbep_uncore_pci_disable_event,
+	.enable_event	= snbep_qpi_enable_event,
+	.read_counter	= snbep_uncore_pci_read_counter,
+	.hw_config	= snbep_qpi_hw_config,
+	.get_constraint	= uncore_get_constraint,
+	.put_constraint	= uncore_put_constraint,
+};
+
 static struct intel_uncore_type ivt_uncore_qpi = {
-	.name		= "qpi",
-	.num_counters   = 4,
-	.num_boxes	= 3,
-	.perf_ctr_bits	= 48,
-	.perf_ctr	= SNBEP_PCI_PMON_CTR0,
-	.event_ctl	= SNBEP_PCI_PMON_CTL0,
-	.event_mask	= IVT_QPI_PCI_PMON_RAW_EVENT_MASK,
-	.box_ctl	= SNBEP_PCI_PMON_BOX_CTL,
-	.ops		= &ivt_uncore_pci_ops,
-	.format_group	= &ivt_uncore_qpi_format_group,
+	.name			= "qpi",
+	.num_counters		= 4,
+	.num_boxes		= 3,
+	.perf_ctr_bits		= 48,
+	.perf_ctr		= SNBEP_PCI_PMON_CTR0,
+	.event_ctl		= SNBEP_PCI_PMON_CTL0,
+	.event_mask		= IVT_QPI_PCI_PMON_RAW_EVENT_MASK,
+	.box_ctl		= SNBEP_PCI_PMON_BOX_CTL,
+	.num_shared_regs	= 1,
+	.ops			= &ivt_uncore_qpi_ops,
+	.format_group		= &ivt_uncore_qpi_format_group,
 };
 
 static struct intel_uncore_type ivt_uncore_r2pcie = {
@@ -1429,6 +1460,16 @@ static DEFINE_PCI_DEVICE_TABLE(ivt_uncore_pci_ids) = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe3e),
 		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R3QPI, 2),
 	},
+	{ /* QPI Port 0 filter  */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe86),
+		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
+						   SNBEP_PCI_QPI_PORT0_FILTER),
+	},
+	{ /* QPI Port 0 filter  */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe96),
+		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
+						   SNBEP_PCI_QPI_PORT1_FILTER),
+	},
 	{ /* end: all zeroes */ }
 };
 
