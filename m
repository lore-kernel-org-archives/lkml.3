Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbaHGIyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:54:35 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45357 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbaHGIyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:54:32 -0400
Date: Thu, 7 Aug 2014 10:54:26 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        YoungJun Cho <yj44.cho@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Dual-channel DSI
Message-ID: <20140807085424.GC13315@ulmo.nvidia.com>
References: <20140805153923.GA3072@ulmo.nvidia.com>
 <53E3227B.1010000@samsung.com>
 <20140807072530.GE17340@ulmo>
 <53E33B48.1080401@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
In-Reply-To: <53E33B48.1080401@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 10:39:36AM +0200, Andrzej Hajda wrote:
> On 08/07/2014 09:25 AM, Thierry Reding wrote:
> > On Thu, Aug 07, 2014 at 08:53:47AM +0200, Andrzej Hajda wrote:
> >> Hi Thierry,
> >>
> >> Nice case.
> >>
> >> On 08/05/2014 05:39 PM, Thierry Reding wrote:
> >>> Hi everyone,
> >>>
> >>> I've been working on adding support for a panel that uses what's
> >>> commonly known as dual-channel DSI. Sometimes this is referred to as
> >>> ganged-mode as well.
> >>>
> >>> What is it, you ask? It's essentially a hack to work around the band-
> >>> width restrictions of DSI, albeit one that's been commonly implemented
> >>> by several SoC vendors.
> >>>
> >>> This typically works by equipping a peripheral with two DSI interface=
s,
> >>> each of which driving one half of the screen (symmetric left-right mo=
de)
> >>> or every other line (symmetric odd-even mode). Apparently there can be
> >>> asymmetric modes in addition to those two, but they seem to be the
> >>> common ones. Often both of the DSI interfaces need to be configured
> >>> using DCS commands and vendor specific registers.
> >>>
> >>> A single display controller is typically used video data transmission.
> >>> This is necessary to provide synchronization and avoid tearing and all
> >>> kinds of other ugliness. For this to work both DSI controllers need to
> >>> be made aware of which chunk of the video data stream is addressing
> >>> them.
> >>>
> >>> From a software perspective, this poses two problems:
> >>>
> >>> 1) A dual-channel device is composed of two DSI peripheral devices wh=
ich
> >>>    cannot be programmed independently of each other. A typical example
> >>>    is that the frame memory extents need to be configured differently
> >>>    for each of the devices (using the DCS set_column_address and
> >>>    set_page_address commands). Therefore each device must know of the
> >>>    other, or there must be a driver that binds against a dummy device
> >>>    that pulls in the two real devices.
> >> I am not sure if I understand correctly, but I see it rather as one
> >> device with two dsi-slave interfaces. Probably panel driver can
> >> create dsi dummy device to program some registers
> >> via second dsi interface but the panel will be attached to one control=
 bus.
> >> It seems to be very similar to mfd/i2c devices with two or more i2c
> >> addresses.
> > They are in fact attached to two different control busses. The DSI
> > controllers that talk to each are separate. On Tegra they are the same
> > type of IP block, but still two separate instances (with their own
> > clock, reset, etc. inputs).
> >
> > So the panel driver can't create a dummy device to talk to the second
> > DSI interface because the second DSI interface uses a different DSI
> > host.
>=20
> Why different DSI host does not allow that? The only thing panel needs
> is the reference to another DSI host and this can be provided via
> DT direct phandle or video interface.

I'm sure one could find ways to make it work. That doesn't mean it's a
good idea, though. The second peripheral is physically there on the
second DSI host controller's bus, so it the device should be in device
tree because so that the device tree matches reality.

> >>> 2) On the DSI host side, each of the controller instances needs to kn=
ow
> >>>    the intimate details of the other controller (or alternatively, one
> >>>    controller needs to be a "master" and the other a "slave").
> >> The question is if they need to communicate each other, or they have
> >> to have similar configurations applied?
> > On Tegra at least the configuration needs to be almost the same. There
> > are two registers that may need to be programmed differently. But they
> > don't have to communicate with each other. Essentially the two registers
> > that require different programming define which parts of the display
> > controller's data stream they need to capture and turn into DSI packets.
> >
> > Theoretically it would be possible to make this work with two completely
> > different DSI controllers, but in practice I'd expect that to never
> > happen. So I'm not sure we need to consider the case where the register
> > layout is different between the two DSI host controllers.
>=20
> So maybe the configuration could be provided by the panel.

