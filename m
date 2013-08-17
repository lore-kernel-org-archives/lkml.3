Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3HQLHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 07:07:40 -0400
Received: from mail-bk0-f68.google.com ([209.85.214.68]:57231 "EHLO
	mail-bk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3HQLHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 07:07:38 -0400
Date: Sat, 17 Aug 2013 13:07:35 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
Message-ID: <20130817110734.GA1536@mithrandir>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
 <1376685563-1053-3-git-send-email-treding@nvidia.com>
 <20130816210637.GC2198@kroah.com>
 <20130816215530.GA14464@mithrandir>
 <CACxGe6uhiKY7a0+aViEamwKbE2tJicVc8CMZChBUaf+KYTs5rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <CACxGe6uhiKY7a0+aViEamwKbE2tJicVc8CMZChBUaf+KYTs5rw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2013 at 11:20:55PM +0100, Grant Likely wrote:
> On Fri, Aug 16, 2013 at 10:55 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Fri, Aug 16, 2013 at 02:06:37PM -0700, Greg Kroah-Hartman wrote:
> >> On Fri, Aug 16, 2013 at 10:39:21PM +0200, Thierry Reding wrote:
> >> > +static DEFINE_MUTEX(device_early_mutex);
> >> > +static LIST_HEAD(device_early_list);
> >> > +static bool device_is_early =3D true;
> >> > +
> >> > +/*
> >> > + * Keep a list of early registered devices so that they can be fully
> >> > + * registered at a later point in time.
> >> > + */
> >> > +static void device_early_add(struct device *dev)
> >>
> >> __init?
> >
> > Yes.
> >
> >> > +{
> >> > +   mutex_lock(&device_early_mutex);
> >> > +   list_add_tail(&dev->p->early, &device_early_list);
> >> > +   mutex_unlock(&device_early_mutex);
> >> > +}
> >> > +
> >> > +/*
> >> > + * Mark the early device registration phase as completed.
> >> > + */
> >> > +int __init device_early_init(void)
> >> > +{
> >> > +   device_is_early =3D false;
> >> > +
> >> > +   return 0;
> >> > +}
> >> > +
> >> > +/*
> >> > + * Fixup platform devices instantiated from device tree. The proble=
m is
> >> > + * that since early registration happens before interrupt controlle=
rs
> >> > + * have been setup, the OF core code won't know how to map interrup=
ts.
> >> > + */
> >> > +int __init platform_device_early_fixup(struct platform_device *pdev)
> >>
> >> This shouldn't be in this file, because:
> >>
> >> > +/*
> >> > + * Fully register early devices.
> >> > + */
> >> > +int __init device_early_done(void)
> >> > +{
> >> > +   struct device_private *private;
> >> > +
> >> > +   list_for_each_entry(private, &device_early_list, early) {
> >> > +           struct device *dev =3D private->device;
> >> > +           int err;
> >> > +
> >> > +           if (dev->bus =3D=3D &platform_bus_type) {
> >>
> >> Why special case the platform bus?  We are trying to move things off of
> >> the platform bus, don't make it harder to do that :)
> >
> > I heard about that, but I must have missed the thread where this was
> > discussed. Can you point me to it?
> >
> >> > +                   struct platform_device *pdev =3D to_platform_dev=
ice(dev);
> >> > +
> >> > +                   err =3D platform_device_early_fixup(pdev);
> >> > +                   if (err < 0)
> >> > +                           dev_err(&pdev->dev,
> >> > +                                   "failed to fixup device %s: %d\n=
",
> >> > +                                   dev_name(&pdev->dev), err);
> >> > +           }
> >>
> >> You should just have a bus callback that can be made here that, if
> >> present, can be called.  That way any bus can handle this type of thin=
g,
> >> not just the platform one.
> >
> > You mean something like an .early_fixup() in struct bus_type? That would
> > indeed be much cleaner. As I mentioned this is a very early prototype
> > and this particular hunk exists specifically to fixup the platform
> > devices created by the device tree helpers so that the kernel actually
> > boots to the login prompt.
> >
> >> Not that I really like the whole idea anyway, but I doubt there's much=
 I
> >> can do about it...
> >
> > Well, getting feedback from you and others is precisely the reason why I
> > wanted to post this early. There must be a reason why you don't like it,
> > so perhaps you can share your thoughts and we can mould this into
> > something that you'd be more comfortable with.
> >
> > To be honest I don't particularly like it either. It's very hackish for
> > core code. But on the other hand there are a few device/driver ordering
> > problems that this (or something similar) would help solve. I'm
> > certainly open to discuss alternatives and perhaps there's a much
> > cleaner way to solve the problem.
>=20
> And on that note, I think we're all in agreement that it's ugly!
> Looking at it now, I don't think it is the right approach.
>=20
> In the big scheme of things, there really aren't a lot of devices that
> will need this functionality. Something I don't have a good handle on
> is the set of devices needed to be created early. Yes, some of the
> clocks and power rails need to be set up, but do all of them? Yes, the
> interrupts need to be set up, but was of_irq_init() a mistake?
> Cascaded interrupt controllers really could be normal devices if there
> isn't anything critical for early boot connected to them (ie. the
> timer). If irq references were changed to be parsed at .probe() time
> instead of device registration time, the deferred probe would have
> everything needed to make sure the interrupt controllers get probed
> before the users.

I remember having this discussion with you before. Deferred probing was
one solution to the problem at the time. However as you point out the
resolution of IRQ references isn't handled by deferred probing, and
supposedly is one of the reasons why interrupt chips are now registered
early using of_irq_init(), which, as I understand it, is the modern-day
equivalent of doing this in drivers/ rather than by platform- or board-
setup code in arch/.

While I'm totally in favour of postponing the resolution of interrupt
references to .probe() time, I also think it's unrealistic to require
individual drivers to do it explicitly. I think it's something that the
core should (and can) solve.

If you nor anyone else has any objections I'll take a stab at it, see if
I can come up with something that solves this nicely. Even if it doesn't
solve everything, it would at least eliminate one of the problems that
currently require the of_irq_init() workarounds.

The common clock framework provides of_clk_init() for similar purposes,
though I'm not sure if the same arguments can be applied to it.

> Also, for the devices that are created early, is it really appropriate
> to use APIs that require a struct device? I could easily argue that
> anything done at early boot should only be the bare minimum to allow
> the kernel to get to initcalls, and so mucking about with devices is
> inappropriate because it really messes with the assumptions made in
> the design of the driver model.

I see your point. But perhaps this could be solved by allowing drivers
to register something like an .early_probe() (or perhaps .of_probe()),
which would be called early to set up the bare minimum to continue to
boot. That's probably not easy to do because drivers are usually only
registered much later too. One solution to that particular problem may
be to move the early probe function to a separate early driver struct.

Thinking about it, that's probably not a whole lot better than what we
currently have. But it would at least somewhat restore consistency in
that the same source file could provide the early driver and a regular
driver so that at least for the full driver the devices would behave
normally.

There could even be some sort of hand-off between the early and the full
driver, though I doubt that it would be necessary. If the early setup is
really only the bare minimum then that code should restrict itself to
writing hardware registers and not set up any long-lived data structures
and whatnot.

Thierry

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSD1l2AAoJEN0jrNd/PrOhGWcQAL/0T4nd2o/2u6E3BzVrza1z
/9Iw9jkB3SMozDwcR/3Jw3OtEzEKLi21jUINastwnXjYBg1qf3MzhRompZHksyxI
w85WnNq9Rk173KXApLg1S8nyrywR0RLxWR7gfO/ZStUFG+SroWEJBCWr6dH3oENG
atQeJ9Bijqiba0+/dZDfxUUb8XWFUc+Nr1wF/X81E3iqtseIU7PGVQyRDbHB88V3
4WaMnbJPvbFGCXBs11qIsCRjr8FK5nKzYVSoydTeRBLzzuEXVrc8U9WCq09fEyXW
CQQiqDYnoEI3RBkpCAvPiwY6DlCYwc6fMzOXsPeWCoADgEJpY7P6K5O6Qm3J+brH
P2w5TTIPgRCJyZFdyvltRRF5zaP+RYE2hB+1S0CEwRaZqKsAmZyxevyIwyRtmIV3
tfe9uKgfGGxXNSs4vkU+hdDQuztyeXYQ4/JqVqlBhDz+7O7j4zuhrYpo5IeZpx4n
TiG9v1uIfSfPLKiWFXtLAVasdi7mVVz5O2CobRFl5dkPT7TTShoKfvwR4+SA333b
OTO4vV8IF81c56/MC7jkfWb33bmnFKDZC7tZd/cZ/ZytU6P/paiiq8fUJM1UWic5
tj6ODkjxrkuIe1595Nh2639LuJlTav4Syc321V8MP6qopmVkN8LilNBeROBFmrHv
Q3Ic43PNnOGvxeRUEvaF
=bsJ8
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
