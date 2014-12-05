Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaLEKFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:05:18 -0500
Received: from down.free-electrons.com ([37.187.137.238]:53041 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752781AbaLEKFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:05:14 -0500
Date: Fri, 5 Dec 2014 11:01:51 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: vishnupatekar <vishnupatekar0510@gmail.com>
Cc: linux-sunxi@googlegroups.com, robh+dt@kernel.org, benh@kernel.crashing.org,
        msalter@redhat.com, ralf@linux-mips.org, jdelvare@suse.de,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH 2/3] drivers:input:ps2 Added sunxi A20 ps2 driver,
 changed makefile and Kconfig
Message-ID: <20141205100151.GT30256@lukather>
References: <1417647224-27950-1-git-send-email-VishnuPatekar0510@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FT/vNgDLxVq4t/AU"
Content-Disposition: inline
In-Reply-To: <1417647224-27950-1-git-send-email-VishnuPatekar0510@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FT/vNgDLxVq4t/AU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for working on this.

First, make sure to read Documentation/SubmittingPatches. The
guidelines in there might seem tedious, but it's there to enforce that
we keep the kernel homogenous.

Most notably, you should make sure that:
  - you run scripts/checkpatch.pl on your patches
  - you have a commit log
  - your commit title stays below 80 chars
  - you have a Signed-off-by in your commit log

On Thu, Dec 04, 2014 at 04:23:44AM +0530, vishnupatekar wrote:
> ---
>  drivers/input/serio/Kconfig     |    9 ++
>  drivers/input/serio/Makefile    |    1 +
>  drivers/input/serio/sunxi-ps2.c |  305 +++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 315 insertions(+)
>  create mode 100644 drivers/input/serio/sunxi-ps2.c
>=20
> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> index bc2d474..1a86e41 100644
> --- a/drivers/input/serio/Kconfig
> +++ b/drivers/input/serio/Kconfig
> @@ -281,4 +281,13 @@ config HYPERV_KEYBOARD
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called hyperv_keyboard.
> =20
> +config SERIO_SUNXI_PS2
> +	tristate "Allwinner Sun7i-A20 PS/2 controller"
> +	default m
> +	help
> +	  Say Y here if you have Sun7i-A20 Allwinner PS/2 ports.
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
> index 0000000..ccd7b29
> --- /dev/null
> +++ b/drivers/input/serio/sunxi-ps2.c
> @@ -0,0 +1,305 @@
> +/*
> + * sunxi-ps2.c Support for Allwinner A20 PS2 host controller
> + *
> + * Author: Aaron.maoye <leafy.myeh@newbietech.com>
> + *	   Vishnu Patekar <vishnupatekar0510@gmail.com>
> + * Based on sunxi-ps2.c 3.0 kernel

Mentionning that it's Allwinner's 3.0 kernel would be good, it doesn't
make much sense otherwise.

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
> +#define RESSIZE(res)        (((res)->end - (res)->start)+1)
> +
> +#define SW_PS2_GCTRL        (0x00)
> +#define SW_PS2_DATA         (0x04)
> +#define SW_PS2_LCTRL        (0x08)
> +#define SW_PS2_LSTAT        (0x0c)
> +#define SW_PS2_FCTRL        (0x10)
> +#define SW_PS2_FSTAT        (0x14)
> +#define SW_PS2_CLKDR        (0x18)

The SW_ prefix is a left over from Allwinner I suppose?

Using a prefix like sun4i_ps2/sun7i_ps2 depending on the outcome of
the discussion you had with Hans would seem better, across all your
driver.

> +
> +/* SW_PS2_GCTRL */
> +#define SWPS2_BUSEN         (1 << 0)
> +#define SWPS2_MASTER        (1 << 1)
> +#define SWPS2_RESET         (1 << 2)
> +#define SWPS2_INTEN         (1 << 3)

We usually have the convention of having the register name mentionned
in the bits offsets, and the bits declared right after their register.

Something like:

#define SUN4I_PS2_GCTRL_REG	0x00
#define SUN4I_PS2_GCTRL_BUS_EN		BIT(0)

#define SUN4I_PS2_LCTRL_REG	0x08
#define SUN4I_PS2_LCTRL_PAR_ERR_EN	BIT(1)

etc....

> +#define SWPS2_INTFLAG       (1 << 3)

This is defined to the same value than _INTEN, is this intentionnal?

