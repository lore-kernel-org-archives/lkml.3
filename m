Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423560Ab3CVWn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:43:27 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:42316
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422648Ab3CVWnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:43:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <benh@kernel.crashing.org>,
        <scottwood@freescale.com>, <stuart.yoder@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 3/5 v10] iommu/fsl: Add the window permission flag as a parameter to iommu_window_enable API.
Date: Sat, 23 Mar 2013 04:04:59 +0530
Message-ID: <1363991700-21454-5-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363991700-21454-1-git-send-email-Varun.Sethi@freescale.com>
References: <1363991700-21454-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each iommu window can have access permissions associated with it. Extended the
window_enable API to incorporate window access permissions.

In case of PAMU each window can have its specific set of permissions.

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
- no change in v10.

 drivers/iommu/iommu.c |    5 +++--
 include/linux/iommu.h |    7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 39106ec..c4d5265 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -853,12 +853,13 @@ EXPORT_SYMBOL_GPL(iommu_unmap);
 
 
 int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
-			       phys_addr_t paddr, u64 size)
+			       phys_addr_t paddr, u64 size, int prot)
 {
 	if (unlikely(domain->ops->domain_window_enable == NULL))
 		return -ENODEV;
 
-	return domain->ops->domain_window_enable(domain, wnd_nr, paddr, size);
+	return domain->ops->domain_window_enable(domain, wnd_nr, paddr, size,
+						 prot);
 }
 EXPORT_SYMBOL_GPL(iommu_domain_window_enable);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 576cc19..02ac111 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -104,7 +104,7 @@ struct iommu_ops {
 
 	/* Window handling functions */
 	int (*domain_window_enable)(struct iommu_domain *domain, u32 wnd_nr,
-				    phys_addr_t paddr, u64 size);
+				    phys_addr_t paddr, u64 size, int prot);
 	void (*domain_window_disable)(struct iommu_domain *domain, u32 wnd_nr);
 	/* Set the numer of window per domain */
 	int (*domain_set_windows)(struct iommu_domain *domain, u32 w_count);
@@ -169,7 +169,8 @@ extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
 
 /* Window handling function prototypes */
 extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
-				      phys_addr_t offset, u64 size);
+				      phys_addr_t offset, u64 size,
+				      int prot);
 extern void iommu_domain_window_disable(struct iommu_domain *domain, u32 wnd_nr);
 /**
  * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
@@ -255,7 +256,7 @@ static inline int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 
 static inline int iommu_domain_window_enable(struct iommu_domain *domain,
 					     u32 wnd_nr, phys_addr_t paddr,
-					     u64 size)
+					     u64 size, int prot)
 {
 	return -ENODEV;
 }
-- 
1.7.4.1


