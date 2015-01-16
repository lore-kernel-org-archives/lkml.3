Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbbAPDvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:51:40 -0500
Received: from [119.145.14.66] ([119.145.14.66]:22545 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbbAPDrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:47:46 -0500
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
        "Yijing Wang" <wangyijing@huawei.com>, <sparclinux@vger.kernel.org>
Subject: [PATCH 01/28] PCI: Rip out pci_bus_add_devices() from pci_scan_bus()
Date: Fri, 16 Jan 2015 09:43:59 +0800
Message-ID: <1421372666-12288-2-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.54B889BC.010D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: a214f9ebcc3dc67534ac72b986c11f09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pci_bus_add_devices() should not be placed in pci_scan_bus().
Now pci device will be added to driver core once its
creation. All things left in pci_bus_add_devices() are
driver attachment and other trivial sysfs things.
Pci_scan_bus() should be the function responsible for
scanning PCI devices, not including driver attachment.
Other, some callers(m68k,unicore32,alpha) of pci_scan_bus()
will call pci_bus_size_bridges() and pci_bus_assign_resources()
after pci_scan_bus().

E.g.
In m68k
mcf_pci_init()
	pci_scan_bus()
		...
		pci_bus_add_devices() --- try to attach driver
	pci_fixup_irqs()
	pci_bus_size_bridges()
	pci_bus_assign_resources()

It is not correct, resources should be assigned correctly
before attaching driver.
So we should rip out pci_bus_add_devices() for better
code design. After applied this patch, pci_scan_bus()
should be used in flow like:

pci_scan_bus() (mandatory)
pci_fixup_irqs() (optional)
pci_bus_size_bridges() (optional)
pci_pci_bus_assign_resources() (optional)
pci_bus_add_devices() (mandatory)

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: linux-alpha@vger.kernel.org
CC: linux-m68k@lists.linux-m68k.org
CC: sparclinux@vger.kernel.org
---
 arch/alpha/kernel/sys_nautilus.c  |    1 +
 arch/m68k/coldfire/pci.c          |    1 +
 arch/sparc/kernel/pcic.c          |    2 ++
 arch/unicore32/kernel/pci.c       |   11 +++--------
 drivers/pci/hotplug/ibmphp_core.c |    6 ++++--
 drivers/pci/probe.c               |    1 -
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/alpha/kernel/sys_nautilus.c b/arch/alpha/kernel/sys_nautilus.c
index 837c0fa..4ae4a40 100644
--- a/arch/alpha/kernel/sys_nautilus.c
+++ b/arch/alpha/kernel/sys_nautilus.c
@@ -253,6 +253,7 @@ nautilus_init_pci(void)
 	   for the root bus, so just clear it. */
 	bus->self = NULL;
 	pci_fixup_irqs(alpha_mv.pci_swizzle, alpha_mv.pci_map_irq);
+	pci_bus_add_devices(bus);
 }
 
 /*
diff --git a/arch/m68k/coldfire/pci.c b/arch/m68k/coldfire/pci.c
index df96792..d45f087 100644
--- a/arch/m68k/coldfire/pci.c
+++ b/arch/m68k/coldfire/pci.c
@@ -319,6 +319,7 @@ static int __init mcf_pci_init(void)
 	pci_fixup_irqs(pci_common_swizzle, mcf_pci_map_irq);
 	pci_bus_size_bridges(rootbus);
 	pci_bus_assign_resources(rootbus);
+	pci_bus_add_devices(rootbus);
 	return 0;
 }
 
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 6cc78c2..7a82fe2 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -391,6 +391,8 @@ static void __init pcic_pbm_scan_bus(struct linux_pcic *pcic)
 	struct linux_pbm_info *pbm = &pcic->pbm;
 
 	pbm->pci_bus = pci_scan_bus(pbm->pci_first_busno, &pcic_ops, pbm);
+	if (pbm->pci_bus)
+		pci_bus_add_devices(pbm->pci_bus);
 #if 0 /* deadwood transplanted from sparc64 */
 	pci_fill_in_pbm_cookies(pbm->pci_bus, pbm, pbm->prom_node);
 	pci_record_assignments(pbm, pbm->pci_bus);
diff --git a/arch/unicore32/kernel/pci.c b/arch/unicore32/kernel/pci.c
index 374a055..3d82024 100644
--- a/arch/unicore32/kernel/pci.c
+++ b/arch/unicore32/kernel/pci.c
@@ -266,17 +266,12 @@ static int __init pci_common_init(void)
 	pci_fixup_irqs(pci_common_swizzle, pci_puv3_map_irq);
 
 	if (!pci_has_flag(PCI_PROBE_ONLY)) {
-		/*
-		 * Size the bridge windows.
-		 */
+		/* Size the bridge windows. */
 		pci_bus_size_bridges(puv3_bus);
-
-		/*
-		 * Assign resources.
-		 */
+		/* Assign resources. */
 		pci_bus_assign_resources(puv3_bus);
 	}
-
+	pci_bus_add_devices(puv3_bus);
 	return 0;
 }
 subsys_initcall(pci_common_init);
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index 96c5c72..86e3bfd 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -738,7 +738,7 @@ static void ibm_unconfigure_device(struct pci_func *func)
  */
 static u8 bus_structure_fixup(u8 busno)
 {
-	struct pci_bus *bus;
+	struct pci_bus *bus, *b;
 	struct pci_dev *dev;
 	u16 l;
 
@@ -765,7 +765,9 @@ static u8 bus_structure_fixup(u8 busno)
 					(l != 0x0000) && (l != 0xffff)) {
 			debug("%s - Inside bus_structure_fixup()\n",
 							__func__);
-			pci_scan_bus(busno, ibmphp_pci_bus->ops, NULL);
+			b = pci_scan_bus(busno, ibmphp_pci_bus->ops, NULL);
+			if (b)
+				pci_bus_add_devices(b);
 			break;
 		}
 	}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 23212f8..053c0f4 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2123,7 +2123,6 @@ struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops,
 	b = pci_create_root_bus(NULL, bus, ops, sysdata, &resources);
 	if (b) {
 		pci_scan_child_bus(b);
-		pci_bus_add_devices(b);
 	} else {
 		pci_free_resource_list(&resources);
 	}
-- 
1.7.1

