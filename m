Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaHHKOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:14:55 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34694 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbaHHKOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:14:51 -0400
Date: Fri, 8 Aug 2014 12:14:48 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        YoungJun Cho <yj44.cho@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Dual-channel DSI
Message-ID: <20140808101447.GF15852@ulmo>
References: <20140805153923.GA3072@ulmo.nvidia.com>
 <53E3227B.1010000@samsung.com>
 <20140807072530.GE17340@ulmo>
 <53E33B48.1080401@samsung.com>
 <20140807085424.GC13315@ulmo.nvidia.com>
 <53E47B99.3040105@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cpvLTH7QU4gwfq3S"
Content-Disposition: inline
In-Reply-To: <53E47B99.3040105@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cpvLTH7QU4gwfq3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 09:26:17AM +0200, Andrzej Hajda wrote:
> On 08/07/2014 10:54 AM, Thierry Reding wrote:
> > On Thu, Aug 07, 2014 at 10:39:36AM +0200, Andrzej Hajda wrote:
> >> On 08/07/2014 09:25 AM, Thierry Reding wrote:
> >>> On Thu, Aug 07, 2014 at 08:53:47AM +0200, Andrzej Hajda wrote:
> >>>> Hi Thierry,
> >>>>
> >>>> Nice case.
> >>>>
> >>>> On 08/05/2014 05:39 PM, Thierry Reding wrote:
> >>>>> Hi everyone,
> >>>>>
> >>>>> I've been working on adding support for a panel that uses what's
> >>>>> commonly known as dual-channel DSI. Sometimes this is referred to as
> >>>>> ganged-mode as well.
> >>>>>
> >>>>> What is it, you ask? It's essentially a hack to work around the ban=
d-
> >>>>> width restrictions of DSI, albeit one that's been commonly implemen=
ted
> >>>>> by several SoC vendors.
> >>>>>
> >>>>> This typically works by equipping a peripheral with two DSI interfa=
ces,
> >>>>> each of which driving one half of the screen (symmetric left-right =
mode)
> >>>>> or every other line (symmetric odd-even mode). Apparently there can=
 be
> >>>>> asymmetric modes in addition to those two, but they seem to be the
> >>>>> common ones. Often both of the DSI interfaces need to be configured
> >>>>> using DCS commands and vendor specific registers.
> >>>>>
> >>>>> A single display controller is typically used video data transmissi=
on.
> >>>>> This is necessary to provide synchronization and avoid tearing and =
all
> >>>>> kinds of other ugliness. For this to work both DSI controllers need=
 to
> >>>>> be made aware of which chunk of the video data stream is addressing
> >>>>> them.
> >>>>>
> >>>>> From a software perspective, this poses two problems:
> >>>>>
> >>>>> 1) A dual-channel device is composed of two DSI peripheral devices =
which
> >>>>>    cannot be programmed independently of each other. A typical exam=
ple
> >>>>>    is that the frame memory extents need to be configured different=
ly
> >>>>>    for each of the devices (using the DCS set_column_address and
> >>>>>    set_page_address commands). Therefore each device must know of t=
he
> >>>>>    other, or there must be a driver that binds against a dummy devi=
ce
> >>>>>    that pulls in the two real devices.
> >>>> I am not sure if I understand correctly, but I see it rather as one
> >>>> device with two dsi-slave interfaces. Probably panel driver can
> >>>> create dsi dummy device to program some registers
> >>>> via second dsi interface but the panel will be attached to one contr=
ol bus.
> >>>> It seems to be very similar to mfd/i2c devices with two or more i2c
> >>>> addresses.
> >>> They are in fact attached to two different control busses. The DSI
> >>> controllers that talk to each are separate. On Tegra they are the same
> >>> type of IP block, but still two separate instances (with their own
> >>> clock, reset, etc. inputs).
> >>>
> >>> So the panel driver can't create a dummy device to talk to the second
> >>> DSI interface because the second DSI interface uses a different DSI
> >>> host.
> >> Why different DSI host does not allow that? The only thing panel needs
> >> is the reference to another DSI host and this can be provided via
> >> DT direct phandle or video interface.
> > I'm sure one could find ways to make it work. That doesn't mean it's a
> > good idea, though. The second peripheral is physically there on the
> > second DSI host controller's bus, so it the device should be in device
> > tree because so that the device tree matches reality.
>=20
> The question is what is the reality? Do we have two separate dsi
> devices? In such case
> both devices should appear in DT.
> If we have single device attached to two different DSI hosts I suppose
> device should appear
> only in one location in DT with link to another DSI host.

