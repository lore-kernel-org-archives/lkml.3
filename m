Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab3DAHxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 03:53:42 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:60488 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab3DAHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 03:53:40 -0400
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        sarah.a.sharp@linux.intel.com, balbi@ti.com, Julia.Lawall@lip6.fr
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert.chuang@gmail.com, john453@faraday-tech.com,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: [PATCH v2] usb host: Faraday FUSBH200 HCD driver
Date: Mon,  1 Apr 2013 07:53:00 +0000
Message-Id: <1364802780-31294-1-git-send-email-yhchen@faraday-tech.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1360149841-2392-1-git-send-email-yuanlmm@gmail.com>
References: <1360149841-2392-1-git-send-email-yuanlmm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUSBH200 is an ehci-like controller with some differences.
First, register layout of FUSBH200 is incompatible with EHCI.
We use a quirk flag and modify struct ehci_regs with anonymous
union and struct to make sure driver of FUSBH200 and EHCI could
coexist. Furthermore, FUSBH200 is lack of siTDs which means iTDs
are used for both HS and FS ISO transfer.

Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
---

Note that anonymous union and struct might not be supported
in earlier version of gcc

v2:
use ehci-platform.c
use anonymous union and struct
add is_fusbh200 to struct ehci_hcd

 drivers/usb/host/Kconfig         |    9 ++
 drivers/usb/host/ehci-fusbh200.c |  223 ++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci-hcd.c      |   18 +++-
 drivers/usb/host/ehci-hub.c      |   30 +++---
 drivers/usb/host/ehci-mem.c      |    3 +-
 drivers/usb/host/ehci-sched.c    |   33 ++++--
 drivers/usb/host/ehci.h          |   27 +++++-
 include/linux/usb/ehci_def.h     |   58 +++++++---
 8 files changed, 351 insertions(+), 50 deletions(-)
 create mode 100644 drivers/usb/host/ehci-fusbh200.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 3f1431d..42b8768 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -157,6 +157,15 @@ config USB_EHCI_HCD_OMAP
 	  Enables support for the on-chip EHCI controller on
 	  OMAP3 and later chips.
 
+config USB_EHCI_HCD_FUSBH200
+	bool "Faraday FUSBH200 HCD support"
+	depends on USB_EHCI_HCD && ARCH_FARADAY
+	select USB_EHCI_ROOT_HUB_TT
+	default y
+	---help---
+	  The USB HCD Driver of Faraday FUSBH200 is designed to
+	  meet USB2.0 EHCI specification with minor modification
+
 config USB_EHCI_MSM
 	bool "Support for MSM on-chip EHCI USB controller"
 	depends on USB_EHCI_HCD && ARCH_MSM
