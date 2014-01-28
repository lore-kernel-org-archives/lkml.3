Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaA1QcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:32:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54999 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbaA1QcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:32:15 -0500
Date: Tue, 28 Jan 2014 10:30:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        <george.cherian@ti.com>, <rogerq@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: dwc3: core: continue probing if usb phy library
 returns -ENODEV/-ENXIO
Message-ID: <20140128163036.GD28546@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
 <1390299099-14764-1-git-send-email-kishon@ti.com>
 <20140121144725.GF30451@saruman.home>
 <20140127150855.GA17928@xps8300>
 <20140127160458.GF13268@saruman.home>
 <20140128153230.GA20991@xps8300>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EXKGNeO8l0xGFBjy"
Content-Disposition: inline
In-Reply-To: <20140128153230.GA20991@xps8300>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 28, 2014 at 05:32:30PM +0200, Heikki Krogerus wrote:
> On Mon, Jan 27, 2014 at 10:05:20AM -0600, Felipe Balbi wrote:
> > > Why would you need to know if the PHY drivers are needed or not
> > > explicitly in your controller driver?
> >=20
> > because, one way or another, they all do need it. Except for quirky ones
> > like AM437x where a USB3 IP was hardwired into USB2-only mode, so it
> > really lacks a USB3 PHY.
>=20
> The Baytrail board I deal with has completely autonomous PHYs. But my
> question is, why would you need to care about the PHYs in your
> controller driver? Why can't you leave the responsibility of them to
> the upper layers and trust what they tell you?
>=20
> If there is no USB3 PHY for dwc3 then, the driver gets something like
> -ENODEV and just continues. There is no need to know about the
> details.

it's a little more complicated than that. We could get -EPROBE_DEFER
meaning we should try probing at a later time because the PHY isn't
available yet.

But sure, if we can very easily differentiate between those two
conditions in a way that error report from PHY layer (whichever it is),
then we can certainly do that.

> For the controller drivers the PHYs are just a resource like any
> other. The controller drivers can't have any responsibility of
> them. They should not care if PHY drivers are available for them or
> not, or even if the PHY framework is available or not.

huh? If memory isn't available you don't continue probing, right ? If
your IORESOURCE_MEM is missing, you also don't continue probing, if your
IRQ line is missing, you bail too. Those are also nothing but resources
to the driver, what you're asking here is to treat PHY as a _different_
resource; which might be fine, but we need to make sure we don't
continue probing when a PHY is missing in a platform that certainly
needs a PHY.

> > > > But I really want to see the argument against using no-op. As far a=
s I
> > > > could see, everybody needs a PHY driver one way or another, some
> > > > platforms just haven't sent any PHY driver upstream and have their =
own
> > > > hacked up solution to avoid using the PHY layer.
> > >=20
> > > Not true in our case. Platforms using Intel's SoCs and chip sets may
> > > or may not have controllable USB PHY. Quite often they don't. The
> > > Baytrails have usually ULPI PHY for USB2, but that does not mean they
> > > provide any vendor specific functions or any need for a driver in any
> > > case.
> >=20
> > that's different from what I heard.
>=20
> I don't know where you got that impression, but it's not true. The
> Baytrail SoCs for example don't have internal USB PHYs, which means
> the manufacturers using it can select what they want. So we have
> boards where PHY driver(s) is needed and boards where it isn't.

alright, that explains it ;-) So you have external USB2 and USB3 PHYs ?
You have an external PIPE3 interface ? That's quite an achievement,
kudos to your HW designers. Getting timing closure on PIPE3 is a
difficult task.

> The problem is that we just don't always know all the details about
> the platform. If the PHY is ULPI PHY, we can do runtime detection, but
> we can't even rely on always having ULPI.

right, we've had that before on n900 ;-)

