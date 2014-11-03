Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaKCP2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:28:46 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55388 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbaKCP2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:28:41 -0500
Date: Mon, 3 Nov 2014 09:25:43 -0600
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
Message-ID: <20141103152543.GC27425@saruman>
Reply-To: <balbi@ti.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-7-git-send-email-dinguyen@opensource.altera.com>
 <20141030140416.GF6482@saruman>
 <5453A8A6.6020800@opensource.altera.com>
 <20141031174257.GA15756@saruman>
 <5453E393.3090505@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
Content-Disposition: inline
In-Reply-To: <5453E393.3090505@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 31, 2014 at 02:31:31PM -0500, Dinh Nguyen wrote:
> On 10/31/2014 12:42 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Oct 31, 2014 at 10:20:06AM -0500, Dinh Nguyen wrote:
> >>>> @@ -339,7 +339,8 @@ static void dwc2_handle_wakeup_detected_intr(str=
uct dwc2_hsotg *hsotg)
> >>>>  		}
> >>>>  		/* Change to L0 state */
> >>>>  		hsotg->lx_state =3D DWC2_L0;
> >>>> -		call_gadget(hsotg, resume);
> >>>> +		if (!IS_ERR(hsotg->clk))
> >>>> +			call_gadget(hsotg, resume);
> >>>
> >>> instead of exposing the clock detail to the entire driver, add IS_ERR=
()
> >>> checks to resume and suspend instead. In fact, NULL is a valid clock,=
 so
> >>> you might as well:
> >>>
> >>> 	clk =3D clk_get(foo, bar);
> >>> 	if (IS_ERR(clk))
> >>> 		dwc->clk =3D NULL;
> >>> 	else
> >>> 		dwc->clk =3D clk;
> >>>
> >>> Then you don't need any IS_ERR() checks sprinkled around the driver.
> >>
> >> But we would still need to check for the clock before accessing gadget
> >> functionality right?
> >>
> >> 	if (dwc2->clk)
> >> 		call_gadget();
> >=20
> > Read my comment again. "NULL is a valid clock".  Look at what
> > clk_enable() does when a NULL pointer is passed:
> >=20
> > static int __clk_enable(struct clk *clk)
> > {
> > 	int ret =3D 0;
> >=20
> > 	if (!clk)
> > 		return 0;
> >=20
> > 	if (WARN_ON(clk->prepare_count =3D=3D 0))
> > 		return -ESHUTDOWN;
> >=20
> > 	if (clk->enable_count =3D=3D 0) {
> > 		ret =3D __clk_enable(clk->parent);
> >=20
> > 		if (ret)
> > 			return ret;
> >=20
> > 		if (clk->ops->enable) {
> > 			ret =3D clk->ops->enable(clk->hw);
> > 			if (ret) {
> > 				__clk_disable(clk->parent);
> > 				return ret;
> > 			}
> > 		}
> > 	}
> >=20
> > 	clk->enable_count++;
> > 	return 0;
> > }
> >=20
> > int clk_enable(struct clk *clk)
> > {
> > 	unsigned long flags;
> > 	int ret;
> >=20
> > 	flags =3D clk_enable_lock();
> > 	ret =3D __clk_enable(clk);
> > 	clk_enable_unlock(flags);
> >=20
> > 	return ret;
> > }
> > EXPORT_SYMBOL_GPL(clk_enable);
>=20
> Ah yes, thanks for the explanation. So if clk=3DNULL, it just return 0.
> But what I'm saying is that if the driver is configured for dual-role
> mode, and no clock is specified, then the driver should not be accessing
> any gadget functionality.

why ? Why only for gadget and why can't it work on platforms without
clk? What if Paul wants to run the gadget side on his HAPS-5x platform
configured as a PCIe card ?

You haven't explained why gadget has this hard-dependency on clk and why
*only* gadget has it. This sounds really, really wrong. Why can host
side run without clk but gadget can't ?

Moreover, if you really want to prevent people from using gadget
without clock, fail dwc2_gadget_init() and have the core fallback to
host-only, then print a warning message.

> So as the patch series stands right now, if I swap out an A connector to
> a B-connector, then I get a connect_id_status change interrupt. The
> status would show a device and I would initialize the gadget portion of
> the driver.

that's fine, but why the hard-dependency on clk ?

> diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
> index 44c609f..96810f7 100644
> --- a/drivers/usb/dwc2/hcd.c
> +++ b/drivers/usb/dwc2/hcd.c
> @@ -1371,7 +1371,8 @@ static void dwc2_conn_id_status_change(struct
> work_struct *work)
>                 hsotg->op_state =3D OTG_STATE_B_PERIPHERAL;
>                 dwc2_core_init(hsotg, false, -1);
>                 dwc2_enable_global_interrupts(hsotg);
> -               s3c_hsotg_core_init(hsotg);
> +               if (hsotg->clk)
> +                       s3c_hsotg_core_init(hsotg);
>=20
> So if I don't have a valid clock, I'll be accessing the peripheral
> portion of the IP.

so what ?

> But I guess not having the check for the valid clock here should be fine
> as I don't see a case where there can be 2 different clocks for host and
> peripheral?

probably the same thing.

> >>>> @@ -400,7 +401,8 @@ static void dwc2_handle_usb_suspend_intr(struct =
dwc2_hsotg *hsotg)
> >>>>  			"DSTS.Suspend Status=3D%d HWCFG4.Power Optimize=3D%d\n",
> >>>>  			!!(dsts & DSTS_SUSPSTS),
> >>>>  			hsotg->hw_params.power_optimized);
> >>>> -		call_gadget(hsotg, suspend);
> >>>> +		if (!IS_ERR(hsotg->clk))
> >>>> +			call_gadget(hsotg, suspend);
> >>>>  	} else {
> >>>>  		if (hsotg->op_state =3D=3D OTG_STATE_A_PERIPHERAL) {
> >>>>  			dev_dbg(hsotg->dev, "a_peripheral->a_host\n");
> >>>> @@ -477,7 +479,8 @@ irqreturn_t dwc2_handle_common_intr(int irq, voi=
d *dev)
> >>>>  	spin_lock(&hsotg->lock);
> >>>> =20
> >>>>  	if (dwc2_is_device_mode(hsotg))
> >>>> -		retval =3D s3c_hsotg_irq(irq, dev);
> >>>> +		if (!IS_ERR(hsotg->clk))
> >>>> +			retval =3D s3c_hsotg_irq(irq, dev);
> >>>
> >>> wait a minute, if there is no clock we don't call the gadget interrupt
> >>> handler ? Why ? Who will disable the IRQ line ?
> >>
> >> This portion is no static int __clk_enable(struct clk *clk)
> >=20
> > huh ? What I mean is that this has the potential of leaving that IRQ
> > line enabled. Imagine you don't have a clock and s3c_hsotg_irq() isn't
> > called, then a peripheral IRQ fires, since the handler isn't called, who
> > will clear the interrupt ?
> >=20
>=20
> Yes, right. This portion of the code is no longer needed when I switched
> to use a shared IRQ.

k

--=20
balbi

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV553AAoJEIaOsuA1yqRE1+gP/3NelQA6fHLfANP1CLjEAt4D
YkU9oIUdO959ZfIW1uwJtriUtx28LoTwi4q3VTAek0poj+dgGsMdgWC6ftURMncT
2xrWB+Td4MZoPxbBvWfoPgnoLai+gN7KEYRa62aUe9HSVuxe7w0Rxp/YBgCgQZNe
wl3WNfrMkPBi2z3lyLxyAT6MmerF4QRy9eD563Zry8/HkGwLmsMbt2UY1qkU9GIr
9Uey+khhi3wcGiAngrYJLVYQ2ulRnN7xZ524iHXpuAl5H6WIsKb2alrfMu8VYCNz
ZYB52MwPVSVDy4d5jx+H8Uz/ykVg1oB2W9UL45YIR7Ec3u3as1bBRGx3+alakoKS
TIPo/XfhSTV6s2QuhkDI/nzgJ4vrqY3zyHjZtPQYKWnV6B2B/PBsGwPXczU4ThGb
fSpBUll/fyO5RBEDdm0LC/Zqbly1fDiNosccPbRk0w19SOrAUjMx8t3A7WfnnKNB
kSVKM4wSS7htr/oaiEAw6XlZdyxUEGVivS4MBxVUhRKc0fm/GJhfRWqm9Yr/gwy0
KzdgkI2Fc/6w7mv2wOio6Osi4PMTsxlqYWQUZdBNDbfeOWNe1HtwqAX9SmOtyysJ
aepm3NGB3XJnlzavyxGlND90ZWIw5gM5J7ZlKBFN0YoSfog5OFgmpSlkXmRNE5Bu
1Cmg/MLBvahbegedzY+x
=NCMt
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--
