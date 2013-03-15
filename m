Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3CONqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:46:12 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:29860 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754843Ab3CONqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:46:07 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        software@gaisler.com
Subject: [PATCH v5 3/3] gpio: grgpio: Add irq support
Date: Fri, 15 Mar 2013 14:45:40 +0100
Message-Id: <1363355140-28216-4-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers sets up an irq domain and hands out unique virqs to irq
capable gpio lines regardless of which underlying irqs maps to which gpio
line.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 .../devicetree/bindings/gpio/gpio-grgpio.txt       |    5 +
 drivers/gpio/gpio-grgpio.c                         |  333 +++++++++++++++++++-
 2 files changed, 334 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt b/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
index 1050dc8..e28bc3c 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
@@ -20,5 +20,10 @@ Optional properties:
 
 - nbits : The number of gpio lines. If not present driver assumes 32 lines.
 
+- irqmap : An array with an index for each gpio line. An index is either a valid
+	index into the interrupts property array, or 0xffffffff that indicates
+	no irq for that line. Driver provides no interrupt support if not
+	present.
+
 For further information look in the documentation for the GLIB IP core library:
 http://www.gaisler.com/products/grlib/grip.pdf
diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index f8902da..3acff77 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -32,6 +32,9 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/basic_mmio_gpio.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
 
 #define GRGPIO_MAX_NGPIO 32
 
@@ -47,10 +50,41 @@ struct grgpio_regs {
 	u32 imap[8];	/* 0x20-0x3c */
 };
 
+struct grgpio_uirq {
+	u8 refcnt; /* Reference counter to manage requesting/freeing of uirq */
+	u8 uirq; /* Underlying virq of the gpio driver */
+};
+
+struct grgpio_lirq {
+	s8 index; /* Index into struct grgpio_priv's uirqs, or -1 */
+	u8 virq; /* virq for the gpio line */
+};
+
 struct grgpio_priv {
 	struct bgpio_chip bgc;
 	struct grgpio_regs __iomem *regs;
 	struct device *dev;
+
+	u32 imask; /* irq mask shadow register */
+
+	/* The grgpio core can have multiple irqs. Severeal gpio lines can
+	 * potentially be mapped to the same irq. This driver sets up an
+	 * irq domain and hands out separate virqs to each gpio line
+	 */
+	struct irq_domain *domain;
+
+	/* This array contains information on each underlying irq, each
+	 * irq of the grgpio core itself.
+	 */
+	struct grgpio_uirq uirqs[GRGPIO_MAX_NGPIO];
+
+	/* This array contains information for each gpio line on the
+	 * virtual irqs obtains from this driver. An index value of -1 for
+	 * a certain gpio line indicates that the line has no
+	 * irq. Otherwise the index connects the virq to the underlying
+	 * irq by pointing into the uirqs array.
+	 */
+	struct grgpio_lirq lirqs[GRGPIO_MAX_NGPIO];
 };
 
 static inline struct grgpio_priv *grgpio_gc_to_priv(struct gpio_chip *gc)
@@ -60,11 +94,231 @@ static inline struct grgpio_priv *grgpio_gc_to_priv(struct gpio_chip *gc)
 	return container_of(bgc, struct grgpio_priv, bgc);
 }
 
