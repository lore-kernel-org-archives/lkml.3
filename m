Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaLHWpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:45:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:40368 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751030AbaLHWpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:45:06 -0500
Date: Mon, 8 Dec 2014 23:41:37 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: vishnupatekar <vishnupatekar0510@gmail.com>
Cc: linux-sunxi@googlegroups.com, dmitry.torokhov@gmail.com,
        linux@arm.linux.org.uk, leafy.myeh@newbietech.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2 2/3] sunxi:drivers:input:ps2 Added sunxi A10/A20 ps2
 driver
Message-ID: <20141208224137.GO8739@lukather>
References: <1417907719-26775-1-git-send-email-VishnuPatekar0510@gmail.com>
 <1417907719-26775-3-git-send-email-VishnuPatekar0510@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hXth9cGL35Nvpk4x"
Content-Disposition: inline
In-Reply-To: <1417907719-26775-3-git-send-email-VishnuPatekar0510@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hXth9cGL35Nvpk4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Dec 07, 2014 at 04:45:18AM +0530, vishnupatekar wrote:
>  -added compatible as allwinner,sun4i-a10-ps2 and allwinner,sun7i-a20-ps2.
>  - added default n depends on ARCH_SUNXI || COMPILE_TEST
>  in Kconfig.
>  -handled errors and free resources on errors.
>  -used BIT(x), DIV_ROUND_UP macros.
>  -corrected style errors.

The changelog should be either in your cover letter or just above the
diffstat, but not in your commitlog.

This should have a real commit log, telling what you're doing, why,
and how.

> Signed-off-by: vishnupatekar <VishnuPatekar0510@gmail.com>
> ---
>  drivers/input/serio/Kconfig     |   10 ++
>  drivers/input/serio/Makefile    |    1 +
>  drivers/input/serio/sunxi-ps2.c |  364 +++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 375 insertions(+)
>  create mode 100644 drivers/input/serio/sunxi-ps2.c
>=20
> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> index bc2d474..3a7599c 100644
> --- a/drivers/input/serio/Kconfig
> +++ b/drivers/input/serio/Kconfig
> @@ -281,4 +281,14 @@ config HYPERV_KEYBOARD
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called hyperv_keyboard.
> =20
> +config SERIO_SUNXI_PS2
> +	tristate "Allwinner Sun4i-A10/Sun7i-A20 PS/2 controller"

Allwinner A10 is enough

> +	default n

This is the default.

> +	depends on ARCH_SUNXI || COMPILE_TEST
> +	help
> +	  Say Y here if you have Sun4i-A10/Sun7i-A20 Allwinner PS/2 ports.

You can just mention Allwinne A10 here, on sun4i, at your convenience.

> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called sunxi-ps2.
> +
>  endif
> diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
> index 815d874..0fa0f78 100644
> --- a/drivers/input/serio/Makefile
> +++ b/drivers/input/serio/Makefile
> @@ -29,3 +29,4 @@ obj-$(CONFIG_SERIO_ARC_PS2)	+=3D arc_ps2.o
>  obj-$(CONFIG_SERIO_APBPS2)	+=3D apbps2.o
>  obj-$(CONFIG_SERIO_OLPC_APSP)	+=3D olpc_apsp.o
>  obj-$(CONFIG_HYPERV_KEYBOARD)	+=3D hyperv-keyboard.o
> +obj-$(CONFIG_SERIO_SUNXI_PS2)	+=3D sunxi-ps2.o
> diff --git a/drivers/input/serio/sunxi-ps2.c b/drivers/input/serio/sunxi-=
ps2.c
> new file mode 100644
> index 0000000..4cd89ae
> --- /dev/null
> +++ b/drivers/input/serio/sunxi-ps2.c

Please call it sun4i-ps2, just in case we have another one coming at
some point.

