Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab3DQMhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 08:37:42 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:36271 "HELO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752878Ab3DQMhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 08:37:35 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: [PATCH v6 2/2] gpio: grgpio: Add irq support
Date: Wed, 17 Apr 2013 14:36:51 +0200
Message-Id: <1366202211-6743-3-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366202211-6743-1-git-send-email-andreas@gaisler.com>
References: <1366202211-6743-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers sets up an irq domain and hands out unique irqs to irq
capable gpio lines regardless of how underlying irq maps to gpio
lines. Any gpio line can map to any one or none of the irqs of the
core, independently of each other.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---

Changes since v5:
- register accesses via base + constant
- change multi line comment style
- no talk of "virtual" irq or virq
- better description of the situation with irqs and underlying irqs
- add missing lock in irq-handler
- add warning printout in irq-handler if no gpio line matches irq

 .../devicetree/bindings/gpio/gpio-grgpio.txt       |    5 +
 drivers/gpio/gpio-grgpio.c                         |  362 +++++++++++++++++++-
 2 files changed, 364 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt b/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
index 1ec46fd..e466598 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
@@ -17,5 +17,10 @@ Optional properties:
 
 - nbits : The number of gpio lines. If not present driver assumes 32 lines.
 
+- irqmap : An array with an index for each gpio line. An index is either a valid
+	index into the interrupts property array, or 0xffffffff that indicates
+	no irq for that line. Driver provides no interrupt support if not
+	present.
+
 For further information look in the documentation for the GLIB IP core library:
 http://www.gaisler.com/products/grlib/grip.pdf
diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index 466a1c7..8e08b86 100644
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
 
@@ -44,10 +47,49 @@
 #define GRGPIO_BYPASS		0x18
 #define GRGPIO_IMAP_BASE	0x20
 
+/* Structure for an irq of the core - called an underlying irq */
+struct grgpio_uirq {
+	u8 refcnt; /* Reference counter to manage requesting/freeing of uirq */
+	u8 uirq; /* Underlying irq of the gpio driver */
+};
+
+/*
+ * Structure for an irq of a gpio line handed out by this driver. The index is
+ * used to map to the corresponding underlying irq.
+ */
+struct grgpio_lirq {
+	s8 index; /* Index into struct grgpio_priv's uirqs, or -1 */
+	u8 irq; /* irq for the gpio line */
+};
+
 struct grgpio_priv {
 	struct bgpio_chip bgc;
 	void __iomem *regs;
 	struct device *dev;
+
+	u32 imask; /* irq mask shadow register */
+
+	/*
+	 * The grgpio core can have multiple "underlying" irqs. The gpio lines
+	 * can be mapped to any one or none of these underlying irqs
+	 * independently of each other. This driver sets up an irq domain and
+	 * hands out separate irqs to each gpio line
+	 */
+	struct irq_domain *domain;
+
+	/*
+	 * This array contains information on each underlying irq, each
+	 * irq of the grgpio core itself.
+	 */
+	struct grgpio_uirq uirqs[GRGPIO_MAX_NGPIO];
+
+	/*
+	 * This array contains information for each gpio line on the irqs
+	 * obtains from this driver. An index value of -1 for a certain gpio
+	 * line indicates that the line has no irq. Otherwise the index connects
+	 * the irq to the underlying irq by pointing into the uirqs array.
+	 */
+	struct grgpio_lirq lirqs[GRGPIO_MAX_NGPIO];
 };
 
 static inline struct grgpio_priv *grgpio_gc_to_priv(struct gpio_chip *gc)