+static void grgpio_set_imask(struct grgpio_priv *priv, unsigned int offset,
+			     int val)
+{
+	struct bgpio_chip *bgc = &priv->bgc;
+	unsigned long mask = bgc->pin2mask(bgc, offset);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	if (val)
+		priv->imask |= mask;
+	else
+		priv->imask &= ~mask;
+	bgc->write_reg(&priv->regs->imask, priv->imask);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
 static int grgpio_to_irq(struct gpio_chip *gc, unsigned offset)
 {
-	return -ENXIO;
+	struct grgpio_priv *priv = grgpio_gc_to_priv(gc);
+
+	if (offset > gc->ngpio)
+		return -ENXIO;
+
+	if (priv->lirqs[offset].index < 0)
+		return -ENXIO;
+
+	return irq_create_mapping(priv->domain, offset);
+}
+
+/* -------------------- IRQ chip functions -------------------- */
+
+static int grgpio_irq_set_type(struct irq_data *d, unsigned int type)
+{
+	struct grgpio_priv *priv = irq_data_get_irq_chip_data(d);
+	unsigned long flags;
+	u32 mask = BIT(d->hwirq);
+	u32 ipol;
+	u32 iedge;
+	u32 pol;
+	u32 edge;
+
+	switch (type) {
+	case IRQ_TYPE_LEVEL_LOW:
+		pol = 0;
+		edge = 0;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		pol = mask;
+		edge = 0;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		pol = 0;
+		edge = mask;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		pol = mask;
+		edge = mask;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&priv->bgc.lock, flags);
+
+	ipol = priv->bgc.read_reg(&priv->regs->ipol) & ~mask;
+	iedge = priv->bgc.read_reg(&priv->regs->iedge) & ~mask;
+
+	priv->bgc.write_reg(&priv->regs->ipol, ipol | pol);
+	priv->bgc.write_reg(&priv->regs->iedge, iedge | edge);
+
+	spin_unlock_irqrestore(&priv->bgc.lock, flags);
+
+	return 0;
+}
+
+static void grgpio_irq_mask(struct irq_data *d)
+{
+	struct grgpio_priv *priv = irq_data_get_irq_chip_data(d);
+	int offset = d->hwirq;
+
+	grgpio_set_imask(priv, offset, 0);
+}
+
+static void grgpio_irq_unmask(struct irq_data *d)
+{
+	struct grgpio_priv *priv = irq_data_get_irq_chip_data(d);
+	int offset = d->hwirq;
+
+	grgpio_set_imask(priv, offset, 1);
+}
+
+static struct irq_chip grgpio_irq_chip = {
+	.name			= "grgpio",
+	.irq_mask		= grgpio_irq_mask,
+	.irq_unmask		= grgpio_irq_unmask,
+	.irq_set_type		= grgpio_irq_set_type,
+};
+
+static irqreturn_t grgpio_irq_handler(int irq, void *dev)
+{
+	struct grgpio_priv *priv = dev;
+	int ngpio = priv->bgc.gc.ngpio;
+	int i;
+
+	for (i = 0; i < ngpio; i++) {
+		struct grgpio_lirq *lirq = &priv->lirqs[i];
+
+		if (priv->imask & BIT(i) && lirq->index >= 0 &&
+		    priv->uirqs[lirq->index].uirq == irq) {
+			generic_handle_irq(lirq->virq);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+/* This function will be called as a consequence of the call to
+ * irq_create_mapping in grgpio_to_irq
+ */
+int grgpio_irq_map(struct irq_domain *d, unsigned int virq,
+		   irq_hw_number_t hwirq)
+{
+	struct grgpio_priv *priv = d->host_data;
+	struct grgpio_lirq *lirq;
+	struct grgpio_uirq *uirq;
+	unsigned long flags;
+	int offset = hwirq;
+	int ret = 0;
+
+	if (!priv)
+		return -EINVAL;
+
+	lirq = &priv->lirqs[offset];
+	if (lirq->index < 0)
+		return -EINVAL;
+
+	dev_dbg(priv->dev, "Mapping virq %d for gpio line %d\n",
+		virq, offset);
+
+	spin_lock_irqsave(&priv->bgc.lock, flags);
+
+	/* Request underlying irq if not already requested */
+	lirq->virq = virq;
+	uirq = &priv->uirqs[lirq->index];
+	if (uirq->refcnt == 0) {
+		ret = request_irq(uirq->uirq, grgpio_irq_handler, 0,
+				  dev_name(priv->dev), priv);
+		if (ret) {
+			dev_err(priv->dev,
+				"Could not request underlying irq %d\n",
+				uirq->uirq);
+
+			spin_unlock_irqrestore(&priv->bgc.lock, flags);
+
+			return ret;
+		}
+	}
+	uirq->refcnt++;
+
+	spin_unlock_irqrestore(&priv->bgc.lock, flags);
+
+	/* Setup virq  */
+	irq_set_chip_data(virq, priv);
+	irq_set_chip_and_handler(virq, &grgpio_irq_chip,
+				 handle_simple_irq);
+	irq_clear_status_flags(virq, IRQ_NOREQUEST);
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return ret;
+}
+
+void grgpio_irq_unmap(struct irq_domain *d, unsigned int virq)
+{
+	struct grgpio_priv *priv = d->host_data;
+	int index;
+	struct grgpio_lirq *lirq;
+	struct grgpio_uirq *uirq;
+	unsigned long flags;
+	int ngpio = priv->bgc.gc.ngpio;
+	int i;
+
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, 0);
+#endif
+	irq_set_chip_and_handler(virq, NULL, NULL);
+	irq_set_chip_data(virq, NULL);
+
+	spin_lock_irqsave(&priv->bgc.lock, flags);
+
+	/* Free underlying irq if last user unmapped */
+	index = -1;
+	for (i = 0; i < ngpio; i++) {
+		lirq = &priv->lirqs[i];
+		if (lirq->virq == virq) {
+			grgpio_set_imask(priv, i, 0);
+			lirq->virq = 0;
+			index = lirq->index;
+			break;
+		}
+	}
+	WARN_ON(index < 0);
+
+	if (index >= 0) {
+		uirq = &priv->uirqs[lirq->index];
+		uirq->refcnt--;
+		if (uirq->refcnt == 0)
+			free_irq(uirq->uirq, priv);
+	}
+
+	spin_unlock_irqrestore(&priv->bgc.lock, flags);
 }
 
+static struct irq_domain_ops grgpio_irq_domain_ops = {
+	.map	= grgpio_irq_map,
+	.unmap	= grgpio_irq_unmap,
+};
+
+/* ------------------------------------------------------------ */
+
 static int grgpio_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
@@ -75,6 +329,9 @@ static int grgpio_probe(struct platform_device *ofdev)
 	struct resource *res;
 	int err;
 	u32 prop;
+	s32 *irqmap;
+	int size;
+	int i;
 
 	priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -94,6 +351,7 @@ static int grgpio_probe(struct platform_device *ofdev)
 	}
 
 	priv->regs = regs;
+	priv->imask = bgc->read_reg(&regs->imask);
 	priv->dev = &ofdev->dev;
 
 	gc = &bgc->gc;
@@ -119,6 +377,49 @@ static int grgpio_probe(struct platform_device *ofdev)
 		gc->ngpio = prop;
 	}
 
+	/* The irqmap contains the index values indicating which underlying irq,
+	 * if anyone, is connected to that line
+	 */
+	irqmap = (s32 *)of_get_property(np, "irqmap", &size);
+	if (irqmap) {
+		if (size < gc->ngpio) {
+			dev_err(&ofdev->dev,
+				"irqmap shorter than ngpio (%d < %d)\n",
+				size, gc->ngpio);
+			return -EINVAL;
+		}
+
+		priv->domain = irq_domain_add_linear(np, gc->ngpio,
+						     &grgpio_irq_domain_ops,
+						     priv);
+		if (!priv->domain) {
+			dev_err(&ofdev->dev, "Could not add irq domain\n");
+			return -EINVAL;
+		}
+
+		for (i = 0; i < gc->ngpio; i++) {
+			struct grgpio_lirq *lirq;
+			int ret;
+
+			lirq = &priv->lirqs[i];
+			lirq->index = irqmap[i];
+
+			if (lirq->index < 0)
+				continue;
+
+			ret = platform_get_irq(ofdev, lirq->index);
+			if (ret <= 0) {
+				/* Continue without irq functionality for that
+				 * gpio line
+				 */
+				dev_err(priv->dev,
+					"Failed to get irq for offset %d\n", i);
+				continue;
+			}
+			priv->uirqs[lirq->index].uirq = ret;
+		}
+	}
+
 	platform_set_drvdata(ofdev, priv);
 
 	err = gpiochip_add(gc);
@@ -127,8 +428,8 @@ static int grgpio_probe(struct platform_device *ofdev)
 		return err;
 	}
 
