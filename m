Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbbAUCl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 21:41:29 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:12958 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbAUCcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 21:32:36 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <jiang.liu@linux.intel.com>, <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Tony Luck <tony.luck@intel.com>,
        <linux-ia64@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>, <linux-alpha@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, Liviu Dudau <liviu@dudau.co.uk>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Yijing Wang" <wangyijing@huawei.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v2 16/30] PCI/IA64: Fix the build warning about pci_domain_nr()
Date: Wed, 21 Jan 2015 08:30:11 +0800
Message-ID: <1421800225-26230-17-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421800225-26230-1-git-send-email-wangyijing@huawei.com>
References: <1421800225-26230-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.54BF0FBF.0086,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 757facdf28b1dfff6b16eff797b4506b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should pass pci_bus * instead of pci_dev * to pci_domain_nr().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
CC: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
CC: linux-ia64@vger.kernel.org
---
 arch/ia64/sn/kernel/io_acpi_init.c |    6 +++---
 arch/ia64/sn/kernel/io_init.c      |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/sn/kernel/io_acpi_init.c b/arch/ia64/sn/kernel/io_acpi_init.c
index 0640739..2fd7414 100644
--- a/arch/ia64/sn/kernel/io_acpi_init.c
+++ b/arch/ia64/sn/kernel/io_acpi_init.c
@@ -364,12 +364,12 @@ sn_acpi_get_pcidev_info(struct pci_dev *dev, struct pcidev_info **pcidev_info,
         status = acpi_evaluate_integer(rootbus_handle, METHOD_NAME__SEG, NULL,
                                        &segment);
         if (ACPI_SUCCESS(status)) {
-		if (segment != pci_domain_nr(dev)) {
+		if (segment != pci_domain_nr(dev->bus)) {
 			acpi_get_name(rootbus_handle, ACPI_FULL_PATHNAME,
 				&name_buffer);
 			printk(KERN_ERR
 			       "%s: Segment number mismatch, 0x%llx vs 0x%x for: %s\n",
-			       __func__, segment, pci_domain_nr(dev),
+			       __func__, segment, pci_domain_nr(dev->bus),
 			       (char *)name_buffer.pointer);
 			kfree(name_buffer.pointer);
 			return 1;
@@ -407,7 +407,7 @@ sn_acpi_get_pcidev_info(struct pci_dev *dev, struct pcidev_info **pcidev_info,
 	/* Build up the pcidev_info.pdi_slot_host_handle */
 	host_devfn = get_host_devfn(pcidev_match.handle, rootbus_handle);
 	(*pcidev_info)->pdi_slot_host_handle =
-			((unsigned long) pci_domain_nr(dev) << 40) |
+			((unsigned long) pci_domain_nr(dev->bus) << 40) |
 					/* bus == 0 */
 					host_devfn;
 	return 0;
diff --git a/arch/ia64/sn/kernel/io_init.c b/arch/ia64/sn/kernel/io_init.c
index bcdc5b8..a97fad4 100644
--- a/arch/ia64/sn/kernel/io_init.c
+++ b/arch/ia64/sn/kernel/io_init.c
@@ -164,7 +164,7 @@ sn_io_slot_fixup(struct pci_dev *dev)
 		panic("%s: Unable to alloc memory for sn_irq_info", __func__);
 
 	/* Call to retrieve pci device information needed by kernel. */
-	status = sal_get_pcidev_info((u64) pci_domain_nr(dev),
+	status = sal_get_pcidev_info((u64) pci_domain_nr(dev->bus),
 		(u64) dev->bus->number,
 		dev->devfn,
 		(u64) __pa(pcidev_info),
-- 
1.7.1

