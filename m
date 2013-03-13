Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965062Ab3CMXaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:30:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51624 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab3CMXaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:30:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 01/27] PCI: Add pci_dev_resource_n()
Date: Wed, 13 Mar 2013 16:27:56 -0700
Message-Id: <1363217302-14383-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now pci device resource iteration is done via "for (i=0...)" open code.
That make code hard to read esp when only bridge or sriov resources
are involved.

We want to replace those open code with for_each_pci_resource().
Also want to add addon_resource handling, and need to make addon resource
to be treated as normal PCI resources during iteration.

Add pci_device_resource_n() instead of using dev->resources[n].
Use it with for_each_pci_resource macro and addon_resource support.

-v2: Add EXPORT_SYMBOL to find building error found by Gary Hade

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |    9 +++++++++
 include/linux/pci.h |    2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b494066..9cb3eb3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -105,6 +105,15 @@ static int __init pcibus_class_init(void)
 }
 postcore_initcall(pcibus_class_init);
 
+struct resource *pci_dev_resource_n(struct pci_dev *dev, int n)
+{
+	if (n >= 0 && n < PCI_NUM_RESOURCES)
+		return &dev->resource[n];
+
+	return NULL;
+}
+EXPORT_SYMBOL(pci_dev_resource_n);
+
 static u64 pci_size(u64 base, u64 maxbase, u64 mask)
 {
 	u64 size = mask & maxbase;	/* Find the significant bits */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2461033a..00d5367 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -338,6 +338,8 @@ struct pci_dev {
 	size_t romlen; /* Length of ROM if it's not from the BAR */
 };
 
+struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
+
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
 {
 #ifdef CONFIG_PCI_IOV
-- 
1.7.10.4

