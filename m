Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3CMD3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 23:29:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50660 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003Ab3CMD3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 23:29:12 -0400
From: Suman Anna <s-anna@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Benoit Cousson <b-cousson@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv3 02/14] ARM: OMAP2+: mbox: remove dependencies with soc.h
Date: Tue, 12 Mar 2013 22:23:56 -0500
Message-ID: <1363145036-14407-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP mailbox platform driver code has been cleaned up to
remove the dependencies with soc.h in preparation for moving
the mailbox code to drivers folder.

The code relied on cpu_is_xxx/soc_is_xxx macros previously to
pick the the right set of mailbox devices and register with the
mailbox driver. This data is now represented in a concise format
and moved to the respective omap_hwmod data files and published
to the driver through the platform data.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 arch/arm/mach-omap2/devices.c              |   9 +-
 arch/arm/mach-omap2/mailbox.c              | 240 ++++++++++-------------------
 arch/arm/mach-omap2/omap_hwmod_2420_data.c |  12 ++
 arch/arm/mach-omap2/omap_hwmod_2430_data.c |  11 ++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  11 ++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  13 ++
 arch/arm/plat-omap/include/plat/mailbox.h  |   2 +-
 include/linux/platform_data/mailbox-omap.h |  53 +++++++
 8 files changed, 190 insertions(+), 161 deletions(-)
 create mode 100644 include/linux/platform_data/mailbox-omap.h

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 1ec7f05..039f6d7 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -20,6 +20,7 @@
 #include <linux/pinctrl/machine.h>
 #include <linux/platform_data/omap4-keypad.h>
 #include <linux/platform_data/omap_ocp2scp.h>
+#include <linux/platform_data/mailbox-omap.h>
 #include <linux/usb/omap_control_usb.h>
 
 #include <asm/mach-types.h>
@@ -332,14 +333,20 @@ static inline void __init omap_init_mbox(void)
 {
 	struct omap_hwmod *oh;
 	struct platform_device *pdev;
+	struct omap_mbox_pdata *pdata;
 
 	oh = omap_hwmod_lookup("mailbox");
 	if (!oh) {
 		pr_err("%s: unable to find hwmod\n", __func__);
 		return;
 	}
+	if (!oh->dev_attr) {
+		pr_err("%s: hwmod doesn't have valid attrs\n", __func__);
+		return;
+	}
 
-	pdev = omap_device_build("omap-mailbox", -1, oh, NULL, 0);
+	pdata = (struct omap_mbox_pdata *)oh->dev_attr;
+	pdev = omap_device_build("omap-mailbox", -1, oh, pdata, sizeof(*pdata));
 	WARN(IS_ERR(pdev), "%s: could not build device, err %ld\n",
 						__func__, PTR_ERR(pdev));
 }
diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 0b08026..8f5bcd8 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -11,16 +11,16 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
+#include <linux/platform_data/mailbox-omap.h>
 
 #include <plat/mailbox.h>
 
-#include "soc.h"
-
 #define MAILBOX_REVISION		0x000
 #define MAILBOX_MESSAGE(m)		(0x040 + 4 * (m))
 #define MAILBOX_FIFOSTATUS(m)		(0x080 + 4 * (m))