Doesn't the fact that both devices are connected to different DSI hosts
make them separate device? While it's physically one device only (there
is one panel), device tree defines devices in terms of the control bus
that they are connected to. Since in this case both subdevices are
controlled by different DSI hosts that makes them separate devices.

> >>>>> 2) On the DSI host side, each of the controller instances needs to =
know
> >>>>>    the intimate details of the other controller (or alternatively, =
one
> >>>>>    controller needs to be a "master" and the other a "slave").
> >>>> The question is if they need to communicate each other, or they have
> >>>> to have similar configurations applied?
> >>> On Tegra at least the configuration needs to be almost the same. There
> >>> are two registers that may need to be programmed differently. But they
> >>> don't have to communicate with each other. Essentially the two regist=
ers
> >>> that require different programming define which parts of the display
> >>> controller's data stream they need to capture and turn into DSI packe=
ts.
> >>>
> >>> Theoretically it would be possible to make this work with two complet=
ely
> >>> different DSI controllers, but in practice I'd expect that to never
> >>> happen. So I'm not sure we need to consider the case where the regist=
er
> >>> layout is different between the two DSI host controllers.
> >> So maybe the configuration could be provided by the panel.
> > What configuration? I suppose one idea would be for the panel driver to
> > set the type of dual-channel mode that it's using. Panels can typically
> > be configured to do symmetric left-right or symmetric odd-even. I think
> > technically it's possible to have asymmetric modes, too, but to be
> > honest I don't want to think about those yet.
> >
> > So I think it's reasonable for the DSI device to provide information as
> > to what mode it's using. Perhaps that could be done as part of the slave
> > setup.
> >
> >>> I've come up with another alternative that works:
> >>>
> >>> 	dsi@54300000 {
> >>> 		panel: panel@0 {
> >>> 			compatible =3D "sharp,lq101r1sx01";
> >>> 			reg =3D <0>;
> >>> 		};
> >>> 	};
> >>>
> >>> 	dsi@54400000 {
> >>> 		panel@0 {
> >>> 			compatible =3D "sharp,lq101r1sx01";
> >>> 			reg =3D <0>;
> >>>
> >>> 			master =3D <&panel>;
> >>> 		};
> >>> 	};
> >> But here you have again two compatibles and two devices in DT represen=
ting
> >> one HW device.
> > Because that's what they really are. There are two different devices,
> > it's just that they happen to be driving two separate halves of the same
> > panel.
>=20
> Compatible string "sharp,lq101r1sx01" clearly indicates that there are
> two panels of type LQ101R1SX01.
> If you really want to split this panel as two separate devices maybe you
> should probably use separate
> compatibles to make it more clear, sth like: "sharp,lq101r1sx01_link1",
> "sharp,lq101r1sx01_link2".
> Anyway it looks odd to me :)

As best as I can tell both subdevices are actually the same. Although it
seems like commands written to the primary channel have an effect on the
device as a whole. For example if you send a DCS exit_sleep_mode command
to the primary channel then both devices will wake up. Similarly sending
the DCS set_display_on command will turn on the display on both halves,
not just the one. I haven't checked yet whether the same is true when
the commands are sent to the secondary.

One other solution I had thought about looked something like this:

	dsi@54300000 {
		left: panel@0 {
			compatible =3D "sharp,lq101r1sx01-link";
			reg =3D <0>;
			...
		};
	};

	dsi@54400000 {
		right: panel@0 {
			compatible =3D "sharp,lq101r1sx01-link";
			reg =3D <0>;
			...
		};
	};

	panel: panel {
		compatible =3D "sharp,lq101r1sx01";
		links =3D <&left &right>;
	};

