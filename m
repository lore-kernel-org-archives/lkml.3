Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab3KUFlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 00:41:55 -0500
Received: from ozlabs.org ([203.10.76.45]:36973 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab3KUFlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 00:41:53 -0500
Message-ID: <528D9D1C.5060407@ozlabs.org>
Date: Thu, 21 Nov 2013 13:41:48 +0800
From: Jeremy Kerr <jk@ozlabs.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
CC: Alex Graf <agraf@suse.de>, Bharat Bhushan <bharat.bhushan@freescale.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9] PPC: POWERNV: move iommu_add_device earlier
References: <1384324220-30109-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1384324220-30109-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

> This patch does 2 things:
> 1. removes the loop in which PCI devices were added to groups and
> adds explicit iommu_add_device() calls to add devices as soon as they get
> the iommu_table pointer assigned to them.
> 2. moves a bus notifier to powernv code in order to avoid conflict with
> the notifier from Freescale driver.

This breaks when building with !IOMMU_API for me, as the
iommu_add_device function is declared but not defined. We'd need
something like the following (on top of your change) to work:

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 426d0ec0..04d2abbe 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -102,10 +102,27 @@ extern void iommu_free_table(struct iommu_table *tbl, cons
  */
 extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
                                            int nid);
+
+#ifdef CONFIG_IOMMU_API
 extern void iommu_register_group(struct iommu_table *tbl,
                                 int pci_domain_number, unsigned long pe_num);
 extern int iommu_add_device(struct device *dev);
 extern void iommu_del_device(struct device *dev);
+#else
+static inline void iommu_register_group(struct iommu_table *tbl,
+                                int pci_domain_number, unsigned long pe_num)
+{
+}
+
+static inline int iommu_add_device(struct device *dev)
+{
+       return 0;
+}
+
+static inline void iommu_del_device(struct device *dev)
+{
+}
+#endif
 
 static inline void set_iommu_table_base_and_group(struct device *dev,
                                                  void *base)
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 170b2182..5a02a50f 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1212,11 +1212,4 @@ void iommu_del_device(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_del_device);
 
-#else
-
-void iommu_register_group(struct iommu_table *tbl,
-               int pci_domain_number, unsigned long pe_num)
-{
-}
-
 #endif /* CONFIG_IOMMU_API */


Cheers,


Jeremy



