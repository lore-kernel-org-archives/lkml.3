Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaJaRpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:45:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60455 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaJaRps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:45:48 -0400
Date: Fri, 31 Oct 2014 12:42:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dinh Nguyen <dinguyen@opensource.altera.com>
CC: <balbi@ti.com>, <paulz@synopsys.com>, <dinh.linux@gmail.com>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 6/8] usb: dwc2: gadget: Do not fail probe if there
 isn't a clock node
Message-ID: <20141031174257.GA15756@saruman>
Reply-To: <balbi@ti.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-7-git-send-email-dinguyen@opensource.altera.com>
 <20141030140416.GF6482@saruman>
 <5453A8A6.6020800@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <5453A8A6.6020800@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 31, 2014 at 10:20:06AM -0500, Dinh Nguyen wrote:
> >> @@ -339,7 +339,8 @@ static void dwc2_handle_wakeup_detected_intr(struc=
t dwc2_hsotg *hsotg)
> >>  		}
> >>  		/* Change to L0 state */
> >>  		hsotg->lx_state =3D DWC2_L0;
> >> -		call_gadget(hsotg, resume);
> >> +		if (!IS_ERR(hsotg->clk))
> >> +			call_gadget(hsotg, resume);
> >=20
> > instead of exposing the clock detail to the entire driver, add IS_ERR()
> > checks to resume and suspend instead. In fact, NULL is a valid clock, so
> > you might as well:
> >=20
> > 	clk =3D clk_get(foo, bar);
> > 	if (IS_ERR(clk))
> > 		dwc->clk =3D NULL;
> > 	else
> > 		dwc->clk =3D clk;
> >=20
> > Then you don't need any IS_ERR() checks sprinkled around the driver.
>=20
> But we would still need to check for the clock before accessing gadget
> functionality right?
>=20
> 	if (dwc2->clk)
> 		call_gadget();

Read my comment again. "NULL is a valid clock".  Look at what
clk_enable() does when a NULL pointer is passed:

static int __clk_enable(struct clk *clk)
{
	int ret =3D 0;

	if (!clk)
		return 0;

	if (WARN_ON(clk->prepare_count =3D=3D 0))
		return -ESHUTDOWN;

	if (clk->enable_count =3D=3D 0) {
		ret =3D __clk_enable(clk->parent);

		if (ret)
			return ret;

		if (clk->ops->enable) {
			ret =3D clk->ops->enable(clk->hw);
			if (ret) {
				__clk_disable(clk->parent);
				return ret;
			}
		}
	}

	clk->enable_count++;
	return 0;
}

int clk_enable(struct clk *clk)
{
	unsigned long flags;
	int ret;

	flags =3D clk_enable_lock();
	ret =3D __clk_enable(clk);
	clk_enable_unlock(flags);

	return ret;
}
EXPORT_SYMBOL_GPL(clk_enable);

> >> @@ -400,7 +401,8 @@ static void dwc2_handle_usb_suspend_intr(struct dw=
c2_hsotg *hsotg)
> >>  			"DSTS.Suspend Status=3D%d HWCFG4.Power Optimize=3D%d\n",
> >>  			!!(dsts & DSTS_SUSPSTS),
> >>  			hsotg->hw_params.power_optimized);
> >> -		call_gadget(hsotg, suspend);
> >> +		if (!IS_ERR(hsotg->clk))
> >> +			call_gadget(hsotg, suspend);
> >>  	} else {
> >>  		if (hsotg->op_state =3D=3D OTG_STATE_A_PERIPHERAL) {
> >>  			dev_dbg(hsotg->dev, "a_peripheral->a_host\n");
> >> @@ -477,7 +479,8 @@ irqreturn_t dwc2_handle_common_intr(int irq, void =
*dev)
> >>  	spin_lock(&hsotg->lock);
> >> =20
> >>  	if (dwc2_is_device_mode(hsotg))
> >> -		retval =3D s3c_hsotg_irq(irq, dev);
> >> +		if (!IS_ERR(hsotg->clk))
> >> +			retval =3D s3c_hsotg_irq(irq, dev);
> >=20
> > wait a minute, if there is no clock we don't call the gadget interrupt
> > handler ? Why ? Who will disable the IRQ line ?
>=20
> This portion is no static int __clk_enable(struct clk *clk)

huh ? What I mean is that this has the potential of leaving that IRQ
line enabled. Imagine you don't have a clock and s3c_hsotg_irq() isn't
called, then a peripheral IRQ fires, since the handler isn't called, who
will clear the interrupt ?

--=20
balbi

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUU8ohAAoJEIaOsuA1yqREkUcP/RyOQHg+iz6D3DYuiacDhFyv
mjaDzHlJe1gYN5EMMpXbxNEAAOa+85DtFYdGrosMGWkwwnULJSP535hAk43btA+s
o28lzuU7fplggKs6P6z02X3kEbBLr2bvNbcSzNI2i+TdoUuMBbVHcTvX/gZKS8rw
2cqmDIISoBuOQPgJkvDdwNTrult5HeoKAEbniTbPfvEP9qkxKRerAbAI3j7N34D6
wHDJU4SeF/Pa6HGvW/M/RXEJuxR0hEY1LezZ3wcsPeWwx5HX0LzPsW8aO6RgfaaM
6ycE9Zjung3Qhw9ikezfGd4PiOpAMI+3AgL6Cv6x0CYRsBMIDEjyMGyP2Fg3udYq
6q70HQXoOs34RFt/mVBn8K9pzlgruKJYCNno/KHw75iv7fYy4R37jEca47ZrZZGI
LSP1d6JcARFxvbNJzBiZvWjJYiPGf4dpslZE5pQz1ck6aFck2t8j/PEG1f7ojfTs
NvmMLRzY/6WZdy6WCPIhO64PTsHdRjZ51UvTLeQgGv0iwHhNR/th3L82QTN2t2zr
s1l+5fXgv4SqXpr7hU8bwGMH2TRXsdFrM0egZgn2sYb3RWWWENuolmDrjqDfdWgw
pt0BPtpHRvtKPiu5oe7T2s13X5W2VQ5Ts0KqKNxymNnZxMiIO6L7jL2r8OKsjhcc
csMoRHqZmiYDwIQdrJoN
=ZTgf
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
