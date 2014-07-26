Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbaGZURo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:17:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaGZTCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        Joerg Roedel <joro@8bytes.org>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 23/23] iommu/vt-d: Disable translation if already enabled
Date: Sat, 26 Jul 2014 12:02:23 -0700
Message-Id: <20140726190150.434444893@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190149.723570428@linuxfoundation.org>
References: <20140726190149.723570428@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/dmar.c        |   11 ++++++++++-
 drivers/iommu/intel-iommu.c |   15 +++++++++++++++
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
@@ -3659,6 +3659,7 @@ static struct notifier_block device_nb =
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
+	struct dmar_drhd_unit *drhd;
 
 	/* VT-d is required for a TXT/tboot launch, so enforce that */
 	force_on = tboot_force_iommu();
@@ -3669,6 +3670,20 @@ int __init intel_iommu_init(void)
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