diff --git a/drivers/usb/host/ehci-fusbh200.c b/drivers/usb/host/ehci-fusbh200.c
new file mode 100644
index 0000000..1d5fd14
--- /dev/null
+++ b/drivers/usb/host/ehci-fusbh200.c
@@ -0,0 +1,223 @@
+/*
+ * ehci-fusbh200.c - driver for Faraday USB2.0 Host FUSBH200
+ *
+ * Copyright (c) 2013 Yuan-Hsin Chen <yhchen@faraday-tech>
+ * Copyright (c) 2013 Po-Yu Chuang <ratbert.chuang@gmail.com>
+ * Copyright (c) 2010-2012 Feng-Hsin Chiang <john453@faraday-tech>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/platform_device.h>
+
+static const struct hc_driver ehci_fusbh200_hc_driver = {
+	.description 		= hcd_name,
+	.product_desc 		= "Faraday USB2.0 Host Controller",
+	.hcd_priv_size 		= sizeof(struct ehci_hcd),
+
+	/*
+	 * generic hardware linkage
+	 */
+	.irq 			= ehci_irq,
+	.flags 			= HCD_MEMORY | HCD_USB2,
+
+	/*
+	 * basic lifecycle operations
+	 */
+	.reset 			= ehci_init,
+	.start 			= ehci_run,
+	.stop 			= ehci_stop,
+	.shutdown 		= ehci_shutdown,
+
+	/*
+	 * managing i/o requests and associated device resources
+	 */
+	.urb_enqueue 		= ehci_urb_enqueue,
+	.urb_dequeue 		= ehci_urb_dequeue,
+	.endpoint_disable 	= ehci_endpoint_disable,
+	.endpoint_reset 	= ehci_endpoint_reset,
+
+	/*
+	 * scheduling support
+	 */
+	.get_frame_number 	= ehci_get_frame,
+
+	/*
+	 * root hub support
+	 */
+	.hub_status_data 	= ehci_hub_status_data,
+	.hub_control 		= ehci_hub_control,
+	.bus_suspend 		= ehci_bus_suspend,
+	.bus_resume 		= ehci_bus_resume,
+
+	.relinquish_port 	= ehci_relinquish_port,
+	.port_handed_over 	= ehci_port_handed_over,
+
+	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
+};
+
+void fusbh200_init(struct ehci_hcd *ehci)
+{
+	u32 reg;
+
+	reg = ehci_readl(ehci, &ehci->regs->bmcsr);
+	reg |= BMCSR_INT_POLARITY;
+	reg &= ~BMCSR_VBUS_OFF;
+	ehci_writel(ehci, reg, &ehci->regs->bmcsr);
+
+	reg = ehci_readl(ehci, &ehci->regs->bmier);
+	ehci_writel(ehci, reg | BMIER_OVC_EN | BMIER_VBUS_ERR_EN,
+		&ehci->regs->bmier);
+}
+
+/**
+ * ehci_hcd_fusbh200_probe - initialize faraday FUSBH200 HCDs
+ *
+ * Allocates basic resources for this USB host controller, and
+ * then invokes the start() method for the HCD associated with it
+ * through the hotplug entry's driver_data.
+ */
+static int ehci_hcd_fusbh200_probe(struct platform_device *pdev)
+{
+	struct device			*dev = &pdev->dev;
+	struct usb_hcd 			*hcd;
+	struct resource			*res;
+	int 				irq;
+	int 				retval = -ENODEV;
+	struct ehci_hcd 		*ehci;
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	pdev->dev.power.power_state = PMSG_ON;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev,
+			"Found HC with no IRQ. Check %s setup!\n",
+			dev_name(dev));
+		return -ENODEV;
+	}
+
+	irq = res->start;
+
+	hcd = usb_create_hcd(&ehci_fusbh200_hc_driver, dev,
+			dev_name(dev));
+	if (!hcd) {
+		dev_err(dev, "failed to create hcd with err %d\n", retval);
+		retval = -ENOMEM;
+		goto fail_create_hcd;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev,
+			"Found HC with no register addr. Check %s setup!\n",
+			dev_name(dev));
+		retval = -ENODEV;
+		goto fail_request_resource;
+	}
+
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
+	hcd->has_tt = 1;
+
+	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
+				ehci_fusbh200_hc_driver.description)) {
+		dev_dbg(dev, "controller already in use\n");
+		retval = -EBUSY;
+		goto fail_request_resource;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(dev,
+			"Found HC with no register addr. Check %s setup!\n",
+			dev_name(dev));
+		retval = -ENODEV;
+		goto fail_request_resource;
+	}
+
+	hcd->regs = ioremap_nocache(res->start, resource_size(res));
+	if (hcd->regs == NULL) {
+		dev_dbg(dev, "error mapping memory\n");
+		retval = -EFAULT;
+		goto fail_ioremap;
+	}
+
+	ehci = hcd_to_ehci(hcd);
+
+	ehci->caps = hcd->regs;
+	ehci->is_fusbh200 = 1;
+
+	retval = ehci_setup(hcd);
+	if (retval)
+		return retval;
+
+	fusbh200_init(ehci);
+
+	ehci_port_power(ehci, 0);
+
+	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
+	if (retval) {
+		dev_err(dev, "failed to add hcd with err %d\n", retval);
+		goto fail_add_hcd;
+	}
+
+	return retval;
+
+fail_add_hcd:
+	iounmap(hcd->regs);
+fail_ioremap:
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+fail_request_resource:
+	usb_put_hcd(hcd);
+fail_create_hcd:
+	dev_err(dev, "init %s fail, %d\n", dev_name(dev), retval);
+	return retval;
+}
+
+/**
+ * ehci_hcd_fusbh200_remove - shutdown processing for EHCI HCDs
+ * @dev: USB Host Controller being removed
+ *
+ * Reverses the effect of fotg2xx_usb_hcd_probe(), first invoking
+ * the HCD's stop() method.  It is always called from a thread
+ * context, normally "rmmod", "apmd", or something similar.
+ */
+int ehci_hcd_fusbh200_remove(struct platform_device *pdev)
+{
+	struct device *dev	= &pdev->dev;
+	struct usb_hcd *hcd	= dev_get_drvdata(dev);
+
+	if (!hcd)
+		return 0;
+
+	usb_remove_hcd(hcd);
+	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+	usb_put_hcd(hcd);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+struct platform_driver ehci_hcd_fusbh200_driver = {
+	.driver = {
+		.name   = "fusbh200",
+	},
+	.probe  = ehci_hcd_fusbh200_probe,
+	.remove = ehci_hcd_fusbh200_remove,
+};
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 6bf6c42..ce87c01 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -247,7 +247,7 @@ static int ehci_reset (struct ehci_hcd *ehci)
 	if (retval)
 		return retval;
 
-	if (ehci_is_TDI(ehci))
+	if (ehci_is_TDI(ehci) && !ehci_is_fusbh200(ehci))
 		tdi_reset (ehci);
 
 	if (ehci->debug)
@@ -326,11 +326,15 @@ static void ehci_silence_controller(struct ehci_hcd *ehci)
 	ehci->rh_state = EHCI_RH_HALTED;
 	ehci_turn_off_all_ports(ehci);
 
+	if (ehci_is_fusbh200(ehci))
+		goto out;
+
 	/* make BIOS/etc use companion controller during reboot */
 	ehci_writel(ehci, 0, &ehci->regs->configured_flag);
 
 	/* unblock posted writes */
 	ehci_readl(ehci, &ehci->regs->configured_flag);
+out:
 	spin_unlock_irq(&ehci->lock);
 }
 
