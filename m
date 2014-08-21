Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaHUOCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:02:21 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36453 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbaHUOCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:02:19 -0400
Date: Thu, 21 Aug 2014 16:02:13 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Jon Loeliger <jdl@jdl.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
Message-ID: <20140821140211.GD19293@ulmo.nvidia.com>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
 <20140514141914.446F7C4153D@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Content-Disposition: inline
In-Reply-To: <20140514141914.446F7C4153D@trevor.secretlab.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 03:19:14PM +0100, Grant Likely wrote:
> On Mon, 12 May 2014 18:47:51 +0200, Alexander Holler <holler@ahsoftware.d=
e> wrote:
> >=20
> > Hello,
> >=20
> > if I would have to describe the Linux kernels init system (before users=
pace
> > starts), it would be like:
> > Unknown functions with almost unknown functionality are called in an al=
most
> > random order.
> >=20
> > That reminded me that a kernel-maintainer once said to me:
> > "We should aim to make things synchronous, deterministic and
> > stuff-happens-in-the-correct-order."
> >=20
> > Looks like either the target moved or no Wilhelm Tell was around. ;)
> >=20
> > This is an attempt to reach the target for the case of (platform-)drive=
rs.
> > It is a mere starting point to reach the final target but it works on t=
wo
> > DT enabled ARM devices I have and it hasn't any implications on other
> > architectures, platforms or whatever. If the new configuration option,
> > which is only available if DT is enabled, isn't turned on, there is no
> > increase of code size or similiar.
> >=20
> > So what are these patches I'm posting here?
> > They offer an imho solid base to fix the 3. problem. they build a deter=
ministic
> > order in which (platform-)drivers should be initialized, based on datas
> > (dependencies) found in the device tree. They also offer a starting poi=
nt to fix
> > the other 2 problems (unknown functions and unknown functionality) by s=
howing a
> > way how the long range target of known functions with known functionali=
ty could
> > be reached.
> >=20
> > Unfortunately work still isn't done. As written above, this is just a s=
tarting
> > point, neiter complete nor perfect. It is what I could do behind closed=
 doors,
> > by spending a limited amount of time and resources (I've started to loo=
k at
> > that stuff 3-4 weeks ago, sometimes after 3.14 appeared), so it can be =
blamed
> > quick & dirty. But it should be already enough to explain and test the =
concepts.
> >=20
> > Enough forewords.
> >=20
> > This is a small patch series to use a deterministic dependency based de=
vice
> > and driver initialization order on machines which are using device tree.
> > The dependency graph will not only be build based on the device tree it=
self,
> > but will use dependencies based on phandle references in the .dts,
> > automatically added by dtc through a new property.
> > Manualy adding dependencies to the .dts is possible too.
> >=20
> > Advantages:
> >=20
> > - Correct order of initialization without any "dirty tricks" in drivers=
 or the
> >   machine init code. The order in which devices/drivers will be initial=
ized
> >   depends only on the DT and the topological sort algorithm used by the
> >   kernel, not some code elsewhere. That means less code and more homoge=
neity
> >   across different SOCs.
> > - Might be(come) a little faster because the number of deferred probes =
should
> >   be minimized (they might not even be necessary anymore at all).
> > - Using a modified algorithm, it's possible to build a list of drivers =
which
> >   can be initialized in parallel, e.g. using n threads, where n equals =
the
> >   number of cores. I have not tested nor implemented it, because I don'=
t have
> >   any multicore DT based board with which I easily can use a (patched) =
mainline
> >   kernel, just locked down multicore things I don't want to go through =
the
> >   pain of unlocking them.
> > - Funny dependency graphs when using Graphviz.
> >=20
> > Disadvantages:
> >=20
> > - To use this feature correctly, binary blobs must be regenerated by
> >   recompiling them to include properties with dependencies. Without
> >   recompiling them there will be no advantage.
>=20
> Rather than a dtb schema change, for the most common properties (irqs,
> clocks, gpios), we could extract dependencies at boot time. I don't like
> the idea of adding a separate depends-on property because it is very
> easy to get it out of sync with the actual binding data (dtc is not the
> only tool that manipulates .dtbs. Firmware will fiddle with it too).

Sorry for reviving this old thread, but this issue keeps popping up time
and time again and people are starting to think about ways to workaround
deferred probe being slow.

I'd very much prefer to avoid that and just keep using deferred probing
as the one means to resolve dependencies at boot time, but at the same
time I can't ignore when several people start complaining about the same
thing.