> @@ -0,0 +1,364 @@
> +/*
> + *	Driver for Allwinner A20 PS2 host controller

s/A20/A10/ ?

> + *	Author: Vishnu Patekar <vishnupatekar0510@gmail.com>
> + *		Aaron.maoye <leafy.myeh@newbietech.com>
> + *
> + *		Based on 3.0 kernel

Please mention that it is Allwinner's kernel driver you're talking
about.

> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/serio.h>
> +#include <linux/interrupt.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/list.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +
> +#define DRIVER_NAME		"sunxi-ps2"
> +
> +/* register offset definitions */
> +#define PS2_REG_GCTL		(0x00)	/*  PS2 Module Global Control Reg */
> +#define PS2_REG_DATA		(0x04)  /*  PS2 Module Data Reg		*/
> +#define PS2_REG_LCTL		(0x08)	/*  PS2 Module Line Control Reg */
> +#define PS2_REG_LSTS		(0x0C)  /*  PS2 Module Line Status Reg	*/
> +#define PS2_REG_FCTL		(0x10)	/*  PS2 Module FIFO Control Reg */
> +#define PS2_REG_FSTS		(0x14)	/*  PS2 Module FIFO Status Reg	*/
> +#define PS2_REG_CLKDR		(0x18)	/*  PS2 Module Clock Divider Reg*/
> +
> +/*  PS2 GLOBAL CONTROL REGISTER PS2_GCTL */
> +#define PS2_GCTL_INTFLAG	BIT(4)
> +#define PS2_GCTL_INTEN		BIT(3)
> +#define PS2_GCTL_RESET		BIT(2)
> +#define PS2_GCTL_MASTER		BIT(1)
> +#define PS2_GCTL_BUSEN		BIT(0)
> +
> +/* PS2 LINE CONTROL REGISTER */
> +#define PS2_LCTL_NOACK		BIT(18)
> +#define PS2_LCTL_TXDTOEN	BIT(8)
> +#define PS2_LCTL_STOPERREN	BIT(3)
> +#define PS2_LCTL_ACKERREN	BIT(2)
> +#define PS2_LCTL_PARERREN	BIT(1)
> +#define PS2_LCTL_RXDTOEN	BIT(0)
> +
> +/* PS2 LINE STATUS REGISTER */
> +#define PS2_LSTS_TXTDO		BIT(8)
> +#define PS2_LSTS_STOPERR	BIT(3)
> +#define PS2_LSTS_ACKERR		BIT(2)
> +#define PS2_LSTS_PARERR		BIT(1)
> +#define PS2_LSTS_RXTDO		BIT(0)
> +
> +/* PS2 FIFO CONTROL REGISTER */
> +#define PS2_FCTL_TXRST		BIT(17)
> +#define PS2_FCTL_RXRST		BIT(16)
> +#define PS2_FCTL_TXUFIEN	BIT(10)
> +#define PS2_FCTL_TXOFIEN	BIT(9)
> +#define PS2_FCTL_TXRDYIEN	BIT(8)
> +#define PS2_FCTL_RXUFIEN	BIT(2)
> +#define PS2_FCTL_RXOFIEN	BIT(1)
> +#define PS2_FCTL_RXRDYIEN	BIT(0)
> +
> +/* PS2 FIFO STATUS REGISTER */
> +#define PS2_FSTS_TXUF		BIT(10)
> +#define PS2_FSTS_TXOF		BIT(9)
> +#define PS2_FSTS_TXRDY		BIT(8)
> +#define PS2_FSTS_RXUF		BIT(2)
> +#define PS2_FSTS_RXOF		BIT(1)
> +#define PS2_FSTS_RXRDY		BIT(0)

Please define the bits right below the register they belong too, not
separated.

