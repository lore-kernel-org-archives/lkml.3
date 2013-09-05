Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289Ab3IEMhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:37:10 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:42315 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934668Ab3IEMhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:37:08 -0400
X-Greylist: delayed 3605 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Sep 2013 08:37:08 EDT
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 4/4] BMC support for PARISC machines
Date: Thu, 05 Sep 2013 06:36:36 -0500
Message-id: <1378380996-4844-5-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1378380996-4844-1-git-send-email-minyard@acm.org>
References: <1378380996-4844-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

The last line of PARISC machines (C8000, RP34x0, etc.) have a BMC for
controlling temperature, fan speed and other stuff. The BMC is connected
via a special bus and listed in the firmware device tree. This change
adds support for these BMCs to the IPMI driver.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |   75 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 810372c..15e4a60 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -71,6 +71,11 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 
+#ifdef CONFIG_PARISC
+#include <asm/hardware.h>	/* for register_parisc_driver() stuff */
+#include <asm/parisc-device.h>
+#endif
+
 #define PFX "ipmi_si: "
 
 /* Measure times between events in the driver. */
@@ -298,6 +303,9 @@ static int pci_registered;
 #ifdef CONFIG_ACPI
 static int pnp_registered;
 #endif
+#ifdef CONFIG_PARISC
+static int parisc_registered;
+#endif
 
 static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
 static int num_max_busy_us;
@@ -2699,6 +2707,62 @@ static struct platform_driver ipmi_driver = {
 	.remove		= ipmi_remove,
 };
 
+#ifdef CONFIG_PARISC
+static int ipmi_parisc_probe(struct parisc_device *dev)
+{
+	struct smi_info *info;
+
+	info = smi_info_alloc();
+
+	if (!info) {
+		dev_err(&dev->dev,
+			"could not allocate memory for PARISC probe\n");
+		return -ENOMEM;
+	}
+
+	info->si_type		= SI_KCS;
+	info->addr_source	= SI_DEVICETREE;
+	info->io_setup		= mem_setup;
+	info->io.addr_type	= IPMI_MEM_ADDR_SPACE;
+	info->io.addr_data	= dev->hpa.start;
+	info->io.regsize	= 1;
+	info->io.regspacing	= 1;
+	info->io.regshift	= 0;
+	info->irq		= 0; /* no interrupt */
+	info->irq_setup		= NULL;
+	info->dev		= &dev->dev;
+
+	dev_dbg(&dev->dev, "addr 0x%lx\n", info->io.addr_data);
+
+	dev_set_drvdata(&dev->dev, info);
+
+	if (add_smi(info)) {
+		kfree(info);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int ipmi_parisc_remove(struct parisc_device *dev)
+{
+	cleanup_one_si(dev_get_drvdata(&dev->dev));
+	return 0;
+}
+
+static struct parisc_device_id ipmi_parisc_tbl[] = {
+	{ HPHW_MC, HVERSION_REV_ANY_ID, 0x004, 0xC0 },
+	{ 0, }
+};
+
+static struct parisc_driver ipmi_parisc_driver = {
+	.name =		"ipmi",
+	.id_table =	ipmi_parisc_tbl,
+	.probe =	ipmi_parisc_probe,
+	.remove =	ipmi_parisc_remove,
+};
+#endif /* CONFIG_PARISC */
+
 static int wait_for_msg_done(struct smi_info *smi_info)
 {
 	enum si_sm_result     smi_result;
@@ -3464,6 +3528,13 @@ static int init_ipmi_si(void)
 		spmi_find_bmc();
 #endif
 
+#ifdef CONFIG_PARISC
+	register_parisc_driver(&ipmi_parisc_driver);
+	parisc_registered = 1;
+	/* poking PC IO addresses will crash machine, don't do it */
+	si_trydefaults = 0;
+#endif
+
 	/* We prefer devices with interrupts, but in the case of a machine
 	   with multiple BMCs we assume that there will be several instances
 	   of a given type so if we succeed in registering a type then also
@@ -3610,6 +3681,10 @@ static void cleanup_ipmi_si(void)
 	if (pnp_registered)
 		pnp_unregister_driver(&ipmi_pnp_driver);
 #endif
+#ifdef CONFIG_PARISC
+	if (parisc_registered)
+		unregister_parisc_driver(&ipmi_parisc_driver);
+#endif
 
 	platform_driver_unregister(&ipmi_driver);
 
-- 
1.7.9.5

