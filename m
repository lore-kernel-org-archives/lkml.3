Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3L3MN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:13:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57448 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab3L3MNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:13:54 -0500
Date: Mon, 30 Dec 2013 13:13:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Message-ID: <20131230121350.GB31236@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > @@ -242,4 +242,14 @@ config BT_WILINK
> > 
> > 	  Say Y here to compile support for Texas Instrument's WiLink7 driver
> > 	  into the kernel or say M to compile it as module.
> > +
> > +config BT_HCIH4P
> > +	tristate "HCI driver with H4 Nokia extensions"
> > +	depends on BT && ARCH_OMAP
> 
> Since then we moved away from doing hci_* prefix of drivers since that is misleading. See btusb.ko, btmrvl_sdio.ko etc.
> 
> So this might be better named BT_NOK_H4P or BT_NOKIA_H4P and the module named btnok_h4p.ko or btnokia_h4p.ko.
> 

Well, I can rename config option, but renaming the module would break
existing userland, no?

>  Can we also make this just depend on some device tree information
> and not on a specific architecture. I know that this driver is
> pretty much OMAP specific, but if we want this upstream, we should
> at least try to make it more generic.

Nokia N900 is certainly moving towards device tree, but we are not
ready, yet...


> > @@ -0,0 +1,1357 @@
> > +/*
> > + * This file is part of hci_h4p bluetooth driver
> > + *
> > + * Copyright (C) 2005-2008 Nokia Corporation.
> > + *
> > + * Contact: Ville Tervo <ville.tervo@nokia.com>
> 
> I think you can just remove the contact names since I think nobody of the original authors is still working at Nokia and I bet this emails addresses just do not work anymore.
> 

I sent him an email with question. I guess we should move Ville to
CREDITS?

> > +#include <linux/bluetooth/hci_h4p.h>
> > +
> > +#include "hci_h4p.h”
> > +
> 
> Please do not introduce public includes for a driver. This should be all confined to the driver itself or if it platform data, it should go into the place for platform data.
> 

(Could you insert newlines after 80 or so characters?)

Where would you like platform_data definition to go? That indeed is
for platform data, and quick grep shows drivers normally do public
header files for that.

> > +
> > +	if (!wait_for_completion_interruptible_timeout(&info->init_completion,
> > +				msecs_to_jiffies(1000)))
> 
> Please follow the net subsystem coding style.

Could you elaborate? I see nothing too obviously wrong here.

> > +{
> > +	if (unlikely(!test_bit(HCI_RUNNING, &info->hdev->flags))) {
> > +		if (bt_cb(skb)->pkt_type == H4_NEG_PKT) {
> > +			hci_h4p_negotiation_packet(info, skb);
> > +			info->rx_state = WAIT_FOR_PKT_TYPE;
> > +			return;
> > +		}
> 
> Use "else if” here or a switch statement.

Ok.

> > +/* hci callback functions */
> > +static int hci_h4p_hci_flush(struct hci_dev *hdev)
> > +{
> > +	struct hci_h4p_info *info;
> > +	info = hci_get_drvdata(hdev);
> 
> This can be directly assigned at variable declaration.

Ok.

> > +static ssize_t hci_h4p_show_bdaddr(struct device *dev,
> > +				   struct device_attribute *attr, char *buf)
> > +{
> > +	struct hci_h4p_info *info = dev_get_drvdata(dev);
> > +
> > +	return sprintf(buf, "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
> > +		       info->bd_addr[0], info->bd_addr[1], info->bd_addr[2],
> > +		       info->bd_addr[3], info->bd_addr[4], info->bd_addr[5]);
> 
> We have printf modifier to print BD_ADDRs.

%pMR. Ok.

> > +	if (hci_register_dev(hdev) < 0) {
> > +		dev_err(info->dev, "hci_register failed %s.\n", hdev->name);
> > +		hci_h4p_sysfs_remove_files(info->dev);
> > +		return -ENODEV;
> > +	}
> > +
> 
> Who is freeing hdev here in case of an error?

Ok.

> > +	if (!info->reset_gpio_shared)
> > +		gpio_free(info->reset_gpio);
> > +	gpio_free(info->bt_wakeup_gpio);
> > +	gpio_free(info->host_wakeup_gpio);
> > +
> > +cleanup_setup:
> > +
> > +	kfree(info);
> > +	return err;
> > +
> 
> Avoid these extra empty lines at function end.

Ok.

> > +
> > +	if (not_valid) {
> > +		dev_info(info->dev, "Valid bluetooth address not found, setting some random\n");
> > +		/* When address is not valid, use some random but Nokia MAC */
> > +		memcpy(info->bd_addr, nokia_oui, 3);
> > +		get_random_bytes(info->bd_addr + 3, 3);
> > +	}
> 
> 
> This behavior is extremely dangerous. I would rather have the device init or powering on the device fail instead of making up a number that might clash with a real Nokia device.
>

Perhaps people can donate bt addresses from their no-longer-functional
bluetooth devices and we can select from such pool here? ;-).

Is there some experimental range we can allocate from?

> > +int hci_h4p_reset_uart(struct hci_h4p_info *info)
> > +{
> > +	int count = 0;
> > +
> > +	/* Reset the  UART */
> > +	hci_h4p_outb(info, UART_OMAP_SYSC, UART_SYSC_OMAP_RESET);
> > +	while (!(hci_h4p_inb(info, UART_OMAP_SYSS) & UART_SYSS_RESETDONE)) {
> > +		if (count++ > 100) {
> > +			dev_err(info->dev, "hci_h4p: UART reset timeout\n");
> > +			return -ENODEV;
> > +		}
> > +		udelay(1);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +
> 
> No double empty lines please.

Ok.

Pali, here's first round of cleanups...

Signed-off-by: Pavel Machek <pavel@ucw.cz>

								Pavel

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 95155c3..9d46f23 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -243,7 +243,7 @@ config BT_WILINK
 	  Say Y here to compile support for Texas Instrument's WiLink7 driver
 	  into the kernel or say M to compile it as module.
 
-config BT_HCIH4P
+config BT_NOKIA_H4P
 	tristate "HCI driver with H4 Nokia extensions"
 	depends on BT && ARCH_OMAP
 	help
diff --git a/drivers/bluetooth/hci_h4p/Makefile b/drivers/bluetooth/hci_h4p/Makefile
index f20bd9a..6f2ef85 100644
--- a/drivers/bluetooth/hci_h4p/Makefile
+++ b/drivers/bluetooth/hci_h4p/Makefile
@@ -2,6 +2,6 @@
 # Makefile for the Linux Bluetooth HCI device drivers.
 #
 
-obj-$(CONFIG_BT_HCIH4P)		+= hci_h4p.o
+obj-$(CONFIG_BT_NOKIA_H4P)		+= hci_h4p.o
 
 hci_h4p-objs := core.o fw.o uart.o fw-csr.o fw-bcm.o fw-ti1273.o
diff --git a/drivers/bluetooth/hci_h4p/core.c b/drivers/bluetooth/hci_h4p/core.c
index 2f1f8d4..a91bd7b 100644
--- a/drivers/bluetooth/hci_h4p/core.c
+++ b/drivers/bluetooth/hci_h4p/core.c
@@ -436,12 +436,12 @@ static inline void hci_h4p_recv_frame(struct hci_h4p_info *info,
 				      struct sk_buff *skb)
 {
 	if (unlikely(!test_bit(HCI_RUNNING, &info->hdev->flags))) {
-		if (bt_cb(skb)->pkt_type == H4_NEG_PKT) {
+		switch (bt_cb(skb)->pkt_type) {
+		case H4_NEG_PKT:
 			hci_h4p_negotiation_packet(info, skb);
 			info->rx_state = WAIT_FOR_PKT_TYPE;
 			return;
-		}
-		if (bt_cb(skb)->pkt_type == H4_ALIVE_PKT) {
+		case H4_ALIVE_PKT:
 			hci_h4p_alive_packet(info, skb);
 			info->rx_state = WAIT_FOR_PKT_TYPE;
 			return;
@@ -843,9 +843,7 @@ static int hci_h4p_reset(struct hci_h4p_info *info)
 /* hci callback functions */
 static int hci_h4p_hci_flush(struct hci_dev *hdev)
 {
-	struct hci_h4p_info *info;
-	info = hci_get_drvdata(hdev);
-
+	struct hci_h4p_info *info = hci_get_drvdata(hdev);
 	skb_queue_purge(&info->txq);
 
 	return 0;
@@ -853,7 +851,8 @@ static int hci_h4p_hci_flush(struct hci_dev *hdev)
 
 static int hci_h4p_bt_wakeup_test(struct hci_h4p_info *info)
 {
-	/* Test Sequence:
+	/*
+	 * Test Sequence:
 	 * Host de-asserts the BT_WAKE_UP line.
 	 * Host polls the UART_CTS line, waiting for it to be de-asserted.
 	 * Host asserts the BT_WAKE_UP line.
@@ -1101,9 +1100,7 @@ static ssize_t hci_h4p_show_bdaddr(struct device *dev,
 {
 	struct hci_h4p_info *info = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
-		       info->bd_addr[0], info->bd_addr[1], info->bd_addr[2],
-		       info->bd_addr[3], info->bd_addr[4], info->bd_addr[5]);
+	return sprintf(buf, "%pMR\n", info->bd_addr);
 }
 
 static DEVICE_ATTR(bdaddr, S_IRUGO | S_IWUSR, hci_h4p_show_bdaddr,
@@ -1146,16 +1143,17 @@ static int hci_h4p_register_hdev(struct hci_h4p_info *info)
 
 	if (hci_h4p_sysfs_create_files(info->dev) < 0) {
 		dev_err(info->dev, "failed to create sysfs files\n");
-		return -ENODEV;
+		goto free;
 	}
 
-	if (hci_register_dev(hdev) < 0) {
-		dev_err(info->dev, "hci_register failed %s.\n", hdev->name);
-		hci_h4p_sysfs_remove_files(info->dev);
-		return -ENODEV;
-	}
+	if (hci_register_dev(hdev) >= 0)
+		return 0;
 
-	return 0;
+	dev_err(info->dev, "hci_register failed %s.\n", hdev->name);
+	hci_h4p_sysfs_remove_files(info->dev);
+free:
+	hci_free_dev(info->hdev);
+	return -ENODEV;
 }
 
 static int hci_h4p_probe(struct platform_device *pdev)
@@ -1296,12 +1294,9 @@ cleanup:
 		gpio_free(info->reset_gpio);
 	gpio_free(info->bt_wakeup_gpio);
 	gpio_free(info->host_wakeup_gpio);
-
 cleanup_setup:
-
 	kfree(info);
 	return err;
-
 }
 
 static int hci_h4p_remove(struct platform_device *pdev)
diff --git a/drivers/bluetooth/hci_h4p/uart.c b/drivers/bluetooth/hci_h4p/uart.c
index 7973c6c..8e0a93c 100644
--- a/drivers/bluetooth/hci_h4p/uart.c
+++ b/drivers/bluetooth/hci_h4p/uart.c
@@ -129,7 +129,7 @@ int hci_h4p_reset_uart(struct hci_h4p_info *info)
 {
 	int count = 0;
 
-	/* Reset the  UART */
+	/* Reset the UART */
 	hci_h4p_outb(info, UART_OMAP_SYSC, UART_SYSC_OMAP_RESET);
 	while (!(hci_h4p_inb(info, UART_OMAP_SYSS) & UART_SYSS_RESETDONE)) {
 		if (count++ > 100) {
@@ -142,7 +142,6 @@ int hci_h4p_reset_uart(struct hci_h4p_info *info)
 	return 0;
 }
 
-
 void hci_h4p_store_regs(struct hci_h4p_info *info)
 {
 	u16 lcr = 0;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
