Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaJXUIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:08:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36679 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaJXUIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:08:16 -0400
Date: Fri, 24 Oct 2014 15:07:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: remove redundant irq disable at halt and restart
Message-ID: <20141024200727.GH11455@saruman>
Reply-To: <balbi@ti.com>
References: <1414177592-14547-1-git-send-email-johan@kernel.org>
 <20141024191627.GA11455@saruman>
 <20141024192111.GC11455@saruman>
 <20141024192845.GC19377@localhost>
 <20141024194250.GF11455@saruman>
 <20141024195029.GE19377@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQR6quUbZ63TTuTU"
Content-Disposition: inline
In-Reply-To: <20141024195029.GE19377@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xQR6quUbZ63TTuTU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 09:50:29PM +0200, Johan Hovold wrote:
> On Fri, Oct 24, 2014 at 02:42:50PM -0500, Felipe Balbi wrote:
> > On Fri, Oct 24, 2014 at 09:28:45PM +0200, Johan Hovold wrote:
> > > On Fri, Oct 24, 2014 at 02:21:11PM -0500, Felipe Balbi wrote:
> > > > On Fri, Oct 24, 2014 at 02:16:27PM -0500, Felipe Balbi wrote:
> > > > > On Fri, Oct 24, 2014 at 09:06:32PM +0200, Johan Hovold wrote:
> > > > > > Remove redundant local_irq_disable() at machine halt and restar=
t.
> > > > > >=20
> > > > > > Since commit 44424c34049f ("ARM: 7803/1: Fix deadlock scenario =
with
> > > > > > smp_send_stop()") interrupts are disabled before stopping secon=
dary
> > > > > > CPUs.
> > > > >=20
> > > > > Assuming this is correct, you should have:
> > > > >=20
> > > > > Fixes: 44424c3 (ARM: 7803/1: Fix deadlock scenario with smp_send_=
stop())
> > > > > Cc: <stable@vger.kernel.org> # v3.12+
> > >=20
> > > It's not a bug. Just a redundant disabling of already disabled
> > > interrupts, something which could possibly lead someone to believe th=
at
> > > interrupts could be re-enabled by the power-off handler.
>=20
> I meant re-enabled by arm_pm_restart().
>=20
> > I didn't dig any of this out but I'll assume you did :-) So I withdraw
> > my comment ;-)
> >=20
> > > > > > diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/proces=
s.c
> > > > > > index a35f6ebbd2c2..5663ab57cf07 100644
> > > > > > --- a/arch/arm/kernel/process.c
> > > > > > +++ b/arch/arm/kernel/process.c
> > > > > > @@ -195,7 +195,6 @@ void machine_halt(void)
> > > > > >  	local_irq_disable();
> > > > > >  	smp_send_stop();
> > > > > > =20
> > > > > > -	local_irq_disable();
> > > > > >  	while (1);
> > > > > >  }
> > > > > > =20
> > > > > > @@ -237,7 +236,6 @@ void machine_restart(char *cmd)
> > > > > > =20
> > > > > >  	/* Whoops - the platform was unable to reboot. Tell the user!=
 */
> > > > > >  	printk("Reboot failed -- System halted\n");
> > > > > > -	local_irq_disable();
> > > > >=20
> > > > > ... but wouldn't this reintroduce the the buck which that commit =
fixed ?
> > > >=20
> > > > s/buck/bug :-) my fingers have a mind of their own, aparently.
> > >=20
> > > :)
> > >=20
> > > No, the interrupts would still be disabled.
> >=20
> > alright... so far I couldn't find where IRQs are disable before
> > machine_power_off() is called. Starting a do_poweroff(), couldn't find
> > it... Oh well, I'll keep digging.
>=20
> It's done a few lines above in the same function. ;)
>=20
> void machine_restart(char *cmd)
> {
>         local_irq_disable();
> 	^^^
>         smp_send_stop();
>=20
>         arm_pm_restart(reboot_mode, cmd);
>=20
>         /* Give a grace period for failure to restart of 1s */
>         mdelay(1000);
>=20
>         /* Whoops - the platform was unable to reboot. Tell the user! */
>         printk("Reboot failed -- System halted\n");
>         local_irq_disable();
>         while (1);
> }
>=20
> [ and similarly in machine_power_off(). ]

oh, now I get it :-) Nevermind, I completely missed that it was
duplicated. My bad.

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--xQR6quUbZ63TTuTU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSrF/AAoJEIaOsuA1yqREEcEP/RyjAoEi5m0ZrEjG6io9tctS
OxHfnYtNII97aE8w1NCTSQyxO/Yc4kXL9l86OsQ/p8FVzalC608mrCO0g7VGp67s
aBC+/ZvpdJ7WhXhd90EJ8GuKhZB0dA2yrwZESVu7nx576Z//TW/cAU1hGVxDM4b5
njOQ6YwxzjpMv8WIFgRYDcecp6xe7s4CwV9zoQ6Yfg6P4hFL831RNY/BCYiNVVaF
mF7obgZTjUvEjSJBGTy5uQo/J9NymDOh395ppPKQpFlqqxBC6/qI1KFNOJByPTHj
GgA7EFEJDGJY6aQT57/NcxzmdC3S3cTxSQfZElEse2LPegS4EXKHIiSw8+uhRTmk
K9iGkCX7N4YWtDdbDzUjFFog7SZsTcZ3o/FETXxgtevgVE336m3MZJRfX0AvMs7X
oUlole6n5Naco2uVE+K2KfNSaQHMJm3omR5PoJMGDLd7nJeFN9LA9qcjJKe1KXou
2IOypy7XZaJeMYvyNkPKRvA2mWTweDBJ/RjJu7ysNH+qT/WCyKycGN2kWdnIwMTU
IJgYeQ/gbUrGX17tM139eDTSfk4x+VKcWICJS6bxI5MQFJoBESdikmSCKyoPgMp0
7ow36MxuoD6i5io6oYgf+WFLV/cjMO8t0p+0XPiUfd5zAi1vWjTsk/U07vypULSW
YhW99Dt58oRhXDg2VDH2
=vISh
-----END PGP SIGNATURE-----

--xQR6quUbZ63TTuTU--
