Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaHGHZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 03:25:37 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:32816 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaHGHZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 03:25:35 -0400
Date: Thu, 7 Aug 2014 09:25:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        YoungJun Cho <yj44.cho@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Dual-channel DSI
Message-ID: <20140807072530.GE17340@ulmo>
References: <20140805153923.GA3072@ulmo.nvidia.com>
 <53E3227B.1010000@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9l24NVCWtSuIVIod"
Content-Disposition: inline
In-Reply-To: <53E3227B.1010000@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9l24NVCWtSuIVIod
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 08:53:47AM +0200, Andrzej Hajda wrote:
> Hi Thierry,
>=20
> Nice case.
>=20
> On 08/05/2014 05:39 PM, Thierry Reding wrote:
> > Hi everyone,
> >
> > I've been working on adding support for a panel that uses what's
> > commonly known as dual-channel DSI. Sometimes this is referred to as
> > ganged-mode as well.
> >
> > What is it, you ask? It's essentially a hack to work around the band-
> > width restrictions of DSI, albeit one that's been commonly implemented
> > by several SoC vendors.
> >
> > This typically works by equipping a peripheral with two DSI interfaces,
> > each of which driving one half of the screen (symmetric left-right mode)
> > or every other line (symmetric odd-even mode). Apparently there can be
> > asymmetric modes in addition to those two, but they seem to be the
> > common ones. Often both of the DSI interfaces need to be configured
> > using DCS commands and vendor specific registers.
> >
> > A single display controller is typically used video data transmission.
> > This is necessary to provide synchronization and avoid tearing and all
> > kinds of other ugliness. For this to work both DSI controllers need to
> > be made aware of which chunk of the video data stream is addressing
> > them.
> >
> > From a software perspective, this poses two problems:
> >
> > 1) A dual-channel device is composed of two DSI peripheral devices which
> >    cannot be programmed independently of each other. A typical example
> >    is that the frame memory extents need to be configured differently
> >    for each of the devices (using the DCS set_column_address and
> >    set_page_address commands). Therefore each device must know of the
> >    other, or there must be a driver that binds against a dummy device
> >    that pulls in the two real devices.
>=20
> I am not sure if I understand correctly, but I see it rather as one
> device with two dsi-slave interfaces. Probably panel driver can
> create dsi dummy device to program some registers
> via second dsi interface but the panel will be attached to one control bu=
s.
> It seems to be very similar to mfd/i2c devices with two or more i2c
> addresses.

They are in fact attached to two different control busses. The DSI
controllers that talk to each are separate. On Tegra they are the same
type of IP block, but still two separate instances (with their own
clock, reset, etc. inputs).

So the panel driver can't create a dummy device to talk to the second
DSI interface because the second DSI interface uses a different DSI
host.

> > 2) On the DSI host side, each of the controller instances needs to know
> >    the intimate details of the other controller (or alternatively, one
> >    controller needs to be a "master" and the other a "slave").
>=20
> The question is if they need to communicate each other, or they have
> to have similar configurations applied?

On Tegra at least the configuration needs to be almost the same. There
are two registers that may need to be programmed differently. But they
don't have to communicate with each other. Essentially the two registers
that require different programming define which parts of the display
controller's data stream they need to capture and turn into DSI packets.

Theoretically it would be possible to make this work with two completely
different DSI controllers, but in practice I'd expect that to never
happen. So I'm not sure we need to consider the case where the register
layout is different between the two DSI host controllers.

