Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab3DLWqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:46:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47030 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab3DLWq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:46:27 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 03/29] PCI: Update pci_resource_start etc to use pci_dev_resource_n()
Date: Fri, 12 Apr 2013 15:44:17 -0700
Message-Id: <1365806683-26717-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now pci_resource_start is using dev->resource[n] directly.
Replace it with pci_dev_resource[n] to prepare for addon resource support.

-v2: fix warning about const pointer that Fengguang found.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/pci.h | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index ffff013..6d450d2 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1455,16 +1455,31 @@ static inline struct pci_dev *pci_dev_get(struct pci_dev *dev)
 
 /* these helpers provide future and backwards compatibility
  * for accessing popular PCI BAR info */
-#define pci_resource_start(dev, bar)	((dev)->resource[(bar)].start)
-#define pci_resource_end(dev, bar)	((dev)->resource[(bar)].end)
-#define pci_resource_flags(dev, bar)	((dev)->resource[(bar)].flags)
-#define pci_resource_len(dev,bar) \
-	((pci_resource_start((dev), (bar)) == 0 &&	\
-	  pci_resource_end((dev), (bar)) ==		\
-	  pci_resource_start((dev), (bar))) ? 0 :	\
-							\
-	 (pci_resource_end((dev), (bar)) -		\
-	  pci_resource_start((dev), (bar)) + 1))
+static inline resource_size_t pci_resource_start(const struct pci_dev *dev,
+						 int bar)
+{
+	return pci_dev_resource_n((struct pci_dev *)dev, bar)->start;
+}
+static inline resource_size_t pci_resource_end(const struct pci_dev *dev,
+						int bar)
+{
+	return pci_dev_resource_n((struct pci_dev *)dev, bar)->end;
+}
+static inline unsigned long pci_resource_flags(const struct pci_dev *dev,
+						 int bar)
+{
+	return pci_dev_resource_n((struct pci_dev *)dev, bar)->flags;
+}
+static inline resource_size_t pci_resource_len(const struct pci_dev *dev,
+							 int bar)
+{
+	struct resource *res = pci_dev_resource_n((struct pci_dev *)dev, bar);
+
+	if (res->start == 0 && res->end == res->start)
+		return 0;
+
+	return res->end - res->start + 1;
+}
 
 /* Similar to the helpers above, these manipulate per-pci_dev
  * driver-specific data.  They are really just a wrapper around
-- 
1.8.1.4

