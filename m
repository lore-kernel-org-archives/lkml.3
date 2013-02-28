Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab3B1AHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:07:42 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:7990 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3B1AHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:07:38 -0500
Message-ID: <1362010050.2808.37.camel@lorien2>
Subject: [PATCH v2 4/4] iommu/amd: Remove calc_devid() and use PCI_DEVID()
 from pci
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>, bhelgaas@google.com
Cc: jiang.liu@huawei.com, shemminger@vyatta.com, paulmck@linux.vnet.ibm.com,
        linasvepstas@gmail.com, dhowells@redhat.com, davej@redhat.com,
        tglx@linutronix.de, mtk.manpages@gmail.com,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        wangyijing@huawei.com, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Wed, 27 Feb 2013 17:07:30 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to remove calc_devid() and use PCI_DEVID() from pci instead.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 drivers/iommu/amd_iommu.c       |    2 +-
 drivers/iommu/amd_iommu_init.c  |    6 +++---
 drivers/iommu/amd_iommu_types.h |    7 -------
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c1c74e0..38c1392 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -173,7 +173,7 @@ static inline u16 get_device_id(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 
-	return calc_devid(pdev->bus->number, pdev->devfn);
+	return PCI_DEVID(pdev->bus->number, pdev->devfn);
 }
 
 static struct iommu_dev_data *get_dev_data(struct device *dev)
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index faf10ba..582b5df 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -406,7 +406,7 @@ static int __init find_last_devid_on_pci(int bus, int dev, int fn, int cap_ptr)
 	u32 cap;
 
 	cap = read_pci_config(bus, dev, fn, cap_ptr+MMIO_RANGE_OFFSET);
-	update_last_devid(calc_devid(MMIO_GET_BUS(cap), MMIO_GET_LD(cap)));
+	update_last_devid(PCI_DEVID(MMIO_GET_BUS(cap), MMIO_GET_LD(cap)));
 
 	return 0;
 }
@@ -1128,9 +1128,9 @@ static int iommu_init_pci(struct amd_iommu *iommu)
 	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_MISC_OFFSET,
 			      &misc);
 
-	iommu->first_device = calc_devid(MMIO_GET_BUS(range),
+	iommu->first_device = PCI_DEVID(MMIO_GET_BUS(range),
 					 MMIO_GET_FD(range));
-	iommu->last_device = calc_devid(MMIO_GET_BUS(range),
+	iommu->last_device = PCI_DEVID(MMIO_GET_BUS(range),
 					MMIO_GET_LD(range));
 
 	if (!(iommu->cap & (1 << IOMMU_CAP_IOTLB)))
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index a07882f..ec36cf6 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -701,13 +701,6 @@ extern int amd_iommu_max_glx_val;
  */
 extern void iommu_flush_all_caches(struct amd_iommu *iommu);
 
-/* takes bus and device/function and returns the device id
- * FIXME: should that be in generic PCI code? */
-static inline u16 calc_devid(u8 bus, u8 devfn)
-{
-	return (((u16)bus) << 8) | devfn;
-}
-
 static inline int get_ioapic_devid(int id)
 {
 	struct devid_map *entry;
-- 
1.7.9.5



