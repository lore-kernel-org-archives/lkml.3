Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3BRNAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:00:54 -0500
Received: from [216.32.180.189] ([216.32.180.189]:7402 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751488Ab3BRNAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:00:51 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <iommu@lists.linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <joro@8bytes.org>, <stuart.yoder@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 4/6] iommu/fsl: Add window permission flags for iommu_domain_window_enable API.
Date: Mon, 18 Feb 2013 18:22:17 +0530
Message-ID: <1361191939-21260-5-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each iommu window can have access permissions associated with it. Extended the
window_enable API to incorporate window access permissions.

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 drivers/iommu/iommu.c |    5 +++--
 include/linux/iommu.h |    7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b972d43..1a2564d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -854,12 +854,13 @@ EXPORT_SYMBOL_GPL(iommu_unmap);
 
 
 int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
-			       phys_addr_t paddr, u64 size)
+			       phys_addr_t paddr, u64 size, int iommu_prot)
 {
 	if (unlikely(domain->ops->domain_window_enable == NULL))
 		return -ENODEV;
 
-	return domain->ops->domain_window_enable(domain, wnd_nr, paddr, size);
+	return domain->ops->domain_window_enable(domain, wnd_nr, paddr, size,
+						 iommu_prot);
 }
 EXPORT_SYMBOL_GPL(iommu_domain_window_enable);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ba3b8a9..529987c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -105,7 +105,7 @@ struct iommu_ops {
 
 	/* Window handling functions */
 	int (*domain_window_enable)(struct iommu_domain *domain, u32 wnd_nr,
-				    phys_addr_t paddr, u64 size);
+				    phys_addr_t paddr, u64 size, int iommu_prot);
 	void (*domain_window_disable)(struct iommu_domain *domain, u32 wnd_nr);
 	/* Set the numer of window per domain */
 	int (*domain_set_windows)(struct iommu_domain *domain, u32 w_count);
@@ -171,7 +171,8 @@ extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
 
 /* Window handling function prototypes */
 extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
-				      phys_addr_t offset, u64 size);
+				      phys_addr_t offset, u64 size,
+				      int iommu_prot);
 extern void iommu_domain_window_disable(struct iommu_domain *domain, u32 wnd_nr);
 /**
  * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
@@ -257,7 +258,7 @@ static inline int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 
 static inline int iommu_domain_window_enable(struct iommu_domain *domain,
 					     u32 wnd_nr, phys_addr_t paddr,
-					     u64 size)
+					     u64 size, int iommu_prot)
 {
 	return -ENODEV;
 }
-- 
1.7.4.1


