Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbaJ3OH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:07:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45105 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759855AbaJ3OHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:07:06 -0400
Date: Thu, 30 Oct 2014 09:04:16 -0500
From: Felipe Balbi <balbi@ti.com>
To: <dinguyen@opensource.altera.com>
CC: <paulz@synopsys.com>, <balbi@ti.com>, <dinh.linux@gmail.com>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 6/8] usb: dwc2: gadget: Do not fail probe if there
 isn't a clock node
Message-ID: <20141030140416.GF6482@saruman>
Reply-To: <balbi@ti.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-7-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VuQYccsttdhdIfIP"
Content-Disposition: inline
In-Reply-To: <1414538749-14735-7-git-send-email-dinguyen@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VuQYccsttdhdIfIP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 28, 2014 at 06:25:47PM -0500, dinguyen@opensource.altera.com wr=
ote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>=20
> Since the dwc2 hcd driver is currently not looking for a clock node during
> init, we should not completely fail if there isn't a clock provided.
> For dual-role mode, we will only fail init for a non-clock node error. We
> then update the HCD to only call gadget funtions if there is a proper clo=
ck
> node.
>=20
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> ---
> v5: reworked to not access gadget functions from the hcd.
> ---
>  drivers/usb/dwc2/core.h      |  3 +--
>  drivers/usb/dwc2/core_intr.c |  9 ++++++---
>  drivers/usb/dwc2/hcd.c       |  3 ++-
>  drivers/usb/dwc2/platform.c  | 19 +++++++++++++++----
>  4 files changed, 24 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> index ec70862..48120c8 100644
> --- a/drivers/usb/dwc2/core.h
> +++ b/drivers/usb/dwc2/core.h
> @@ -660,6 +660,7 @@ struct dwc2_hsotg {
>  #endif
>  #endif /* CONFIG_USB_DWC2_HOST || CONFIG_USB_DWC2_DUAL_ROLE */
> =20
> +	struct clk *clk;
>  #if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || IS_ENABLED(CONFIG_USB_DWC2=
_DUAL_ROLE)
>  	/* Gadget structures */
>  	struct usb_gadget_driver *driver;
> @@ -667,8 +668,6 @@ struct dwc2_hsotg {
>  	struct usb_phy *uphy;
>  	struct s3c_hsotg_plat *plat;
> =20
> -	struct clk *clk;
> -
>  	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
> =20
>  	u32 phyif;
> diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
> index 1240875..1608037 100644
> --- a/drivers/usb/dwc2/core_intr.c
> +++ b/drivers/usb/dwc2/core_intr.c
> @@ -339,7 +339,8 @@ static void dwc2_handle_wakeup_detected_intr(struct d=
wc2_hsotg *hsotg)
>  		}
>  		/* Change to L0 state */
>  		hsotg->lx_state =3D DWC2_L0;
> -		call_gadget(hsotg, resume);
> +		if (!IS_ERR(hsotg->clk))
> +			call_gadget(hsotg, resume);

instead of exposing the clock detail to the entire driver, add IS_ERR()
checks to resume and suspend instead. In fact, NULL is a valid clock, so
you might as well:

	clk =3D clk_get(foo, bar);
	if (IS_ERR(clk))
		dwc->clk =3D NULL;
	else
		dwc->clk =3D clk;

Then you don't need any IS_ERR() checks sprinkled around the driver.

