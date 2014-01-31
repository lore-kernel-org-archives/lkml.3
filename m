Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaAaQrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 11:47:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48932 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbaAaQrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 11:47:17 -0500
Date: Fri, 31 Jan 2014 10:45:34 -0600
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <balbi@ti.com>, Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <ivan.khoronzhuk@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: keystone: switch to use runtime pm
Message-ID: <20140131164534.GL20736@saruman.home>
Reply-To: <balbi@ti.com>
References: <1391174426-13773-1-git-send-email-grygorii.strashko@ti.com>
 <20140131151955.GB20736@saruman.home>
 <52EBC499.2070302@ti.com>
 <20140131154721.GD20736@saruman.home>
 <52EBC650.50305@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p7S+EREVcBHk3zUG"
Content-Disposition: inline
In-Reply-To: <52EBC650.50305@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--p7S+EREVcBHk3zUG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2014 at 10:50:40AM -0500, Santosh Shilimkar wrote:
> On Friday 31 January 2014 10:47 AM, Felipe Balbi wrote:
> > On Fri, Jan 31, 2014 at 10:43:21AM -0500, Santosh Shilimkar wrote:
> >> On Friday 31 January 2014 10:19 AM, Felipe Balbi wrote:
> >>> Hi,
> >>>
> >>> On Fri, Jan 31, 2014 at 03:20:26PM +0200, Grygorii Strashko wrote:
> >>>> The Keystone PM management layer has been implemented using PM bus f=
or
> >>>> power management clocks. As result, most of Keystone drivers don't n=
eed
> >>>> to manage clocks directly. They just need to enable runtime PM and u=
se it
> >>>> to handle their PM state and clocks.
> >>>>
> >>>> Hence, remove clock management code and switch to use runtime PM.
> >>>>
> >>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >>>
> >>> quite a few weeks back I sent a series enabling runtime pm for all gl=
ue
> >>> layers. I'll use that version instead, sorry.
> >>>
> >> That should be fine but you need to drop clk_*() related code
> >> from that patch. I assume you will send refresh version of it then.
> >=20
> > why ? it makes no difference if you enable twice and disable twice.
> >=20
> Sure but why do you want to have the clock node handling code in drivers
> if it is not needed. Isn't that better ?

It might, but then way that I wanted to see it is so that I can make
assumptions about the device state. From a driver perspective, what I
would love to see is the ability to assume that when my probe gets
called the device is already enabled. So if you can make sure that
clk_enable() happens before my probe and that you call
pm_runtime_set_active() before my probe too, then I can more than
hapilly remove clk_* calls from the driver ;-)

either that or maintain the driver like so:

probe()
{
	...

	clk_get(dev, "fck");
	clk_prepare(clk);
	clk_enable(clk);
	pm_runtime_set_active(dev);
	pm_runtime_enable(dev);
	pm_runtime_get_sync(dev);
	...
}

runtime_suspend()
{
	clk_disable(dev);
}

runtime_resume()
{
	clk_enable(dev);
}

note that because of pm_runtime_set_active() that first
pm_runtime_get_sync() in probe() will simply increase the reference
counter without calling my ->runtime_resume() callback, which is exactly
what we want, as that would completely avoid situations of bad context
being restored because of that initial pm_runtime_get_sync().

Then, we can even make pm_runtime completely async easily, because
clk_prepare() was called only on probe() (or before it, for that
matter).

Bottomline is, if you can guarantee me that clk_get(), clk_prepare(),
clk_enable() and pm_runtime_set_active() will be called properly before
my probe, i'll be more than happy to comply with your request above as
that will greatly simplify my driver.

Just make, also, that if this clock is shared between dwc3-keystone
wrapper and dwc3 core, you clk_get() on both driver's probe.

cheers

--=20
balbi

--p7S+EREVcBHk3zUG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS69MuAAoJEIaOsuA1yqRESF8QAK5JPUe2oFKdXfY7xnQnqjKv
DX5KIYHswv+yxP1r/oj7D9VULPVp9KAh+Zwu+GOTv+u9fj0kXCIQ//MT7Nx1LP/4
jnQqI1mZtl1nVE0MMOgN9aGgmaqk78QmOjZlxat4lXZG32LaWOyLMEZga97EyI+t
jP3PPt8i5Xma1y+Y18WkwrKqSgN1JW4hmDL6aEGvvu3VVZJDGP5qbnMuuJPkWxE4
8yDpmCGlHtHlauyKiF2n0HIIJq6qnJ0IeEzCusKyxIDamMvmCzAZaqurUG5BBk/g
lT7atAdShIpeYbiX1G2LZOZLjNxqYf6PvUMnW3FC2nGfjMg1TC3WCf+wOse24UzR
mBDheYj3/uMeZ3TL7kz7OEImnqdTbwgkde85T+NFYwJv99FwXrN0pEJ+Gb4tFMo5
JDgGeYiWo/etKNY1Zp+Go5X1R8OfMwI0VaMKbLBJD/GzbQUgO/+R3OYaq38Llsi6
LvtihhdE03pppQ4ZBDCP/My8QN/V90YabwcoZb9bF+y5XTaFb9QDZ+0UczYJepRn
T0uAkLCZv9TJBPe65c1CTue7fwqa7B+yj+utorMLZnWDmuCMxgP0+ZTDPZ7pgbvP
mFY7kglEwd5KdSNNMnfeyea+r/yEq04mktbvGJ+D1nFbyqfgFKEMw2iSkuHp5ClF
b/7EQWZFuovy7t0QqOrK
=29hU
-----END PGP SIGNATURE-----

--p7S+EREVcBHk3zUG--