> +
> +/* SW_PS2_LCTRL */
> +#define SWPS2_LCTL_NOACK        (0x0 << 18)
> +#define SWPS2_LCTL_TXDTOEN      (0x1 << 8)
> +#define SWPS2_LCTL_STOPERREN    (0x1 << 3)
> +#define SWPS2_LCTL_ACKERREN     (0x1 << 2)
> +#define SWPS2_LCTL_PARERREN     (0x1 << 1)
> +#define SWPS2_LCTL_RXDTOEN      (0x1 << 0)
> +
> +/* SW_PS2_FSTAT */
> +#define SWPS2_FSTA_RXRDY        (1 << 0)
> +#define SWPS2_FSTA_RXOF         (1 << 1)
> +#define SWPS2_FSTA_RXUF         (1 << 2)
> +#define SWPS2_FSTA_TXRDY        (1 << 8)
> +#define SWPS2_FSTA_TXOF         (1 << 9)
> +#define SWPS2_FSTA_TXUF         (1 << 10)
> +
> +#define SW_PS2_SAMPLE_CLK      (1000000)
> +#define SW_PS2_SCLK            (125000)
> +
> +struct sunxips2data {
> +	int irq;
> +	spinlock_t ps2_lock;
> +	void __iomem *base_address;	/* virt address of control registers*/
> +	struct serio *serio;		/* serio*/
> +	struct device *dev;
> +	struct	clk	*pclk;
> +};
> +
> +/*********************/
> +/* Interrupt handler */
> +/*********************/
> +static irqreturn_t sunxips2_interrupt(int irq, void *dev_id)
> +{
> +	struct sunxips2data *drvdata =3D dev_id;
> +	u32 intr_status;
> +	u32 fifo_status;
> +	unsigned char byte;
> +	u32 rval;
> +	u32 error =3D 0;
> +
> +	spin_lock(&drvdata->ps2_lock);
> +
> +	/* Get the PS/2 interrupts and clear them */
> +	intr_status  =3D readl(drvdata->base_address + SW_PS2_LSTAT);
> +	fifo_status  =3D readl(drvdata->base_address + SW_PS2_FSTAT);
> +
> +	/*Check Line Status Register*/
> +	if (intr_status & 0x10f) {
> +		if (intr_status & 0x08)
> +			dev_info(drvdata->dev, "PS/2 Stop Bit Error!");
> +		if (intr_status & 0x04)
> +			dev_info(drvdata->dev, "PS/2 Acknowledge Error!\n");
> +		if (intr_status & 0x02)
> +			dev_info(drvdata->dev, "PS/2 Parity Error!\n");
> +		if (intr_status & 0x100)
> +			dev_info(drvdata->dev, "PS/2 Transmit Data Timeout!\n");
> +		if (intr_status & 0x01)
> +			dev_info(drvdata->dev, "PS/2 Receive Data Timeout!\n");
> +
> +		writel(readl(drvdata->base_address + SW_PS2_GCTRL)|0x4, drvdata->base_=
address + SW_PS2_GCTRL);/*reset PS/2 controller*/
> +		writel(0x10f, drvdata->base_address + SW_PS2_LSTAT);
> +
> +		error =3D 1;
> +	}
> +
> +    /*Check FIFO Status Register*/
> +	if (fifo_status & 0x0606) {
> +		if (fifo_status & 0x400)
> +			dev_info(drvdata->dev, "PS/2 Tx FIFO Underflow!\n");
> +		if (fifo_status & 0x200)
> +			dev_info(drvdata->dev, "PS/2 Tx FIFO Overflow!\n");
> +		if (fifo_status & 0x04)
> +			dev_info(drvdata->dev, "PS/2 Rx FIFO Underflow!\n");
> +		if (fifo_status & 0x02)
> +			dev_info(drvdata->dev, "PS/2 Rx FIFO Overflow!\n");
> +
> +		writel(readl(drvdata->base_address + SW_PS2_GCTRL)|0x4, drvdata->base_=
address + SW_PS2_GCTRL); /*reset PS/2 controller*/
> +		writel(0x707, drvdata->base_address + SW_PS2_FSTAT);
> +		error =3D 1;
> +	}
> +
> +	rval =3D (fifo_status >> 16) & 0x3;
> +	while (!error && rval--) {
> +		byte =3D readl(drvdata->base_address + SW_PS2_DATA) & 0xff;
> +		dev_info(drvdata->dev, "PS/2 Receive %02x\n", byte);
> +		serio_interrupt(drvdata->serio, byte, 0);
> +	}
> +
> +	writel(intr_status, drvdata->base_address + SW_PS2_LSTAT);
> +	writel(fifo_status, drvdata->base_address + SW_PS2_FSTAT);
> +
> +	spin_unlock(&drvdata->ps2_lock);
> +
> +	return IRQ_HANDLED;
> +}
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
> +	rval =3D SWPS2_LCTL_TXDTOEN|SWPS2_LCTL_STOPERREN|SWPS2_LCTL_ACKERREN|SW=
PS2_LCTL_PARERREN|SWPS2_LCTL_RXDTOEN;
> +	writel(rval, drvdata->base_address + SW_PS2_LCTRL);
> +
> +	/*Reset FIFO*/
> +	writel(0x3<<16 | 0x607, drvdata->base_address + SW_PS2_FCTRL);
> +
> +	src_clk =3D clk_get_rate(drvdata->pclk);
> +
> +	if (!src_clk) {
> +		dev_info(drvdata->dev, "w_ps2c_set_sclk error, source clock is 0.");
> +		return -1;
> +	}
> +
> +	/*Set Clock Divider Register*/
> +	clk_scdf =3D ((src_clk + (SW_PS2_SAMPLE_CLK>>1)) / SW_PS2_SAMPLE_CLK - =
1);
> +	clk_pcdf =3D ((SW_PS2_SAMPLE_CLK + (SW_PS2_SCLK>>1)) / SW_PS2_SCLK - 1);
> +	rval =3D (clk_scdf<<8) | clk_pcdf;/* | (PS2_DEBUG_SEL<<16);*/