@@ -59,6 +59,7 @@ struct omap_mbox2_priv {
 	u32 notfull_bit;
 	u32 ctx[OMAP4_MBOX_NR_REGS];
 	unsigned long irqdisable;
+	u32 intr_type;
 };
 
 static void omap2_mbox_enable_irq(struct omap_mbox *mbox,
@@ -141,7 +142,7 @@ static void omap2_mbox_disable_irq(struct omap_mbox *mbox,
 	struct omap_mbox2_priv *p = mbox->priv;
 	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
 
-	if (!cpu_is_omap44xx())
+	if (!p->intr_type)
 		bit = mbox_read_reg(p->irqdisable) & ~bit;
 
 	mbox_write_reg(bit, p->irqdisable);
@@ -175,7 +176,8 @@ static void omap2_mbox_save_ctx(struct omap_mbox *mbox)
 	int i;
 	struct omap_mbox2_priv *p = mbox->priv;
 	int nr_regs;
-	if (cpu_is_omap44xx())
+
+	if (p->intr_type)
 		nr_regs = OMAP4_MBOX_NR_REGS;
 	else
 		nr_regs = MBOX_NR_REGS;
@@ -192,7 +194,8 @@ static void omap2_mbox_restore_ctx(struct omap_mbox *mbox)
 	int i;
 	struct omap_mbox2_priv *p = mbox->priv;
 	int nr_regs;
-	if (cpu_is_omap44xx())
+
+	if (p->intr_type)
 		nr_regs = OMAP4_MBOX_NR_REGS;
 	else
 		nr_regs = MBOX_NR_REGS;
@@ -220,185 +223,104 @@ static struct omap_mbox_ops omap2_mbox_ops = {
 	.restore_ctx	= omap2_mbox_restore_ctx,
 };
 
-/*
- * MAILBOX 0: ARM -> DSP,
- * MAILBOX 1: ARM <- DSP.
- * MAILBOX 2: ARM -> IVA,
- * MAILBOX 3: ARM <- IVA.
- */
-
-/* FIXME: the following structs should be filled automatically by the user id */
-
-#if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_ARCH_OMAP2)
-/* DSP */
-static struct omap_mbox2_priv omap2_mbox_dsp_priv = {
-	.tx_fifo = {
-		.msg		= MAILBOX_MESSAGE(0),
-		.fifo_stat	= MAILBOX_FIFOSTATUS(0),
-	},
-	.rx_fifo = {
-		.msg		= MAILBOX_MESSAGE(1),
-		.msg_stat	= MAILBOX_MSGSTATUS(1),
-	},
-	.irqenable	= MAILBOX_IRQENABLE(0),
-	.irqstatus	= MAILBOX_IRQSTATUS(0),
-	.notfull_bit	= MAILBOX_IRQ_NOTFULL(0),
-	.newmsg_bit	= MAILBOX_IRQ_NEWMSG(1),
-	.irqdisable	= MAILBOX_IRQENABLE(0),
-};
-
-struct omap_mbox mbox_dsp_info = {
-	.name	= "dsp",
-	.ops	= &omap2_mbox_ops,
-	.priv	= &omap2_mbox_dsp_priv,
-};
-#endif
-
-#if defined(CONFIG_ARCH_OMAP3)
-struct omap_mbox *omap3_mboxes[] = { &mbox_dsp_info, NULL };
-#endif
-
-#if defined(CONFIG_SOC_OMAP2420)
-/* IVA */
-static struct omap_mbox2_priv omap2_mbox_iva_priv = {
-	.tx_fifo = {
-		.msg		= MAILBOX_MESSAGE(2),
-		.fifo_stat	= MAILBOX_FIFOSTATUS(2),
-	},
-	.rx_fifo = {
-		.msg		= MAILBOX_MESSAGE(3),
-		.msg_stat	= MAILBOX_MSGSTATUS(3),
-	},
-	.irqenable	= MAILBOX_IRQENABLE(3),
-	.irqstatus	= MAILBOX_IRQSTATUS(3),
-	.notfull_bit	= MAILBOX_IRQ_NOTFULL(2),
-	.newmsg_bit	= MAILBOX_IRQ_NEWMSG(3),
-	.irqdisable	= MAILBOX_IRQENABLE(3),
-};
-
-static struct omap_mbox mbox_iva_info = {
-	.name	= "iva",
-	.ops	= &omap2_mbox_ops,
-	.priv	= &omap2_mbox_iva_priv,
-};
-#endif
-
-#ifdef CONFIG_ARCH_OMAP2
-struct omap_mbox *omap2_mboxes[] = {
-	&mbox_dsp_info,
-#ifdef CONFIG_SOC_OMAP2420
-	&mbox_iva_info,
-#endif
-	NULL
-};
-#endif
-
-#if defined(CONFIG_ARCH_OMAP4)
-/* OMAP4 */
-static struct omap_mbox2_priv omap2_mbox_1_priv = {
-	.tx_fifo = {
-		.msg		= MAILBOX_MESSAGE(0),
-		.fifo_stat	= MAILBOX_FIFOSTATUS(0),
-	},
-	.rx_fifo = {
-		.msg		= MAILBOX_MESSAGE(1),
-		.msg_stat	= MAILBOX_MSGSTATUS(1),
-	},
-	.irqenable	= OMAP4_MAILBOX_IRQENABLE(0),
-	.irqstatus	= OMAP4_MAILBOX_IRQSTATUS(0),
-	.notfull_bit	= MAILBOX_IRQ_NOTFULL(0),
-	.newmsg_bit	= MAILBOX_IRQ_NEWMSG(1),
-	.irqdisable	= OMAP4_MAILBOX_IRQENABLE_CLR(0),
-};
-
-struct omap_mbox mbox_1_info = {
-	.name	= "mailbox-1",
-	.ops	= &omap2_mbox_ops,
-	.priv	= &omap2_mbox_1_priv,
-};
-
-static struct omap_mbox2_priv omap2_mbox_2_priv = {
-	.tx_fifo = {
-		.msg		= MAILBOX_MESSAGE(3),
-		.fifo_stat	= MAILBOX_FIFOSTATUS(3),
-	},
-	.rx_fifo = {
-		.msg		= MAILBOX_MESSAGE(2),
-		.msg_stat	= MAILBOX_MSGSTATUS(2),
-	},
-	.irqenable	= OMAP4_MAILBOX_IRQENABLE(0),
-	.irqstatus	= OMAP4_MAILBOX_IRQSTATUS(0),
-	.notfull_bit	= MAILBOX_IRQ_NOTFULL(3),
-	.newmsg_bit	= MAILBOX_IRQ_NEWMSG(2),
-	.irqdisable     = OMAP4_MAILBOX_IRQENABLE_CLR(0),
-};
-
-struct omap_mbox mbox_2_info = {
-	.name	= "mailbox-2",
-	.ops	= &omap2_mbox_ops,
-	.priv	= &omap2_mbox_2_priv,
-};
-
-struct omap_mbox *omap4_mboxes[] = { &mbox_1_info, &mbox_2_info, NULL };
-#endif
-
 static int omap2_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *mem;
 	int ret;
-	struct omap_mbox **list;
-
-	if (false)
-		;
-#if defined(CONFIG_ARCH_OMAP3)
-	else if (cpu_is_omap34xx()) {
-		list = omap3_mboxes;
+	struct omap_mbox **list, *mbox, *mboxblk;
+	struct omap_mbox2_priv *priv, *privblk;
+	struct omap_mbox_pdata *pdata = pdev->dev.platform_data;
+	struct omap_mbox_dev_info *info;
+	int i;
 
-		list[0]->irq = platform_get_irq(pdev, 0);
+	if (!pdata || !pdata->info_cnt || !pdata->info) {
+		pr_err("%s: platform not supported\n", __func__);
+		return -ENODEV;
 	}
-#endif
-#if defined(CONFIG_ARCH_OMAP2)
-	else if (cpu_is_omap2430()) {
-		list = omap2_mboxes;
 
-		list[0]->irq = platform_get_irq(pdev, 0);
-	} else if (cpu_is_omap2420()) {
-		list = omap2_mboxes;
+	/* allocate one extra for marking end of list */
+	list = kzalloc((pdata->info_cnt + 1) * sizeof(*list), GFP_KERNEL);
+	if (!list)
+		return -ENOMEM;
 
-		list[0]->irq = platform_get_irq_byname(pdev, "dsp");
-		list[1]->irq = platform_get_irq_byname(pdev, "iva");
+	mboxblk = mbox = kzalloc(pdata->info_cnt * sizeof(*mbox), GFP_KERNEL);
+	if (!mboxblk) {
+		ret = -ENOMEM;
+		goto free_list;
 	}
-#endif
-#if defined(CONFIG_ARCH_OMAP4)
-	else if (cpu_is_omap44xx()) {
-		list = omap4_mboxes;
 
-		list[0]->irq = list[1]->irq = platform_get_irq(pdev, 0);
+	privblk = priv = kzalloc(pdata->info_cnt * sizeof(*priv), GFP_KERNEL);
+	if (!privblk) {
+		ret = -ENOMEM;
+		goto free_mboxblk;
 	}
-#endif
-	else {
-		pr_err("%s: platform not supported\n", __func__);
-		return -ENODEV;
+
+	info = pdata->info;
+	for (i = 0; i < pdata->info_cnt; i++, info++, priv++) {
+		priv->tx_fifo.msg = MAILBOX_MESSAGE(info->tx_id);
+		priv->tx_fifo.fifo_stat = MAILBOX_FIFOSTATUS(info->tx_id);
+		priv->rx_fifo.msg =  MAILBOX_MESSAGE(info->rx_id);
+		priv->rx_fifo.msg_stat =  MAILBOX_MSGSTATUS(info->rx_id);
+		priv->notfull_bit = MAILBOX_IRQ_NOTFULL(info->tx_id);
+		priv->newmsg_bit = MAILBOX_IRQ_NEWMSG(info->rx_id);
+		if (pdata->intr_type) {
+			priv->irqenable = OMAP4_MAILBOX_IRQENABLE(info->usr_id);
+			priv->irqstatus = OMAP4_MAILBOX_IRQSTATUS(info->usr_id);
+			priv->irqdisable =
+				OMAP4_MAILBOX_IRQENABLE_CLR(info->usr_id);
+		} else {
+			priv->irqenable = MAILBOX_IRQENABLE(info->usr_id);
+			priv->irqstatus = MAILBOX_IRQSTATUS(info->usr_id);
+			priv->irqdisable = MAILBOX_IRQENABLE(info->usr_id);
+		}
+		priv->intr_type = pdata->intr_type;
+
+		mbox->priv = priv;
+		mbox->name = info->name;
+		mbox->ops = &omap2_mbox_ops;
+		mbox->irq = platform_get_irq(pdev, info->irq_id);
+		list[i] = mbox++;
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mbox_base = ioremap(mem->start, resource_size(mem));
-	if (!mbox_base)
-		return -ENOMEM;
+	if (!mbox_base) {
+		ret = -ENOMEM;
+		goto free_privblk;
+	}
 
 	ret = omap_mbox_register(&pdev->dev, list);
-	if (ret) {
-		iounmap(mbox_base);
-		return ret;
-	}
+	if (ret)
+		goto unmap_mbox;
+	platform_set_drvdata(pdev, list);
 
 	return 0;
+
+unmap_mbox:
+	iounmap(mbox_base);
+free_privblk:
+	kfree(privblk);
+free_mboxblk:
+	kfree(mboxblk);
+free_list:
+	kfree(list);
+	return ret;
 }
 
 static int omap2_mbox_remove(struct platform_device *pdev)
 {
+	struct omap_mbox2_priv *privblk;
+	struct omap_mbox **list = platform_get_drvdata(pdev);
+	struct omap_mbox *mboxblk = list[0];
+
+	privblk = mboxblk->priv;
 	omap_mbox_unregister();
 	iounmap(mbox_base);
+	kfree(privblk);
+	kfree(mboxblk);
+	kfree(list);
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 
diff --git a/arch/arm/mach-omap2/omap_hwmod_2420_data.c b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
index 6a764af..8dcd65a 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2420_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
@@ -16,6 +16,7 @@
 #include <linux/i2c-omap.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/omap-dma.h>
+#include <linux/platform_data/mailbox-omap.h>
 #include <plat/dmtimer.h>
 
 #include "omap_hwmod.h"
@@ -166,6 +167,16 @@ static struct omap_hwmod omap2420_dma_system_hwmod = {
 };
 
 /* mailbox */
+static struct omap_mbox_dev_info omap2420_mailbox_info[] = {
+	{ .name = "dsp", .tx_id = 0, .rx_id = 1, .irq_id = 0, .usr_id = 0 },
+	{ .name = "iva", .tx_id = 2, .rx_id = 3, .irq_id = 1, .usr_id = 3 },
+};
+
+static struct omap_mbox_pdata omap2420_mailbox_attrs = {
+	.info_cnt	= ARRAY_SIZE(omap2420_mailbox_info),
+	.info		= omap2420_mailbox_info,
+};
+
 static struct omap_hwmod_irq_info omap2420_mailbox_irqs[] = {
 	{ .name = "dsp", .irq = 26 + OMAP_INTC_START, },
 	{ .name = "iva", .irq = 34 + OMAP_INTC_START, },
@@ -186,6 +197,7 @@ static struct omap_hwmod omap2420_mailbox_hwmod = {
 			.idlest_idle_bit = OMAP24XX_ST_MAILBOXES_SHIFT,
 		},
 	},
+	.dev_attr	= &omap2420_mailbox_attrs,
 };
 
 /*
diff --git a/arch/arm/mach-omap2/omap_hwmod_2430_data.c b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
index d2d3840..468c682 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2430_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
@@ -17,6 +17,7 @@
 #include <linux/platform_data/asoc-ti-mcbsp.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/omap-dma.h>
+#include <linux/platform_data/mailbox-omap.h>
 #include <plat/dmtimer.h>
 
 #include "omap_hwmod.h"
@@ -170,6 +171,15 @@ static struct omap_hwmod omap2430_dma_system_hwmod = {
 };
 
 /* mailbox */
+static struct omap_mbox_dev_info omap2430_mailbox_info[] = {
+	{ .name = "dsp", .tx_id = 0, .rx_id = 1 },
+};
+
+static struct omap_mbox_pdata omap2430_mailbox_attrs = {
+	.info_cnt	= ARRAY_SIZE(omap2430_mailbox_info),
+	.info		= omap2430_mailbox_info,
+};
+
 static struct omap_hwmod_irq_info omap2430_mailbox_irqs[] = {
 	{ .irq = 26 + OMAP_INTC_START, },
 	{ .irq = -1 },
@@ -189,6 +199,7 @@ static struct omap_hwmod omap2430_mailbox_hwmod = {
 			.idlest_idle_bit = OMAP24XX_ST_MAILBOXES_SHIFT,
 		},
 	},
+	.dev_attr	= &omap2430_mailbox_attrs,
 };
 
 /* mcspi3 */
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index ac7e03e..dac2297 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -25,6 +25,7 @@
 #include <linux/platform_data/asoc-ti-mcbsp.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/iommu-omap.h>
+#include <linux/platform_data/mailbox-omap.h>
 #include <plat/dmtimer.h>
 
 #include "am35xx.h"
@@ -1501,6 +1502,15 @@ static struct omap_hwmod_class omap3xxx_mailbox_hwmod_class = {
 	.sysc = &omap3xxx_mailbox_sysc,
 };
 
+static struct omap_mbox_dev_info omap3xxx_mailbox_info[] = {
+	{ .name = "dsp", .tx_id = 0, .rx_id = 1 },
+};
+
+static struct omap_mbox_pdata omap3xxx_mailbox_attrs = {
+	.info_cnt	= ARRAY_SIZE(omap3xxx_mailbox_info),
+	.info		= omap3xxx_mailbox_info,
+};
+
 static struct omap_hwmod_irq_info omap3xxx_mailbox_irqs[] = {
 	{ .irq = 26 + OMAP_INTC_START, },
 	{ .irq = -1 },
@@ -1520,6 +1530,7 @@ static struct omap_hwmod omap3xxx_mailbox_hwmod = {
 			.idlest_idle_bit = OMAP3430_ST_MAILBOXES_SHIFT,
 		},
 	},
+	.dev_attr	= &omap3xxx_mailbox_attrs,
 };
 
 /*
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 0e47d2e..10f3d32 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -29,6 +29,7 @@
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
 #include <linux/platform_data/iommu-omap.h>
+#include <linux/platform_data/mailbox-omap.h>
 #include <plat/dmtimer.h>
 
 #include "omap_hwmod.h"
@@ -1861,6 +1862,17 @@ static struct omap_hwmod_class omap44xx_mailbox_hwmod_class = {
 };
 
 /* mailbox */
+static struct omap_mbox_dev_info omap44xx_mailbox_info[] = {
+	{ .name = "mbox-ipu", .tx_id = 0, .rx_id = 1 },
+	{ .name = "mbox-dsp", .tx_id = 3, .rx_id = 2 },
+};
+
+static struct omap_mbox_pdata omap44xx_mailbox_attrs = {
+	.intr_type	= MBOX_INTR_CFG_TYPE2,
+	.info_cnt	= ARRAY_SIZE(omap44xx_mailbox_info),
+	.info		= omap44xx_mailbox_info,
+};
+
 static struct omap_hwmod_irq_info omap44xx_mailbox_irqs[] = {
 	{ .irq = 26 + OMAP44XX_IRQ_GIC_START },
 	{ .irq = -1 }
@@ -1877,6 +1889,7 @@ static struct omap_hwmod omap44xx_mailbox_hwmod = {
 			.context_offs = OMAP4_RM_L4CFG_MAILBOX_CONTEXT_OFFSET,
 		},
 	},
+	.dev_attr	= &omap44xx_mailbox_attrs,
 };
 
 /*
diff --git a/arch/arm/plat-omap/include/plat/mailbox.h b/arch/arm/plat-omap/include/plat/mailbox.h
index cc3921e..e98f7e2 100644
--- a/arch/arm/plat-omap/include/plat/mailbox.h
+++ b/arch/arm/plat-omap/include/plat/mailbox.h
@@ -51,7 +51,7 @@ struct omap_mbox_queue {
 };
 
 struct omap_mbox {
-	char			*name;
+	const char		*name;
 	unsigned int		irq;
 	struct omap_mbox_queue	*txq, *rxq;
 	struct omap_mbox_ops	*ops;
diff --git a/include/linux/platform_data/mailbox-omap.h b/include/linux/platform_data/mailbox-omap.h
new file mode 100644
index 0000000..676cd64
--- /dev/null
+++ b/include/linux/platform_data/mailbox-omap.h
@@ -0,0 +1,53 @@
+/*
+ * mailbox-omap.h
+ *
+ * Copyright (C) 2013 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _PLAT_MAILBOX_H
+#define _PLAT_MAILBOX_H
+
+/* Interrupt register configuration types */
+#define MBOX_INTR_CFG_TYPE1	(0)
+#define MBOX_INTR_CFG_TYPE2	(1)
+
+/**
+ * struct omap_mbox_dev_info - OMAP mailbox device attribute info
+ * @name:	name of the mailbox device
+ * @tx_id:	mailbox queue id used for transmitting messages
+ * @rx_id:	mailbox queue id on which messages are received
+ * @irq_id:	irq identifier number to use from the hwmod data
+ * @usr_id:	mailbox user id for identifying the interrupt into
+ *			the MPU interrupt controller.
+ */
+struct omap_mbox_dev_info {
+	const char *name;
+	u32 tx_id;
+	u32 rx_id;
+	u32 irq_id;
+	u32 usr_id;
+};
+
+/**
+ * struct omap_mbox_pdata - OMAP mailbox platform data
+ * @intr_type:	type of interrupt configuration registers used
+			while programming mailbox queue interrupts
+ * @info_cnt:	number of mailbox devices for the platform
+ * @info:	array of mailbox device attributes
+ */
+struct omap_mbox_pdata {
+	u32 intr_type;
+	u32 info_cnt;
+	struct omap_mbox_dev_info *info;
+};
+
+#endif /* _PLAT_MAILBOX_H */
-- 
1.8.1.2

