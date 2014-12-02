Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbaLBBzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:55:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbaLBBzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:55:51 -0500
Date: Tue, 2 Dec 2014 12:55:39 +1100
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GTA04 owners <gta04-owner@goldelico.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/2] mmc: core: allow a reset gpio to be configured.
Message-ID: <20141202125539.42f22074@notabene.brown>
In-Reply-To: <CAPDyKFrx98NspRU1nV3uJ6XwTuA4tZQkrYTfDoeXGR+f5htODQ@mail.gmail.com>
References: <20141108000919.5629.55381.stgit@notabene.brown>
	<20141108001411.5629.25179.stgit@notabene.brown>
	<CAPDyKFrx98NspRU1nV3uJ6XwTuA4tZQkrYTfDoeXGR+f5htODQ@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.0SuOiC_R0bKrVciSrX5x._"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.0SuOiC_R0bKrVciSrX5x._
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Nov 2014 12:56:33 +0100 Ulf Hansson <ulf.hansson@linaro.org> wro=
te:

> On 8 November 2014 at 01:14, NeilBrown <neilb@suse.de> wrote:
> > If the regulator supplying an SDIO device is shared
> > with another device, the turning the regulator 'on' and 'off'
> > will not actually cycle power and so will not reset
> > the device.
> >
> > This is particularly a problem for some wi2si wireless modules which
> > have a BT module on chip and can share power lines.
> > Without the power-cycle, subsequent reset commands fail.
> >
> > So allow a 'reset' gpio to be specified.  If provided, the
> > line is asserted during power-up.
>=20
> There have been several attempts to fix similar issues as this patch
> does. The latest one I posted a few month ago, which wasn't accepted.
> http://comments.gmane.org/gmane.linux.power-management.general/46635

Thanks for that link.

>=20
> There has also been some off-list discussions on especially how we
> should describe this in DT and there were actually some consensus made
> around that. Still I haven't seen any patches on the mailing lists.

Wish I could have a link for those off-list discussions :-)

Based on what I read and my own thoughts about other devices that I'm having
trouble managing I wonder if the right approach might be to admit that these
buses are *not* 100% discoverable.

i.e. you can discover what is there once it is turned on, but you cannot
discover how to turn it on.

So the *fix* is to allow attached devices to be explicitly listed.
In my case I would create a child node of the mmc1 node, which is
compatible=3D"libertas,wifi" (or whatever the proper name is).

Then when the mmc1 wants to power-up, it does:

   device_for_each_child(mmc_dev, NULL, power_up)

where:

static int power_up(struct device *dev, void *data)
{
       pm_runtime_get_sync(dev);
       return 0;
}

Then I can put my reset-line management in the libertas driver instead of
trying to include some of it in the mmc driver.

This has the advantage of the devicetree actually describing the hardware
(there is a libertas wifi SDIO chip attached) rather than the behaviour
(please turn on this regulator and toggle this GPIO to initialise the devic=
e).

I want to do a very similar thing for UARTs (so my GPS and Bluetooth turn on
when /dev/ttyO? is opened), and I've been thinking about something similar
for USB - I have a USB attached GSM module, but it also has an Audio link a=
nd
some reset/interrupt lines that need to be configured.
If I could say to device tree "This USB port has this device attached", I
think it would be a step in the right direction.



>=20
> So to summarize, I am really concerned that we keep having these power
> sequence issues for SDIO devices and right now the discussion has been
> on hold. I am considering to hack on it myself, since I am tired of
> waiting. :-)

Please Cc me if you do.  Meanwhile I'll try to hack together code supporting
my latest idea and let you know if I get anywhere.

>=20
> Regarding this patch, I don't intent to apply it.

Fair enough, I'm starting to not like it so much anyway.

Thanks,
NeilBrown



--Sig_/.0SuOiC_R0bKrVciSrX5x._
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVH0cGznsnt1WYoG5AQKGrRAAh1pogeaJja6m7oYFqxHTk5nk+U5USFuf
LD0REOmFTQHWbJ29BfpyU1aBEWzAEQw6D6ruiJ5hPsa+DX5vVuqfVI/OVILOnYwy
shazvDxKwzlXVIBfFiSoRDPQDNTLv+4pDeAeT0HY7/j8axh2vYEIAow/GmKO/QYz
eZB3C9RgHuy6efPnRRYMjwIIS42S5uyKAedZ3Y2v85ccgKA5tEXlxjwoDYSXWSGI
+blBMqRvPlqGnOSzgGMRUi+ZeCOZVIaOrfrVSJT1Q7qsc0u+YNAlYws9KPBgPr+F
xuOndDjJebkjbr27Ji8pLuYrBHsWWbRgyc0qvaTOLlwWyEuuqeyHEv56EGbOhcRN
3eKexw8JbclHLtFnwGpmPnKJi8vAMtzkQjQPRG5M/XTEJidoP9mVyJuu5zAuKrpV
ha2kYv/+X67pLWt+Gn4R/9V1sNnnnHuxElBki03bfR6grOGsiMpL/ITour5LCyNY
atGbrOfOEAJB5ykuwiBYSHbeB7dMKi/kytPdsb/ltzOyCBvNj8i0ifrJMQm8yrN8
rYjKLny1AKQmVW3hfaVouXPA89ZQT88B26wfuXdPID0R68wSL8kHcIvM+uovpdlY
as6jyGO+813yGK1tu+qq1fDIr8F4Fh28/bUzcEw45tfokT2OPTiBZ+HhqphGwq8D
MhfFfH0jJYU=
=zR6+
-----END PGP SIGNATURE-----

--Sig_/.0SuOiC_R0bKrVciSrX5x._--