> @@ -400,7 +401,8 @@ static void dwc2_handle_usb_suspend_intr(struct dwc2_=
hsotg *hsotg)
>  			"DSTS.Suspend Status=3D%d HWCFG4.Power Optimize=3D%d\n",
>  			!!(dsts & DSTS_SUSPSTS),
>  			hsotg->hw_params.power_optimized);
> -		call_gadget(hsotg, suspend);
> +		if (!IS_ERR(hsotg->clk))
> +			call_gadget(hsotg, suspend);
>  	} else {
>  		if (hsotg->op_state =3D=3D OTG_STATE_A_PERIPHERAL) {
>  			dev_dbg(hsotg->dev, "a_peripheral->a_host\n");
> @@ -477,7 +479,8 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *de=
v)
>  	spin_lock(&hsotg->lock);
> =20
>  	if (dwc2_is_device_mode(hsotg))
> -		retval =3D s3c_hsotg_irq(irq, dev);
> +		if (!IS_ERR(hsotg->clk))
> +			retval =3D s3c_hsotg_irq(irq, dev);

wait a minute, if there is no clock we don't call the gadget interrupt
handler ? Why ? Who will disable the IRQ line ?

> diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
> index 44c609f..fa49c72 100644
> --- a/drivers/usb/dwc2/hcd.c
> +++ b/drivers/usb/dwc2/hcd.c
> @@ -1371,7 +1371,8 @@ static void dwc2_conn_id_status_change(struct work_=
struct *work)
>  		hsotg->op_state =3D OTG_STATE_B_PERIPHERAL;
>  		dwc2_core_init(hsotg, false, -1);
>  		dwc2_enable_global_interrupts(hsotg);
> -		s3c_hsotg_core_init(hsotg);
> +		if (!IS_ERR(hsotg->clk))
> +			s3c_hsotg_core_init(hsotg);
>  	} else {
>  		/* A-Device connector (Host Mode) */
>  		dev_dbg(hsotg->dev, "connId A\n");
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index 72f32f7..77c8417 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -217,8 +217,17 @@ static int dwc2_driver_probe(struct platform_device =
*dev)
> =20
>  	spin_lock_init(&hsotg->lock);
>  	retval =3D dwc2_gadget_init(hsotg, irq);
> -	if (retval)
> -		return retval;
> +	if (retval) {
> +		/*
> +		 * We will not fail the driver initialization for dual-role
> +		 * if no clock node is supplied. However, all gadget
> +		 * functionality will be disabled if a clock node is not
> +		 * provided. Host functionality will continue.
> +		 * TO-DO: make clock node a requirement for the HCD.
> +		 */
> +		if (!IS_ERR(hsotg->clk))
> +			return retval;
> +	}

no here... this should have been taken care by dwc2_gadget_init()
itself.

--=20
balbi

--VuQYccsttdhdIfIP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUkVfAAoJEIaOsuA1yqREGuEP/3ZR5+mnYwF5auqlTUqprHRC
t5qGNSV3/zbXXgdV/yZ5TK6cTC5Q0EKGJ6rpjBCr718DoJNz+p5czUpGwBbivyU0
9wyjq1IWz24FibJCDXR3Sfdsg4QlJ+Z5rt+PUaBmlK4WjKoB7zBitwviHb47g7WI
hNkN0x9CmS+L4yY7hoEQBv/5BxsMzcUYqwQ5YY9nQuATfqP1DqlqvvAmpJosW24X
WV2qquOR4rtA/m1bXdT5t47gNEnFUsGEXiweLlHCe7lujcdHb8ZlWaafUQf600ea
l37P6LEhjcJmskdBfVV84vmNQnqq6KNHDP5uGwyePBnwxnsjpkTXpLeIF8B1LSHo
/7FoLP+YyyQgfEWd8QrBJ2SvNZ26dGdR+pg40mYIAU1suaYW2wVcKOKBL9AXeQvF
FQD0+h/5T8j/ZqJRjJQo3yh4MsyLZU2kRxQXVU4kGZamjHPw9oiXzvyKbvFuzWph
wUXBr1Nj8kPouY2hM7ZDvJBzvZzQr2zzsDRpFNTtQ6u2xZ/eHQPTaUjoWzCheXAu
EA8uQOm8+gUVk3qo6/3J8G6aa9y1oE+dsx5yZokP0MjAaIDn+o6gmOmON1C/cDOu
+MdIG9hC83MgO6T5AH/T+E1RjReQvEiInqJwH4ZNSGMwMg0h7SOrlJRr0NMSszFS
0ZblvIIgiCKWtYPPlBib
=YcxO
-----END PGP SIGNATURE-----

--VuQYccsttdhdIfIP--