What is this supposed to do? Calculating and rounding the dividers?

You should look into DIV_ROUND_* if that's so

> +	writel(rval, drvdata->base_address + SW_PS2_CLKDR);
> +
> +	/*Set Global Control Register*/
> +	rval =3D SWPS2_RESET|SWPS2_INTEN|SWPS2_MASTER|SWPS2_BUSEN;
> +	writel(rval, drvdata->base_address + SW_PS2_GCTRL);
> +
> +	udelay(100);

Why is that udelay needed?

> +
> +	return 0;
> +}
> +
> +static void sunxips2_close(struct serio *pserio)
> +{
> +	struct sunxips2data *drvdata =3D pserio->port_data;
> +
> +	spin_lock(&drvdata->ps2_lock);

spin_lock_irqsave would be better I guess.

> +	/* Disable the PS2 interrupts */
> +	writel(0, drvdata->base_address + SW_PS2_GCTRL);
> +	spin_unlock(&drvdata->ps2_lock);
> +}
> +
> +static int sunxips2_write(struct serio *pserio, unsigned char val)
> +{
> +	struct sunxips2data *drvdata =3D (struct sunxips2data *)pserio->port_da=
ta;
> +	u32 timeout =3D 10000;
> +
> +	do {
> +		if (readl(drvdata->base_address + SW_PS2_FSTAT) & SWPS2_FSTA_TXRDY) {
> +			writel(val, drvdata->base_address + SW_PS2_DATA);
> +			return 0;
> +		}
> +	} while (timeout--);

Please use time_before() here

> +	return -1;

And return a meaningful error.

> +static int sunxips2_probe(struct platform_device *ofdev)

The ofdev name is measleading. This is a platform_device structure, it
could be probed by other mechanisms than OF, so please use a different
name here. Usually pdev is used.

> +{
> +	struct resource *res; /* IO mem resources */
> +	struct sunxips2data *drvdata;
> +	struct serio *serio;
> +	struct device *dev =3D &ofdev->dev;
> +	unsigned int irq;
> +	int error;
> +
> +	drvdata =3D devm_kzalloc(dev, sizeof(struct sunxips2data), GFP_KERNEL);
> +	serio =3D devm_kzalloc(dev, sizeof(struct serio), GFP_KERNEL);
> +	if (!drvdata || !serio)
> +		error =3D -ENOMEM;
> +
> +	/* Request clock */
> +	drvdata->pclk =3D clk_get(dev, NULL);

You can use devm_clk_get.

> +	if (IS_ERR(drvdata->pclk))
> +		dev_dbg(dev, "couldn't get clock %li\n",
> +			PTR_ERR(drvdata->pclk));

This is an error, you should treat it as such.

> +	if (!IS_ERR(drvdata->pclk)) {
> +		error =3D clk_prepare_enable(drvdata->pclk);
> +		if (error < 0) {
> +			dev_err(dev, "failed to enable clock %d\n", error);
> +			return error;
> +		}
> +	}
> +
> +	/* IO */
> +	res =3D platform_get_resource(ofdev, IORESOURCE_MEM, 0);
> +	drvdata->base_address =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(drvdata->base_address)) {
> +		dev_err(dev, "failed to map registers\n");
> +		error =3D PTR_ERR(drvdata->base_address);
> +	}

ditto.

> +	serio->id.type =3D SERIO_8042;
> +	serio->write =3D sunxips2_write;
> +	serio->open =3D sunxips2_open;
> +	serio->close =3D sunxips2_close;
> +	serio->port_data =3D drvdata;
> +	serio->dev.parent =3D dev;
> +	strlcpy(serio->name, dev_name(dev), sizeof(serio->name));
> +	strlcpy(serio->phys, dev_name(dev), sizeof(serio->phys));
> +
> +	platform_set_drvdata(ofdev, drvdata);
> +	serio_register_port(serio);
> +
> +	/* Get IRQ for the device */
> +	irq =3D irq_of_parse_and_map(ofdev->dev.of_node, 0);
> +	if (!irq) {
> +		dev_err(dev, "no IRQ found\n");
> +		return -ENODEV;
> +	}

You can use platform_get_irq, for consistency with how you retrieve
resources.

You're also no unregistering the driver from the serio framework.

> +	drvdata->irq =3D irq;
> +	drvdata->serio =3D serio;
> +	drvdata->dev =3D dev;
> +	error =3D devm_request_any_context_irq(drvdata->dev, drvdata->irq, &sun=
xips2_interrupt, 0,
> +				DRIVER_NAME, drvdata);

request_irq is enough here.

> +	if (error) {
> +		dev_err(drvdata->dev,
> +			"Couldn't allocate interrupt %d : error: %d\n", drvdata->irq, error);
> +		return error;
> +	}
> +	return 0;		/* success */
> +}
> +
> +static int sunxips2_remove(struct platform_device *of_dev)
> +{
> +	struct sunxips2data *drvdata =3D platform_get_drvdata(of_dev);
> +
> +	if (!IS_ERR(drvdata->pclk)) {
> +		clk_disable_unprepare(drvdata->pclk);
> +		clk_put(drvdata->pclk);
> +	}
> +	serio_unregister_port(drvdata->serio);
> +	mdelay(2);

Why a mdelay?

> +	return 0;
> +}
> +
> +/* Match table for of_platform binding */
> +static const struct of_device_id sunxips2_of_match[] =3D {
> +	{ .compatible =3D "allwinner,sun7i-a20-ps2", },
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
> +		.owner =3D THIS_MODULE,

You can drop the owner field, it's already set by
module_platform_driver.

> +		.of_match_table =3D sunxips2_of_match,
> +	},
> +};
> +module_platform_driver(sunxips2_of_driver);
> +
> +MODULE_AUTHOR("Aaron.maoye<leafy.myeh@newbietech.com, "
> +		"Vishnu Patekar <vishnupatekar0510@gmail.com>");

