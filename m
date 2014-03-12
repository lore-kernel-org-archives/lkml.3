Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaCLLUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:20:05 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:59692 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaCLLUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:20:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Wed, 12 Mar 2014 12:21:32 +0100
Message-ID: <2398742.ziJRvL3pZ3@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53203B2D.6080201@ti.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <20140312102556.GC21483@n2100.arm.linux.org.uk> <53203B2D.6080201@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1849666.9EvsXHZdxQ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1849666.9EvsXHZdxQ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Russell and Tomi,

On Wednesday 12 March 2014 12:47:09 Tomi Valkeinen wrote:
> On 12/03/14 12:25, Russell King - ARM Linux wrote:
> > On Mon, Mar 10, 2014 at 02:52:53PM +0100, Laurent Pinchart wrote:
> >> In theory unidirectional links in DT are indeed enough. However, l=
et's
> >> not forget the following.
> >>=20
> >> - There's no such thing as single start points for graphs. Sure, i=
n some
> >> simple cases the graph will have a single start point, but that's =
not a
> >> generic rule. For instance the camera graphs
> >> http://ideasonboard.org/media/omap3isp.ps and
> >> http://ideasonboard.org/media/eyecam.ps have two camera sensors, a=
nd thus
> >> two starting points from a data flow point of view.
> >=20
> > I think we need to stop thinking of a graph linked in terms of data=

> > flow - that's really not useful.
> >=20
> > Consider a display subsystem.  The CRTC is the primary interface fo=
r
> > the CPU - this is the "most interesting" interface, it's the interf=
ace
> > which provides access to the picture to be displayed for the CPU.  =
Other
> > interfaces are secondary to that purpose - reading the I2C DDC bus =
for
> > the display information is all secondary to the primary purpose of
> > displaying a picture.
> >=20
> > For a capture subsystem, the primary interface for the CPU is the f=
rame
> > grabber (whether it be an already encoded frame or not.)  The senso=
r
> > devices are all secondary to that.
> >=20
> > So, the primary software interface in each case is where the data f=
or
> > the primary purpose is transferred.  This is the point at which the=
se
> > graphs should commence since this is where we would normally start
> > enumeration of the secondary interfaces.
> >=20
> > V4L2 even provides interfaces for this: you open the capture device=
,
> > which then allows you to enumerate the capture device's inputs, and=

> > this in turn allows you to enumerate their properties.  You don't o=
pen
> > a particular sensor and work back up the tree.

Please note that this has partly changed a couple of years ago with the=
=20
introduction of the media controller framework. Userspace now opens a l=
ogical=20
media device that describes the topology of the hardware, and then acce=
sses=20
individual components directly, from sensor to DMA engine.

> We do it the other way around in OMAP DSS. It's the displays the user=
 is
> interested in, so we enumerate the displays, and if the user wants to=

> enable a display, we then follow the links from the display towards t=
he
> SoC, configuring and enabling the components on the way.

The logical view of a device from a CPU perspective evolves over time, =
as APIs=20
are refactored or created to support new hardware that comes with new=20=

paradigms and additional complexity. The hardware data flow direction,=20=

however, doesn't change. Only modeling the data flow direction in DT mi=
ght be=20
tempting but is probably too hasty of a conclusion though : if DT shoul=
d model=20
the hardware, it ends up modeling a logical view of the hardware, and i=
s thus=20
not as closed as one might believe.

In the particular case of display devices I believe that using the data=
 flow=20
direction for links (assuming we can't use bidirectional links in DT) i=
s a=20
good model. It would allow parsing the whole graph at a reasonable cost=
 (still=20
higher than with bidirectional links) while making clear how to represe=
nt=20
links. Let's not forgot that with more complex devices not all componen=
ts can=20
be referenced directly from the CPU-side display controller.

> I don't have a strong opinion on the direction, I think both have the=
ir
> pros. In any case, that's more of a driver model thing, and I'm fine
> with linking in the DT outwards from the SoC (presuming the
> double-linking is not ok, which I still like best).
>=20
> > I believe trying to do this according to the flow of data is just w=
rong.
> > You should always describe things from the primary device for the C=
PU
> > towards the peripheral devices and never the opposite direction.
>=20
> In that case there's possibly the issue I mentioned in other email in=

> this thread: an encoder can be used in both a display and a capture
> pipeline. Describing the links outwards from CPU means that sometimes=

> the encoder's input port is pointed at, and sometimes the encoder's
> output port is pointed at.
>=20
> That's possibly ok, but I think Grant was of the opinion that things
> should be explicitly described in the binding documentation: either a=

> device's port must contain a 'remote-endpoint' property, or it must n=
ot,
> but no "sometimes". But maybe I took his words too literally.
>=20
> Then there's also the audio example Philipp mentioned, where there is=
 no
> clear "outward from Soc" direction for the link, as the link was
> bi-directional and between two non-SoC devices.

Even if the link was unidirectional the "outward from SoC" direction is=
n't=20
always defined for links between non-SoC devices.

=2D-=20
Regards,

Laurent Pinchart

--nextPart1849666.9EvsXHZdxQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJTIENCAAoJEIkPb2GL7hl17lQH/Rm/Pc/HzDFWdGyopxEo1uWr
YfsQ1alEQGavajcKzbQr3w5+8/vVxYIcZ4oyx4MWCIQgoYyBDZo4+4mCkiXmehyp
Smxlv1gPEJpf8msikaEYoSpkkrxuegAIcB3/P++lmIwp/GbSFKij43T4zVgCtj6o
Yt9D8Q3Uus/Mf8326daaJ1cWd19OAVMCID/J9plLVF1xoJ7aIVe+DjBb90S3gsH0
JsFfjqHNaDIgiyUIWPytiLlEJsOmZp7OJmrysLn4hhxIkPSThA/dMxrLg/he97mS
okP9SJiI79pLGEEmpczMp+ficX+c3U/9tjP/LyfDp+r8QTyqtBqE6GNRbUb9o2Y=
=iCfR
-----END PGP SIGNATURE-----

--nextPart1849666.9EvsXHZdxQ--

