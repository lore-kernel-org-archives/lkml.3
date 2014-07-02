Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbaGBQKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:10:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58622 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbaGBQKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:10:10 -0400
Date: Wed, 2 Jul 2014 11:09:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140702160932.GF5541@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gdTfX7fkYsEEjebm"
Content-Disposition: inline
In-Reply-To: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gdTfX7fkYsEEjebm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

+linux-omap, lakml

On Wed, Jul 02, 2014 at 06:00:09PM +0200, Sebastian Andrzej Siewior wrote:
> This patch provides a 8250-core based UART driver for the internal OMAP
> UART. The longterm goal is to provide the same functionality as the
> current OMAP uart driver and hopefully DMA support which could borrowed
> from the 8250-core.
>=20
> The whole PM-Runtime part is currently missing.

AWESOME!!!! I guess PM can be added after we know this i working fine..
Note that there are many workarounds which have been implemented one way
or another in the OMAP serial driver. Some of them might not even apply
to 8250, though.

> It has been only tested as console UART.
> The tty name is ttyS based instead of ttyO. How big is the pain here,
> what could be the easiest way to provide compatibility?

have been considering that myself for months. You could pass an optional
argument to serial8250_register_8250_port() but that only solves part of
the problem :-(

all in all, patch looks good to me.

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/tty/serial/8250/8250_core.c |   7 ++
>  drivers/tty/serial/8250/8250_omap.c | 224 ++++++++++++++++++++++++++++++=
++++++
>  drivers/tty/serial/8250/Kconfig     |   9 ++
>  drivers/tty/serial/8250/Makefile    |   1 +
>  include/uapi/linux/serial_core.h    |   3 +-
>  5 files changed, 243 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/tty/serial/8250/8250_omap.c
>=20
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/825=
0/8250_core.c
> index 7a91c6d..f47e876 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -260,6 +260,13 @@ static const struct serial8250_config uart_config[] =
=3D {
>  		.fcr		=3D UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
>  		.flags		=3D UART_CAP_FIFO | UART_CAP_AFE,
>  	},
> +	[PORT_OMAP_16750] =3D {
> +		.name		=3D "OMAP",
> +		.fifo_size	=3D 64,
> +		.tx_loadsz	=3D 64,
> +		.fcr		=3D UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_01,
> +		.flags		=3D UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
> +	},
>  	[PORT_TEGRA] =3D {
>  		.name		=3D "Tegra",
>  		.fifo_size	=3D 32,
> diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/825=
0/8250_omap.c
> new file mode 100644
> index 0000000..a23013f
> --- /dev/null
> +++ b/drivers/tty/serial/8250/8250_omap.c
> @@ -0,0 +1,224 @@
> +/*
> + * 8250-core based driver for the OMAP internal UART
> + *
> + *  Copyright (C) 2014 Sebastian Andrzej Siewior
> + *
> + */
> +
> +#include <linux/device.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/serial_8250.h>
> +#include <linux/serial_core.h>
> +#include <linux/serial_reg.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +
> +#include "8250.h"
> +
> +#define UART_DLL_EM 9
> +#define UART_DLM_EM 10
> +
> +#define DEFAULT_CLK_SPEED 48000000 /* 48Mhz*/
> +
> +#define UART_ERRATA_i202_MDR1_ACCESS	(1 << 0)
> +#define OMAP_UART_WER_HAS_TX_WAKEUP	(1 << 1)
> +
> +/* SCR register bitmasks */
> +#define OMAP_UART_SCR_RX_TRIG_GRANU1_MASK	(1 << 7)
> +#define OMAP_UART_SCR_TX_TRIG_GRANU1_MASK	(1 << 6)
> +#define OMAP_UART_SCR_TX_EMPTY			(1 << 3)
> +
> +/* MVR register bitmasks */
> +#define OMAP_UART_MVR_SCHEME_SHIFT	30
> +#define OMAP_UART_LEGACY_MVR_MAJ_MASK	0xf0
> +#define OMAP_UART_LEGACY_MVR_MAJ_SHIFT	4
> +#define OMAP_UART_LEGACY_MVR_MIN_MASK	0x0f
> +#define OMAP_UART_MVR_MAJ_MASK		0x700
> +#define OMAP_UART_MVR_MAJ_SHIFT		8
> +#define OMAP_UART_MVR_MIN_MASK		0x3f
> +
> +#define UART_BUILD_REVISION(x, y)	(((x) << 8) | (y))
> +
> +#define OMAP_UART_REV_46 0x0406
> +#define OMAP_UART_REV_52 0x0502
> +#define OMAP_UART_REV_63 0x0603
> +
> +struct serial8250_omap_priv {
> +	int line;
> +	u32 habit;
> +};
> +
> +static u32 uart_read(struct uart_8250_port *up, u32 reg)
> +{
> +	return readl(up->port.membase + (reg << up->port.regshift));
> +}
> +
> +static void uart_write(struct uart_8250_port *up, u32 reg, u32 val)
> +{
> +	writel(val, up->port.membase + (reg << up->port.regshift));
> +}
> +
> +static void omap_serial_fill_features_erratas(struct uart_8250_port *up,
> +		struct serial8250_omap_priv *priv)
> +{
> +	u32 mvr, scheme;
> +	u16 revision, major, minor;
> +
> +	mvr =3D uart_read(up, UART_OMAP_MVER);
> +
> +	/* Check revision register scheme */
> +	scheme =3D mvr >> OMAP_UART_MVR_SCHEME_SHIFT;
> +
> +	switch (scheme) {
> +	case 0: /* Legacy Scheme: OMAP2/3 */
> +		/* MINOR_REV[0:4], MAJOR_REV[4:7] */
> +		major =3D (mvr & OMAP_UART_LEGACY_MVR_MAJ_MASK) >>
> +			OMAP_UART_LEGACY_MVR_MAJ_SHIFT;
> +		minor =3D (mvr & OMAP_UART_LEGACY_MVR_MIN_MASK);
> +		break;
> +	case 1:
> +		/* New Scheme: OMAP4+ */
> +		/* MINOR_REV[0:5], MAJOR_REV[8:10] */
> +		major =3D (mvr & OMAP_UART_MVR_MAJ_MASK) >>
> +			OMAP_UART_MVR_MAJ_SHIFT;
> +		minor =3D (mvr & OMAP_UART_MVR_MIN_MASK);
> +		break;
> +	default:
> +		dev_warn(up->port.dev,
> +				"Unknown revision, defaulting to highest\n");
> +		/* highest possible revision */
> +		major =3D 0xff;
> +		minor =3D 0xff;
> +	}
> +	/* normalize revision for the driver */
> +	revision =3D UART_BUILD_REVISION(major, minor);
> +
> +	switch (revision) {
> +	case OMAP_UART_REV_46:
> +		priv->habit =3D UART_ERRATA_i202_MDR1_ACCESS;
> +		break;
> +	case OMAP_UART_REV_52:
> +		priv->habit =3D UART_ERRATA_i202_MDR1_ACCESS |
> +				OMAP_UART_WER_HAS_TX_WAKEUP;
> +		break;
> +	case OMAP_UART_REV_63:
> +		priv->habit =3D UART_ERRATA_i202_MDR1_ACCESS |
> +			OMAP_UART_WER_HAS_TX_WAKEUP;
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static int serial8250_omap_probe(struct platform_device *pdev)
> +{
> +	struct resource *regs =3D platform_get_resource(pdev, IORESOURCE_MEM, 0=
);
> +	struct resource *irq =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	struct serial8250_omap_priv *priv;
> +	struct uart_8250_port up;
> +	int ret;
> +	void __iomem *membase;
> +
> +	if (!regs || !irq) {
> +		dev_err(&pdev->dev, "missing registers or irq\n");
> +		return -EINVAL;
> +	}
> +
> +	priv =3D devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		dev_err(&pdev->dev, "unable to allocate private data\n");
> +		return -ENOMEM;
> +	}
> +	membase =3D devm_ioremap_nocache(&pdev->dev, regs->start,
> +			resource_size(regs));
> +	if (!membase)
> +		return -ENODEV;
> +
> +	memset(&up, 0, sizeof(up));
> +	up.port.dev =3D &pdev->dev;
> +	up.port.mapbase =3D regs->start;
> +	up.port.membase =3D membase;
> +	up.port.irq =3D irq->start;
> +	/*
> +	 * It claims to be 16C750 compatible however it is a little different.
> +	 * It has EFR and has no FCR7_64byte bit. The AFE which it claims to is
> +	 * enabled via EFR instead of MCR.
> +	 */
> +	up.port.type =3D PORT_OMAP_16750;
> +	up.port.iotype =3D UPIO_MEM32;
> +	up.port.flags =3D UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_FIXED_TYPE;
> +	up.port.private_data =3D priv;
> +
> +	up.port.regshift =3D 2;
> +	up.port.fifosize =3D 64;
> +
> +	if (pdev->dev.of_node) {
> +		up.port.line =3D of_alias_get_id(pdev->dev.of_node, "serial");
> +		of_property_read_u32(pdev->dev.of_node, "clock-frequency",
> +				&up.port.uartclk);
> +	} else {
> +		up.port.line =3D pdev->id;
> +	}
> +
> +	if (up.port.line < 0) {
> +		dev_err(&pdev->dev, "failed to get alias/pdev id, errno %d\n",
> +				up.port.line);
> +		ret =3D -ENODEV;
> +		/*XXX*/
> +		BUG();
> +	}
> +	if (!up.port.uartclk) {
> +		up.port.uartclk =3D DEFAULT_CLK_SPEED;
> +		dev_warn(&pdev->dev,
> +				"No clock speed specified: using default: %d\n",
> +				DEFAULT_CLK_SPEED);
> +	}
> +
> +	omap_serial_fill_features_erratas(&up, priv);
> +
> +	uart_write(&up, UART_OMAP_SCR, OMAP_UART_SCR_TX_EMPTY |
> +			OMAP_UART_SCR_RX_TRIG_GRANU1_MASK);
> +
> +	ret =3D serial8250_register_8250_port(&up);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "unable to register 8250 port\n");
> +		return ret;
> +	}
> +	priv->line =3D ret;
> +	platform_set_drvdata(pdev, priv);
> +	return 0;
> +}
> +
> +static int serial8250_omap_remove(struct platform_device *pdev)
> +{
> +	struct serial8250_omap_priv *priv =3D platform_get_drvdata(pdev);
> +
> +	serial8250_unregister_port(priv->line);
> +	return 0;
> +}
> +
> +static const struct of_device_id serial8250_omap_dt_ids[] =3D {
> +	{ .compatible =3D "ti,omap2-uart" },
> +	{ .compatible =3D "ti,omap3-uart" },
> +	{ .compatible =3D "ti,omap4-uart" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, serial8250_omap_dt_ids);
> +
> +static struct platform_driver serial8250_omap_platform_driver =3D {
> +	.driver =3D {
> +		.name		=3D "serial8250-omap",
> +		.of_match_table =3D serial8250_omap_dt_ids,
> +		.owner		=3D THIS_MODULE,
> +	},
> +	.probe			=3D serial8250_omap_probe,
> +	.remove			=3D serial8250_omap_remove,
> +};
> +
> +module_platform_driver(serial8250_omap_platform_driver);
> +
> +MODULE_AUTHOR("Sebastian Andrzej Siewior");
> +MODULE_DESCRIPTION("OMAP 8250 Driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kc=
onfig
> index 349ee59..7a5073b 100644
> --- a/drivers/tty/serial/8250/Kconfig
> +++ b/drivers/tty/serial/8250/Kconfig
> @@ -298,3 +298,12 @@ config SERIAL_8250_RT288X
>  	  If you have a Ralink RT288x/RT305x SoC based board and want to use the
>  	  serial port, say Y to this option. The driver can handle up to 2 seri=
al
>  	  ports. If unsure, say N.
> +
> +config SERIAL_8250_OMAP
> +	tristate "Support for OMAP internal UART (8250 based driver)"
> +	depends on SERIAL_8250 && ARCH_OMAP2PLUS
> +	help
> +	  If you have a machine based on an Texas Instruments OMAP CPU you
> +	  can enable its onboard serial ports by enabling this option.
> +
> +	  This driver is in early stage and uses ttyS instead of ttyO.
> diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/M=
akefile
> index 36d68d0..4bac392 100644
> --- a/drivers/tty/serial/8250/Makefile
> +++ b/drivers/tty/serial/8250/Makefile
> @@ -20,3 +20,4 @@ obj-$(CONFIG_SERIAL_8250_HUB6)		+=3D 8250_hub6.o
>  obj-$(CONFIG_SERIAL_8250_FSL)		+=3D 8250_fsl.o
>  obj-$(CONFIG_SERIAL_8250_DW)		+=3D 8250_dw.o
>  obj-$(CONFIG_SERIAL_8250_EM)		+=3D 8250_em.o
> +obj-$(CONFIG_SERIAL_8250_OMAP)		+=3D 8250_omap.o
> diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial=
_core.h
> index 5820269..74f9b11 100644
> --- a/include/uapi/linux/serial_core.h
> +++ b/include/uapi/linux/serial_core.h
> @@ -54,7 +54,8 @@
>  #define PORT_ALTR_16550_F32 26	/* Altera 16550 UART with 32 FIFOs */
>  #define PORT_ALTR_16550_F64 27	/* Altera 16550 UART with 64 FIFOs */
>  #define PORT_ALTR_16550_F128 28 /* Altera 16550 UART with 128 FIFOs */
> -#define PORT_MAX_8250	28	/* max port ID */
> +#define PORT_OMAP_16750	29	/* TI's OMAP internal 16C750 compatible UART =
*/
> +#define PORT_MAX_8250	29	/* max port ID */
> =20
>  /*
>   * ARM specific type numbers.  These are not currently guaranteed
> --=20
> 2.0.0
>=20

--=20
balbi

--gdTfX7fkYsEEjebm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtC68AAoJEIaOsuA1yqRELdMP/0SQrfSV9Ht+ivMSok7+zinu
hZ9MXIezYuvhI42cmUlwskdSQKszkmsalchRVcWeS/nMApkU9xMScdQyqo4Dj2oc
w4+MVAP/M7Dhux7peN5oORBuTaliJ3osFI2wjaxn35vVkQCpuJINB1Yn3Bw2HgUC
crESAKLUp1dBMbpqHorKKaAcoa6Zz+3Q3AGFk4Fsa1Gwwt3iBBoe+Z/ieczUER07
DQVXqWxF7AkSbzqr1SCX22m2Wr0fBJjjTp6NpFGa/v42bKmIJUBm1O3QQbQmM9E5
QBnhW82F2kB04GIuMm18iRQInWqkc0G2Knu0/PTdp0n4qgw/pUFOSV+l4SLlCZ72
0Ei3/A7synOdvJC/ueLxqUEy6tF6a3VYMnFay5MhPmzDo0pIcbM6Em09vrHqp68A
PQgBdNfhLPFS52aLikjYlni659LNIxpIfpAEs37Kl4V8M4yh3O6Z7LBLIEt7VH9Y
FRp/V3yTU0foI3Y7+fVR5ofxWVlizrXkIXeXn0vGxDa3RF4sLqNameoGFLX+Oeds
IijTFj4m2mitrFtTSntKUFLs7y6X2kKS8d1kNSI/mL3CYX7KkQIVBjeOZ7ffVTwe
XiR12kzNhIBBpdK/tQgLJQe3qDyeyjLOHjM6q5xDw5ju7gf2s4DTGNqPTHWb9sN0
T7lr3+JcdCl+2X00kMW1
=dAVL
-----END PGP SIGNATURE-----

--gdTfX7fkYsEEjebm--