Usually, you define two MODULE_AUTHOR.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--FT/vNgDLxVq4t/AU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgYKPAAoJEBx+YmzsjxAg1sMP/iHfWeop9n+KvLAaF/35X1zk
Fwj4hy6YQz1LQNN6KtyQ9Z0X4/2eM/JO3ys1K17DF/QUS3NefBk/uKi4Rxxyh0t/
omUPzdbd6hYOs/Ji/tpPK/xIJ7CYrcdbe7LhuO/yi1F4zTVtHckXWsESsRyQwcYR
6t1GYHGQjCoNyB370KK4qipJubchWdZXQjHYEEYg882MBRFlPUhGzehwUgZbYxc9
0VuaBf2+LpVncSHvtnRa6qTcggcggSR0Og7aaJiWaYgZNaDqib0yGR7Kx77umRWD
srTpTOe9fDaEk9gFZZp8hHxXl/KGOhps57FokvafXvuYoeyFxrxqpVl2/KfNPsth
vrXatP3kS20c2HQ2OsgK0/CC4pvfPg3ydH1SudvzbVfeemqtQIuxxUfg/AqdZnkn
8GGx5SDiwjjrwIbEeuTlp5MrH87HVovQcKSfi2bkzWj+mwBXwd1nS3UK1j4ydTUX
m1gt96B/XQV7TrHJWgr2RE7yUl2BKx5kWz4Cs79Tvab3rnZP7zcbwxg2tR5XjbqF
m8ydcCfUfMBsncVjwax+Jp2UrnWI5Tr7LF2GLjvUtTVHiZQDBh3xLgSbKlEWa2du
f49Ys8xArjb/XYFQY09wTP8M1TqDFRlkeTZZOoeQ8QNyRY9B256yzHgIIg/5AGn5
iF/vdQCksU9o/fW0+eEV
=1DS7
-----END PGP SIGNATURE-----

--FT/vNgDLxVq4t/AU--
