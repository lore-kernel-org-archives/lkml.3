Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3KVP4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:56:04 -0500
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:43167
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755505Ab3KVP4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:56:00 -0500
Message-ID: <528F7E8F.5050807@newflow.co.uk>
Date: Fri, 22 Nov 2013 15:55:59 +0000
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        bigeasy@linutronix.de, Greg KH <gregkh@linuxfoundation.org>,
        jkosina@suse.cz, anatol.pomozov@gmail.com,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: [PATCH] Allow MUSB DSPS to use "force host" mode
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IDDIG input pin is normally used to determine the USB mode
(i.e. HOST or DEVICE).

On some systems (e.g. AM335x) leaving this pin floating allows
the USB mode to be set via software.

This patch adds support for this via the device tree.

Signed-off-by: Mark Jackson <mpfj@newflow.co.uk>
---
 .../devicetree/bindings/usb/am33xx-usb.txt         |    2 ++
 drivers/usb/musb/musb_dsps.c                       |   14 ++++++++++++++
 include/linux/usb/musb.h                           |    1 +
 3 files changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/am33xx-usb.txt b/Documentation/devicetree/bindings/usb/am33xx-usb.txt
index 20c2ff2..560b7ff 100644
--- a/Documentation/devicetree/bindings/usb/am33xx-usb.txt
+++ b/Documentation/devicetree/bindings/usb/am33xx-usb.txt
@@ -47,6 +47,8 @@ USB
 - dmas: specifies the dma channels
 - dma-names: specifies the names of the channels. Use "rxN" for receive
   and "txN" for transmit endpoints. N specifies the endpoint number.
+- ti,force-host: specifies that the IDDIG input be ignored and the device be
+  put into host mode regardless.
 
 The controller should have an "usb" alias numbered properly in the alias
 node.
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 1901f6f..6439809 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -105,6 +105,7 @@ struct dsps_musb_wrapper {
 	unsigned	otg_disable:5;
 
 	/* bit positions for mode */
+	unsigned	iddig_mux:5;
 	unsigned	iddig:5;
 	/* miscellaneous stuff */
 	u8		poll_seconds;
@@ -387,6 +388,15 @@ static int dsps_musb_init(struct musb *musb)
 
 	musb->isr = dsps_interrupt;
 
+	/* Force host mode, rather than relying on IDDIG input */
+	if (musb->config->force_host) {
+		val = dsps_readl(reg_base, wrp->mode);
+		/* clear IDDIG bit, set IDDIG_MUX bit */
+		val &= ~(1 << wrp->iddig);
+		val |= (1 << wrp->iddig_mux);
+		dsps_writel(musb->ctrl_base, wrp->mode, val);
+	}
+
 	/* reset the otgdisable bit, needed for host mode to work */
 	val = dsps_readl(reg_base, wrp->phy_utmi);
 	val &= ~(1 << wrp->otg_disable);
@@ -512,6 +522,9 @@ static int dsps_create_musb_pdev(struct dsps_glue *glue,
 	pdata.power = get_int_prop(dn, "mentor,power") / 2;
 	config->multipoint = of_property_read_bool(dn, "mentor,multipoint");
 
+	if (of_property_read_bool(dn, "ti,force-host"))
+		config->force_host = true;
+
 	ret = platform_device_add_data(musb, &pdata, sizeof(pdata));
 	if (ret) {
 		dev_err(dev, "failed to add platform_data\n");
@@ -607,6 +620,7 @@ static const struct dsps_musb_wrapper am33xx_driver_data = {
 	.mode			= 0xe8,
 	.reset			= 0,
 	.otg_disable		= 21,
+	.iddig_mux		= 7,
 	.iddig			= 8,
 	.usb_shift		= 0,
 	.usb_mask		= 0x1ff,
diff --git a/include/linux/usb/musb.h b/include/linux/usb/musb.h
index eb50525..a0a81c5 100644
--- a/include/linux/usb/musb.h
+++ b/include/linux/usb/musb.h
@@ -75,6 +75,7 @@ struct musb_hdrc_config {
 	unsigned	high_iso_rx:1;	/* Rx ep required for HD iso */
 	unsigned	dma:1 __deprecated; /* supports DMA */
 	unsigned	vendor_req:1 __deprecated; /* vendor registers required */
+	unsigned	force_host:1;	/* force host mode */
 
 	u8		num_eps;	/* number of endpoints _with_ ep0 */
 	u8		dma_channels __deprecated; /* number of dma channels */
-- 
1.7.9.5

