Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbbAPDsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:48:18 -0500
Received: from [119.145.14.66] ([119.145.14.66]:23231 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932612AbbAPDsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:48:08 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <jiang.liu@linux.intel.com>, <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        <linux-ia64@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>, <linux-alpha@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, Liviu Dudau <liviu@dudau.co.uk>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Yijing Wang" <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>
Subject: [PATCH 20/28] PCI/Parisc: Use pci_scan_root_bus() for simplicity
Date: Fri, 16 Jan 2015 09:44:18 +0800
Message-ID: <1421372666-12288-21-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.54B889D2.0010,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 66d4ad5119b43c78fade524658957320
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing0307@gmail.com>

Now pci_bus_add_devices() has been ripped out
from pci_scan_root_bus(), we could use pci_scan_root_bus()
instead of pci_create_root_bus() + pci_scan_child_bus()
for simplicity.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/parisc/dino.c    |   11 ++---------
 drivers/parisc/lba_pci.c |    6 ++----
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index a0580af..e5ee339 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -977,15 +977,11 @@ static int __init dino_probe(struct parisc_device *dev)
 	if (dino_dev->hba.gmmio_space.flags)
 		pci_add_resource(&resources, &dino_dev->hba.gmmio_space);
 
-	dino_dev->hba.bus_num.start = dino_current_bus;
-	dino_dev->hba.bus_num.end = 255;
-	dino_dev->hba.bus_num.flags = IORESOURCE_BUS;
-	pci_add_resource(&resources, &dino_dev->hba.bus_num);
 	/*
 	** It's not used to avoid chicken/egg problems
 	** with configuration accessor functions.
 	*/
-	dino_dev->hba.hba_bus = bus = pci_create_root_bus(&dev->dev,
+	dino_dev->hba.hba_bus = bus = pci_scan_root_bus(&dev->dev,
 			 dino_current_bus, &dino_cfg_ops, NULL, &resources);
 	if (!bus) {
 		printk(KERN_ERR "ERROR: failed to scan PCI bus on %s (duplicate bus number %d?)\n",
@@ -996,13 +992,10 @@ static int __init dino_probe(struct parisc_device *dev)
 		return 0;
 	}
 
-	max = pci_scan_child_bus(bus);
-	pci_bus_update_busn_res_end(bus, max);
-
 	/* This code *depends* on scanning being single threaded
 	 * if it isn't, this global bus number count will fail
 	 */
-	dino_current_bus = max + 1;
+	dino_current_bus = bus->busn_res.end + 1;
 	pci_bus_assign_resources(bus);
 	pci_bus_add_devices(bus);
 	return 0;
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index 37e71ff..9e3a016 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -1564,15 +1564,13 @@ lba_driver_probe(struct parisc_device *dev)
 
 	dev->dev.platform_data = lba_dev;
 	lba_bus = lba_dev->hba.hba_bus =
-		pci_create_root_bus(&dev->dev, lba_dev->hba.bus_num.start,
+		pci_scan_root_bus(&dev->dev, lba_dev->hba.bus_num.start,
 				    cfg_ops, NULL, &resources);
 	if (!lba_bus) {
 		pci_free_resource_list(&resources);
 		return 0;
 	}
 
-	max = pci_scan_child_bus(lba_bus);
-
 	/* This is in lieu of calling pci_assign_unassigned_resources() */
 	if (is_pdc_pat()) {
 		/* assign resources to un-initialized devices */
@@ -1600,7 +1598,7 @@ lba_driver_probe(struct parisc_device *dev)
 		lba_dev->flags |= LBA_FLAG_SKIP_PROBE;
 	}
 
-	lba_next_bus = max + 1;
+	lba_next_bus = pci_bus_child_max_busnr(lba_bus) + 1;
 	pci_bus_add_devices(lba_bus);
 
 	/* Whew! Finally done! Tell services we got this one covered. */
-- 
1.7.1

