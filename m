Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbaHEPje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:39:34 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50076 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbaHEPjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:39:32 -0400
Date: Tue, 5 Aug 2014 17:39:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        YoungJun Cho <yj44.cho@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Dual-channel DSI
Message-ID: <20140805153923.GA3072@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi everyone,

I've been working on adding support for a panel that uses what's
commonly known as dual-channel DSI. Sometimes this is referred to as
ganged-mode as well.

What is it, you ask? It's essentially a hack to work around the band-
width restrictions of DSI, albeit one that's been commonly implemented
by several SoC vendors.

This typically works by equipping a peripheral with two DSI interfaces,
each of which driving one half of the screen (symmetric left-right mode)
or every other line (symmetric odd-even mode). Apparently there can be
asymmetric modes in addition to those two, but they seem to be the
common ones. Often both of the DSI interfaces need to be configured
using DCS commands and vendor specific registers.

A single display controller is typically used video data transmission.
This is necessary to provide synchronization and avoid tearing and all
kinds of other ugliness. For this to work both DSI controllers need to
be made aware of which chunk of the video data stream is addressing
them.

=46rom a software perspective, this poses two problems:

1) A dual-channel device is composed of two DSI peripheral devices which
   cannot be programmed independently of each other. A typical example
   is that the frame memory extents need to be configured differently
   for each of the devices (using the DCS set_column_address and
   set_page_address commands). Therefore each device must know of the
   other, or there must be a driver that binds against a dummy device
   that pulls in the two real devices.

2) On the DSI host side, each of the controller instances needs to know
   the intimate details of the other controller (or alternatively, one
   controller needs to be a "master" and the other a "slave").

I'm looking for feedback on how this is handled on other SoCs, hence
adding a few people that I know are working on DSI as well (or have in
the past). If you know of any other people that might have useful advice
on this topic, feel free to include them.

Another goal of this discussion is to come up with a somewhat standard
way to represent this in device tree (oh no!) so that panels can be
easily reused on different SoCs.

What I currently have for Tegra is something along these lines:

	dsi@54300000 {
		nvidia,ganged-mode =3D <&dsib>;

		panel@0 {
			compatible =3D "sharp,lq101r1sx01";
			reg =3D <0>;

			secondary =3D <&secondary>;
		};
	};

	dsib: dsi@54400000 {
		nvidia,ganged-mode;

		secondary: panel@0 {
			reg =3D <0>;
		};
	};

There are a couple of other properties in those nodes, such as
regulators and such, but I've omitted them so that the discussion can
focus on the important bits.

In the above the panel driver will bind against dsi@54300000/panel@0 and
use the "secondary" property to obtain a reference to the DSI peripheral
device of the second DSI interface of the device.

Similarly, the dsi@54300000 primary DSI host will obtain a reference to
a "slave" DSI host via the "nvidia,ganged-mode" property. The secondary
DSI host dsi@54400000 will know that it's not a fully functional DSI
output by the presence of the empty "nvidia,ganged-mode" property.

Using the above I can get things to work, but it seems somewhat kludgy.
For example it assumes that both DSI hosts are the same type. I'm not
sure if it makes sense for dual-channel to use completely different DSI
hosts given that they need to be very tightly coupled (take input from
the same display controller, use the same PLL, ...). It's also kind of
redundant to have to specify the dual relationship twice (once for the
peripheral and once for the DSI hosts). There's also the issue that we
should really be specifying a compatible string for the secondary
instance of the DSI peripheral, but that would mean that it will bind
against the same driver and then both would be programmed independently
in the same way (without taking into account the differences between the
two interfaces).

One alternative to the above could be something like this:

	dsi@54300000 {
		nvidia,ganged-mode =3D <&dsib>;
		nvidia,panel =3D <&panel>

		primary: panel@0 {
			compatible =3D "sharp,lq101r1sx01-left";
			reg =3D <0>;
		};
	};

	dsib: dsi@54400000 {
		nvidia,ganged-mode;

		secondary: panel@0 {
			compatible =3D "sharp,lq101r1sx01-right";
			reg =3D <0>;
		};
	};

	panel {
		compatible =3D "sharp,lq101r1sx01";
		sharp,left =3D <&primary>;
		sharp,right =3D <&secondary>;
	};

Which would give us a more natural way to represent this. On the other
hand we loose information about the device type (/panel is no longer a
DSI device) and associated meta-data (number of DSI lanes, ...).

My primary concern is that this may not work for other SoCs since I've
only tested it against Tegra. But the goal would be that the same panel
connected to a different SoC would still be able to work with the same
device tree binding.

It would be great if anybody could share if they know how this works on
other SoCs and if somebody's thought about how to implement it.

Thierry

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4PqrAAoJEN0jrNd/PrOhXBoP/RnJLKfhpuCjk8ALg1pFyCbv
ZIGgsnFse+5QnEzIpKgfaQgngcL8001vLN9EnHbJKLDMgkYObIs4OjZel9jbgLvf
1yUuUS075Vbjm+jdbCbmirlNwIDZLLDr1Y/iM0aNTfj1IcV2OtAClkEmduNR5lEq
7dIY9QpoWtHMC1Cth0sZ2w7ieZGoaqak396WaCSko489ntxnxVTUXt+H8x1/1Op0
P0vR7V0J5VZY1YkHRu+bVKp+U2gz+XximOPZ65wa3HcBjGcWCjk+9QXnm7GNVvAs
pFZE4o3cvePh0qO0Kjr0TxDJs27jlCeIcrPt3kKipS6c+J7sDCaiOobY0zrKEu7R
DxpPhNCWhQL/UQEtwGrZejxXYUaa3Bf6zkRWdj4orbhadPlBwS+6GWja0noUgkWc
G3OjJ/q5fMFhSj1kCcQjIXuhMPROHh4JPEiuGlcpCGzgfQTN5yMvYczDweF/CqRL
aGbWK/J9MVUYSdy4fAp/ODUtKKqK/gnJ0uMpG7JUETMsB40lO/OKH5zHgtwuV6QF
MDx1flZqVYPrOum9OVaLEJfqt3uDc9hf4Nzbpzkwa90VK+56M4QZlBFPnlWAMjqv
IDheQ4IE1m9WZQht8rrCr9WpzcqrXZP8qQNCIm7tkmFCWTaeoyg90aypp+SpKrpD
9D2wC4BdiLJqaqtnLNrj
=Cf+X
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