> > I'm looking for feedback on how this is handled on other SoCs, hence
> > adding a few people that I know are working on DSI as well (or have in
> > the past). If you know of any other people that might have useful advice
> > on this topic, feel free to include them.
> >
> > Another goal of this discussion is to come up with a somewhat standard
> > way to represent this in device tree (oh no!) so that panels can be
> > easily reused on different SoCs.
> >
> > What I currently have for Tegra is something along these lines:
> >
> > 	dsi@54300000 {
> > 		nvidia,ganged-mode =3D <&dsib>;
> >
> > 		panel@0 {
> > 			compatible =3D "sharp,lq101r1sx01";
> > 			reg =3D <0>;
> >
> > 			secondary =3D <&secondary>;
> > 		};
> > 	};
> >
> > 	dsib: dsi@54400000 {
> > 		nvidia,ganged-mode;
> >
> > 		secondary: panel@0 {
> > 			reg =3D <0>;
> > 		};
> > 	};
> >
> > There are a couple of other properties in those nodes, such as
> > regulators and such, but I've omitted them so that the discussion can
> > focus on the important bits.
> >
> > In the above the panel driver will bind against dsi@54300000/panel@0 and
> > use the "secondary" property to obtain a reference to the DSI peripheral
> > device of the second DSI interface of the device.
> >
> > Similarly, the dsi@54300000 primary DSI host will obtain a reference to
> > a "slave" DSI host via the "nvidia,ganged-mode" property. The secondary
> > DSI host dsi@54400000 will know that it's not a fully functional DSI
> > output by the presence of the empty "nvidia,ganged-mode" property.
> >
> > Using the above I can get things to work, but it seems somewhat kludgy.
> > For example it assumes that both DSI hosts are the same type. I'm not
> > sure if it makes sense for dual-channel to use completely different DSI
> > hosts given that they need to be very tightly coupled (take input from
> > the same display controller, use the same PLL, ...). It's also kind of
> > redundant to have to specify the dual relationship twice (once for the
> > peripheral and once for the DSI hosts). There's also the issue that we
> > should really be specifying a compatible string for the secondary
> > instance of the DSI peripheral, but that would mean that it will bind
> > against the same driver and then both would be programmed independently
> > in the same way (without taking into account the differences between the
> > two interfaces).
> >
> > One alternative to the above could be something like this:
> >
> > 	dsi@54300000 {
> > 		nvidia,ganged-mode =3D <&dsib>;
> > 		nvidia,panel =3D <&panel>
> >
> > 		primary: panel@0 {
> > 			compatible =3D "sharp,lq101r1sx01-left";
> > 			reg =3D <0>;
> > 		};
> > 	};
> >
> > 	dsib: dsi@54400000 {
> > 		nvidia,ganged-mode;
> >
> > 		secondary: panel@0 {
> > 			compatible =3D "sharp,lq101r1sx01-right";
> > 			reg =3D <0>;
> > 		};
> > 	};
> >
> > 	panel {
> > 		compatible =3D "sharp,lq101r1sx01";
> > 		sharp,left =3D <&primary>;
> > 		sharp,right =3D <&secondary>;
> > 	};
> >
> > Which would give us a more natural way to represent this. On the other
> > hand we loose information about the device type (/panel is no longer a
> > DSI device) and associated meta-data (number of DSI lanes, ...).
> >
> > My primary concern is that this may not work for other SoCs since I've
> > only tested it against Tegra. But the goal would be that the same panel
> > connected to a different SoC would still be able to work with the same
> > device tree binding.
> >
> > It would be great if anybody could share if they know how this works on
> > other SoCs and if somebody's thought about how to implement it.
>=20
> What about strictly following general 'rules' in DT:
> 1. Control bus is modeled using subnodes.
> 2. Video bus is modeled using video interface bindings.
>=20
> Assuming this we will put panel node inside the first dsi node and we
> should make
> video link to other dsi node. Something like this:
>=20
> dsiA {
>     ports {
>         port@0 {
>             remote-endpoint =3D <&dc_port0>;
>         };
>         dsiA_port1: port@1 {
>             remote-endpoint =3D <&panel_port0>;
>     };
>     panel@0 {
>         compatible =3D "...";
>         reg =3D <0>;
>         ports {
>             /* maybe common configuration for all ports */
>             panel_port0: port@0 {
>                 /* configuration specific for port@0 */
>                 remote-endpoint =3D <&dsiA_port1>;
>             };
>             panel_port1: port@1 {
>                 /* configuration specific for port@1 */
>                 remote-endpoint =3D <&dsiB_port1>;
>             };
>         };
>     };
> };
>=20
> dsiB {
>     ports {
>         port@0 {
>             remote-endpoint =3D <&dc_port1>;
>         };
>         dsiA_port1: port@1 {
>             remote-endpoint =3D <&panel_port1>;
>     };
> };

Much of that information is redundant. For example the "DC" ports are
dynamically configurable at runtime. Also I think panel_port1 is not
necessary because the panel can work (admittedly somewhat crippled) with
only a single DSI interface. I've come up with another alternative that
works:

	dsi@54300000 {
		panel: panel@0 {
			compatible =3D "sharp,lq101r1sx01";
			reg =3D <0>;
		};
	};

	dsi@54400000 {
		panel@0 {
			compatible =3D "sharp,lq101r1sx01";
			reg =3D <0>;

			master =3D <&panel>;
		};
	};

That's about as minimal as it gets. The meaning of the above is that
there are two panel devices, each connected to different DSI hosts, that
form a composite device. The first instance can be used standalone, in
which case it will only display one half of the screen, whereas the
second instance can attach to a master (the first instance). When
attached the master can "enslave" the secondary device and set up dual-
channel mode.

=46rom a driver perspective in the above the two instances share the same
driver, but the slave device will only perform a subset of the
initialization, whereas the master device will be the controlling
instance. Furthermore the DSI host controller driver will check that the
secondary's DSI host is compatible (by comparing the mipi_dsi_host.dev->
driver fields) and configure it in ganged mode.

This does work out pretty nicely and I've added a bit of helper code to
the DSI core to make this easier. I'm considering making this more
explicit by introducing the concept of a mipi_dsi_master that wraps a
mipi_dsi_device and provides callbacks for setting up or tearing down
dual-channel mode when a slave is added or removed.

Thierry

--9l24NVCWtSuIVIod
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4ynqAAoJEN0jrNd/PrOhpioP/2qzXnJy/eaLeZi+C0BeG5QV
qPD4UkOhiHH9SRYFI/5zJnOXd341gppK6/yH6qlqf+kxt3x6nVewWKI/EYuTv/8b
zX/1xYghrYj/94zyep19qSuaGw8DijSjf8wQIEYNl0uPaRi6PAWJ1sxsb2X+0zLg
yG2MUc8LTLymBM/2vOgSvFHSZ0QhCqUnZ3rpJ5B+mp5GdcQvtypUtSHej67ayiFW
yh4JFYZsVJvGPze3EzJRNmD2JsQa8krxyZ6bTv0qrOQOxtKggP8RYh7O/uGPQkbh
EnlIFTw4l9RFAmGHneRffXMeo4Ad996PZH4r9CGfyM2UZipyrUYgif8OTrg4wXd8
MqLpH68Oa1AgaUx7NCFrRBrJTTX33xoddBLOOK/GiCPKwoWpKmsfaokvK0YEtv4p
UEPbIkwJDiiAqmU5oQNnZAhTWL1s3ZNRiSJXSJZ6/OdsrJKrDd9za2lV4BF7GeEB
CKjLRydSI7DYx+UxUXDtEEbX5td8QuDb0XrV6qPfJ9tHRHwc7c4U5UF8B7xYS/Zi
6CnAjU9exIatpoMG+cDjdBbx2FPRE07fGnWkoocOpSq5X4rTAzi3kGwgz+FunYp6
9HwkfxOEe2RR9nwJaeAi4NxeywaVFlWa0qefgQQFePz9yGsk4CSKLRzsSrCkEDff
TyiHKOmfx6HDwRCMTqYo
=j6KA
-----END PGP SIGNATURE-----

--9l24NVCWtSuIVIod--
