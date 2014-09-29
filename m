Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaI2JaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:30:05 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:56835 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaI2JaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:30:01 -0400
Date: Mon, 29 Sep 2014 11:29:58 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Luc Verhaegen <libv@skynet.be>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-sunxi] Re: [PATCH 4/4] simplefb: add clock handling code
Message-ID: <20140929092956.GA26008@ulmo>
References: <53FF1D6C.6090205@redhat.com>
 <20140829070116.GC13106@ulmo>
 <20140829141244.GH15297@lukather>
 <20140829143812.GC31264@ulmo>
 <20140902092508.GR15297@lukather>
 <20140927235601.19023.31593@quantum>
 <20140929080637.GB12506@ulmo>
 <CAMuHMdV8job81-sf88Dx6w=0GZsWD02h94picAtYw2BtSz=Kgw@mail.gmail.com>
 <20140929085421.GH12506@ulmo>
 <CAMuHMdU0_GjbOjVE9Vnp703TnsdmkN-nxCxrigCWO7RPMzPRyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <CAMuHMdU0_GjbOjVE9Vnp703TnsdmkN-nxCxrigCWO7RPMzPRyw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2014 at 11:10:53AM +0200, Geert Uytterhoeven wrote:
> Hi Thierry,
>=20
> On Mon, Sep 29, 2014 at 10:54 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Mon, Sep 29, 2014 at 10:27:41AM +0200, Geert Uytterhoeven wrote:
> >> (CC linux-pm, as PM is the real reason behind disabling unused clocks)
> >> (CC gregkh and lkml, for driver core)
> >>
> >> On Mon, Sep 29, 2014 at 10:06 AM, Thierry Reding
> >> <thierry.reding@gmail.com> wrote:
> >> > If we start extending the binding with board-level details we end up
> >> > duplicating the device tree node for the proper video device. Also n=
ote
> >> > that it won't stop at clocks. Other setups will require regulators t=
o be
> >> > listed in this device tree node as well so that they don't get disab=
led
> >> > at late_initcall. And the regulator bindings don't provide a method =
to
> >> > list an arbitrary number of clocks in a single property in the way t=
hat
> >> > the clocks property works.
> >>
> >> Then (optional) regulator support needs to be added.
> >
> > Can you elaborate?
>=20
> I'm not so familiar with regulators, but I guess it's similar to clocks?

The bindings are different. Essentially what you use is a *-supply
property per regulator. There is no way to specify more than one
regulator in a single property.

So if you want to keep that generic you have to do crazy things like:

	simplefb {
		enable-0-supply =3D <&reg1>;
		enable-1-supply =3D <&reg2>;
		...
	};

I suppose a more generic supplies property could be created to support
this use-case, but I think this kind of proves my point. The only way
that the original proposal is going to work for other resources is if
they follow the same kind of binding. I don't think it makes sense to
introduce such a prerequisite merely because it would make life easy
for some exotic driver with a very specific application.

> > And then all of a sudden something that was supposed to be simple and
> > generic needs to know the specifics of some hardware device.
>=20
> And suddenly we wish we could write a real driver and put the stuff in
> the DTS, not DTB...

Oh, there's no doubt a real driver would be preferrable. Note that
simplefb is only meant to be a shim to pass a framebuffer from firmware
to kernel. In some cases it can be used with longer lifetime, like for
example if you really want to have graphical output but the real driver
isn't there yet.

Being a shim driver is precisely the reason why I think the binding
shouldn't be extended to cover all possible types of resources. That
should all go into the binding for the real device.

> >> > The only reasonable thing for simplefb to do is not deal with any ki=
nd
> >> > of resource at all (except perhaps area that contains the framebuffer
> >> > memory).
> >> >
> >> > So how about instead of requiring resources to be explicitly claimed=
 we
> >> > introduce something like the below patch? The intention being to give
> >> > "firmware device" drivers a way of signalling to the clock framework
> >> > that they need rely on clocks set up by firmware and when they no lo=
nger
> >> > need them. This implements essentially what Mark (CC'ing again on th=
is
> >> > subthread) suggested earlier in this thread. Basically, it will allow
> >> > drivers to determine the time when unused clocks are really unused. =
It
> >> > will of course only work when used correctly by drivers. For the cas=
e of
> >> > simplefb I'd expect its .probe() implementation to call the new
> >> > clk_ignore_unused() function and once it has handed over control of =
the
> >> > display hardware to the real driver it can call clk_unignore_unused(=
) to
> >> > signal that all unused clocks that it cares about have now been clai=
med.
> >> > This is "reference counted" and can therefore be used by more than a
> >> > single driver if necessary. Similar functionality could be added for
> >> > other resource subsystems as needed.
> >>
> >> This still won't work for modules, right? Or am I missing something?
> >> With modules you will never know in advance what will be used and what
> >> won't be used, so you need to keep all clocks, regulators, PM domains,=
 ...
> >> up and running?
> >
> > No. The way this works is that your firmware shim driver, simplefb in
> > this case, will call clk_ignore_unused() to tell the clock framework
> > that it uses clocks set up by the firmware, and therefore requests that
> > no clocks should be considered unused (for now). Later on when the
> > proper driver has successfully taken over from the shim driver, the shim
> > driver can unregister itself and call clk_unignore_unused(), which will
> > drop its "reference" on the unused clocks. When all references have been
> > dropped the clock framework will then disable all remaining unused
> > clocks.
>=20
> So the shim must be built-in, not modular.

Correct. Making it a module isn't very useful in my opinion. You'd loose
all the advantages.

Thierry

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUKSaUAAoJEN0jrNd/PrOhCyMP/jqv5QPAVj/upKL0ptIZuJEa
4OSqgUc1ZQvbaeFWxQtJdQdibqt13+StOQ3mdtJdvrwFFh7YWhTG1K3IZEGF3FC7
76PCUXowotjJ+RqxVn1FdAQs/B68FZBlLXn44iI/XyFrtLV+Z4ZcCVxsw7YUzbSK
ipVbJFGTI2O4n11Karejq/EwNr3FohqUu6kXTYyUiVUOjMV1l2w4FKjsWmEbrfWz
C9r+Rm2GrypaSg5pdOeBPuvFyMzctQHweMGO8nhtsV2Z7w1ZifRO5LaiXTgyQ+je
UMckuznVGDYLqJgs3BOZpJ/gBZjSlTgCmtZZ8vO1b/RXG99qxi+F11rvxIoaDjAe
PPuWoBTrrPsKYHzF/5ZlrJpUKWoPHpJtVQbidtNZHvoIusU+AqlU+BieDwBROo0O
CClVJiqBHf1vqo7FZthjiqG3oUQZb8DeOu4ba9Lok6P3UBwabz5YhacMeB+mzlKU
gs16EsulrwaNTx8KBCKDQud9p52m6FwQlSHBYC9eHwjbOImJHizCYutx/9dN4q48
eHpn6NyuRGpa+ayIVGUBK8x7mUdcbUXFbp7qdbWlBqCSHOczhTu0GeGU0k7X2QpG
bBj/Gk9nycWxuNy1qkrOhnwKMovJbsUPMPW/tIY7SowuUsneZ4WdEFhKdBM5woSR
XENnnnSExlEr1ZZ1Hl5z
=Vpgk
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