This very recently popped up again in the context of DRM and panels. One
user complaints that in some cases, deferred probe increases boot time
by 1.5 seconds (best case) and 5-6 seconds (worst case). That doesn't
sound all that much, objectively, but if the boot time of the device is
on the order of 6 seconds or so, then it's quite a lot.

The reason why this happens is that the DRM driver looks up a panel
connected to it and return -EPROBE_DEFER if the panel hasn't registered
yet. Typically the panel would be probed after the DRM driver, therefore
causing the DRM driver to defer probing. But it can also happen that the
panel driver defers probing because it needs a regulator that hasn't
been probed yet.

Anyway, those are all fairly standard reasons for where deferred probe
triggers, and since I do like deferred probe for it's simplicity and
reliability I'd rather not try to work around it if boot time is all
that people are concerned about.

In order to solve the above problem I started investigating a bit what
it would take to parse dependency information from a device tree at boot
time. As it happens this can easily be done for things like clocks and
interrupts properties, because they have very well-defined generic
bindings. Unfortunately they are also the two types of resources where
deferred probing matters the least because they are so special that they
often get probed earlier than normal drivers (and in some cases even way
before initcalls).

Unfortunately for other bindings it's not that easy. Take GPIOs for
example. GPIOs can be specified in fairly arbitrary properties. There's
a concensus on using a -gpio or -gpios suffix, but I don't think there
are any guarantees. It could also technically be that a -gpio or -gpios
property doesn't in fact contain a phandle at all.

The same is true for regulators (*-supply) and likely a couple other
bindings. So one of the hurdles to take trying to obtain the dependency
information from existing DTBs is that there may be false positives (and
the code could therefore try to resolve non-phandles as phandles and
even succeed) and the code resolving the dependencies would need to know
a whole lot about bindings.

I suppose the latter problem could be solved by adding a way for
subsystems to register a "dependency resolver" that would implement the
knowledge about existing generic bindings of the subsystems. Another way
to push that even further down into drivers would be to make drivers
list the types of resources that they need in some structure. Arnd
(Cc'ed) proposed something akin to that a while ago with the goal of
removing a lot of boilerplate from device drivers. Such a list would
automatically "implement" the driver binding and could be used to
resolve dependencies when the driver is registered.

On the other hand, some of the solutions that workaround the problems
caused by deferred probing may actually be worthwhile to have in any
case. One such solution for the above-mentioned example of panels is to
make the DRM subsystem deal better with hotplugging panels. This is in a
way counterintuitive because those panels are not really hotpluggable
(you'd have to disassemble the device at runtime and remove or unsolder
some connector and even then there's no GPIO detecting their presence or
absence). However I can imagine that it would round things off nicely if
a panel driver could simply be unloaded and the result being that the OS
simply registers this as a display going away, much like with external
monitors.

Thierry

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9fvjAAoJEN0jrNd/PrOhLnkP/0pCqR1rSLKRMDPFsMdNQvWt
CDd5Dn9QI2bvA6sU7pzbPBzW5hRKnAUKxMfy03sza0OTIUONV6jKWbnjwUCaONCV
TcE/12FDV0GnGOMyZYvoHTxgSCWzjKvb8mOMbw3qKKYDXZ6lWU4Th8ChHR01AOiM
mKsOg6odHUty6pRkGxQ/tvfJlVjssKF9jgZPKkDqBr9HtZodnR9N9z45wcHAikuC
+fotEYUWRV3H2rtxjrIAoAvPfV9Fo0i1l9oWgn2w0EiULlFDkvvFMUo4cigHesYX
Bhaj4CJSSojquqwJ8XUtduo4RuZZbOR3qkapB39A5Sii+XVrrecRtfnr8YxaJcdE
mfpKYF+OfqfDt3URtIPl7AXCbkS7OOXKF/ddWa1HMzbzoNFd6/apUqom7OOoSWGs
pJU9OxBsgfhpi2UgwK86hbXx3v994GBKi/hY2Se2Lmny6eJVS3QEvK3zrDjyyVm/
hhsPG0Vp3QwxyTp0YNH1JZWVBY4rWdjri1vWgefHddJqdwbY1OGhv81DkcJyNmlj
tFugFAKnfFTUi7oBJy8+UYp/xlKeuETTfJEbjvTzwK0VP66UwNHudFM3y1cTSlYR
re/8OX875Naq5uFsb95Qic8+vjbtmPDvzq+Q1jP/XFahmwWWqephGEVMSbVS8kzv
YbLSXMhxhw7Ji4xV5wYa
=qy8Z
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
