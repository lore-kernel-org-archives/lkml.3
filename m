Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaEMVbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:31:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33741 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaEMVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:31:12 -0400
Date: Tue, 13 May 2014 23:31:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] drivers/base: Add interface framework
Message-ID: <20140513213057.GA7239@mithrandir>
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
 <1399995050-28435-5-git-send-email-thierry.reding@gmail.com>
 <20140513175713.GS3908@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20140513175713.GS3908@phenom.ffwll.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 07:57:13PM +0200, Daniel Vetter wrote:
> On Tue, May 13, 2014 at 05:30:47PM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Some drivers, such as graphics drivers in the DRM subsystem, do not have
> > a real device that they can bind to. They are often composed of several
> > devices, each having their own driver. The master/component framework
> > can be used in these situations to collect the devices pertaining to one
> > logical device, wait until all of them have registered and then bind
> > them all at once.
> >=20
> > For some situations this is only a partial solution. An implementation
> > of a master still needs to be registered with the system somehow. Many
> > drivers currently resort to creating a dummy device that a driver can
> > bind to and register the master against. This is problematic since it
> > requires (and presumes) knowledge about the system within drivers.
> >=20
> > Furthermore there are setups where a suitable device already exists, but
> > is already bound to a driver. For example, on Tegra the following device
> > tree extract (simplified) represents the host1x device along with child
> > devices:
> >=20
> > 	host1x {
> > 		display-controller {
> > 			...
> > 		};
> >=20
> > 		display-controller {
> > 			...
> > 		};
> >=20
> > 		hdmi {
> > 			...
> > 		};
> >=20
> > 		dsi {
> > 			...
> > 		};
> >=20
> > 		csi {
> > 			...
> > 		};
> >=20
> > 		video-input {
> > 			...
> > 		};
> > 	};
> >=20
> > Each of the child devices is in turn a client of host1x, in that it can
> > request resources (command stream DMA channels and syncpoints) from it.
> > To implement the DMA channel and syncpoint infrastructure, host1x comes
> > with its own driver. Children are implemented in separate drivers. In
> > Linux this set of devices would be exposed by DRM and V4L2 drivers.
> >=20
> > However, neither the DRM nor the V4L2 drivers have a single device that
> > they can bind to. The DRM device is composed of the display controllers
> > and the various output devices, whereas the V4L2 device is composed of
> > one or more video input devices.
> >=20
> > This patch introduces the concept of an interface and drivers that can
> > bind to a given interface. An interface can be exposed by any device,
> > and interface drivers can bind to these interfaces. Multiple drivers can
> > bind against a single interface. When a device is removed, interfaces
> > exposed by it will be removed as well, thereby removing the drivers that
> > were bound to those interfaces.
> >=20
> > In the example above, the host1x device would expose the "tegra-host1x"
> > interface. DRM and V4L2 drivers can then bind to that interface and
> > instantiate the respective subsystem objects from there.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> > Note that I'd like to merge this through the Tegra DRM tree so that the
> > changes to the Tegra DRM driver later in this series can be merged at
> > the same time and are not delayed for another release cycle.
> >=20
> > In particular that means that I'm looking for an Acked-by from Greg.
> >=20
> >  drivers/base/Makefile     |   2 +-
> >  drivers/base/interface.c  | 186 ++++++++++++++++++++++++++++++++++++++=
++++++++
> >  include/linux/interface.h |  40 ++++++++++
> >  3 files changed, 227 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/base/interface.c
> >  create mode 100644 include/linux/interface.h
>=20
> Hm, this interface stuff smells like bus drivers light. Should we instead
> have a pile of helpers to make creating new buses with match methods more
> trivial? There's a fairly big pile of small use-cases where this might be
> useful. In your case here all the host1x children would sit on a host1x
> bus. Admittedly I didn't look into the details.

