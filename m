Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaHDRTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:19:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56439 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takao Indoh" <indou.takao@jp.fujitsu.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "Yijing Wang" <wangyijing@huawei.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.791393803@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 94/94] iommu/vt-d: Disable translation if already enabled
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takao Indoh <indou.takao@jp.fujitsu.com>

commit 3a93c841c2b3b14824f7728dd74bd00a1cedb806 upstream.

This patch disables translation(dma-remapping) before its initialization
if it is already enabled.

This is needed for kexec/kdump boot. If dma-remapping is enabled in the
first kernel, it need to be disabled before initializing its page table
during second kernel boot. Wei Hu also reported that this is needed
when second kernel boots with intel_iommu=off.

Basically iommu->gcmd is used to know whether translation is enabled or
disabled, but it is always zero at boot time even when translation is
enabled since iommu->gcmd is initialized without considering such a
case. Therefor this patch synchronizes iommu->gcmd value with global
command register when iommu structure is allocated.

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
[wyj: Backported to 3.4: adjust context]
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/dmar.c        | 11 ++++++++++-
 drivers/iommu/intel-iommu.c | 15 +++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -582,7 +582,7 @@ int alloc_iommu(struct dmar_drhd_unit *d
 {
 	struct intel_iommu *iommu;
 	int map_size;
-	u32 ver;
+	u32 ver, sts;
 	static int iommu_allocated = 0;
 	int agaw = 0;
 	int msagaw = 0;
@@ -652,6 +652,15 @@ int alloc_iommu(struct dmar_drhd_unit *d
 		(unsigned long long)iommu->cap,
 		(unsigned long long)iommu->ecap);
 
+	/* Reflect status in gcmd */
+	sts = readl(iommu->reg + DMAR_GSTS_REG);
+	if (sts & DMA_GSTS_IRES)
+		iommu->gcmd |= DMA_GCMD_IRE;
+	if (sts & DMA_GSTS_TES)
+		iommu->gcmd |= DMA_GCMD_TE;
+	if (sts & DMA_GSTS_QIES)
+		iommu->gcmd |= DMA_GCMD_QIE;
+
 	raw_spin_lock_init(&iommu->register_lock);
 
 	drhd->iommu = iommu;
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3630,6 +3630,7 @@ static struct notifier_block device_nb =
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
+	struct dmar_drhd_unit *drhd;
 
 	/* VT-d is required for a TXT/tboot launch, so enforce that */
 	force_on = tboot_force_iommu();
@@ -3640,6 +3641,20 @@ int __init intel_iommu_init(void)
 		return 	-ENODEV;
 	}
 
+	/*
+	 * Disable translation if already enabled prior to OS handover.
+	 */
+	for_each_drhd_unit(drhd) {
+		struct intel_iommu *iommu;
+
+		if (drhd->ignored)
+			continue;
+
+		iommu = drhd->iommu;
+		if (iommu->gcmd & DMA_GCMD_TE)
+			iommu_disable_translation(iommu);
+	}
+
 	if (dmar_dev_scope_init() < 0) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMAR device scope\n");