What configuration? I suppose one idea would be for the panel driver to
set the type of dual-channel mode that it's using. Panels can typically
be configured to do symmetric left-right or symmetric odd-even. I think
technically it's possible to have asymmetric modes, too, but to be
honest I don't want to think about those yet.

So I think it's reasonable for the DSI device to provide information as
to what mode it's using. Perhaps that could be done as part of the slave
setup.

> > I've come up with another alternative that works:
> >
> > 	dsi@54300000 {
> > 		panel: panel@0 {
> > 			compatible =3D "sharp,lq101r1sx01";
> > 			reg =3D <0>;
> > 		};
> > 	};
> >
> > 	dsi@54400000 {
> > 		panel@0 {
> > 			compatible =3D "sharp,lq101r1sx01";
> > 			reg =3D <0>;
> >
> > 			master =3D <&panel>;
> > 		};
> > 	};
>=20
> But here you have again two compatibles and two devices in DT representing
> one HW device.

Because that's what they really are. There are two different devices,
it's just that they happen to be driving two separate halves of the same
panel.

> I am not sure if it is better. If you do not like video
> interfaces
> maybe better would be sth like this:
>=20
> 	dsi@54300000 {
> 		panel: panel@0 {
> 			compatible =3D "sharp,lq101r1sx01";
> 			reg =3D <0>;
> 			secondary_dsi =3D <&dsiB>;
>  		};
> 	};
>=20
> 	dsiB: dsi@54400000 {
> 	};

That's pretty much the same thing that I proposed, except that it
reverses the link between the two. In fact I tried something similar to
that before, but it has a couple of problems: if the secondary device
does not have a compatible string (that's probably not valid in device
tree to begin with) then there's no way for the device to report what
format it expects or what number of lanes it uses. But those are
parameters that are needed to set up the DSI (and display controllers).

One other problem with the above is that the dependency implied by your
"secondary_dsi" property is the wrong way around. The above would mean
that &panel requires &dsiB's services to function, but that's not the
case. If anything it's the other way around. &panel could still work
standalone (though only drive the left half of the screen).

Thierry

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4z7AAAoJEN0jrNd/PrOh8QAQAI1c8s8a6zlqDNE0qban8NOt
/PE/Z/7hCvHoc/chqh4ov9PC/YuNnjhy+J77lKMNd+RqftCzeI+tUnzT3xdb3qp5
FbQ7ucDgiFe9Uq6eJPkEVDHPovs0km5rYVRKlcfipIlaSrIPFwqJFsq586U+Ro9v
uZ9899U+SDhWU5lL9I5PfDgaJ6tuv4AlS6WzOY3QJ4llW7Lq7lQxgSlkewqGc3ta
7SGf90fuYFWCkrpoQMEYSAmYE+fm0qtss8c/6dpRktKnLTxTLs/qMwsmYxmTno/d
cjpIjdnmkmlkC0TSasBrH5rCxhmA8K/QfvTZuu1dtWKCbqj0sZX6fOqKIj5yjqOc
TX7zzySzhqXmNLdi37+/ISeCokyL4+dmnPnV+lor+FXGijrFN/TF76nid5FkgSTh
6PJru8ujak5t1tVagKbAlpdjtmBiwZXt+r5GrS/Tc5+vL6xq49hRNHQkCns9ubk/
kRyOXVPdNg295pYLcpHQ04Z2MrcHYp8WY2tH6NbSQUKCB/+RkiwIKb51+kXIkJUW
bg66sKGQXsfFdBdGOQSthfpABsDb1BU9fg3juV+yOlVQrpBuk6Y1HQP3V+jSmrQN
L9RAnRtgZR+rngLmG+7w/JfURwaVABUA/jkDCVD8F3mreyHCl6P0z37EwqrmOawe
UMGjV8ezZw3gyOa39wYH
=fNMN
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