@@ -57,6 +99,246 @@ static inline struct grgpio_priv *grgpio_gc_to_priv(struct gpio_chip *gc)
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
+	bgc->write_reg(priv->regs + GRGPIO_IMASK, priv->imask);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static int grgpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
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
+	ipol = priv->bgc.read_reg(priv->regs + GRGPIO_IPOL) & ~mask;
+	iedge = priv->bgc.read_reg(priv->regs + GRGPIO_IEDGE) & ~mask;
+
+	priv->bgc.write_reg(priv->regs + GRGPIO_IPOL, ipol | pol);
+	priv->bgc.write_reg(priv->regs + GRGPIO_IEDGE, iedge | edge);
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
+	unsigned long flags;
+	int i;
+	int match = 0;
+
+	spin_lock_irqsave(&priv->bgc.lock, flags);
+
+	/*
+	 * For each gpio line, call its interrupt handler if it its underlying
+	 * irq matches the current irq that is handled.
+	 */
+	for (i = 0; i < ngpio; i++) {
+		struct grgpio_lirq *lirq = &priv->lirqs[i];
+
+		if (priv->imask & BIT(i) && lirq->index >= 0 &&
+		    priv->uirqs[lirq->index].uirq == irq) {
+			generic_handle_irq(lirq->irq);
+			match = 1;
+		}
+	}
+
+	spin_unlock_irqrestore(&priv->bgc.lock, flags);
+
+	if (!match)
+		dev_warn(priv->dev, "No gpio line matched irq %d\n", irq);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * This function will be called as a consequence of the call to
+ * irq_create_mapping in grgpio_to_irq
+ */
+int grgpio_irq_map(struct irq_domain *d, unsigned int irq,
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
+	dev_dbg(priv->dev, "Mapping irq %d for gpio line %d\n",
+		irq, offset);
+
+	spin_lock_irqsave(&priv->bgc.lock, flags);
+
+	/* Request underlying irq if not already requested */
+	lirq->irq = irq;
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
+	/* Setup irq  */
+	irq_set_chip_data(irq, priv);
+	irq_set_chip_and_handler(irq, &grgpio_irq_chip,
+				 handle_simple_irq);
+	irq_clear_status_flags(irq, IRQ_NOREQUEST);
+#ifdef CONFIG_ARM
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	irq_set_noprobe(irq);
+#endif
+
+	return ret;
+}
+
+void grgpio_irq_unmap(struct irq_domain *d, unsigned int irq)
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
+	set_irq_flags(irq, 0);
+#endif
+	irq_set_chip_and_handler(irq, NULL, NULL);
+	irq_set_chip_data(irq, NULL);
+
+	spin_lock_irqsave(&priv->bgc.lock, flags);
+
+	/* Free underlying irq if last user unmapped */
+	index = -1;
+	for (i = 0; i < ngpio; i++) {
+		lirq = &priv->lirqs[i];
+		if (lirq->irq == irq) {
+			grgpio_set_imask(priv, i, 0);
+			lirq->irq = 0;
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
+}
+
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
@@ -67,6 +349,9 @@ static int grgpio_probe(struct platform_device *ofdev)
 	struct resource *res;
 	int err;
 	u32 prop;
+	s32 *irqmap;
+	int size;
+	int i;
 
 	priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -87,11 +372,13 @@ static int grgpio_probe(struct platform_device *ofdev)
 	}
 
 	priv->regs = regs;
+	priv->imask = bgc->read_reg(regs + GRGPIO_IMASK);
 	priv->dev = &ofdev->dev;
 
 	gc = &bgc->gc;
 	gc->of_node = np;
 	gc->owner = THIS_MODULE;
+	gc->to_irq = grgpio_to_irq;
 	gc->label = np->full_name;
 	gc->base = -1;
 
@@ -104,6 +391,51 @@ static int grgpio_probe(struct platform_device *ofdev)
 		gc->ngpio = prop;
 	}
 
+	/*
+	 * The irqmap contains the index values indicating which underlying irq,
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
+				/*
+				 * Continue without irq functionality for that
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
@@ -112,8 +444,8 @@ static int grgpio_probe(struct platform_device *ofdev)
 		return err;
 	}
 
-	dev_info(&ofdev->dev, "regs=0x%p, base=%d, ngpio=%d\n",
-		 priv->regs, gc->base, gc->ngpio);
+	dev_info(&ofdev->dev, "regs=0x%p, base=%d, ngpio=%d, irqs=%s\n",
+		 priv->regs, gc->base, gc->ngpio, priv->domain ? "on" : "off");
 
 	return 0;
 }
@@ -121,8 +453,32 @@ static int grgpio_probe(struct platform_device *ofdev)
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

