Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaLOJyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:54:55 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:55966 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaLOJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:54:47 -0500
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <dwmw2@infradead.org>, <indou.takao@jp.fujitsu.com>, <bhe@redhat.com>,
        <joro@8bytes.org>, <vgoyal@redhat.com>, <dyoung@redhat.com>,
        <billsumnerlinux@gmail.com>, <zhen-hual@hp.com>
Cc: <iommu@lists.linux-foundation.org>, <kexec@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <ishii.hironobu@jp.fujitsu.com>, <bhelgaas@google.com>,
        <doug.hatch@hp.com>, <jerry.hoemann@hp.com>, <tom.vaden@hp.com>,
        <li.zhang6@hp.com>, <lisa.mitchell@hp.com>
Subject: [PATCH 08/10] iommu/vtd: assign new page table for dma_map
Date: Mon, 15 Dec 2014 17:53:04 +0800
Message-Id: <1418637186-9988-9-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <1418637186-9988-1-git-send-email-zhen-hual@hp.com>
References: <1418637186-9988-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a device driver issues the first dma_map command for a
device, we assign a new and empty page-table, thus removing all
mappings from the old kernel for the device.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/intel-iommu.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 4837ce5..f11a9b1 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3200,15 +3200,28 @@ static struct dmar_domain *__get_valid_domain_for_dev(struct device *dev)
 	}
 
 	/* make sure context mapping is ok */
-	if (unlikely(!domain_context_mapped(dev))) {
-		ret = domain_context_mapping(domain, dev, CONTEXT_TT_MULTI_LEVEL);
-		if (ret) {
-			printk(KERN_ERR "Domain context map for %s failed",
-			       dev_name(dev));
-			return NULL;
-		}
+	if (likely(domain_context_mapped(dev))) {
+#ifdef CONFIG_CRASH_DUMP
+		if (is_kdump_kernel()) {
+			domain_exit(domain);
+			domain = get_domain_for_dev(dev,
+				DEFAULT_DOMAIN_ADDRESS_WIDTH);
+			if (!domain) {
+				pr_err("Allocating domain for %s failed",
+				       dev_name(dev));
+				return NULL;
+			}
+		} else
+#endif
+			return domain;
 	}
 
+	ret = domain_context_mapping(domain, dev, CONTEXT_TT_MULTI_LEVEL);
+	if (ret) {
+		pr_err("Domain context map for %s failed",
+		       dev_name(dev));
+		return NULL;
+	}
 	return domain;
 }
 
-- 
2.0.0-rc0

