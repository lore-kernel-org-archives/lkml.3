Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3LLH6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:58:51 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10197 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab3LLH6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:58:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Dec 2013 00:00:24 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, <swarren@nvidia.com>,
        <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <robherring2@gmail.com>, <joro@8bytes.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <galak@codeaurora.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv7 11/12] iommu/tegra: smmu: Rename hwgrp -> swgroups
Date: Thu, 12 Dec 2013 09:57:12 +0200
Message-ID: <1386835033-4701-12-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the correct term for SWGROUP related variables and macros.

The term "swgroup" is the collection of "memory client". A "memory
client" usually represents a HardWare Accelerator(HWA) like
GPU. Sometimes a strut device can belong to multiple "swgroup" so that
"swgroup's'" is used here. This "swgroups" is the term used in Tegra
TRM. Rename along with TRM.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v4:
New for v4

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 2b8a302..2d4b8b6 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -179,12 +179,12 @@ enum {
 
 #define NUM_SMMU_REG_BANKS	3
 
-#define smmu_client_enable_hwgrp(c, m)	smmu_client_set_hwgrp(c, m, 1)
-#define smmu_client_disable_hwgrp(c)	smmu_client_set_hwgrp(c, 0, 0)
-#define __smmu_client_enable_hwgrp(c, m) __smmu_client_set_hwgrp(c, m, 1)
-#define __smmu_client_disable_hwgrp(c)	__smmu_client_set_hwgrp(c, 0, 0)
+#define smmu_client_enable_swgroups(c, m) smmu_client_set_swgroups(c, m, 1)
+#define smmu_client_disable_swgroups(c) smmu_client_set_swgroups(c, 0, 0)
+#define __smmu_client_enable_swgroups(c, m) __smmu_client_set_swgroups(c, m, 1)
+#define __smmu_client_disable_swgroups(c) __smmu_client_set_swgroups(c, 0, 0)
 
-#define HWGRP_ASID_REG(x) ((x) * sizeof(u32) + SMMU_ASID_BASE)
+#define SWGROUPS_ASID_REG(x) ((x) * sizeof(u32) + SMMU_ASID_BASE)
 
 /*
  * Per client for address space
@@ -195,7 +195,7 @@ struct smmu_client {
 	struct device		*dev;
 	struct list_head	list;
 	struct smmu_as		*as;
-	unsigned long		hwgrp[2];
+	unsigned long		swgroups[2];
 };
 
 /*
@@ -377,7 +377,7 @@ static int register_smmu_client(struct smmu_device *smmu,
 
 	client->dev = dev;
 	client->of_node = dev->of_node;
-	memcpy(client->hwgrp, swgroups, sizeof(u64));
+	memcpy(client->swgroups, swgroups, sizeof(u64));
 	return insert_smmu_client(smmu, client);
 }
 
@@ -403,7 +403,7 @@ static int smmu_of_get_swgroups(struct device *dev, unsigned long *swgroups)
 	return -ENODEV;
 }
 
-static int __smmu_client_set_hwgrp(struct smmu_client *c,
+static int __smmu_client_set_swgroups(struct smmu_client *c,
 				   unsigned long *map, int on)
 {
 	int i;
@@ -412,10 +412,10 @@ static int __smmu_client_set_hwgrp(struct smmu_client *c,
 	struct smmu_device *smmu = as->smmu;
 
 	if (!on)
-		map = c->hwgrp;
+		map = c->swgroups;
 
 	for_each_set_bit(i, map, TEGRA_SWGROUP_MAX) {
-		offs = HWGRP_ASID_REG(i);
+		offs = SWGROUPS_ASID_REG(i);
 		val = smmu_read(smmu, offs);
 		if (on) {
 			if (val) {
@@ -425,7 +425,7 @@ static int __smmu_client_set_hwgrp(struct smmu_client *c,
 			}
 
 			val = mask;
-			memcpy(c->hwgrp, map, sizeof(u64));
+			memcpy(c->swgroups, map, sizeof(u64));
 		} else {
 			WARN_ON((val & mask) == mask);
 			val &= ~mask;
@@ -438,7 +438,7 @@ skip:
 	return 0;
 }
 
-static int smmu_client_set_hwgrp(struct smmu_client *c,
+static int smmu_client_set_swgroups(struct smmu_client *c,
 				 unsigned long *map, int on)
 {
 	int err;
@@ -447,7 +447,7 @@ static int smmu_client_set_hwgrp(struct smmu_client *c,
 	struct smmu_device *smmu = as->smmu;
 
 	spin_lock_irqsave(&smmu->lock, flags);
-	err = __smmu_client_set_hwgrp(c, map, on);
+	err = __smmu_client_set_swgroups(c, map, on);
 	spin_unlock_irqrestore(&smmu->lock, flags);
 	return err;
 }
@@ -487,7 +487,7 @@ static int smmu_setup_regs(struct smmu_device *smmu)
 		smmu_write(smmu, val, SMMU_PTB_DATA);
 
 		list_for_each_entry(c, &as->client, list)
-			__smmu_client_set_hwgrp(c, c->hwgrp, 1);
+			__smmu_client_set_swgroups(c, c->swgroups, 1);
 	}
 
 	smmu_write(smmu, smmu->translation_enable_0, SMMU_TRANSLATION_ENABLE_0);
@@ -815,7 +815,7 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,
 		return -ENOMEM;
 
 	client->as = as;
-	err = smmu_client_enable_hwgrp(client, client->hwgrp);
+	err = smmu_client_enable_swgroups(client, client->swgroups);
 	if (err)
 		return -EINVAL;
 
@@ -835,7 +835,7 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,
 	 * Reserve "page zero" for AVP vectors using a common dummy
 	 * page.
 	 */
-	if (test_bit(TEGRA_SWGROUP_AVPC, client->hwgrp)) {
+	if (test_bit(TEGRA_SWGROUP_AVPC, client->swgroups)) {
 		struct page *page;
 
 		page = as->smmu->avp_vector_page;
@@ -848,7 +848,7 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,
 	return 0;
 
 err_client:
-	smmu_client_disable_hwgrp(client);
+	smmu_client_disable_swgroups(client);
 	spin_unlock(&as->client_lock);
 	return err;
 }
@@ -864,7 +864,7 @@ static void smmu_iommu_detach_dev(struct iommu_domain *domain,
 
 	list_for_each_entry(c, &as->client, list) {
 		if (c->dev == dev) {
-			smmu_client_disable_hwgrp(c);
+			smmu_client_disable_swgroups(c);
 			list_del(&c->list);
 			c->as = NULL;
 			dev_dbg(smmu->dev,
-- 
1.8.1.5