> +#define PS2_LINE_ERROR_BIT \
> +	(PS2_LSTS_TXTDO|PS2_LSTS_STOPERR|PS2_LSTS_ACKERR| \
> +	PS2_LSTS_PARERR|PS2_LSTS_RXTDO)
> +
> +#define PS2_FIFO_ERROR_BIT \
> +	(PS2_FSTS_TXUF|PS2_FSTS_TXOF|PS2_FSTS_TXRDY|PS2_FSTS_RXUF| \
> +	PS2_FSTS_RXOF|PS2_FSTS_RXRDY)

Spaces around the operators.

> +
> +#define PS2_SAMPLE_CLK		(1000000)
> +#define PS2_SCLK		(125000)
> +
> +struct sunxips2data {
> +	struct serio *serio;
> +	struct device *dev;
> +
> +	/* IO mapping base */
> +	void __iomem	*reg_base;
> +
> +	/* clock management */
> +	struct clk	*clk;
> +
> +	/* irq */
> +	spinlock_t	lock;
> +	int		irq;
> +};
> +
> +/*********************/
> +/* Interrupt handler */
> +/*********************/
> +static irqreturn_t sunxips2_interrupt(int irq, void *dev_id)

s/sunxips2/sun4i_ps2/ please.

> +{
> +	struct sunxips2data *drvdata =3D dev_id;
> +	u32 intr_status;
> +	u32 fifo_status;
> +	unsigned char byte;
> +	u32 rval;
> +	u32 error =3D 0;
> +
> +	spin_lock(&drvdata->lock);
> +
> +	/* Get the PS/2 interrupts and clear them */
> +	intr_status  =3D readl(drvdata->reg_base + PS2_REG_LSTS);
> +	fifo_status  =3D readl(drvdata->reg_base + PS2_REG_FSTS);
> +
> +	/*Check Line Status Register*/
> +	if (intr_status & 0x10f) {
> +		if (intr_status & PS2_LSTS_STOPERR)
> +			dev_info(drvdata->dev, "PS/2 Stop Bit Error!");
> +		if (intr_status & PS2_LSTS_ACKERR)
> +			dev_info(drvdata->dev, "PS/2 Acknowledge Error!\n");
> +		if (intr_status & PS2_LSTS_PARERR)
> +			dev_info(drvdata->dev, "PS/2 Parity Error!\n");
> +		if (intr_status & PS2_LSTS_TXTDO)
> +			dev_info(drvdata->dev, "PS/2 Transmit Data Timeout!\n");
> +		if (intr_status & PS2_LSTS_RXTDO)
> +			dev_info(drvdata->dev, "PS/2 Receive Data Timeout!\n");
> +
> +		/*reset PS/2 controller*/
> +		writel(readl(drvdata->reg_base + PS2_REG_GCTL) | PS2_GCTL_RESET,
> +			drvdata->reg_base + PS2_REG_GCTL);

It's usually better to have it as two lines: one for the read, one for
the write.

> +
> +		rval =3D PS2_LSTS_TXTDO | PS2_LSTS_STOPERR | PS2_LSTS_ACKERR |
> +			PS2_LSTS_PARERR | PS2_LSTS_RXTDO;
> +		writel(rval, drvdata->reg_base + PS2_REG_LSTS);
> +		error =3D 1;
> +	}
> +
> +	/*Check FIFO Status Register*/
> +	if (fifo_status & 0x0606) {
> +		if (fifo_status & PS2_FSTS_TXUF)
> +			dev_info(drvdata->dev, "PS/2 Tx FIFO Underflow!\n");
> +		if (fifo_status & PS2_FSTS_TXOF)
> +			dev_info(drvdata->dev, "PS/2 Tx FIFO Overflow!\n");
> +		if (fifo_status & PS2_FSTS_RXUF)
> +			dev_info(drvdata->dev, "PS/2 Rx FIFO Underflow!\n");
> +		if (fifo_status & PS2_FSTS_RXOF)
> +			dev_info(drvdata->dev, "PS/2 Rx FIFO Overflow!\n");
> +		/*reset PS/2 controller*/
> +		writel(readl(drvdata->reg_base + PS2_REG_GCTL) | PS2_GCTL_RESET,
> +			drvdata->reg_base + PS2_REG_GCTL);

Ditto.

> +		rval =3D PS2_FSTS_TXUF | PS2_FSTS_TXOF | PS2_FSTS_TXRDY |
> +			PS2_FSTS_RXUF | PS2_FSTS_RXOF | PS2_FSTS_RXRDY;
> +		writel(rval, drvdata->reg_base + PS2_REG_FSTS);
> +		error =3D 1;
> +	}
> +
> +	rval =3D (fifo_status >> 16) & 0x3;
> +	while (!error && rval--) {
> +		byte =3D readl(drvdata->reg_base + PS2_REG_DATA) & 0xff;
> +		/* dev_info(drvdata->dev, "PS/2 Receive %02x\n", byte); */

Remove that line.

> +		serio_interrupt(drvdata->serio, byte, 0);
> +	}
> +
> +	writel(intr_status, drvdata->reg_base + PS2_REG_LSTS);
> +	writel(fifo_status, drvdata->reg_base + PS2_REG_FSTS);
> +
> +	spin_unlock(&drvdata->lock);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +
> +static int sunxips2_open(struct serio *pserio)
> +{
> +	struct sunxips2data *drvdata =3D pserio->port_data;
> +	u32 src_clk =3D 0;
> +	u32 clk_scdf;
> +	u32 clk_pcdf;
> +	u32 rval;
> +
> +	/*Set Line Control And Enable Interrupt*/
> +	rval =3D PS2_LCTL_TXDTOEN | PS2_LCTL_STOPERREN | PS2_LCTL_ACKERREN
> +		| PS2_LCTL_PARERREN | PS2_LCTL_RXDTOEN;
> +	writel(rval, drvdata->reg_base + PS2_REG_LCTL);
> +
> +	/*Reset FIFO*/
> +	rval =3D PS2_FCTL_TXRST|PS2_FCTL_RXRST|PS2_FCTL_TXUFIEN|PS2_FCTL_TXOFIEN
> +		|PS2_FCTL_RXUFIEN|PS2_FCTL_RXOFIEN|PS2_FCTL_RXRDYIEN;
> +	writel(rval, drvdata->reg_base + PS2_REG_FCTL);
> +
> +	src_clk =3D clk_get_rate(drvdata->clk);
> +
> +	if (!src_clk) {
> +		dev_info(drvdata->dev, "w_ps2c_set_sclk error, source clock is 0.");
> +		return -1;
> +	}
> +
> +	/*Set Clock Divider Register*/
> +	clk_scdf =3D DIV_ROUND_UP(src_clk, PS2_SAMPLE_CLK) - 1;
> +	clk_pcdf =3D DIV_ROUND_UP(PS2_SAMPLE_CLK, PS2_SCLK) - 1;

So this is actually a rounding down?

Why not just using src_clk / PS2_SAMPLE_CLK directly?

> +	rval =3D (clk_scdf<<8) | clk_pcdf;

Spaces between the operators. Remember, run checkpatch.

> +	writel(rval, drvdata->reg_base + PS2_REG_CLKDR);
> +
> +	/*Set Global Control Register*/
> +	rval =3D PS2_GCTL_RESET | PS2_GCTL_INTEN | PS2_GCTL_MASTER
> +		| PS2_GCTL_BUSEN;
> +	writel(rval, drvdata->reg_base + PS2_REG_GCTL);

You seem to be reading/writing from the same registers than in your
interrupt handler, don't you need some locking in here?

> +
> +	return 0;
> +}
> +
> +static void sunxips2_close(struct serio *pserio)
> +{
> +	struct sunxips2data *drvdata =3D pserio->port_data;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&drvdata->lock, flags);
> +	/* Disable the PS2 interrupts */
> +	writel(0, drvdata->reg_base + PS2_REG_GCTL);
> +	spin_unlock_irqrestore(&drvdata->lock, flags);
> +}
> +
> +static int sunxips2_write(struct serio *pserio, unsigned char val)
> +{
> +	unsigned long expire =3D jiffies + msecs_to_jiffies(10000);
> +	struct sunxips2data *drvdata =3D (struct sunxips2data *)pserio->port_da=
ta;
> +
> +	do {
> +		if (readl(drvdata->reg_base + PS2_REG_FSTS) & PS2_FSTS_TXRDY) {
> +			writel(val, drvdata->reg_base + PS2_REG_DATA);
> +			return 0;
> +		}
> +	} while (time_before(jiffies, expire));
> +
> +	return 0;
> +}
> +
> +static int sunxips2_probe(struct platform_device *pdev)
> +{
> +	struct resource *res; /* IO mem resources */
> +	struct sunxips2data *drvdata;
> +	struct serio *serio;
> +	struct device *dev =3D &pdev->dev;
> +	unsigned int irq;
> +	int error;
> +
> +	drvdata =3D devm_kzalloc(dev, sizeof(struct sunxips2data), GFP_KERNEL);
> +	serio =3D kzalloc(sizeof(struct serio), GFP_KERNEL);
> +	if (!drvdata || !serio) {
> +		error =3D -ENOMEM;
> +		goto err_free_mem;
> +	}
> +
> +	spin_lock_init(&drvdata->lock);
> +
> +	/* IO */
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	drvdata->reg_base =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(drvdata->reg_base)) {
> +		dev_err(dev, "failed to map registers\n");
> +		error =3D PTR_ERR(drvdata->reg_base);
> +		goto err_free_mem;
> +	}
> +
> +	drvdata->clk =3D devm_clk_get(dev, NULL);
> +	if (!IS_ERR(drvdata->clk)) {
> +		error =3D clk_prepare_enable(drvdata->clk);
> +		if (error < 0) {
> +			dev_err(dev, "failed to enable clock %d\n", error);
> +			goto err_free_mem;
> +		}
> +	} else {
> +		error =3D PTR_ERR(drvdata->clk);
> +		dev_err(dev, "couldn't get clock %d\n", error);
> +		goto err_free_mem;
> +	}

