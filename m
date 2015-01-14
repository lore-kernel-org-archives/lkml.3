Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbbANWup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:50:45 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46934 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbbANWua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:50:30 -0500
Date: Wed, 14 Jan 2015 16:49:37 -0600
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
Message-ID: <20150114224937.GY16533@saruman>
Reply-To: <balbi@ti.com>
References: <20150114211434.GT16533@saruman>
 <Pine.LNX.4.44L0.1501141636590.1464-100000@iolanthe.rowland.org>
 <20150114214603.GU16533@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E03048450771B@US01WEMBX2.internal.synopsys.com>
 <20150114223941.GV16533@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E03048450774D@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OCeUrMLoh2ht7f6S"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E03048450774D@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OCeUrMLoh2ht7f6S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 14, 2015 at 10:45:26PM +0000, Paul Zimmerman wrote:
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Wednesday, January 14, 2015 2:40 PM
> >=20
> > On Wed, Jan 14, 2015 at 10:28:54PM +0000, Paul Zimmerman wrote:
> > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > Sent: Wednesday, January 14, 2015 1:46 PM
> > > >
> > > > On Wed, Jan 14, 2015 at 04:41:23PM -0500, Alan Stern wrote:
> > > > > > > > This is really, really odd. Register accesses are atomic, s=
o the lock
> > > > > > > > isn't really doing anything. Besides, you're calling
> > > > > > > > dwc2_is_controller_alive() from within the IRQ handler, so =
IRQs are
> > > > > > > > already disabled.
> > > > > > >
> > > > > > > Spinlocks sometimes do more than you think.  For instance, he=
re the
> > > > > > > lock prevents the register access from happening while some o=
ther CPU
> > > > > > > is holding the lock.  If a silicon quirk causes the register =
access to
> > > > > > > interfere with other activities, this could be important.
> > > > > >
> > > > > > readl() (which is used by dwc2_is_controller_alive()) adds a me=
mory
> > > > > > barrier to the register accesses, that should force all register
> > > > > > accesses the be correctly ordered.
> > > > >
> > > > > Memory barriers will order accesses that are all made on the same=
 CPU
> > > > > with respect to each other.  They do not order these accesses aga=
inst
> > > > > accesses made from another CPU -- that's why we have spinlocks.  =
:-)
> > > >
> > > > a fair point :-) The register is still read-only, so that shouldn't
> > > > matter either :-)
> > > >
> > > > > >  I fail to see how a silicon quirk
> > > > > > could cause this and if, indeed, it does, I'd be more comfortab=
le with a
> > > > > > proper STARS tickect number from synopsys :-s
> > > > >
> > > > > Maybe accessing this register somehow resets something else.  I d=
on't
> > > > > know.  It seems unlikely, but at least it explains how adding a
> > > > > spinlock could fix the problem.
> > > >
> > > > I would really need Paul (or someone at Synopsys) to confirm this
> > > > somehow. Maybe it has something to do with how the register is
> > > > implemented, dunno.
> > > >
> > > > Paul, do you have any idea what could cause this ? Could the HW into
> > > > some weird state if we read GSNPSID at random locations or when dat=
a is
> > > > being transferred, or anything like that ?
> > >
> > > Only thing I can think of is that there is some silicon bug in Robert=
's
> > > platform. But I am not aware of any STARs that mention accesses to the
> > > GSNPSID register as being problematic.
> > >
> > > Funny thing is, this code has been basically the same since at least
> > > November 2013. So I think some other recent change must have modified
> > > the timing of the register accesses, or something like that. But that=
's
> > > just handwaving, really.
> >=20
> > Alright, I'll apply this patch but for 3.20 with a stable tag as I have
> > already sent my last pull request to Greg. Unless someone has a really
> > big complaint about doing things as such.
>=20
> It should go to 3.19-rc shouldn't it? It's a fix, and Robert's platform
> is broken without it, IIUC.

It can also be categorized as "has-never-worked-before" before the code
has been like this forever. Since we don't really have a git bisect
result pointing to a commit that went in v3.19 merge window, I'm not
sure how I can convince myself that this absolutely needs to be in
v3.19.

At a minimum, I need a proper bisection with a proper commit being
blamed (even if it's a commit from months ago). From my point of view,
debugging of this "regression" has not been finalized and we're just
"assuming" it's caused by GSNPSID because moving that inside the
spin_lock seems to fix the problem.

--=20
balbi

--OCeUrMLoh2ht7f6S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtvKBAAoJEIaOsuA1yqREphQP/1ckgt5IRYroGCLOb0BXQVFK
hKlDG03v2IQaCQElAEaZFDE6q6Z2C2FOh0dCk1NGbmOihtbnKa0BLsJ1qFGm13Ni
DzIZyVQxYEkoXNB/+dUSodtDPYpwFbYXGDPHGx0MxG+k0Db1v+Pq31daOmHPzgR5
AGHL8xAGHbTtoMsArIokvbh9F68SucNjRMUNpHKxjVunwWPjaH8+TWOvebClzW0V
npoYqj8x1S8jkvC3a4BFcOvIMs4McJQlpxzTCBcOmiCFWmOAgyLR4tjr6pZJif8r
O4hNCNFfsZt7sPvDEPfHjoYyOijkrloIZ3TlhPSquIqQOvUK+XVzzbBeqaerkggm
6tiseQLz51rJIipLhj83vojt51EtlJYfxZdaXkKDC/dh/N3cybZNENN/hN2kBFhY
1HXJcqV3uh5mpY4ia1nxB0o1gpzh+nkhV7wct9tdgzUuHYMoS+FWRLtaZDJCstLw
KTFD2aRTs7ANhirEsOIehRE6Zqc5gczOuounYmDKT4Z3TA6vHGS8WEb0QCQIiFKq
rf/DNUrnUl5EdajNh47rC9Y/E02BXisqMZqzRHHv4Qz8HUswuGwJfJHZAk4JIsFH
Xzoi1/2s20YT8nPhkoRiGnh7IWrEiFEgPsizSNpukMRd/Hs/lsMm9PWXNYjZNXvD
mkcvjDbvJH7Zf0NIJpPz
=3MoA
-----END PGP SIGNATURE-----

--OCeUrMLoh2ht7f6S--
