Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbbANWkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:40:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49497 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbbANWkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:40:37 -0500
Date: Wed, 14 Jan 2015 16:39:41 -0600
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
Message-ID: <20150114223941.GV16533@saruman>
Reply-To: <balbi@ti.com>
References: <20150114211434.GT16533@saruman>
 <Pine.LNX.4.44L0.1501141636590.1464-100000@iolanthe.rowland.org>
 <20150114214603.GU16533@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E03048450771B@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LqbCLdmouU4wLANe"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E03048450771B@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LqbCLdmouU4wLANe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 10:28:54PM +0000, Paul Zimmerman wrote:
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Wednesday, January 14, 2015 1:46 PM
> >=20
> > On Wed, Jan 14, 2015 at 04:41:23PM -0500, Alan Stern wrote:
> > > > > > This is really, really odd. Register accesses are atomic, so th=
e lock
> > > > > > isn't really doing anything. Besides, you're calling
> > > > > > dwc2_is_controller_alive() from within the IRQ handler, so IRQs=
 are
> > > > > > already disabled.
> > > > >
> > > > > Spinlocks sometimes do more than you think.  For instance, here t=
he
> > > > > lock prevents the register access from happening while some other=
 CPU
> > > > > is holding the lock.  If a silicon quirk causes the register acce=
ss to
> > > > > interfere with other activities, this could be important.
> > > >
> > > > readl() (which is used by dwc2_is_controller_alive()) adds a memory
> > > > barrier to the register accesses, that should force all register
> > > > accesses the be correctly ordered.
> > >
> > > Memory barriers will order accesses that are all made on the same CPU
> > > with respect to each other.  They do not order these accesses against
> > > accesses made from another CPU -- that's why we have spinlocks.  :-)
> >=20
> > a fair point :-) The register is still read-only, so that shouldn't
> > matter either :-)
> >=20
> > > >  I fail to see how a silicon quirk
> > > > could cause this and if, indeed, it does, I'd be more comfortable w=
ith a
> > > > proper STARS tickect number from synopsys :-s
> > >
> > > Maybe accessing this register somehow resets something else.  I don't
> > > know.  It seems unlikely, but at least it explains how adding a
> > > spinlock could fix the problem.
> >=20
> > I would really need Paul (or someone at Synopsys) to confirm this
> > somehow. Maybe it has something to do with how the register is
> > implemented, dunno.
> >=20
> > Paul, do you have any idea what could cause this ? Could the HW into
> > some weird state if we read GSNPSID at random locations or when data is
> > being transferred, or anything like that ?
>=20
> Only thing I can think of is that there is some silicon bug in Robert's
> platform. But I am not aware of any STARs that mention accesses to the
> GSNPSID register as being problematic.
>=20
> Funny thing is, this code has been basically the same since at least
> November 2013. So I think some other recent change must have modified
> the timing of the register accesses, or something like that. But that's
> just handwaving, really.

Alright, I'll apply this patch but for 3.20 with a stable tag as I have
already sent my last pull request to Greg. Unless someone has a really
big complaint about doing things as such.

--=20
balbi

--LqbCLdmouU4wLANe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtvAtAAoJEIaOsuA1yqREhEkP/irqvvecH71DMz7OMql6Q6Eg
fVLL6WZSJTeIepc1fSeKt3xBzC7TtflLV9fBsJYaIezwoPcL316q1aQHEQo5CF65
jZer0GggGvmBItikP3OMcrlmQhHlAWNHAAh7MSvnu3/KVCLIrQqvd0WzrpnyCOK3
Af/08hww3gUNSP4FRRXsAoa3OYFbFGvRQ+aiJ/zQs6e461u1g2lZUxpiSE8VA07Q
pWmFHoJOQcSRsvNNGStJJJMWb39+fz8Nz6NCHG70RMjwr6fjpFfW/6znr07LiOYq
9pl1BJl4e3MfqT6F0Aq6zX0fBBkD+7T20VNB4lrK3SNeqRgpOSo3qlQ8aAUsQNxB
I40l6LKRKuEeagk9aSyP1p+r/vxmiC5UCFI9C5x2fnkjwvp8OZvLomluUPW3ITEM
pZSgweo3DtlyU3rEZGQkBZkk4Zsjhxe7PT5+Ozs/mk59+AQrfDwo1o2ndkvC2JPb
I4lpHgONhcXxOclLBcHI+1YQPiUCDad3EnirUjFXHNw8B3ADEXFrnI0l37WDLrql
gDNzh5r2XcwT4C5ETNnFtlzz2HLuhHdT1C2t2y3E1dYlWq2We747qc/3dZdxx29B
BaBKo3lgcic27UqWYVIMhCEpA5LsGZNdkmdOCL+UxrDmEhdBuLpAIZfFSLT/1f6U
DPMMeJs1EF1n5tNvzH2W
=QycB
-----END PGP SIGNATURE-----

--LqbCLdmouU4wLANe--
