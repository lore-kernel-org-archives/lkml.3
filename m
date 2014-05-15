Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaEOJt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:49:26 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:57469 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaEOJtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:49:22 -0400
Message-ID: <53748D84.5040005@monstr.eu>
Date: Thu, 15 May 2014 11:48:52 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bart Tanghe <bart.tanghe@thomasmore.be>, thierry.reding@gmail.com,
        michal.simek@xilinx.com
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        grant.likely@linaro.org, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc]pwm: add xilinx pwm driver
References: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be>
In-Reply-To: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="N7vku60ivkfV1TQbVKTf4KllpoJ7A1Rhj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N7vku60ivkfV1TQbVKTf4KllpoJ7A1Rhj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/14/2014 01:26 PM, Bart Tanghe wrote:
> 	add Xilinx PWM support - axi timer hardware block=20
>=20
> Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt b/Docum=
entation/devicetree/bindings/pwm/pwm-xlnx.txt
> new file mode 100644
> index 0000000..cb48926
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt
> @@ -0,0 +1,20 @@
> +Xilinx PWM controller
> +
> +Required properties:
> +- compatible: should be "xlnx,pwm-xlnx"
> +- add a clock source to the description
> +
> +Examples:
> +
> +		axi_timer_0: timer@42800000 {
> +			clock-frequency =3D <100000000>;

just remove this from example it is not needed and unused.


> +			clocks =3D <&clkc 15>;
> +			compatible =3D "xlnx,xlnx-pwm";
> +			reg =3D <0x42800000 0x10000>;
> +			xlnx,count-width =3D <0x20>;
> +			xlnx,gen0-assert =3D <0x1>;
> +			xlnx,gen1-assert =3D <0x1>;
> +			xlnx,one-timer-only =3D <0x0>;
> +			xlnx,trig0-assert =3D <0x1>;
> +			xlnx,trig1-assert =3D <0x1>;
> +		} ;

ok. This has to be done completely differently.
I have looked around and found one a little bit older
example but it is in the Linux kernel.
It is pwm-atmel-tcb.c driver and atmel_tclib.c and tcb_clksrc.c.

Arnd: Isn't there any newer better example how to manage it?

The latest timer driver is available here
arch/microblaze/kernel/timer.c which has support for big
and little endian.
There is probably no timer driver for old xilinx ppc405/ppc440
platforms but this timer can be also used there.

The timer driver needs to be moved from microblaze
folder to drivers/clocksource/ and should be just git mv
because I have done some changes some time ago
that it is compatible with clocksource drivers.

Back to atmel example - they are maintaining
internal list of timers (atmel_tclib.c)
and then clocksource driver (tcb_clksrc.c) is asking with atmel_tc_alloc(=
) for it.
The same is for pwm driver (pwm-atmel-tcb.c).

They probably have all timers the same which is not
our case because they can be different but this can be solved
with flags.

=46rom DT point of view I think this is the reasonable description

axi_timer_0: timer@42800000 {
	clocks =3D <&clkc 15>;
	compatible =3D "xlnx,xps-timer-1.00.a";
	interrupt-parent =3D <&xps_intc_0>;
	interrupts =3D < 3 2 >;
	reg =3D <0x42800000 0x10000>;
	xlnx,count-width =3D <0x20>;
	xlnx,gen0-assert =3D <0x1>;
	xlnx,gen1-assert =3D <0x1>;
	xlnx,one-timer-only =3D <0x0>;
	xlnx,trig0-assert =3D <0x1>;
	xlnx,trig1-assert =3D <0x1>;
} ;


pwm {
        compatible =3D "xlnx,timer-pwm";
        #pwm-cells =3D <2>;
        timer =3D <&axi_timer_0>;
};