-	dev_info(&ofdev->dev, "regs=0x%p, base=%d, ngpio=%d\n",
-		 priv->regs, gc->base, gc->ngpio);
+	dev_info(&ofdev->dev, "regs=0x%p, base=%d, ngpio=%d, irqs=%s\n",
+		 priv->regs, gc->base, gc->ngpio, priv->domain ? "on" : "off");
 
 	return 0;
 }
@@ -136,8 +437,32 @@ static int grgpio_probe(struct platform_device *ofdev)
 static int grgpio_remove(struct platform_device *ofdev)
 {
 	struct grgpio_priv *priv = platform_get_drvdata(ofdev);
+	unsigned long flags;
+	int i;
+	int ret = 0;
+
+	spin_lock_irqsave(&priv->bgc.lock, flags);
+
+	if (priv->domain) {
+		for (i = 0; i < GRGPIO_MAX_NGPIO; i++) {
+			if (priv->uirqs[i].refcnt != 0) {
+				ret = -EBUSY;
+				goto out;
+			}
+		}
+	}
+
+	ret = gpiochip_remove(&priv->bgc.gc);
+	if (ret)
+		goto out;
+
+	if (priv->domain)
+		irq_domain_remove(priv->domain);
+
+out:
+	spin_unlock_irqrestore(&priv->bgc.lock, flags);
 
-	return gpiochip_remove(&priv->bgc.gc);
+	return ret;
 }
 
 static struct of_device_id grgpio_match[] = {
-- 
1.7.10.4

