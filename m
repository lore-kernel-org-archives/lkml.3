Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbbANBRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:17:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44665 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbbANBRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:17:30 -0500
Date: Tue, 13 Jan 2015 19:16:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Brian Hutchinson <b.hutchman@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 1/2] irqchip: omap-intc: Fix support for dm814 and dm816
Message-ID: <20150114011636.GB18523@saruman>
Reply-To: <balbi@ti.com>
References: <1421187806-6804-1-git-send-email-tony@atomide.com>
 <1421187806-6804-2-git-send-email-tony@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <1421187806-6804-2-git-send-email-tony@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2015 at 02:23:25PM -0800, Tony Lindgren wrote:
> On dm81xx we have 128 interrupts like am33xx has. Let's add
> compatible flags for dm814x and dm816x, and document the
> existing binding.
>=20
> As the dm81xx are booting in device tree only mode, we can now
> also remove ti81xx_init_irq() legacy function.
>=20
> Cc: Brian Hutchinson <b.hutchman@gmail.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Thanks for documenting the binding :-s

Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  .../interrupt-controller/ti,omap-intc-irq.txt      | 28 ++++++++++++++++=
++++++
>  drivers/irqchip/irq-omap-intc.c                    | 14 ++++-------
>  include/linux/irqchip/irq-omap-intc.h              |  1 -
>  3 files changed, 33 insertions(+), 10 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controlle=
r/ti,omap-intc-irq.txt
>=20
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/ti,om=
ap-intc-irq.txt b/Documentation/devicetree/bindings/interrupt-controller/ti=
,omap-intc-irq.txt
> new file mode 100644
> index 0000000..38ce5d03
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/ti,omap-intc=
-irq.txt
> @@ -0,0 +1,28 @@
> +Omap2/3 intc controller
> +
> +On TI omap2 and 3 the intc interrupt controller can provide
> +96 or 128 IRQ signals to the ARM host depending on the SoC.
> +
> +Required Properties:
> +- compatible: should be one of
> +			"ti,omap2-intc"
> +			"ti,omap3-intc"
> +			"ti,dm814-intc"
> +			"ti,dm816-intc"
> +			"ti,am33xx-intc"
> +
> +- interrupt-controller : Identifies the node as an interrupt controller
> +- #interrupt-cells : Specifies the number of cells needed to encode inte=
rrupt
> +		     source, should be 1 for intc
> +- interrupts: interrupt reference to primary interrupt controller
> +
> +Please refer to interrupts.txt in this directory for details of the comm=
on
> +Interrupt Controllers bindings used by client devices.
> +
> +Example:
> +	intc: interrupt-controller@48200000 {
> +		compatible =3D "ti,omap3-intc";
> +		interrupt-controller;
> +		#interrupt-cells =3D <1>;
> +		reg =3D <0x48200000 0x1000>;
> +	};
> diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-i=
ntc.c
> index 28718d3..b75a44a 100644
> --- a/drivers/irqchip/irq-omap-intc.c
> +++ b/drivers/irqchip/irq-omap-intc.c
> @@ -364,14 +364,6 @@ void __init omap3_init_irq(void)
>  	set_handle_irq(omap_intc_handle_irq);
>  }
> =20
> -void __init ti81xx_init_irq(void)
> -{
> -	omap_nr_irqs =3D 96;
> -	omap_nr_pending =3D 4;
> -	omap_init_irq(OMAP34XX_IC_BASE, NULL);
> -	set_handle_irq(omap_intc_handle_irq);
> -}
> -
>  static int __init intc_of_init(struct device_node *node,
>  			     struct device_node *parent)
>  {
> @@ -383,7 +375,9 @@ static int __init intc_of_init(struct device_node *no=
de,
>  	if (WARN_ON(!node))
>  		return -ENODEV;
> =20
> -	if (of_device_is_compatible(node, "ti,am33xx-intc")) {
> +	if (of_device_is_compatible(node, "ti,dm814-intc") ||
> +	    of_device_is_compatible(node, "ti,dm816-intc") ||
> +	    of_device_is_compatible(node, "ti,am33xx-intc")) {
>  		omap_nr_irqs =3D 128;
>  		omap_nr_pending =3D 4;
>  	}
> @@ -399,4 +393,6 @@ static int __init intc_of_init(struct device_node *no=
de,
> =20
>  IRQCHIP_DECLARE(omap2_intc, "ti,omap2-intc", intc_of_init);
>  IRQCHIP_DECLARE(omap3_intc, "ti,omap3-intc", intc_of_init);
> +IRQCHIP_DECLARE(dm814x_intc, "ti,dm814-intc", intc_of_init);
> +IRQCHIP_DECLARE(dm816x_intc, "ti,dm816-intc", intc_of_init);
>  IRQCHIP_DECLARE(am33xx_intc, "ti,am33xx-intc", intc_of_init);
> diff --git a/include/linux/irqchip/irq-omap-intc.h b/include/linux/irqchi=
p/irq-omap-intc.h
> index e06b370..bda426a 100644
> --- a/include/linux/irqchip/irq-omap-intc.h
> +++ b/include/linux/irqchip/irq-omap-intc.h
> @@ -20,7 +20,6 @@
> =20
>  void omap2_init_irq(void);
>  void omap3_init_irq(void);
> -void ti81xx_init_irq(void);
> =20
>  int omap_irq_pending(void);
>  void omap_intc_save_context(void);
> --=20
> 2.1.4
>=20

--=20
balbi

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtcN0AAoJEIaOsuA1yqRES1EP/jdHBqs8/FeYgCb9wWyAcZE6
0SOfEpXqDBBDt8V7G3+lzmRgBrXxTLgaSpQTwMYeCIQuGg5T+7Ty+jTaZ1OnOAAK
R6q6uk3iRKMkjxHN+nH/peFmaFCz9BDFKfQC7UiRsDVOx4kgab9P1XITM7mxszzR
HQOdkC2NXSSzRpLHEdbgzIYbD0t1BRxIXw7NT0zdw2DdX8fO0qctZjJawrI1L3VD
xeHYUea223JptOcNNibhQL7HsAbl+6a8nYhj6ZZvDNkgF8D7yOS9cwZVSn+E6Hgw
LJaQIH6ajXQGmsHC81ZgmonYgc84ozodO+1CRFcq06ilYxM9AdGiJvqB098Bz19S
/0XyImlRjRJwjpFO+eQVMRg1NslZPjc6Qlv7tWKANH2Y3lSvp7y7rPbRfi6SFJvQ
5SWKZ/1865IVxYyrqxfXKEWLoM8Hd4IRm0IUbMg1OM/zPJKwnEtww2aTarIa/o26
YT2y8qk8IdaMf7nB+QX0mZJPN14h+HW6ipxtU1jTn6gT2RHClNp1BZZqHe2U5tU/
v36lTebcOhPpBgfE6USfcYkh27jzMi9PfK4V1WbXHdlk1fBfPFctS6ZshPTSX6cT
OGVzR5lm5mdR3kGQV0ME++vEZ7yY3el+3g7ntapI2+I9FcV3ecC87dkiMkj8knrT
J5X61iJshAufpwmItWJh
=ZywO
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