Allocation function will also require to do a change
in clocksource driver because currently the first
timer in the DTS/system is taken for clocksource/clockevents
(others are just ignored).
That's why will be necessary to add clock-handle property
to cpu node to exactly describe which timer is system timer.
The same as is for interrupt-handle (more intc's can be in design).

	cpus {
		#address-cells =3D <1>;
		#cpus =3D <1>;
		#size-cells =3D <0>;
		microblaze_0: cpu@0 {
			compatible =3D "xlnx,microblaze-8.50.a";
			interrupt-handle =3D <&microblaze_0_intc>;
			...
			clock-handle =3D <&axi_timer_X>;
			...
		} ;
	} ;

Then clocksource driver will ask just exact timer which is suitable
to provide clocksource/clockevent. It can be also split and
use 2 cells format to specify which timer should be used.
clocksource-handle =3D <&axi_timer_X 0>;
clockeven-handle =3D <&axi_timer_X 1>;



> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index eece329..1d59b02 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -233,4 +233,17 @@ config PWM_VT8500
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-vt8500.
> =20
> +config PWM_XLNX
> +	tristate "Xilinx PWM support"
> +	help
> +	  Generic PWM framework driver for xilinx axi timer.
> +
> +	  This driver implements the pwm channel of a xilinx axi timer hardwa=
re

in the next email you are writing about ppc. It means xilinx timer just
here. Because it can be opb/plb/axi now.

> +	  block.
> +	  The hardware block has to be configured with generate output signal=

> +	  of timer 1 and timer 2 active high.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-xlnx.
> +
>  endif
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index 8b754e4..e0c5f59 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -21,3 +21,4 @@ obj-$(CONFIG_PWM_TIPWMSS)	+=3D pwm-tipwmss.o
>  obj-$(CONFIG_PWM_TWL)		+=3D pwm-twl.o
>  obj-$(CONFIG_PWM_TWL_LED)	+=3D pwm-twl-led.o
>  obj-$(CONFIG_PWM_VT8500)	+=3D pwm-vt8500.o
> +obj-$(CONFIG_PWM_XLNX)		+=3D pwm-xlnx.o
> diff --git a/drivers/pwm/pwm-xlnx.c b/drivers/pwm/pwm-xlnx.c
> new file mode 100644
> index 0000000..9c1be71
> --- /dev/null
> +++ b/drivers/pwm/pwm-xlnx.c
> @@ -0,0 +1,197 @@
> +/*
> + * pwm-xlnx driver
> + * Tested on zedboard - axi timer v2.00a
> + *
> + * Copyright (C) 2014 Thomas more

more?

> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y
> + * the Free Software Foundation; version 2.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +
> +/*mmio regiser mapping*/

typo and use proper comment format, fix comment format globally.

> +
> +#define OFFSET		0x10
> +#define DUTY		0x14
> +#define PERIOD		0x04

this has to reuse proper register name from datasheet.

> +
> +/* configure the counters as 32 bit counters */
> +
> +#define PWM_CONF	0x00000206
> +#define PWM_ENABLE	0x00000080

same for bits.

> +
> +#define DRIVER_AUTHOR "Bart Tanghe <bart.tanghe@thomasmore.be>"
> +#define DRIVER_DESC "A Xilinx pwm driver"

Just use it directly below.

> +
> +struct xlnx_pwm_chip {
> +	struct pwm_chip chip;
> +	struct device *dev;
> +	int scaler;
> +	void __iomem *mmio_base;
> +};
> +
> +static inline struct xlnx_pwm_chip *to_xlnx_pwm_chip(
> +					struct pwm_chip *chip){
> +
> +	return container_of(chip, struct xlnx_pwm_chip, chip);
> +}
> +
> +static int xlnx_pwm_config(struct pwm_chip *chip,
> +			      struct pwm_device *pwm,
> +			      int duty_ns, int period_ns){
> +
> +	struct xlnx_pwm_chip *pc;
> +
> +	pc =3D container_of(chip, struct xlnx_pwm_chip, chip);
> +
> +	iowrite32(duty_ns/pc->scaler - 2, pc->mmio_base + DUTY);
> +	iowrite32(period_ns/pc->scaler - 2, pc->mmio_base + PERIOD);

not a proper coding style.


> +
> +	return 0;
> +}
> +
> +static int xlnx_pwm_enable(struct pwm_chip *chip,
> +			      struct pwm_device *pwm){
> +
> +	struct xlnx_pwm_chip *pc;
> +
> +	pc =3D container_of(chip, struct xlnx_pwm_chip, chip);
> +
> +	iowrite32(ioread32(pc->mmio_base) | PWM_ENABLE, pc->mmio_base);
> +	iowrite32(ioread32(pc->mmio_base + OFFSET) | PWM_ENABLE,
> +						pc->mmio_base + OFFSET);
> +	return 0;
> +}
> +
> +static void xlnx_pwm_disable(struct pwm_chip *chip,
> +				struct pwm_device *pwm)
> +{
> +	struct xlnx_pwm_chip *pc;
> +
> +	pc =3D to_xlnx_pwm_chip(chip);
> +
> +	iowrite32(ioread32(pc->mmio_base) & ~PWM_ENABLE, pc->mmio_base);
> +	iowrite32(ioread32(pc->mmio_base + OFFSET) & ~PWM_ENABLE,
> +						pc->mmio_base + OFFSET);
> +}
> +
> +static int xlnx_set_polarity(struct pwm_chip *chip, struct pwm_device =
*pwm,
> +				enum pwm_polarity polarity)
> +{
> +	struct xlnx_pwm_chip *pc;
> +
> +	pc =3D to_xlnx_pwm_chip(chip);
> +
> +	/* no implementation of polarity function
> +	   the axi timer hw block doesn't support this
> +	*/

wrong comment.

> +
> +	return 0;
> +}
> +
> +static const struct pwm_ops xlnx_pwm_ops =3D {
> +	.config =3D xlnx_pwm_config,
> +	.enable =3D xlnx_pwm_enable,
> +	.disable =3D xlnx_pwm_disable,
> +	.set_polarity =3D xlnx_set_polarity,
> +	.owner =3D THIS_MODULE,
> +};
> +
> +static int xlnx_pwm_probe(struct platform_device *pdev)
> +{
> +	struct xlnx_pwm_chip *pwm;
> +
> +	int ret;
> +	struct resource *r;
> +	u32 start, end;
> +	struct clk *clk;
> +
> +	pwm =3D devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
> +	if (!pwm) {
> +		dev_err(&pdev->dev, "failed to allocate memory\n");

don't need this error message. It is reported by core automatically.

> +		return -ENOMEM;
> +	}
> +
> +	pwm->dev =3D &pdev->dev;
> +
> +	clk =3D devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(clk)) {
> +		dev_err(&pdev->dev, "could not find clk: %ld\n", PTR_ERR(clk));
> +		devm_kfree(&pdev->dev, pwm);

this is called automatically that's why you are calling devm_ functions.

> +		return PTR_ERR(clk);
> +	}
> +
> +	pwm->scaler =3D (int)1000000000/clk_get_rate(clk);

magic value - comment will be useful.

> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	pwm->mmio_base =3D devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(pwm->mmio_base)) {
> +		devm_kfree(&pdev->dev, pwm);

ditto.

> +		return PTR_ERR(pwm->mmio_base);
> +	}
> +
> +	start =3D r->start;
> +	end =3D r->end;
> +
> +	pwm->chip.dev =3D &pdev->dev;
> +	pwm->chip.ops =3D &xlnx_pwm_ops;
> +	pwm->chip.base =3D (int)&pdev->id;
> +	pwm->chip.npwm =3D 1;
> +
> +	ret =3D pwmchip_add(&pwm->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> +		devm_kfree(&pdev->dev, pwm);
> +		return -1;
> +	}
> +
> +	/*set the pwm0 configuration*/
> +	iowrite32(PWM_CONF, pwm->mmio_base);
> +	iowrite32(PWM_CONF, pwm->mmio_base + OFFSET);
> +
> +	platform_set_drvdata(pdev, pwm);
> +
> +	return 0;
> +}
> +
> +static int xlnx_pwm_remove(struct platform_device *pdev)
> +{
> +
> +	struct xlnx_pwm_chip *pc;
> +	pc  =3D platform_get_drvdata(pdev);

two spaces.

> +
> +	if (WARN_ON(!pc))
> +		return -ENODEV;
> +
> +	return pwmchip_remove(&pc->chip);
> +}
> +
> +static const struct of_device_id xlnx_pwm_of_match[] =3D {
> +	{ .compatible =3D "xlnx,pwm-xlnx", },
> +	{ /* sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, xlnx_pwm_of_match);
> +
> +static struct platform_driver xlnx_pwm_driver =3D {
> +	.driver =3D {
> +		.name =3D "pwm-xlnx",
> +		.owner =3D THIS_MODULE,
> +		.of_match_table =3D xlnx_pwm_of_match,
> +	},
> +	.probe =3D xlnx_pwm_probe,
> +	.remove =3D xlnx_pwm_remove,
> +};
> +module_platform_driver(xlnx_pwm_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);


Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--N7vku60ivkfV1TQbVKTf4KllpoJ7A1Rhj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlN0jYUACgkQykllyylKDCGETgCgmkKYrfDs0gB2falvhK5svvSQ
zwoAniA/mBpb94GmBL9kFllgOzj1kV1N
=49y5
-----END PGP SIGNATURE-----

--N7vku60ivkfV1TQbVKTf4KllpoJ7A1Rhj--
