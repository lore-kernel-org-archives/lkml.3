Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbaJ3NWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:22:48 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60335 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbaJ3NWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:22:44 -0400
Date: Thu, 30 Oct 2014 14:22:40 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH RESEND V4 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox
 driver
Message-ID: <20141030132239.GC19386@ulmo>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
 <1414535277-15645-3-git-send-email-abrestic@chromium.org>
 <20141029113415.GD28356@ulmo.nvidia.com>
 <CAL1qeaG2DFyfsPa2wgDqOkYTbnJ-tXoiV48AF9EaSCf1QCtOyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <CAL1qeaG2DFyfsPa2wgDqOkYTbnJ-tXoiV48AF9EaSCf1QCtOyQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2014 at 11:02:36AM -0700, Andrew Bresticker wrote:
[...]
> > Maybe something like this patch would be more correct in handling
> > this:
> >
> > diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
> > index afcb430508ec..85691a7d8ca6 100644
> > --- a/drivers/mailbox/mailbox.c
> > +++ b/drivers/mailbox/mailbox.c
> > @@ -117,10 +117,11 @@ static void poll_txdone(unsigned long data)
> >                 struct mbox_chan *chan =3D &mbox->chans[i];
> >
> >                 if (chan->active_req && chan->cl) {
> > -                       resched =3D true;
> >                         txdone =3D chan->mbox->ops->last_tx_done(chan);
> >                         if (txdone)
> >                                 tx_tick(chan, 0);
> > +                       else
> > +                               resched =3D true;
> >                 }
> >         }
>=20
> ... but we still need to re-arm the timer if tx_tick() submits another
> message.  Perhaps the better thing to do is to have msg_submit() arm
> the timer.

I think we need both. If the last transmission isn't done yet we still
want to keep polling. And we also want to poll if a new message is sent
subsequently.

Perhaps it would be as easy as moving the poll handling code from
mbox_send_message() (if (chan->txdone_method =3D=3D TXDONE_BY_POLL)) into
msg_submit()? That has the additional advantage of being able to omit
the polling when an error happens during the mbox' .send_data().

> >> +     res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +     if (!res)
> >> +             return -ENODEV;
> >> +     mbox->regs =3D devm_ioremap(&pdev->dev, res->start, resource_siz=
e(res));
> >> +     if (!mbox->regs)
> >> +             return -ENOMEM;
> >
> > This doesn't look right. Upon closer inspection, the reason why you
> > don't use devm_request_resource() is because these registers are shared
> > with the XHCI controller.
> >
> > Perhaps a better design would be for the XHCI driver to expose the
> > mailbox rather than split it off into a separate driver.
>=20
> Well that's what I had originally, but then it was suggested I make it
> a separate driver.
>=20
> Stephen also brought this up during review and suggested that some
> sort of MFD would be the best way to structure this, but was fine with
> the way I have it now.  I can move this driver around (again) if you
> feel that strongly about it...

We've had this discussion only recently about the memory controller
driver. It used to be that there were separate drivers for the memory
controller part and the IOMMU part. But that resulted in hilarious DT
bindings. Granted, most of the issues had to do with unfortunate inter-
leaving of register regions, but generally I think there's nothing wrong
with exposing multiple interfaces from a single driver.

The downside of course is that you have to choose which subsystem is the
primary one and then get it merged via that tree. There's also a problem
in that the driver is now in a different directory than the others, so a
subsystem-wide change may not notice the "out-of-place" driver. But I
think we have pretty good tools to help with this type of thing.

Also, managing all the resources (regulators, clocks, resets, ...) that
a hardware block requires is much easier to do in a single driver than
spread over several. MFD could be an option somewhere halfway between
the two but also has some downsides. Most importantly it isn't going to
scale in the long run.

> >> diff --git a/include/soc/tegra/xusb.h b/include/soc/tegra/xusb.h
> >> new file mode 100644
> >> index 0000000..cfe211d
> >> --- /dev/null
> >> +++ b/include/soc/tegra/xusb.h
> >
> > Perhaps this should really be named xusb-mbox.h?
>=20
> I'd prefer to leave it as xusb.h so that any other XUSB-related
> definitions can be left here.

Okay, that makes sense given that the mbox really is part of the larger
XUSB block.

Thierry

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUjufAAoJEN0jrNd/PrOh9+MQAJ34A1WmGFbkp9i+fSy1vxj2
YLCYfpKpaGdcBHorAwrbvF4bLpCw+tuzuFyN6nyIof5stLW1v71laG3L/VVvUvv9
V0Hw55J3h0MUqicqX6Xxf1CrZ32h9llBwtO2Rsrn0Fu+hDZD//qhxUTozJqfgX9X
6W364/0TBUDKX/AzkT8mc5isfIZZzFaSSWs5eLFW23fvcm6Vakw/a0WpDGi87ydF
VmCrVqqSicWINn1wDuezUXJzp0uvrDZvfuJiINlof84MWgT/iAkXYW/D/9s5caSz
VMozDX9LOc9as6Yl2wXugU50uRdz8+mkzYzfnATZBEsa+xdDvZ1f4dS0PCMpYLRV
tVCdHJ7LeEey8TouLRte6zRYeLCWlix2weLGAC903EQlnnANhWcRIm/s9jOr5fEG
bnjvH2k16h1WNwQ7vBHeqXEzRkVz1TqmTPASCmuw9mvrobkvOJ/ahLrHG9jMXwT0
XPJuUHSaylYMkUp93TtPhPxhvIgyVLDt9EMyISIO4IrxUCP5yRnziGX1PonHDP2W
HnDZyemGYaxLGg413tswuZsOkJqDdJ7EDB3uNPwBEVPmzR0vN/JVAty3/aLE0f+s
JF5lmtjEuficDy5g62NJh+8Zyn3zOoK3eB0/Hsd/s3v2PIBzjWt3XTf+Me+Kd1x2
LpirIX4NNT/hHO4jEzgn
=+U1C
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