That would be better if you had something like

clk_get()
if (IS_ERR())
  goto

clk_prepare_enable()
if (IS_ERR())

Especially since you're using that kind of construct in the rest of
your function.

> +	serio->id.type =3D SERIO_8042;
> +	serio->write =3D sunxips2_write;
> +	serio->open =3D sunxips2_open;
> +	serio->close =3D sunxips2_close;
> +	serio->port_data =3D drvdata;
> +	serio->dev.parent =3D dev;
> +	strlcpy(serio->name, dev_name(dev), sizeof(serio->name));
> +	strlcpy(serio->phys, dev_name(dev), sizeof(serio->phys));
> +
> +	/* Get IRQ for the device */
> +	irq =3D platform_get_irq(pdev, 0);
> +	if (!irq) {
> +		dev_err(dev, "no IRQ found\n");
> +		error =3D -ENXIO;
> +		goto error_disable_clk;
> +	}
> +
> +	drvdata->irq =3D irq;
> +	drvdata->serio =3D serio;
> +	drvdata->dev =3D dev;
> +	error =3D devm_request_threaded_irq(dev, drvdata->irq,
> +		sunxips2_interrupt, NULL, 0, DRIVER_NAME, drvdata);

This really looks like a case for a regular request_irq.

> +	if (error) {
> +		dev_err(drvdata->dev, "Interrupt alloc failed %d:error:%d\n",
> +			drvdata->irq, error);
> +		goto error_disable_clk;
> +	}
> +
> +	serio_register_port(serio);
> +	platform_set_drvdata(pdev, drvdata);
> +
> +	return 0;	/* success */
> +
> +error_disable_clk:
> +	clk_disable_unprepare(drvdata->clk);
> +
> +err_free_mem:
> +	kfree(serio);
> +	return error;
> +}
> +
> +static int sunxips2_remove(struct platform_device *pdev)
> +{
> +	struct sunxips2data *drvdata =3D platform_get_drvdata(pdev);
> +
> +	serio_unregister_port(drvdata->serio);
> +	disable_irq(drvdata->irq);
> +
> +	if (!IS_ERR(drvdata->clk))
> +		clk_disable_unprepare(drvdata->clk);

And you can drop that if.

> +	kfree(drvdata->serio);
> +
> +	return 0;
> +}
> +
> +/* Match table for of_platform binding */
> +static const struct of_device_id sunxips2_of_match[] =3D {
> +	{ .compatible =3D "allwinner,sun7i-a20-ps2", },
> +	{ .compatible =3D "allwinner,sun4i-a10-ps2", },

If the two really are compatible, you just need one of them, the A10
one in that case, since that's the earlier SoCs.

> +	{ },
> +};
> +
> +MODULE_DEVICE_TABLE(of, sunxips2_of_match);
> +
> +/*platform driver structure*/
> +static struct platform_driver sunxips2_of_driver =3D {
> +	.probe		=3D sunxips2_probe,
> +	.remove		=3D sunxips2_remove,
> +	.driver =3D {
> +		.name =3D DRIVER_NAME,
> +		.of_match_table =3D sunxips2_of_match,
> +	},
> +};
> +module_platform_driver(sunxips2_of_driver);
> +
> +MODULE_AUTHOR("Vishnu Patekar <vishnupatekar0510@gmail.com>");
> +MODULE_AUTHOR("Aaron.maoye <leafy.myeh@newbietech.com>");
> +MODULE_DESCRIPTION("Sunxi PS/2 driver");
> +MODULE_LICENSE("GPL");
> --=20
> 1.7.9.5
>=20

