Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3DTKes (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 06:34:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52534 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3DTKeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 06:34:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v2] serial: pl011: Add Device Tree support to request DMA channels
Date: Sat, 20 Apr 2013 12:33:45 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Russell King <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
References: <1366272857-14038-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366272857-14038-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304201233.45501.arnd@arndb.de>
X-Provags-ID: V02:K0:2hFTh2gDXZWo4jKNmAwqXNa/RHIVUZYIcapULj6YAv0
 kRqqZz2YeGy5wDXrSLfbiclxf+Dmdwd2oFX1n6EjfVMWrxnqXA
 xJGWCvuXfZ6vAlo+V0b2XzvRIaFlQBOFxT2nr4dAFOjKPR+1P8
 6uh2DEm/lJY2GvV7Y0hpEmcoHNrpcu2T1Huw9gYgm+WZGiDxIu
 7J6WbVJZc/4pBNthQrRbESVHcLwDXrEnMikaRgDXQk4XDL6Cg7
 71rK5XVBvoECjEQbkfMqFqzPmKV9FKrcgZQ9tOJZx6wOzSzhpO
 CmpJR4ltDFKFryZOj1jZU8K1oR+X2+/zTG2VAKTNytK0oMpb+9
 FCFKdJ8swRbSFg0d2rBQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee and Russell,

While going through the arm-soc tree yesterday, I noticed two things:

* I had already done a patch for this in January which I meant to queue up
  for 3.10, as it is needed to make spear13xx use the dma-engine binding
* I actually forgot to merge that branch into for-next :(

I've put it into a "late" branch now. Could you have a look please?
If there are any problems with this, I'll probably just drop the branch
and queue it for 3.11 instead with the required fixes.

	Arnd

commit 787b0c1f8e1975157fe73104e67cac18f955281b
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Mon Jan 28 16:24:37 2013 +0000

    serial: pl011: use generic DMA slave configuration if possible
    
    With the new OF DMA binding, it is possible to completely avoid the
    need for platform_data for configuring a DMA channel. In cases where the
    platform has already been converted, calling dma_request_slave_channel
    should get all the necessary information from the device tree.
    
    This also adds a binding document specific to the pl011 controller,
    and extends the generic primecell binding to mention "dmas" and other
    common properties.
    
    Like the patch that converts the dw_dma controller, this is completely
    untested and is looking for someone to try it out.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Grant Likely <grant.likely@secretlab.ca>
    Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Cc: Russell King <linux@arm.linux.org.uk>
    Cc: Jiri Slaby <jslaby@suse.cz>
    Cc: Viresh Kumar <viresh.kumar@linaro.org>
    Cc: devicetree-discuss@lists.ozlabs.org
    Cc: linux-arm-kernel@lists.infradead.org

diff --git a/Documentation/devicetree/bindings/arm/primecell.txt b/Documentation/devicetree/bindings/arm/primecell.txt
index 64fc82b..0df6aca 100644
--- a/Documentation/devicetree/bindings/arm/primecell.txt
+++ b/Documentation/devicetree/bindings/arm/primecell.txt
@@ -16,14 +16,31 @@ Optional properties:
 - clocks : From common clock binding. First clock is phandle to clock for apb
 	pclk. Additional clocks are optional and specific to those peripherals.
 - clock-names : From common clock binding. Shall be "apb_pclk" for first clock.
+- dmas : From common DMA binding. If present, refers to one or more dma channels.
+- dma-names : From common DMA binding, needs to match the 'dmas' property.
+              Devices with exactly one receive and transmit channel shall name
+              these "rx" and "tx", respectively.
+- pinctrl-<n> : Pinctrl states as described in bindings/pinctrl/pinctrl-bindings.txt
+- pinctrl-names : Names corresponding to the numbered pinctrl states
+- interrupts : one or more interrupt specifiers
+- interrupt-names : names corresponding to the interrupts properties
 
 Example:
 
 serial@fff36000 {
 	compatible = "arm,pl011", "arm,primecell";
 	arm,primecell-periphid = <0x00341011>;
+
 	clocks = <&pclk>;
 	clock-names = "apb_pclk";
-	
+
+	dmas = <&dma-controller 4>, <&dma-controller 5>;
+	dma-names = "rx", "tx";	
+
+	pinctrl-0 = <&uart0_default_mux>, <&uart0_default_mode>;
+	pinctrl-1 = <&uart0_sleep_mode>;
+	pinctrl-names = "default","sleep";
+
+	interrupts = <0 11 0x4>;
 };
 
diff --git a/Documentation/devicetree/bindings/serial/pl011.txt b/Documentation/devicetree/bindings/serial/pl011.txt
new file mode 100644
index 0000000..5d2e840
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/pl011.txt
@@ -0,0 +1,17 @@
+* ARM AMBA Primecell PL011 serial UART
+
+Required properties:
+- compatible: must be "arm,primecell", "arm,pl011"
+- reg: exactly one register range with length 0x1000
+- interrupts: exactly one interrupt specifier
+
+Optional properties:
+- pinctrl: When present, must have one state named "sleep"
+	   and one state named "default"
+- clocks:  When present, must refer to exactly one clock named
+	   "apb_pclk"
+- dmas:	   When present, may have one or two dma channels.
+	   The first one must be named "rx", the second one
+	   must be named "tx".
+
+See also bindings/arm/primecell.txt
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 3ea5408..c25b00e 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -245,7 +245,7 @@ static void pl011_sgbuf_free(struct dma_chan *chan, struct pl011_sgbuf *sg,
 	}
 }
 
