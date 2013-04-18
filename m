Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967256Ab3DRMM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 08:12:59 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50231 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965330Ab3DRMM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 08:12:58 -0400
Date: Thu, 18 Apr 2013 13:12:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 24/32 v2] dmaengine: ste_dma40: Supply full Device Tree
 parsing support
Message-ID: <20130418121253.GF27903@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-25-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-25-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the new DMA DT bindings and API, we can register the DMA40 driver
as Device Tree capable. Now, when a client attempts to allocate a
channel using the DMA DT bindings via its own node, we are able to parse
the request and allocate a channel in the correct manner.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/Documentation/devicetree/bindings/dma/ste-dma40.txt b/Documentation/devicetree/bindings/dma/ste-dma40.txt
new file mode 100644
index 0000000..0aca55f
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/ste-dma40.txt
@@ -0,0 +1,62 @@
+* DMA40 DMA Controller
+
+Required properties:
+- compatible: "stericsson,dma40"
+- reg: Address range of the DMAC registers
+- reg-names: Names of the above areas to use during resource look-up
+- interrupt: Should contain the DMAC interrupt number
+- #dma-cells: must be <3>
+
+Optional properties:
+- dma-channels: Number of channels supported by hardware - if not present
+		the driver will attempt to obtain the information from H/W
+
+Example:
+
+	dma: dma-controller@801C0000 {
+		compatible = "stericsson,db8500-dma40", "stericsson,dma40";
+		reg = <0x801C0000 0x1000  0x40010000 0x800>;
+		reg-names = "base", "lcpa";
+		interrupt-parent = <&intc>;
+		interrupts = <0 25 0x4>;
+
+		#dma-cells = <2>;
+		dma-channels = <8>;
+	};
+
+Clients
+Required properties:
+- dmas: Comma separated list of dma channel requests
+- dma-names: Names of the aforementioned requested channels
+
+Each dmas request consists of 4 cells:
+  1. A phandle pointing to the DMA controller
+  2. Device Type
+  3. The DMA request line number (only when 'use fixed channel' is set)
+  4. A 32bit mask specifying; mode, direction and endianess [NB: This list will grow]
+        bit 1: Mode:
+           0: Logical
+           1: Physical
+        bit 2: Direction:
+           0: Mem to Mem
+           1: Mem to Dev
+        bit 3: Endianess:
+           0: Little endian
+           1: Big endian
+        bit 4: Use fixed channel:
+           0: Use automatic channel selection
+           1: Use DMA request line number
+
+Example:
+
+	uart@80120000 {
+		compatible = "arm,pl011", "arm,primecell";
+		reg = <0x80120000 0x1000>;
+		interrupts = <0 11 0x4>;
+
+		dmas = <&dma 13 0 0x8>, /* Logical - DevToMem */
+		       <&dma 13 0 0x4>; /* Logical - MemToDev */
+		dma-names = "rx", "rx";
+
+		status = "disabled";
+	};
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c70660d..f551b27 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -18,6 +18,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/of_dma.h>
 #include <linux/amba/bus.h>
 #include <linux/regulator/consumer.h>
 #include <linux/platform_data/dma-ste-dma40.h>
@@ -2409,6 +2410,53 @@ static void d40_set_prio_realtime(struct d40_chan *d40c)
 		__d40_set_prio_rt(d40c, d40c->dma_cfg.dev_type, false);
 }
 
+#define D40_DT_FLAGS_MODE(flags)       ((flags >> 0) & 0x1)
+#define D40_DT_FLAGS_DIR(flags)        ((flags >> 1) & 0x1)
+#define D40_DT_FLAGS_BIG_ENDIAN(flags) ((flags >> 2) & 0x1)
+#define D40_DT_FLAGS_FIXED_CHAN(flags) ((flags >> 3) & 0x1)
+
+static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
+				  struct of_dma *ofdma)
+{
+	struct stedma40_chan_cfg cfg;
+	dma_cap_mask_t cap;
+	u32 flags;
+
+	memset(&cfg, 0, sizeof(struct stedma40_chan_cfg));
+
+	dma_cap_zero(cap);
+	dma_cap_set(DMA_SLAVE, cap);
+
+	cfg.dev_type = dma_spec->args[0];
+	flags = dma_spec->args[2];
+
+	switch (D40_DT_FLAGS_MODE(flags)) {
+	case 0: cfg.mode = STEDMA40_MODE_LOGICAL; break;
+	case 1: cfg.mode = STEDMA40_MODE_PHYSICAL; break;
+	default:
+		pr_err("dma40: Unknown mode read from DT (%d)\n",
+		       D40_DT_FLAGS_MODE(flags));
+		return NULL;
+	}
+
+	switch (D40_DT_FLAGS_DIR(flags)) {
+	case 0: cfg.dir = STEDMA40_MEM_TO_MEM; break;
+	case 1: cfg.dir = STEDMA40_MEM_TO_PERIPH; break;
+	}
+
+	if (cfg.dir == STEDMA40_PERIPH_TO_MEM)
+		cfg.src_info.big_endian = D40_DT_FLAGS_BIG_ENDIAN(flags);
+	if (cfg.dir == STEDMA40_MEM_TO_PERIPH)
+		cfg.dst_info.big_endian = D40_DT_FLAGS_BIG_ENDIAN(flags);
+
+	if (D40_DT_FLAGS_FIXED_CHAN(flags)) {
+		cfg.phy_channel = dma_spec->args[1];
+		cfg.use_fixed_channel = true;
+	}
+
+	return dma_request_channel(cap, stedma40_filter, &cfg);
+}
+
 /* DMA ENGINE functions */
 static int d40_alloc_chan_resources(struct dma_chan *chan)
 {
@@ -3615,6 +3663,13 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	d40_hw_init(base);
 
+	if (np) {
+		err = of_dma_controller_register(np, d40_xlate, NULL);
+		if (err && err != -ENODEV)
+			dev_err(&pdev->dev,
+				"could not register of_dma_controller\n");
+	}
+
 	dev_info(base->dev, "initialized\n");
 	return 0;