It's looking great otherwise.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--hXth9cGL35Nvpk4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUhikhAAoJEBx+YmzsjxAghP4QAIRMDDhKJ7cleI/AY5dc/DDJ
j8Ng/o/3wn6qGN0BLDnN9JCJUQSRUV1gvqadCGXG12eGEM0VzDIjDrX2zP7eMMQ7
M0S2z4DNeVt1AWZT9smD9E+xAVTCRyCg9q9lLbf6ABV1zOYdIhH7NCGF8qXihJyV
nd5jp40Xn+24pqPwKGDg/R93bPzcZVZJqh949kofD1G/M3tJ9/syslGbJRyWtSsr
h6yr80ONSYiLf/mz6CSAfavgmU3sODrPYrJAwNFmaHVWSSVUIuUFYntnlC93Bqek
KF6+LU0aRSSG4Skq7fq2KujoWUHOopNHQurdgFKJqXjLSrZ/heYVO4l4pmVzF88P
77eWpvsWnwqJwFe3nPye3favyACdb8xmvrG3CTw7mG0mRrRTVPtFiLOYbc3O+6rn
6wfGL/IyFVfeWjIBQdGMIybuvT6oS31JPfBl+9mR/uKNHnWV7Ey0sVxsnmoJYW8s
/8e9gyXcg2RT0fAL4QMfYvrQTsfhmpZiKnGhmvz8WleIcsywmcsK/Blm5pNPQ7+v
zbRE7OigQ51nuQCXDvj+rU6Wp3kVit1uJO3sHtGfSZ5yFzRXDe1xkGLO6EebN/mN
FcYPggLq4J3QIoouDLaEw362LIdZUpvjsYsXlrN/sBC2/exq1I4b5zhFQT8XFEww
VUMM4VT2iinIV66ChxBr
=2VKs
-----END PGP SIGNATURE-----

--hXth9cGL35Nvpk4x--