-static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
+static void pl011_dma_probe_initcall(struct device *dev, struct uart_amba_port *uap)
 {
 	/* DMA is the sole user of the platform data right now */
 	struct amba_pl011_data *plat = uap->port.dev->platform_data;
@@ -259,20 +259,25 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
 	struct dma_chan *chan;
 	dma_cap_mask_t mask;
 
-	/* We need platform data */
-	if (!plat || !plat->dma_filter) {
-		dev_info(uap->port.dev, "no DMA platform data\n");
-		return;
-	}
+	chan = dma_request_slave_channel(dev, "tx");
 
-	/* Try to acquire a generic DMA engine slave TX channel */
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-
-	chan = dma_request_channel(mask, plat->dma_filter, plat->dma_tx_param);
 	if (!chan) {
-		dev_err(uap->port.dev, "no TX DMA channel!\n");
-		return;
+		/* We need platform data */
+		if (!plat || !plat->dma_filter) {
+			dev_info(uap->port.dev, "no DMA platform data\n");
+			return;
+		}
+
+		/* Try to acquire a generic DMA engine slave TX channel */
+		dma_cap_zero(mask);
+		dma_cap_set(DMA_SLAVE, mask);
+
+		chan = dma_request_channel(mask, plat->dma_filter,
+						plat->dma_tx_param);
+		if (!chan) {
+			dev_err(uap->port.dev, "no TX DMA channel!\n");
+			return;
+		}
 	}
 
 	dmaengine_slave_config(chan, &tx_conf);
@@ -282,7 +287,18 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
 		 dma_chan_name(uap->dmatx.chan));
 
 	/* Optionally make use of an RX channel as well */
-	if (plat->dma_rx_param) {
+	chan = dma_request_slave_channel(dev, "rx");
+	
+	if (!chan && plat->dma_rx_param) {
+		chan = dma_request_channel(mask, plat->dma_filter, plat->dma_rx_param);
+
+		if (!chan) {
+			dev_err(uap->port.dev, "no RX DMA channel!\n");
+			return;
+		}
+	}
+
+	if (chan) {
 		struct dma_slave_config rx_conf = {
 			.src_addr = uap->port.mapbase + UART01x_DR,
 			.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE,
@@ -291,12 +307,6 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
 			.device_fc = false,
 		};
 
-		chan = dma_request_channel(mask, plat->dma_filter, plat->dma_rx_param);
-		if (!chan) {
-			dev_err(uap->port.dev, "no RX DMA channel!\n");
-			return;
-		}
-
 		dmaengine_slave_config(chan, &rx_conf);
 		uap->dmarx.chan = chan;
 
@@ -315,6 +325,7 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
 struct dma_uap {
 	struct list_head node;
 	struct uart_amba_port *uap;
+	struct device *dev;
 };
 
 static LIST_HEAD(pl011_dma_uarts);
@@ -325,7 +336,7 @@ static int __init pl011_dma_initcall(void)
 
 	list_for_each_safe(node, tmp, &pl011_dma_uarts) {
 		struct dma_uap *dmau = list_entry(node, struct dma_uap, node);
-		pl011_dma_probe_initcall(dmau->uap);
+		pl011_dma_probe_initcall(dmau->dev, dmau->uap);
 		list_del(node);
 		kfree(dmau);
 	}
@@ -334,18 +345,19 @@ static int __init pl011_dma_initcall(void)
 
 device_initcall(pl011_dma_initcall);
 
-static void pl011_dma_probe(struct uart_amba_port *uap)
+static void pl011_dma_probe(struct device *dev, struct uart_amba_port *uap)
 {
 	struct dma_uap *dmau = kzalloc(sizeof(struct dma_uap), GFP_KERNEL);
 	if (dmau) {
 		dmau->uap = uap;
+		dmau->dev = dev;
 		list_add_tail(&dmau->node, &pl011_dma_uarts);
 	}
 }
 #else
-static void pl011_dma_probe(struct uart_amba_port *uap)
+static void pl011_dma_probe(struct device *dev, struct uart_amba_port *uap)
 {
-	pl011_dma_probe_initcall(uap);
+	pl011_dma_probe_initcall(dev, uap);
 }
 #endif
 
@@ -991,7 +991,7 @@ static inline bool pl011_dma_rx_running(struct uart_amba_port *uap)
 
 #else
 /* Blank functions if the DMA engine is not available */
-static inline void pl011_dma_probe(struct uart_amba_port *uap)
+static inline void pl011_dma_probe(struct device *dev, struct uart_amba_port *uap)
 {
 }
 @@ -2020,7 +2032,7 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
 	uap->port.ops = &amba_pl011_pops;
 	uap->port.flags = UPF_BOOT_AUTOCONF;
 	uap->port.line = i;
-	pl011_dma_probe(uap);
+	pl011_dma_probe(&dev->dev, uap);
 
 	/* Ensure interrupts from this UART are masked and cleared */
 	writew(0, uap->port.membase + UART011_IMSC);



