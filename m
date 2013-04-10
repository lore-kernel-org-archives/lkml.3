Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3DJSuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:50:22 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45232 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3DJSuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:50:20 -0400
MIME-Version: 1.0
In-Reply-To: <1363355140-28216-3-git-send-email-andreas@gaisler.com>
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
	<1363355140-28216-3-git-send-email-andreas@gaisler.com>
Date: Wed, 10 Apr 2013 20:50:19 +0200
Message-ID: <CACRpkdYf7U=YY92Pma8+mWGALJvQDPU=d3x7Z6rX+rWkhuBANg@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] gpio: grgpio: Add device driver for GRGPIO cores
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 2:45 PM, Andreas Larsson <andreas@gaisler.com> wrote:

> This driver supports GRGPIO gpio cores available in the GRLIB VHDL IP
> core library from Aeroflex Gaisler.
>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> ---
>  .../devicetree/bindings/gpio/gpio-grgpio.txt       |   24 +++
>  drivers/gpio/Kconfig                               |    9 ++
>  drivers/gpio/Makefile                              |    1 +
>  drivers/gpio/gpio-grgpio.c                         |  164 ++++++++++++++++++++
>  4 files changed, 198 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
>  create mode 100644 drivers/gpio/gpio-grgpio.c
>
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt b/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
> new file mode 100644
> index 0000000..1050dc8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
> @@ -0,0 +1,24 @@
> +Aeroflex Gaisler GRGPIO General Purpose I/O cores.
> +
> +The GRGPIO GPIO core is available in the GRLIB VHDL IP core library.
> +
> +Note: In the ordinary environment for the GRGPIO core, a Leon SPARC system,
> +these properties are built from information in the AMBA plug&play.
> +
> +Required properties:
> +
> +- name : Should be "GAISLER_GPIO" or "01_01a"

What is this? Don't we usually use a .compatible string for this?
Name? Que? Is that something legacy?

I would prefer:

- Add you vendor prefix to Documentation/devicetree/bindings/vendor-prefixes.txt
- Use a compatible string like this "gaisler,gpio"

> +- reg : Address and length of the register set for the device
> +
> +- interrupts : Interrupt numbers for this device
> +
> +Optional properties:
> +
> +- base : The base gpio number for the core. A dynamic base is used if not
> +       present

This has to go. We don't hardcode numbers from the global GPIO
space into the device tree, beacause as you soon realize this is
Linux-specific and the device tree shall be OS agnostic.

The discussion has come up a number of times, review the mailing
lists for suggestions on how to get around this.

(...)
> +++ b/drivers/gpio/gpio-grgpio.c

> +struct grgpio_regs {
> +       u32 data;       /* 0x00 */
> +       u32 output;     /* 0x04 */
> +       u32 dir;        /* 0x08 */
> +       u32 imask;      /* 0x0c */
> +       u32 ipol;       /* 0x10  */
> +       u32 iedge;      /* 0x14 */
> +       u32 bypass;     /* 0x18 */
> +       u32 __reserved; /* 0x1c */
> +       u32 imap[8];    /* 0x20-0x3c */
> +};

Um... Why are you doing this?

> +struct grgpio_priv {
> +       struct bgpio_chip bgc;
> +       struct grgpio_regs __iomem *regs;

And that's tagged as __iomem * as well, that is very unorthodox.
The usual practice is to have a base pointer void __iomem *base
and offset from that.

> +       struct device *dev;
> +};
> +
> +static inline struct grgpio_priv *grgpio_gc_to_priv(struct gpio_chip *gc)
> +{
> +       struct bgpio_chip *bgc = to_bgpio_chip(gc);
> +
> +       return container_of(bgc, struct grgpio_priv, bgc);
> +}
> +
> +static int grgpio_to_irq(struct gpio_chip *gc, unsigned offset)
> +{
> +       return -ENXIO;
> +}

The gpiolib core already returns -ENXIO if this function is
not assigned so just delete this function and leave that
function pointer as NULL.

> +static int grgpio_probe(struct platform_device *ofdev)
> +{
> +       struct device_node *np = ofdev->dev.of_node;
> +       struct grgpio_regs __iomem *regs;

Prefer void __iomem *base;

> +       struct gpio_chip *gc;
> +       struct bgpio_chip *bgc;
> +       struct grgpio_priv *priv;
> +       struct resource *res;
> +       int err;
> +       u32 prop;
> +
> +       priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
> +       if (!priv)
> +               return -ENOMEM;
> +
> +       res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
> +       regs = devm_ioremap_resource(&ofdev->dev, res);
> +       if (IS_ERR(regs))
> +               return PTR_ERR(regs);
> +
> +       bgc = &priv->bgc;
> +       err = bgpio_init(bgc, &ofdev->dev, 4, &regs->data, &regs->output, NULL,
> +                        &regs->dir, NULL, BGPIOF_BIG_ENDIAN_BYTE_ORDER);

So I would prefer if you did:

#define GRGPIO_DATA 0x00
#define GRGPIO_OUTPUT 0x04
#define GRGPIO_DIR 0x08
(...)

err = bgpio_init(bgc, &ofdev->dev, 4, base + GRGPIO_DATA, base +
GRGPIO_OUTPUT, NULL,
                       base + GRGPIO_DIR, NULL, BGPIOF_BIG_ENDIAN_BYTE_ORDER);

> +       if (err) {
> +               dev_err(&ofdev->dev, "bgpio_init() failed\n");
> +               return err;
> +       }
> +
> +       priv->regs = regs;
> +       priv->dev = &ofdev->dev;
> +
> +       gc = &bgc->gc;
> +       gc->of_node = np;
> +       gc->owner = THIS_MODULE;
> +       gc->to_irq = grgpio_to_irq;
> +       gc->label = np->full_name;
> +
> +       err = of_property_read_u32(np, "base", &prop);
> +       if (err) {
> +               dev_dbg(&ofdev->dev, "No base property: use dynamic base\n");
> +               gc->base = -1;
> +       } else {
> +               gc->base = prop;
> +       }

Over my dead body ;-)

(...)
> +static struct of_device_id grgpio_match[] = {
> +       {.name = "GAISLER_GPIO"},
> +       {.name = "01_01a"},
> +       {},
> +};

This is very weird. Especially "01_01a" needs a real good explanation
if it is to be kept.

Alas, I don't really know what the .name field in the of_device_id is for...

Yours,
Linus Walleij
