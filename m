Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585AbaCUMKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:10:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35022 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965435AbaCUMKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:10:39 -0400
Message-ID: <532C2C21.1060806@ti.com>
Date: Fri, 21 Mar 2014 14:10:09 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < 5427810.BUKJ3iUXnO@avalon> <20140310145815.17595C405FA@trevor.secretlab.ca> <4339286.FzhQ2m6hoA@avalon> <20140320170159.A9A87C4067A@trevor.secretlab.ca>
In-Reply-To: <20140320170159.A9A87C4067A@trevor.secretlab.ca>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="XA7AGeQp0Qvdt5KJE96jFGUoPi6XsaHId"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XA7AGeQp0Qvdt5KJE96jFGUoPi6XsaHId
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 20/03/14 19:01, Grant Likely wrote:

> I think depending on a generic graph walk is where I have the biggest
> concern about the design. I don't think it is a good idea for the maste=
r
> device to try a generic walk over the graph looking for other devices
> that might be components because it cannot know whether or not further
> links are relevant, or even if other endpoint nodes in the target
> hierarchy actually conform to the graph binding in the same way.
>=20
> Consider the example of a system with two video controllers (one
> embedded and one discrete), a display mux, and a panel. The display
> controller depends on the mux, and the mux depends on the panel. It
> would be entirely reasonable to start up the display subsystem with the=

> embedded controller without the discrete adapter being available, but
> the way the current graph pattern is proposed there is no dependency
> information between the devices.

For some reason I don't understand this master and dependency way of
thinking. I just can't twist my brain to it, please help me =3D).

With the setup you describe above, why does the video controller depend
on the mux, and why it is the master? Why the DMA engine does not depend
on the embedded video controller, and why is the DMA engine not the maste=
r?

With the setup above, what are we really interested in? It's the
display, right? We want to have the display working, with resolution and
video timings that work for the display. The mux and the display
controllers are just necessary evils to make the display work. The
display depends on the mux to provide it a video stream. The mux depends
on the two video controllers to provide the mux two video streams. The
video controllers depend (possibly) on SoC's DMA, or PCI bus to provide
them video data.

And if we consider the same setup as above, but the mux has two
exclusive outputs, it again works fine with the dependency I described.
If you want to enable panel 1, you'll depend on mux and video
controllers, but not on panel 2. So you can leave the panel 2 driver out
and things still work ok.

But note that I don't think this dependency has strict relation to the
DT graph representation, see below.

> I really do think the dependency direction needs to be explicit so that=

> a driver knows whether or not a given link is relevant for it to start,=


I think that comes implicitly from the driver, it doesn't need to be
described in the DT. If a device has an input port, and the device is
configured to use that input port, the device depends on whatever is on
the other side of the input port. The device driver must know that.

Somehow a device driver needs to find if the driver behind its input
ports are ready. It could use the links in DT directly, if they are
supplied in that direction, or it could rely on someone else parsing the
DT, and exposing the information via some API.

I think it's simpler for the SW to follow the links directly, but that
would mean having the links in the opposite direction than the data
flow, which feels a bit odd to me.

> and there must be driver know that knows how to interpret the target
> node. A device that is a master needs to know which links are
> dependencies, and which are not.

Well, again, I may not quite understand what the master means here. But
for me, the display is the master of the pipeline. The driver for the
display is the one that has to decide what kind of video signal is
acceptable, how the signal must be enabled, and disabled, etc.

When someone (the master's master =3D) tells the panel to enable itself,
the panel needs to use an API to configure and enable its input ports.
The devices on the other end of the input ports then configure and
enable their inputs. And so on.

Anyway, I do think this is more of a SW organization topic than how we
should describe the hardware. As I see it, the parent-child
relationships in the DT describe the control paths and the graph
describes the data paths. Having the data paths described in the
direction of data flow (or double-linked in case of bi-dir link) sounds
logical to me, but I think the inverse could work fine too.

But using some kind of CPU centric direction doesn't sound very usable,
it makes no sense for cases with peripheral-to-peripheral links, and the
control bus already describes the CPU centric direction in cases where
there exists a clear CPU-to-peripheral direction.

> I'm not even talking about the bi-directional link issue. This issue
> remains regardless of whether or not bidirectional links are used.
>=20
> I would solve it in one of the following two ways:
>=20
> 1) Make masters only look at one level of dependency. Make the componen=
t
> driver responsible for checking /its/ dependencies. If its dependencies=

> aren't yet met, then don't register the component as ready. We could
> probably make the drivers/base/component code allow components to pull
> in additional components as required. This approach shouldn't even
> require a change to the binding and eliminates any need for walking the=

> full graph.
>=20
> 2) Give the master node an explicit list of all devices it depends on. =
I
> don't like this solution as much, but it does the job.

I'd suggest the first one (without the "masters" part, which I don't
quite follow, and presuming the component's inputs are its
dependencies...). Each device driver should only check its dependencies.
If this happens by using the DT data, then the easiest way is to have
the graph links go opposite to data-flow.

But I think it should work fine with data-flow direction also. Each
driver would register itself, including it's outputs. After that, the
components behind the outputs can find their inputs via an API. However,
that prevents us from using EPROBE_DEFER to handle missing inputs.

However, I do think it could be useful in some cases to observe the
whole pipeline, even the components that have not been loaded. It could
be used to, say, decide which modules to load when a particular output
needs to be enabled. I'm not sure how important such feature is, though.

And I don't really see why we should forbid that. If the graph bindings
are standard, we can reliably follow the links to form an image of the
whole graph. Of course, the component doing that should not look at the
properties of the ports or endpoints, as those are private to the node
in question, but it could follow the graph and find out if a node has a
driver available, and in those cases maybe get more information via an AP=
I.

 Tomi



--XA7AGeQp0Qvdt5KJE96jFGUoPi6XsaHId
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTLCwhAAoJEPo9qoy8lh71FAAP/1Tc6GiDsnUOxmo2/IeaFatd
738uMjUXndty7pvQDCoqzz5D+CaBoczm0JRoN4oH/YyV78yBmW3aVVwfnkwH4+eL
BF1T3wIGghxOfDw+GRz5nVSNFc255zxh2eA/leBySrtK4+eX5+9SMgR5an0cISvO
oV+g6neNfvCrYCUu3wSbK4uJ5KMu4QzO+ydHkcY/n3fQmInG7WOj8u162O2dHSB0
mrD5wjihnLMd2z3DFTRlYiKBab8j6ejzcPl7RUNZ44z7RSgwHXf2bPjwhU+R5k+s
E73Sso3ujSrq3ojFTS7QouqklWNfNudmYvcUmWGAp6Ro0Cf5OarFQWNbToMAvwBW
vMi1RdrODfditWfJVG7yIGbOpTUhXUgdVO+XYwGHKPUoXfZJA+Nb8lQ9oZYdHeTR
68DU1bNHn0wAgG9zFyLPjrljwz1asghypcrY/0oM5epqIWf3ClLhN0YAIxQauPFS
DFk79tRLuVnG1DWirzJC8fMhh9aJOJle3rXOF4iB9jYUAWkHpBeM3Co1hbk9GJnz
lBPONvxlTc4VLeJb1MZKQTDlC70OnK1Nt9nmfmc1Qx7hQ4Helu0jtB/w6NPNovd3
iZpBhmz8qhcGkZ878PZV/kdhxVno6vRFd7LNgvXJvdb5CccnDwTF3VyW2GQtb83k
nabnwzTgUE3b0gnOmekK
=FWks
-----END PGP SIGNATURE-----

--XA7AGeQp0Qvdt5KJE96jFGUoPi6XsaHId--