The problem that this is trying to solve is slightly different. The
host1x children do already sit on a kind of bus, only that there's
currently (and likely never) a real need to turn it into a custom bus
implementation, so we reuse platform_bus instead (host1x is the parent
of the child devices).

What this interface framework tries to solve is that host1x itself is a
device with a proper driver. Child devices in turn are implemented as
separate drivers as well. The result is that there is no device that can
be used to register the DRM driver against. DRM doesn't specifically
require this since it doesn't take ownership of a device, but with the
driver model every driver needs a device to bind against, otherwise no
=2Eprobe() function is called.

Two solutions have previously been proposed, and Tegra DRM has used each
of them at one point, but it never really seemed like the right
solution. Also at each point I was told to look into fixing it.

The first solution is to have everything in one driver. That way the DRM
device could be instantiated from the host1x driver. Similarily a future
V4L2 driver could be instantiated from the same host1x driver. That has
the obvious disadvantage that the driver becomes really big and
monolithic.

A different solution, which seems to be fairly common for DRM drivers
for SoCs, is to instantiate a dummy device so that the DRM driver can
bind to it. This can happen in two forms: add the dummy device directly
in device tree (which goes against pretty much everything that's been
preached about device tree in the past) or the dummy device can be
instantiated in code, which is what the current Tegra DRM/host1x driver
does.

The interface framework solution is a way to combine both of the above,
while dropping the ugly parts at the same time. What it tries to achieve
is to allow a specific device (the host1x parent device in this case) to
expose an interface (which is essentially just a name of a set of
functions that the device implements). For host1x this interface would
be "tegra-host1x". An interface can be bound to by more than one driver,
which is probably the most fundamental difference between an interface
and a device (as in the driver model).

So for host1x, there could be two drivers that bind to the tegra-host1x
interface: DRM and V4L2 (there could potentially be others). None of the
drivers would need to take ownership of a device, since they are meta-
drivers that would typically use the component/master framework. The
only reason why it's needed is so that the drivers get an entry point so
that they can register the master of a componentized device.

I guess that reduces the number of use-cases compared to what you had in
mind, so perhaps moving this from the driver core into host1x would be a
better option. Still perhaps it's useful for other scenarios that I just
haven't thought about and having it in the core would make it easier to
find.

Thierry

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTco8RAAoJEN0jrNd/PrOhOxYQAL38oBC5/ZsY8pN0nP3zN0G+
M1T9oWMCSp7nLjvYJ4fn2dxcRN3D2S/2IKd2QkLg4xhatGpJezA6O0OnIaY6+hYh
MTK5/EtPjg1RSoUkO3H/ap9koY5MWRsEreBqgS+NQLYriCIBcK1NYJNIJYOuMq0w
x3baaZdY6b8NnivFkIqljabWs8SioaLmcSccSfRFg7oBmvtkgCa61JDE0pMTGA7Q
V7/BUatdwFQemr5+6wCaIPJdWFdLngmEsk0PiiJzPG0lhVhDoDQNkwz7IgiQDde4
TlBuLxc9b521GYUmj9x20VURCXfMgoGwWRCvguDWFnzDhpht4IohEsJQMJ0rqStd
JJcflw+Uc4TkujfM6uMwpmjY8MBisluxA2lzFNIJSDFDEkgKCbi4rUwmzU4wixzz
Tw7ksBMIQVcoZhlLa1RyqqmQVgYjOzlBDfJi8GfnVt9gYeYJtq1qr4+nWJnEIJbU
baaV8raPP3+ygO1QgZDrOrnsHXYUTiixuV8e42e5Ze8G/aLoS+LjpnkWauemj3mc
lMYjDQXC7/E4obFI1AouIvjDo5YxpPejts/v4IXcd0/k3Wo7OpOOaSxNbdX66MOD
mLObZvZKqYRaiXbFCDcRyHLkzc5D0WB8Qzcb5wHXWD1Su6XojiH6VthxnwLikI+L
dMZFS0iRuSvpJD1470Bn
=/3Y8
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
