Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaCMHnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 03:43:47 -0400
Received: from [216.32.180.13] ([216.32.180.13]:58210 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbaCMHno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 03:43:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz10e3Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz8275ch1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1de2h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Suresh Gupta <suresh.gupta@freescale.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <suresh.gupta@freescale.com>, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH] USB: Gadget: fsl driver pullup fix
Date: Thu, 13 Mar 2014 18:40:55 +0530
Message-ID: <1394716255-26963-1-git-send-email-suresh.gupta@freescale.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached is a small fix for the fsl usb gadget driver. This fix the
driver in a way that the usb device will be only "pulled up" on requests
like other usb gadget drivers do.
This is necessary, because the device information is not always
available until an application is up and running which provides this
datas.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
---
 drivers/usb/gadget/fsl_udc_core.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 35cb972..9a93727 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -153,6 +153,21 @@ static inline void fsl_set_accessors(struct fsl_usb2_platform_data *pdata) {}
 /********************************************************************
  *	Internal Used Function
 ********************************************************************/
+static int can_pullup(struct fsl_udc *udc)
+{
+	return udc->driver && udc->softconnect && udc->vbus_active;
+}
+
+static void set_pullup(struct fsl_udc *udc)
+{
+	if (can_pullup(udc))
+		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
+				&dr_regs->usbcmd);
+	else
+		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
+				&dr_regs->usbcmd);
+}
+
 /*-----------------------------------------------------------------
  * done() - retire a request; caller blocked irqs
  * @status : request status to be set, only works when
@@ -283,6 +298,8 @@ static int dr_controller_setup(struct fsl_udc *udc)
 	tmp &= ~USB_CMD_RUN_STOP;
 	fsl_writel(tmp, &dr_regs->usbcmd);
 
+	set_pullup(udc);
+
 	tmp = fsl_readl(&dr_regs->usbcmd);
 	tmp |= USB_CMD_CTRL_RESET;
 	fsl_writel(tmp, &dr_regs->usbcmd);
@@ -1168,11 +1185,6 @@ static int fsl_wakeup(struct usb_gadget *gadget)
 	return 0;
 }
 
-static int can_pullup(struct fsl_udc *udc)
-{
-	return udc->driver && udc->softconnect && udc->vbus_active;
-}
-
 /* Notify controller that VBUS is powered, Called by whatever
    detects VBUS sessions */
 static int fsl_vbus_session(struct usb_gadget *gadget, int is_active)
@@ -1184,12 +1196,7 @@ static int fsl_vbus_session(struct usb_gadget *gadget, int is_active)
 	spin_lock_irqsave(&udc->lock, flags);
 	VDBG("VBUS %s", is_active ? "on" : "off");
 	udc->vbus_active = (is_active != 0);
-	if (can_pullup(udc))
-		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
-				&dr_regs->usbcmd);
-	else
-		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
-				&dr_regs->usbcmd);
+	set_pullup(udc);
 	spin_unlock_irqrestore(&udc->lock, flags);
 	return 0;
 }
@@ -1220,12 +1227,7 @@ static int fsl_pullup(struct usb_gadget *gadget, int is_on)
 
 	udc = container_of(gadget, struct fsl_udc, gadget);
 	udc->softconnect = (is_on != 0);
-	if (can_pullup(udc))
-		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
-				&dr_regs->usbcmd);
-	else
-		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
-				&dr_regs->usbcmd);
+	set_pullup(udc);
 
 	return 0;
 }
@@ -2286,6 +2288,8 @@ static int __init struct_udc_setup(struct fsl_udc *udc,
 	udc->usb_state = USB_STATE_POWERED;
 	udc->ep0_dir = 0;
 	udc->remote_wakeup = 0;	/* default to 0 on reset */
+	udc->vbus_active = 1;
+	udc->softconnect = 1;
 
 	return 0;
 }
-- 
1.8.4.1


