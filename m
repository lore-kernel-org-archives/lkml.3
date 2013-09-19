Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3ISHhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:37:12 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:23066 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253Ab3ISHhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:37:03 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kz70kd2iz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h20cfi1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>,
        <benh@kernel.crashing.org>, <galak@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-pci@vger.kernel.org>, <agraf@suse.de>,
        <scottwood@freescale.com>, <iommu@lists.linux-foundation.org>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 2/7] iommu: add api to get iommu_domain of a device
Date: Thu, 19 Sep 2013 12:59:18 +0530
Message-ID: <1379575763-2091-3-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This api return the iommu domain to which the device is attached.
The iommu_domain is required for making API calls related to iommu.
Follow up patches which use this API to know iommu maping.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 drivers/iommu/iommu.c |   10 ++++++++++
 include/linux/iommu.h |    7 +++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fbe9ca7..6ac5f50 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -696,6 +696,16 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_detach_device);
 
+struct iommu_domain *iommu_get_dev_domain(struct device *dev)
+{
+	struct iommu_ops *ops = dev->bus->iommu_ops;
+
+	if (unlikely(ops == NULL || ops->get_dev_iommu_domain == NULL))
+		return NULL;
+
+	return ops->get_dev_iommu_domain(dev);
+}
+EXPORT_SYMBOL_GPL(iommu_get_dev_domain);
 /*
  * IOMMU groups are really the natrual working unit of the IOMMU, but
  * the IOMMU API works on domains and devices.  Bridge that gap by
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 7ea319e..fa046bd 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -127,6 +127,7 @@ struct iommu_ops {
 	int (*domain_set_windows)(struct iommu_domain *domain, u32 w_count);
 	/* Get the numer of window per domain */
 	u32 (*domain_get_windows)(struct iommu_domain *domain);
+	struct iommu_domain *(*get_dev_iommu_domain)(struct device *dev);
 
 	unsigned long pgsize_bitmap;
 };
@@ -190,6 +191,7 @@ extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
 				      phys_addr_t offset, u64 size,
 				      int prot);
 extern void iommu_domain_window_disable(struct iommu_domain *domain, u32 wnd_nr);
+extern struct iommu_domain *iommu_get_dev_domain(struct device *dev);
 /**
  * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
  * @domain: the iommu domain where the fault has happened
@@ -284,6 +286,11 @@ static inline void iommu_domain_window_disable(struct iommu_domain *domain,
 {
 }
 
+static inline struct iommu_domain *iommu_get_dev_domain(struct device *dev)
+{
+	return NULL;
+}
+
 static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova)
 {
 	return 0;
-- 
1.7.0.4


