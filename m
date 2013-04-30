Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451Ab3D3Ldg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:33:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23700 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760372Ab3D3LdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:33:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,581,1363104000"; 
   d="scan'208,223";a="7159408"
Message-ID: <517FAB90.3030502@cn.fujitsu.com>
Date: Tue, 30 Apr 2013 19:31:28 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, tangchen <tangchen@cn.fujitsu.com>,
        Lin Feng <linfeng@cn.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, guz.fnst@cn.fujitsu.com
Subject: [PATCH v2 3/4] PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus)
 instead
References: <516FB647.5030203@cn.fujitsu.com> <CAErSpo65ARR_fZwsGCZDJqbPWktHYUkufgPt-2mWwur=nPR1Qg@mail.gmail.com>
In-Reply-To: <CAErSpo65ARR_fZwsGCZDJqbPWktHYUkufgPt-2mWwur=nPR1Qg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 19:31:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 19:31:36,
	Serialize complete at 2013/04/30 19:31:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 055d93b0e9a29f3786996f90b7893bd6eb4d244b Mon Sep 17 00:00:00 2001
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Tue, 30 Apr 2013 17:23:31 +0900
Subject: [PATCH v2 3/4] PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus)
 instead

Use the new pci_alloc_dev(bus) to replace the existing using of alloc_pci_dev(void).
And new functions pci_bus_get/put() are introdued to hide pci_bus' reference management.

v2:
  Follow Bjorn's correction to move pci_bus_put() to pci_release_dev() instead.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 arch/powerpc/kernel/pci_of_scan.c |    3 +--
 arch/sparc/kernel/pci.c           |    3 +--
 drivers/char/agp/alpha-agp.c      |    2 +-
 drivers/char/agp/parisc-agp.c     |    2 +-
 drivers/pci/iov.c                 |    8 +++++---
 drivers/pci/probe.c               |   10 ++++------
 drivers/scsi/megaraid.c           |    2 +-
 7 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 2a67e9b..24d01c4 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -128,7 +128,7 @@ struct pci_dev *of_create_pci_dev(struct device_node *node,
 	const char *type;
 	struct pci_slot *slot;
 
-	dev = alloc_pci_dev();
+	dev = pci_alloc_dev(bus);
 	if (!dev)
 		return NULL;
 	type = of_get_property(node, "device_type", NULL);
@@ -137,7 +137,6 @@ struct pci_dev *of_create_pci_dev(struct device_node *node,
 
 	pr_debug("    create device, devfn: %x, type: %s\n", devfn, type);
 
-	dev->bus = bus;
 	dev->dev.of_node = of_node_get(node);
 	dev->dev.parent = bus->bridge;
 	dev->dev.bus = &pci_bus_type;
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index baf4366..e5871fb 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -254,7 +254,7 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	const char *type;
 	u32 class;
 
-	dev = alloc_pci_dev();
+	dev = pci_alloc_dev(bus);
 	if (!dev)
 		return NULL;
 
@@ -281,7 +281,6 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 		printk("    create device, devfn: %x, type: %s\n",
 		       devfn, type);
 
-	dev->bus = bus;
 	dev->sysdata = node;
 	dev->dev.parent = bus->bridge;
 	dev->dev.bus = &pci_bus_type;
diff --git a/drivers/char/agp/alpha-agp.c b/drivers/char/agp/alpha-agp.c
index dd84af4..199b8e9 100644
--- a/drivers/char/agp/alpha-agp.c
+++ b/drivers/char/agp/alpha-agp.c
@@ -174,7 +174,7 @@ alpha_core_agp_setup(void)
 	/*
 	 * Build a fake pci_dev struct
 	 */
-	pdev = alloc_pci_dev();
+	pdev = pci_alloc_dev(NULL);
 	if (!pdev)
 		return -ENOMEM;
 	pdev->vendor = 0xffff;
diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 94821ab..bf5d247 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -333,7 +333,7 @@ parisc_agp_setup(void __iomem *ioc_hpa, void __iomem *lba_hpa)
 	struct agp_bridge_data *bridge;
 	int error = 0;
 
-	fake_bridge_dev = alloc_pci_dev();
+	fake_bridge_dev = pci_alloc_dev(NULL);
 	if (!fake_bridge_dev) {
 		error = -ENOMEM;
 		goto fail;
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index ee599f2..24134cd 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -75,18 +75,20 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 	struct pci_dev *virtfn;
 	struct resource *res;
 	struct pci_sriov *iov = dev->sriov;
+	struct pci_bus *bus;
 
-	virtfn = alloc_pci_dev();
+	virtfn = pci_alloc_dev(NULL);
 	if (!virtfn)
 		return -ENOMEM;
 
 	mutex_lock(&iov->dev->sriov->lock);
-	virtfn->bus = virtfn_add_bus(dev->bus, virtfn_bus(dev, id));
-	if (!virtfn->bus) {
+	bus = virtfn_add_bus(dev->bus, virtfn_bus(dev, id));
+	if (!bus) {
 		kfree(virtfn);
 		mutex_unlock(&iov->dev->sriov->lock);
 		return -ENOMEM;
 	}
+	virtfn->bus = pci_bus_get(bus);
 	virtfn->devfn = virtfn_devfn(dev, id);
 	virtfn->vendor = dev->vendor;
 	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_DID, &virtfn->device);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 89db76a..32cf908 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1131,6 +1131,7 @@ static void pci_release_dev(struct device *dev)
 	struct pci_dev *pci_dev;
 
 	pci_dev = to_pci_dev(dev);
+	pci_bus_put(pci_dev->bus);
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
 	kfree(pci_dev);
@@ -1211,10 +1212,8 @@ struct pci_dev *pci_alloc_dev(struct pci_bus *bus)
 
 	INIT_LIST_HEAD(&dev->bus_list);
 
-	if (bus) {
-		get_device(&bus->dev);
-		dev->bus = bus;
-	}
+	if (bus)
+		dev->bus = pci_bus_get(bus);
 
 	return dev;
 }
@@ -1274,11 +1273,10 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	if (!pci_bus_read_dev_vendor_id(bus, devfn, &l, 60*1000))
 		return NULL;
 
-	dev = alloc_pci_dev();
+	dev = pci_alloc_dev(bus);
 	if (!dev)
 		return NULL;
 
-	dev->bus = bus;
 	dev->devfn = devfn;
 	dev->vendor = l & 0xffff;
 	dev->device = (l >> 16) & 0xffff;
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 9504ec0..e1660ca 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -2025,7 +2025,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 static inline int
 make_local_pdev(adapter_t *adapter, struct pci_dev **pdev)
 {
-	*pdev = alloc_pci_dev();
+	*pdev = pci_alloc_dev(NULL);
 
 	if( *pdev == NULL ) return -1;
 
-- 
1.7.7

