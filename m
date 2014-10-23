Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaJWSyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:54:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48018 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaJWSyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:54:06 -0400
Date: Thu, 23 Oct 2014 13:52:47 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        <nsekhar@ti.com>, <t-kristo@ti.com>, <j-keerthy@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/12] rtc: omap: restore irq state after reading TC
 registers
Message-ID: <20141023185247.GB21407@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-9-git-send-email-johan@kernel.org>
 <20141010180225.GT31348@saruman>
 <20141011101201.GC18988@localhost>
 <20141012004758.GB21128@saruman>
 <20141022105011.GN2113@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <20141022105011.GN2113@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 12:50:11PM +0200, Johan Hovold wrote:
> On Sat, Oct 11, 2014 at 07:47:58PM -0500, Felipe Balbi wrote:
> > On Sat, Oct 11, 2014 at 12:12:01PM +0200, Johan Hovold wrote:
> > > On Fri, Oct 10, 2014 at 01:02:31PM -0500, Felipe Balbi wrote:
> > > > Hi,
> > > >=20
> > > > On Thu, Oct 09, 2014 at 09:06:30PM +0200, Johan Hovold wrote:
> > > > > Make sure to restore local irq state when reading the timer/calen=
dar
> > > > > (TC) registers, so that omap_rtc_read_time() can be called with
> > > > > interrupts disabled.
> > > > >=20
> > > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > > > ---
> > > > >  drivers/rtc/rtc-omap.c | 6 ++++--
> > > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > >=20
> > > > > diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> > > > > index 0ef016553a97..62e2e9a9887a 100644
> > > > > --- a/drivers/rtc/rtc-omap.c
> > > > > +++ b/drivers/rtc/rtc-omap.c
> > > > > @@ -239,8 +239,10 @@ static void bcd2tm(struct rtc_time *tm)
> > > > > =20
> > > > >  static int omap_rtc_read_time(struct device *dev, struct rtc_tim=
e *tm)
> > > > >  {
> > > > > +	unsigned long flags;
> > > > > +
> > > > >  	/* we don't report wday/yday/isdst ... */
> > > > > -	local_irq_disable();
> > > > > +	local_irq_save(flags);
> > > >=20
> > > > you should really convert these to a real spin_lock_irq*(), that's
> > > > because local_irq* do not get re-written with RT patchset, so this
> > > > pretty much "breaks" RT.
> > >=20
> > > The driver uses local_irq* throughout to guarantee registers are not
> > > read or written during an update event.
> > >=20
> > > In fact, at least on AM33xx, this is not even necessary when reading =
(as
> > > opposed to writing) the TC registers, but I did not dare change that
> > > without knowing how the legacy platforms work in this respect.
> > >=20
> > > Do you suggest doing this conversion as part of, or on top of, this
> > > series?
> >=20
> > probably on top of is. Safer that way.
>=20
> I didn't include this conversion in v2 as you may have noticed. In fact,
> I'm not even sure it should be done.
>=20
> Using local_irq* "breaks" RT, but if we change it to spin_lock_irq* and
> RT preempts us, we may miss the 15us access window which would break the
> driver:
>=20
> 	"If the ARM accesses the TC registers outside of the access
> 	 period, then the access is not guaranteed."
>=20
> On am33xx this only affects updating the TC (timer/calendar) or alarm
> registers, but the driver currently disables interrupts also on reading
> the time (possibly because the early IP revisions did not have the
> shadow read registers).

that's alright, better not to change the behavior in this case. But as a
future patch, you might want to convert this to a raw_spinlock. That
won't get preempted.

--=20
balbi

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSU5/AAoJEIaOsuA1yqRE6f8QAKZrfi0zty3h+uHjFdm3aHFA
6qh7bjLtJkLFxcCiMG1ZchkyQSbeYY/3hEmv8YjrsFKj+WHohw5yNP6ZDbmCftyt
eflAhFgjnjm+8XtO763PX10O7OFUJWu4sibsj81KbBV4i/bL5NcbI4NKJOmUYBoD
IUXO3bbqIXbeCmcMFkghGf8QMHrmDcAKQMtfdwAe53KtlY3bTPoSPk5uUsS+EwMY
ULlo4d/TKb5ol0jPnDlBw/fQ8rCcSJYdKdzQKnH5TQ+qLbA+9JLdHQLcBnirr9yC
pkDbnA3BOWHfvnrMmsAzpFtP479XPXhlv8anYjgT8qcw7gJv0La1zBXDBR4zwiiJ
3olgs7/yV83T8Y4tQyuY5sPQbpwqsh/dJo1Hel4Ljq6m+MuBexSo/1g1IBWEE9Qv
5G1NgKklvev6Q2uhio3Ly2u4bWPmQBwQy45OzGzSFrc5nHG9UxJJz0yaQspLabW/
NpRzv7GE2Vs30Tx0hrcxP96HhMKy8Sn6tSEWrdMzzVOHbzKg6LJmT4LqIZP4A1fN
k2YAbiGByZztbMvpfSOCrw3TNcayjy2Pw3NL2iCdnVp00UJSpundZBqF3nIo+yIc
B6GEmZP1z1EALh12odtFC0Z0C91X/tzvguRK+Yp+m7XHobpwNg/sykwLUdu7iku7
E9hynAD3kQcuwvbVKqY2
=6iin
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