> > > Are we talking about the old USB PHY library or the new PHY framework
> > > with the no-op PHY driver?
> > >=20
> > > Well, in any case, I don't understand what is the purpose of the no-op
> > > PHY driver. What are you drying to achieve with that?
> >=20
> > I'm trying to avoid supporting 500 different combinations for a single
> > driver. We already support old USB PHY layer and generic PHY layer, now
> > they both need to be made optional.
>=20
> This is really good to get. We have some projects where we are dealing
> with more embedded environments, like IVI, where the kernel should be
> stripped of everything useless. Since the PHYs are autonomous, we
> should be able to disable the PHY libraries/frameworks.

hmmm, in that case it's a lot easier to treat. We can use
ERR_PTR(-ENXIO) as an indication that the framework is disabled, or
something like that.

The difficult is really reliably supporting e.g. OMAP5 (which won't work
without a PHY) and your BayTrail with autonomous PHYs. What can we use
as an indication ?

I mean, I need to know that a particular platform depends on a PHY
driver before I decide to return -EPROBE_DEFER or just assume the PHY
isn't needed ;-)

> But I still don't understand what is the benefit in the no-op? You
> really need to explain this. What you have now in dwc3 is expectations
> regarding the PHY, which put a lot of pressure on upper layers to
> satisfy the driver. The no-op is just an extra thing that you have to
> provide when you fail to determine if the system requires a PHY driver
> or not, or if you know that it doesn't, plus an additional check for
> the case where the PHY lib/framework is not enabled. I don't see the
> value in it.

it "solves" the difficulty above. If everybody has to provide a PHY
driver, the problem is a lot simpler don't you think ? ;-)

> > The old USB PHY layer also provides
> > a no-op, now called phy-generic, which is actually pretty useful.
> >=20
> > On top of all that, I'm sure you'll subscribe to the idea of preventing
> > dwc3 from becoming another MUSB which supports several different
> > configurations and none work correctly. I much prefer to take baby steps
> > which are well thought-out and very well exercised, so I'll be very
> > pedantic about proof of testing.
>=20
> I think our goals are the same. I just want to also minimize the need
> for any platform specific extra work from the upper layers regarding
> the PHYs.

I'll agree to that, but let's not apply patches until we're 100% sure
there will be no regressions. Looking at $subject, I don't think it
satisfies that condition ;-)

--=20
balbi

--EXKGNeO8l0xGFBjy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS59ssAAoJEIaOsuA1yqRE2DQQAJBPe9+AaFFy2LHSwsHIB8M3
1eEN6W14HG5ddH81mGHhCsuxA+cihSNLFYOcJeGSWSpBVPTC8psEHFMfwjMNnKDS
yMcHvbPnVBoQNn4fVYToTuow1cq1pItOUqj+HeSfEIZYGH69M+Ss+jJllHKq2CKO
7bNY9ayNHI/DNcKKK3q0MoEFTlVacCe9P36U8D71EpokRl8gw03bnZyGVcsDQ4IM
42SqVzsx4KvbcblZwIJVX5jaGhJ8AiTR8h4sBAP4mLzutWuU8DIBL6+8dvLDiAz/
0qO6ieieTKZryuJxEMUB/FOGnmfFOMXvjkZEHAd1twcZj39qFhH5q6IaJspLHs7N
be2FdQQ6FROTYqlQzRdLslUkkzQd5V8+ifAzkGN7Ps/jHfn/Py6ciQho/8tAiwUB
77CeSIMZc9aCIwBwLBt31HZOVWK9VzGIEEFkndJDz1F40sPtBYqlZVHX70TAtgog
1gswb+TOE5f0vUpSpu0tloPAJ58pCHkDkIdhqW4waebR1HLr30EI1+QQfe7fziZx
Mq+9ubzZHagSPM+FgedxDJT2LsyyPtctTVM2lfbOqRuiLXcvHVaO4uqARaXZE0eB
8KRXYYBYTl0S98z0kn4N4/LNZfKTHl4BOHV1mTA2jPEnsiXx46DsYZ1iqnO6+hzw
Ce5hzcuqHXMaKLXoBO9g
=/XoJ
-----END PGP SIGNATURE-----

--EXKGNeO8l0xGFBjy--