The downside of that being that &panel becomes a non-DSI device and we
loose meta information such as the number of lanes etc.

Perhaps this could be solved by using a device_type =3D "dsi" property and
thereby cause the driver core to instantiate a DSI device rather than a
platform device. Or perhaps even device_type =3D "dual-dsi" so that it
could directly hook up both channels.

But that's not all that different from the minimal proposal above, and I
don't know if it's worth the trouble. Anyway, it would be good to hear
thoughts on this from the device tree maintainers.

> >> I am not sure if it is better. If you do not like video
> >> interfaces
> >> maybe better would be sth like this:
> >>
> >> 	dsi@54300000 {
> >> 		panel: panel@0 {
> >> 			compatible =3D "sharp,lq101r1sx01";
> >> 			reg =3D <0>;
> >> 			secondary_dsi =3D <&dsiB>;
> >>  		};
> >> 	};
> >>
> >> 	dsiB: dsi@54400000 {
> >> 	};
> > That's pretty much the same thing that I proposed, except that it
> > reverses the link between the two.
> For me it is fundamentally different - in your proposition you have two
> different panels, in my you have only one, attached to one dsi with
> phandle to 2nd dsi.

Looking at the example again I don't see how it could work. The phandle
references the second DSI host, but we need a reference to the second
DSI peripheral. We can't just assume that it's on the same virtual
channel as the first.

> > In fact I tried something similar to
> > that before, but it has a couple of problems: if the secondary device
> > does not have a compatible string (that's probably not valid in device
> > tree to begin with) then there's no way for the device to report what
> > format it expects or what number of lanes it uses. But those are
> > parameters that are needed to set up the DSI (and display controllers).
>=20
> I2C has:
> struct i2c_client *
> i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *inf=
o)
>=20
> DSI could have something similar, this way you could pass everything you
> need.

We don't need any of that if both devices have a proper compatible
string, which they should have anyway, since then the driver can fill in
those values as appropriate.

Thierry

--cpvLTH7QU4gwfq3S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT5KMXAAoJEN0jrNd/PrOhV2YP/jtWXkYGqUo3cllYp4PrmPPf
nO+h52iABjI2Hr1N8pDcIbebDnQpfbgLIbh7TIMh1lcbi45PMq+ToOcnXM5oDEct
L3RqCrgxPlWM4bJRV3fBabhOhgYHlGmY5bSfBMXjo1TRf/91RLaRs+0nus+ny7dy
A9ZQu7dBUB+49RypOQW+k2WRvERAu9CbKg5RzpxU67yHoqxWEWqofMuZ+xpK0B/B
WUeH74KjoqbEDR9WSmZfm31ho1vTG+2Cn/VjAZMS4YhyOP3AzAVDdupJWPy1GWYV
HOfp7UZiFb3UxqyfNjFklRtPxE/HJAt/jcCobbOnxZSBaecNeWz7ShEZeLspKW1w
aEN4ES+1PSsAfheBkrYsYU01ZbYKGltGSHX1BergE50u96V9XWIgGhU3QQIpny7o
0ciXhb7l91elmsLhfxo2wZQQ4WsN7Vbr43MWheBlvGwO0uYSKz9SpEJ+eGDa0Qpc
5XfUJBw7gwxGX8AdX6MSQnbJRSNbl2HjwTKOFnKO3DsxS6vc4RDbcJc6+jLtAteO
mwFPT6L6ITSI7YCgtJrhtJKAuK4NcWW0eSoEPGS2g5PHjtBHqVvOJsm6p6B4LK49
/3bXKBy1HgwVCzcn65l+Wg57ZVcQ1cXOjwqbH3rrlNIIeSZ2mUisH0UhMn5qcgNy
/rEMVKL/auYczN7Ym00d
=9qBe
-----END PGP SIGNATURE-----

--cpvLTH7QU4gwfq3S--
