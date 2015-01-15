Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbbAOGZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 01:25:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36763 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbbAOGZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 01:25:32 -0500
Date: Thu, 15 Jan 2015 00:24:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Robert Baldyga <r.baldyga@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yousaf.kaukab@intel.com" <yousaf.kaukab@intel.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
Message-ID: <20150115062436.GA6615@saruman>
Reply-To: <balbi@ti.com>
References: <20150114211434.GT16533@saruman>
 <Pine.LNX.4.44L0.1501141636590.1464-100000@iolanthe.rowland.org>
 <20150114214603.GU16533@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E03048450771B@US01WEMBX2.internal.synopsys.com>
 <20150114223941.GV16533@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E03048450774D@US01WEMBX2.internal.synopsys.com>
 <20150114224937.GY16533@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E030484507789@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030484507789@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 14, 2015 at 11:04:27PM +0000, Paul Zimmerman wrote:
> > > > > > > > > > This is really, really odd. Register accesses are atomi=
c, so the lock
> > > > > > > > > > isn't really doing anything. Besides, you're calling
> > > > > > > > > > dwc2_is_controller_alive() from within the IRQ handler,=
 so IRQs are
> > > > > > > > > > already disabled.
> > > > > > > > >
> > > > > > > > > Spinlocks sometimes do more than you think.  For instance=
, here the
> > > > > > > > > lock prevents the register access from happening while so=
me other CPU
> > > > > > > > > is holding the lock.  If a silicon quirk causes the regis=
ter access to
> > > > > > > > > interfere with other activities, this could be important.
> > > > > > > >
> > > > > > > > readl() (which is used by dwc2_is_controller_alive()) adds =
a memory
> > > > > > > > barrier to the register accesses, that should force all reg=
ister
> > > > > > > > accesses the be correctly ordered.
> > > > > > >
> > > > > > > Memory barriers will order accesses that are all made on the =
same CPU
> > > > > > > with respect to each other.  They do not order these accesses=
 against
> > > > > > > accesses made from another CPU -- that's why we have spinlock=
s.  :-)
> > > > > >
> > > > > > a fair point :-) The register is still read-only, so that shoul=
dn't
> > > > > > matter either :-)
> > > > > >
> > > > > > > >  I fail to see how a silicon quirk
> > > > > > > > could cause this and if, indeed, it does, I'd be more comfo=
rtable with a
> > > > > > > > proper STARS tickect number from synopsys :-s
> > > > > > >
> > > > > > > Maybe accessing this register somehow resets something else. =
 I don't
> > > > > > > know.  It seems unlikely, but at least it explains how adding=
 a
> > > > > > > spinlock could fix the problem.
> > > > > >
> > > > > > I would really need Paul (or someone at Synopsys) to confirm th=
is
> > > > > > somehow. Maybe it has something to do with how the register is
> > > > > > implemented, dunno.
> > > > > >
> > > > > > Paul, do you have any idea what could cause this ? Could the HW=
 into
> > > > > > some weird state if we read GSNPSID at random locations or when=
 data is
> > > > > > being transferred, or anything like that ?
> > > > >
> > > > > Only thing I can think of is that there is some silicon bug in Ro=
bert's
> > > > > platform. But I am not aware of any STARs that mention accesses t=
o the
> > > > > GSNPSID register as being problematic.
> > > > >
> > > > > Funny thing is, this code has been basically the same since at le=
ast
> > > > > November 2013. So I think some other recent change must have modi=
fied
> > > > > the timing of the register accesses, or something like that. But =
that's
> > > > > just handwaving, really.
> > > >
> > > > Alright, I'll apply this patch but for 3.20 with a stable tag as I =
have
> > > > already sent my last pull request to Greg. Unless someone has a rea=
lly
> > > > big complaint about doing things as such.
> > >
> > > It should go to 3.19-rc shouldn't it? It's a fix, and Robert's platfo=
rm
> > > is broken without it, IIUC.
> >=20
> > It can also be categorized as "has-never-worked-before" before the code
> > has been like this forever. Since we don't really have a git bisect
> > result pointing to a commit that went in v3.19 merge window, I'm not
> > sure how I can convince myself that this absolutely needs to be in
> > v3.19.
> >=20
> > At a minimum, I need a proper bisection with a proper commit being
> > blamed (even if it's a commit from months ago). From my point of view,
> > debugging of this "regression" has not been finalized and we're just
> > "assuming" it's caused by GSNPSID because moving that inside the
> > spin_lock seems to fix the problem.
>=20
> On further investigation, I was wrong about "this code has been
> basically the same since at least November 2013". Prior to commit
> db8178c33db "usb: dwc2: Update common interrupt handler to call gadget
> interrupt handler" from November 2014, the gadget interrupt handler
> did not read from the GSNPSID register.

right, but the common IRQ always did. So unless Robert's SoC has always
been used only for peripheral, then I agree with you that behavior did,
in fact, change.

> So likely the bug in Robert's hardware has been there all along, and
> that commit just caused it to manifest itself.

Robert, out of curiosity, which SoC are you using ? Is it UP or SMP ?

I guess we need a mention on commit log that at least SoC XYZ is known
to break unless the register access is done with locks held.

--=20
balbi

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUt10kAAoJEIaOsuA1yqREevcQAK2/st3AabOvFGrCdFiZeUzT
Ab/HTp1HteuqnfHuWuQZaDHFMZccuUfBYCjbFxGkmXYl510r7LUSRFy+1tC1UH3u
9ii9dK3QQjnCaIcZW4iWtsjsBC8SD2+vMnYlNdwjKXUoJdCyi2oDhN7yfmidDmjq
8TkmRSqCfrkdJiQp6EDDjN/pAcTDo4vACsT1x03Vsv2imOY1EozXDf3FO0rQGSda
F31ohkECsEm1//+3wjJY5w8Sw8u48oEvDZOuPSqt1hJQs9O3I+3X1DNykjBYm27Z
C1RyUE7mL14BZsf7L34izoi7b1fFNTRGy6UgBZn+Dy6gVr5BAgNJMxPHRXtbvj72
dj3fzAlSsIgoVauVcrs49hyYI99owvgWSZkZh3qH3WJmXRllA19AmoQW2xrpH0pW
3rM+wh+uYLcE7FTO6uXDzgTjTmY/ilXi9EIR4L/jBd+dzA99cz3MBMivoVNbMSUq
3/MjnmAeJLgmJGkTn04n7Zx3Ce+NHwLnJUv/bKpy7r9ZcPcwEcBeGKkfvKsDRzWU
Xy72K5eWcx/uA0mGhOz42kpobNWndrzLNkSXtYwGY+A2p0hxxvnbWR9l9ZlvJa/N
HOp2NpFkzz79SuBLnajvmdiL0kIPf02ndUBW00oGU0+b5rI28Q999Uz/kKLjprCO
x3veDAYitWs1NSvrPzc9
=ojKz
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