@@ -634,7 +638,8 @@ static int ehci_run (struct usb_hcd *hcd)
 	 */
 	down_write(&ehci_cf_port_reset_rwsem);
 	ehci->rh_state = EHCI_RH_RUNNING;
-	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
+	if (!ehci_is_fusbh200(ehci))
+		ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
 	msleep(5);
 	up_write(&ehci_cf_port_reset_rwsem);
@@ -684,7 +689,7 @@ static int ehci_setup(struct usb_hcd *hcd)
 	if (retval)
 		return retval;
 
-	if (ehci_is_TDI(ehci))
+	if (ehci_is_TDI(ehci) && !ehci_is_fusbh200(ehci))
 		tdi_reset(ehci);
 
 	ehci_reset(ehci);
@@ -887,7 +892,7 @@ static int ehci_urb_enqueue (
 		return intr_submit(ehci, urb, &qtd_list, mem_flags);
 
 	case PIPE_ISOCHRONOUS:
-		if (urb->dev->speed == USB_SPEED_HIGH)
+		if (urb->dev->speed == USB_SPEED_HIGH || ehci_is_fusbh200(ehci))
 			return itd_submit (ehci, urb, mem_flags);
 		else
 			return sitd_submit (ehci, urb, mem_flags);
@@ -1339,6 +1344,11 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_platform_driver
 #endif
 
+#ifdef CONFIG_USB_EHCI_HCD_FUSBH200
+#include "ehci-fusbh200.c"
+#define PLATFORM_DRIVER		ehci_hcd_fusbh200_driver
+#endif
+
 #if !defined(PCI_DRIVER) && !defined(PLATFORM_DRIVER) && \
     !defined(PS3_SYSTEM_BUS_DRIVER) && !defined(OF_PLATFORM_DRIVER) && \
     !defined(XILINX_OF_PLATFORM_DRIVER)
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 914ce93..c374d6a 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -63,7 +63,7 @@ static void ehci_handover_companion_ports(struct ehci_hcd *ehci)
 	port = HCS_N_PORTS(ehci->hcs_params);
 	while (port--) {
 		if (test_bit(port, &ehci->owned_ports)) {
-			reg = &ehci->regs->port_status[port];
+			reg = ehci_portsc_addr(ehci, port);
 			status = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
 
 			/* Port already owned by companion? */
@@ -100,7 +100,7 @@ static void ehci_handover_companion_ports(struct ehci_hcd *ehci)
 			 * but if something went wrong the port must not
 			 * remain enabled.
 			 */
-			reg = &ehci->regs->port_status[port];
+			reg = ehci_portsc_addr(ehci, port)
 			status = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
 			if (status & PORT_OWNER)
 				ehci_writel(ehci, status | PORT_CSC, reg);
@@ -131,7 +131,7 @@ static int ehci_port_change(struct ehci_hcd *ehci)
 	 */
 
 	while (i--)
-		if (ehci_readl(ehci, &ehci->regs->port_status[i]) & PORT_CSC)
+		if (ehci_readl(ehci, ehci_portsc_addr(ehci, i)) & PORT_CSC)
 			return 1;
 
 	return 0;
@@ -169,7 +169,7 @@ static void ehci_adjust_port_wakeup_flags(struct ehci_hcd *ehci,
 
 	port = HCS_N_PORTS(ehci->hcs_params);
 	while (port--) {
-		u32 __iomem	*reg = &ehci->regs->port_status[port];
+		u32 __iomem	*reg = ehci_portsc_addr(ehci, port);
 		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
 		u32		t2 = t1 & ~PORT_WAKE_BITS;
 
@@ -247,7 +247,7 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 	changed = 0;
 	port = HCS_N_PORTS(ehci->hcs_params);
 	while (port--) {
-		u32 __iomem	*reg = &ehci->regs->port_status [port];
+		u32 __iomem	*reg = ehci_portsc_addr(ehci, port);
 		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
 		u32		t2 = t1 & ~PORT_WAKE_BITS;
 
@@ -415,14 +415,14 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 	/* manually resume the ports we suspended during bus_suspend() */
 	i = HCS_N_PORTS (ehci->hcs_params);
 	while (i--) {
-		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
+		temp = ehci_readl(ehci, ehci_portsc_addr(ehci, i));
 		temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
 		if (test_bit(i, &ehci->bus_suspended) &&
 				(temp & PORT_SUSPEND)) {
 			temp |= PORT_RESUME;
 			set_bit(i, &resume_needed);
 		}
-		ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
+		ehci_writel(ehci, temp, ehci_portsc_addr(ehci, i));
 	}
 
 	/* msleep for 20ms only if code is trying to resume port */
@@ -436,10 +436,10 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 
 	i = HCS_N_PORTS (ehci->hcs_params);
 	while (i--) {
-		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
+		temp = ehci_readl(ehci, ehci_portsc_addr(ehci, i));
 		if (test_bit(i, &resume_needed)) {
 			temp &= ~(PORT_RWC_BITS | PORT_RESUME);
-			ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
+			ehci_writel(ehci, temp, ehci_portsc_addr(ehci, i));
 			ehci_vdbg (ehci, "resumed port %d\n", i + 1);
 		}
 	}
@@ -482,7 +482,7 @@ static void set_owner(struct ehci_hcd *ehci, int portnum, int new_owner)
 	u32			port_status;
 	int 			try;
 
-	status_reg = &ehci->regs->port_status[portnum];
+	status_reg = ehci_portsc_addr(ehci, portnum);
 
 	/*
 	 * The controller won't set the OWNER bit if the port is
@@ -604,7 +604,7 @@ ehci_hub_status_data (struct usb_hcd *hcd, char *buf)
 		/* leverage per-port change bits feature */
 		if (ehci->has_ppcd && !(ppcd & (1 << i)))
 			continue;
-		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
+		temp = ehci_readl(ehci, ehci_portsc_addr(ehci, i));
 
 		/*
 		 * Return status information even for ports with OWNER set.
@@ -675,8 +675,7 @@ static int ehci_hub_control (
 ) {
 	struct ehci_hcd	*ehci = hcd_to_ehci (hcd);
 	int		ports = HCS_N_PORTS (ehci->hcs_params);
-	u32 __iomem	*status_reg = &ehci->regs->port_status[
-				(wIndex & 0xff) - 1];
+	u32 __iomem	*status_reg = ehci_portsc_addr(ehci, (wIndex & 0xff) - 1);
 	u32 __iomem	*hostpc_reg = &ehci->regs->hostpc[(wIndex & 0xff) - 1];
 	u32		temp, temp1, status;
 	unsigned long	flags;
@@ -1054,8 +1053,7 @@ static int ehci_hub_control (
 
 			/* Put all enabled ports into suspend */
 			while (ports--) {
-				u32 __iomem *sreg =
-						&ehci->regs->port_status[ports];
+				u32 __iomem *sreg = ehci_portsc_addr(ehci, ports);
 
 				temp = ehci_readl(ehci, sreg) & ~PORT_RWC_BITS;
 				if (temp & PORT_PE)
@@ -1106,6 +1104,6 @@ static int __maybe_unused ehci_port_handed_over(struct usb_hcd *hcd,
 
 	if (ehci_is_TDI(ehci))
 		return 0;
-	reg = &ehci->regs->port_status[portnum - 1];
+	reg = ehci_portsc_addr(ehci, portnum - 1);
 	return ehci_readl(ehci, reg) & PORT_OWNER;
 }
diff --git a/drivers/usb/host/ehci-mem.c b/drivers/usb/host/ehci-mem.c
index ef2c3a1..fd7e298 100644
--- a/drivers/usb/host/ehci-mem.c
+++ b/drivers/usb/host/ehci-mem.c
@@ -159,6 +159,7 @@ static void ehci_mem_cleanup (struct ehci_hcd *ehci)
 static int ehci_mem_init (struct ehci_hcd *ehci, gfp_t flags)
 {
 	int i;
+	unsigned int itd_align = ehci_is_fusbh200(ehci) ? 64 : 32;
 
 	/* QTDs for control/bulk/intr transfers */
 	ehci->qtd_pool = dma_pool_create ("ehci_qtd",
@@ -188,7 +189,7 @@ static int ehci_mem_init (struct ehci_hcd *ehci, gfp_t flags)
 	ehci->itd_pool = dma_pool_create ("ehci_itd",
 			ehci_to_hcd(ehci)->self.controller,
 			sizeof (struct ehci_itd),
-			32 /* byte alignment (for hw parts) */,
+			itd_align /* byte alignment (for hw parts) */,
 			4096 /* can't cross 4K */);
 	if (!ehci->itd_pool) {
 		goto fail;
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 7cf3da7..29b7c40 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1005,11 +1005,9 @@ iso_stream_init (
 	}
 
 	/* knows about ITD vs SITD */
-	if (dev->speed == USB_SPEED_HIGH) {
+	if (dev->speed == USB_SPEED_HIGH || ehci_is_fusbh200(ehci)) {
 		unsigned multi = hb_mult(maxp);
 
-		stream->highspeed = 1;
-
 		maxp = max_packet(maxp);
 		buf1 |= maxp;
 		maxp *= multi;
@@ -1021,10 +1019,17 @@ iso_stream_init (
 		/* usbfs wants to report the average usecs per frame tied up
 		 * when transfers on this endpoint are scheduled ...
 		 */
-		stream->usecs = HS_USECS_ISO (maxp);
+		if (dev->speed == USB_SPEED_FULL) {
+			interval <<= 3;
+			stream->usecs = NS_TO_US(usb_calc_bus_time(dev->speed,
+					is_input, 1, maxp));
+			stream->usecs /= 8;
+		} else {
+			stream->highspeed = 1;
+			stream->usecs = HS_USECS_ISO (maxp);
+		}
 		bandwidth = stream->usecs * 8;
 		bandwidth /= interval;
-
 	} else {
 		u32		addr;
 		int		think_time;
@@ -1377,7 +1382,7 @@ iso_stream_schedule (
 
 	period = urb->interval;
 	span = sched->span;
-	if (!stream->highspeed) {
+	if (!stream->highspeed && !ehci_is_fusbh200(ehci)) {
 		period <<= 3;
 		span <<= 3;
 	}
@@ -1449,7 +1454,7 @@ iso_stream_schedule (
 		do {
 			start--;
 			/* check schedule: enough space? */
-			if (stream->highspeed) {
+			if (stream->highspeed || ehci_is_fusbh200(ehci)) {
 				if (itd_slot_ok(ehci, mod, start,
 						stream->usecs, period))
 					done = 1;
@@ -1699,12 +1704,12 @@ static bool itd_complete(struct ehci_hcd *ehci, struct ehci_itd *itd)
 
 			/* HC need not update length with this error */
 			if (!(t & EHCI_ISOC_BABBLE)) {
-				desc->actual_length = EHCI_ITD_LENGTH(t);
+				desc->actual_length = ehci_itdlen(ehci, urb, desc, t);
 				urb->actual_length += desc->actual_length;
 			}
 		} else if (likely ((t & EHCI_ISOC_ACTIVE) == 0)) {
 			desc->status = 0;
-			desc->actual_length = EHCI_ITD_LENGTH(t);
+			desc->actual_length = ehci_itdlen(ehci, urb, desc, t);
 			urb->actual_length += desc->actual_length;
 		} else {
 			/* URB was too late */
@@ -1777,9 +1782,13 @@ static int itd_submit (struct ehci_hcd *ehci, struct urb *urb,
 		return -ENOMEM;
 	}
 	if (unlikely (urb->interval != stream->interval)) {
-		ehci_dbg (ehci, "can't change iso interval %d --> %d\n",
-			stream->interval, urb->interval);
-		goto done;
+		if (!ehci_is_fusbh200(ehci) ||
+		    (ehci_is_fusbh200(ehci) &&
+		     ehci_port_speed(ehci, 0) == USB_PORT_STAT_HIGH_SPEED)) {
+			ehci_dbg (ehci, "can't change iso interval %d --> %d\n",
+				stream->interval, urb->interval);
+			goto done;
+		}
 	}
 
 #ifdef EHCI_URB_TRACE
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index da07d98..fa9028d 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -197,6 +197,7 @@ struct ehci_hcd {			/* one per controller */
 	unsigned		use_dummy_qh:1;	/* AMD Frame List table quirk*/
 	unsigned		has_synopsys_hc_bug:1; /* Synopsys HC */
 	unsigned		frame_index_bug:1; /* MosChip (AKA NetMos) */
+	unsigned		is_fusbh200:1; /* Faraday FUSBH200 */
 
 	/* required for usb32 quirk */
 	#define OHCI_CTRL_HCFS          (3 << 6)
@@ -578,6 +579,8 @@ struct ehci_fstn {
 
 /*-------------------------------------------------------------------------*/
 
+#define	ehci_is_fusbh200(e)		((e)->is_fusbh200)
+
 #ifdef CONFIG_USB_EHCI_ROOT_HUB_TT
 
 /*
@@ -589,12 +592,23 @@ struct ehci_fstn {
 
 #define	ehci_is_TDI(e)			(ehci_to_hcd(e)->has_tt)
 
+static inline unsigned int
+ehci_get_speed(struct ehci_hcd *ehci, unsigned int portsc)
+{
+	if (ehci_is_fusbh200(ehci))
+		return (readl(&ehci->regs->bmcsr)
+			& BMCSR_HOST_SPD_TYP) >> 9;
+	else
+		return (portsc >> (ehci->has_hostpc ?
+			25 : 26)) & 3;
+}
+
 /* Returns the speed of a device attached to a port on the root hub. */
 static inline unsigned int
 ehci_port_speed(struct ehci_hcd *ehci, unsigned int portsc)
 {
 	if (ehci_is_TDI(ehci)) {
-		switch ((portsc >> (ehci->has_hostpc ? 25 : 26)) & 3) {
+		switch (ehci_get_speed(ehci, portsc)) {
 		case 0:
 			return 0;
 		case 1:
@@ -776,6 +790,17 @@ static inline unsigned ehci_read_frame_index(struct ehci_hcd *ehci)
 
 #endif
 
+#define ehci_portsc_addr(ehci, port) ({			\
+	ehci_is_fusbh200(ehci) ?			\
+	&(ehci)->regs->fusbh200_portsc :		\
+	&(ehci)->regs->port_status[(port)];		\
+})
+
+#define ehci_itdlen(ehci, urb, desc, t) ({			\
+	ehci_is_fusbh200(ehci) && usb_pipein((urb)->pipe) ?	\
+	(desc)->length - EHCI_ITD_LENGTH(t) :			\
+	EHCI_ITD_LENGTH(t);					\
+})
 /*-------------------------------------------------------------------------*/
 
 #ifndef DEBUG
diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
index daec99a..41f9c55 100644
--- a/include/linux/usb/ehci_def.h
+++ b/include/linux/usb/ehci_def.h
@@ -111,20 +111,22 @@ struct ehci_regs {
 	/* ASYNCLISTADDR: offset 0x18 */
 	u32		async_next;	/* address of next async queue head */
 
-	u32		reserved1[2];
+	union {
+		struct {
+			u32	reserved1[2];
 
-	/* TXFILLTUNING: offset 0x24 */
-	u32		txfill_tuning;	/* TX FIFO Tuning register */
+			/* TXFILLTUNING: offset 0x24 */
+			u32	txfill_tuning;	/* TX FIFO Tuning register */
 #define TXFIFO_DEFAULT	(8<<16)		/* FIFO burst threshold 8 */
 
-	u32		reserved2[6];
+			u32	reserved2[6];
 
-	/* CONFIGFLAG: offset 0x40 */
-	u32		configured_flag;
+			/* CONFIGFLAG: offset 0x40 */
+			u32	configured_flag;
 #define FLAG_CF		(1<<0)		/* true: we'll support "high speed" */
 
-	/* PORTSC: offset 0x44 */
-	u32		port_status[0];	/* up to N_PORTS */
+			/* PORTSC: offset 0x44 */
+			u32	port_status[0];	/* up to N_PORTS */
 /* EHCI 1.1 addendum */
 #define PORTSC_SUSPEND_STS_ACK 0
 #define PORTSC_SUSPEND_STS_NYET 1
@@ -162,32 +164,56 @@ struct ehci_regs {
 #define PORT_CONNECT	(1<<0)		/* device connected */
 #define PORT_RWC_BITS   (PORT_CSC | PORT_PEC | PORT_OCC)
 
-	u32		reserved3[9];
+			u32	reserved3[9];
 
 	/* USBMODE: offset 0x68 */
-	u32		usbmode;	/* USB Device mode */
+			u32	usbmode;	/* USB Device mode */
 #define USBMODE_SDIS	(1<<3)		/* Stream disable */
 #define USBMODE_BE	(1<<2)		/* BE/LE endianness select */
 #define USBMODE_CM_HC	(3<<0)		/* host controller mode */
 #define USBMODE_CM_IDLE	(0<<0)		/* idle state */
 
-	u32		reserved4[6];
+			u32	reserved4[6];
 
 /* Moorestown has some non-standard registers, partially due to the fact that
  * its EHCI controller has both TT and LPM support. HOSTPCx are extensions to
  * PORTSCx
  */
-	/* HOSTPC: offset 0x84 */
-	u32		hostpc[1];	/* HOSTPC extension */
+			/* HOSTPC: offset 0x84 */
+			u32	hostpc[1];	/* HOSTPC extension */
 #define HOSTPC_PHCD	(1<<22)		/* Phy clock disable */
 #define HOSTPC_PSPD	(3<<25)		/* Port speed detection */
 
-	u32		reserved5[16];
+			u32	reserved5[16];
 
-	/* USBMODE_EX: offset 0xc8 */
-	u32		usbmode_ex;	/* USB Device mode extension */
+			/* USBMODE_EX: offset 0xc8 */
+			u32	usbmode_ex;	/* USB Device mode extension */
 #define USBMODE_EX_VBPS	(1<<5)		/* VBus Power Select On */
 #define USBMODE_EX_HC	(3<<0)		/* host controller mode */
+		};
+		struct {
+			u32	reserved6;
+
+			/* PORTSC: offset 0x20 */
+			u32	fusbh200_portsc;
+
+			u32	reserved7[3];
+
+			/* BMCSR: offset 0x30 */
+			u32	bmcsr; /* Bus Moniter Control/Status Register */
+#define BMCSR_HOST_SPD_TYP	(3<<9)
+#define BMCSR_VBUS_OFF		(1<<4)
+#define BMCSR_INT_POLARITY	(1<<3)
+
+			/* BMISR: offset 0x34 */
+			u32	bmisr; /* Bus Moniter Interrupt Status Register*/
+
+			/* BMIER: offset 0x38 */
+			u32	bmier; /* Bus Moniter Interrupt Enable Register */
+#define BMIER_OVC_EN		(1<<1)
+#define BMIER_VBUS_ERR_EN	(1<<0)
+		};
+	};
 };
 
 /* Appendix C, Debug port ... intended for use with special "debug devices"
-- 
1.7.4.1

