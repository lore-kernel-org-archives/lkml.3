Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaC1Onr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 10:43:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33644 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaC1Onp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 10:43:45 -0400
Date: Fri, 28 Mar 2014 09:41:10 -0500
From: Felipe Balbi <balbi@ti.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Tero Kristo <t-kristo@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH] base: platform: add generic clock handling for
 platform-bus
Message-ID: <20140328144110.GC17820@saruman.home>
Reply-To: <balbi@ti.com>
References: <1391191965-31102-1-git-send-email-balbi@ti.com>
 <2775124.TXohNNxBKa@avalon>
 <CAMuHMdWMiEnpdMgFtAuq70TUxDGWje6thc_Rnaptnua0XTBOMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5QAgd0e35j3NYeGe"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWMiEnpdMgFtAuq70TUxDGWje6thc_Rnaptnua0XTBOMw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 28, 2014 at 02:20:24PM +0100, Geert Uytterhoeven wrote:
> Hi Felipe,
>=20
> On Wed, Mar 12, 2014 at 4:37 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > On Friday 31 January 2014 12:12:45 Felipe Balbi wrote:
> >> Still TODO a commit log. Not for merging!!!!!
> >>
> >> NYET-Signed-off-by: Felipe Balbi <balbi@ti.com>
> >> ---
> >>
> >> This patch is an idea I've had recently in order to combine several
> >> different PM implementations into the platform-bus.
> >>
> >> This patch is bare minimum for platforms which need to handle function=
al and
> >> interface clocks but the whole thing is made optional.
> >>
> >> Note that this patch makes sure that by the time a platform_driver's p=
robe
> >> is called, we already have clocks enabled and pm_runtime_set_active() =
has
> >> been called, thus making sure that a device driver's pm_runtime_get_sy=
nc()
> >> will solely increase the pm usage counter.
> >>
> >> I have *NOT* tested this anywhere *YET*, but I suppose it shouldn't ca=
use
> >> any issues since the clock API has ref counting too.
> >>
> >> Would really like to get some review from several folks involved with =
ARM
> >> SoC PM so that's the reason for the wide audience. If I have missed
> >> anybody, please add them to Cc.
> >>
> >> As mentioned above, this is *NOT* meant for merging, but serves as a
> >> starting point for discussing some convergence of several PM domain
> >> implementations on different arch/arm/mach-* directories.
> >>
> >> For OMAP, this has the added benefit of removing clock handling from
> >> omap_device/omap_hwmod and, thus, dropping the need for so many DT_CLK=
()
> >> tables under drivers/clk/ti/
> >>
> >>  drivers/base/platform.c         | 169 +++++++++++++++++++++++++++++++=
++++--
> >>  include/linux/platform_device.h |   9 +++
> >>  2 files changed, 173 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> >> index 3a94b79..86aeb5b 100644
> >> --- a/drivers/base/platform.c
> >> +++ b/drivers/base/platform.c
> >> @@ -484,6 +484,21 @@ static int platform_drv_probe(struct device *_dev)
> >>       if (ACPI_HANDLE(_dev))
> >>               acpi_dev_pm_attach(_dev, true);
> >>
> >> +     dev->fck =3D devm_clk_get(_dev, "fck");
> >> +     dev->ick =3D devm_clk_get(_dev, "ick");
> >
> > My concern with this that some devices might want to handle their funct=
ional
> > and interface clocks manually if they have exotic requirements. They wo=
uld
> > thus need a way to signal that the platform bus core should not try to =
perform
> > clock management on its own.
> >
> > One possible way would be to name the clocks differently for those devi=
ces,
> > but we might then have a backward compatibility issue with DT.
> >
> > Another concern is how to handle the DT backward compatibility for devi=
ces
> > that would benefit from core management of their functional and interfa=
ce
> > clocks, but that currently don't name those clocks "fck" and "ick". Ren=
aming
> > those clocks in DT wouldn't be a problem for the future, but backward
> > compatibility needs to be handled. Maybe platforms could provide aliase=
s in
> > that case.
>=20
> IIUC, on OMAP the "fck" and "ick" clock names are also not present in DT.
>=20
> Device nodes have "ti,hwmods" properties, while the board code uses
> struct omap_hwmod to match the "ti,hwmods" values with clock names, and
> creates fck aliases for them, right?

right, the idea was to move clock handling away from that, because that
has been creating a few issues for drivers the biggest of which is the
fact that we can't know, by probe() time, if the device is active or
suspended. Ideally, by probe() the device would be fully active with is
runtime pm usage counter incremented so that the first pm_runtime_get*
in our probe() doesn't try to call ->runtime_resume().

--=20
balbi

--5QAgd0e35j3NYeGe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTNYoGAAoJEIaOsuA1yqREToUQAIJLWMWc5mPMmJFdol2FMsLg
3IUC4i4b3qhx5aXg28N4f72WzpfijW6hNef8i12lsSJCFBqb/+0ph6oRkvHu0lnO
H/39T5cKUztmG32bc7fM1/egC3b8LjinjxkVhNUsKmgGtDw7Z76/jg/Tc36dKyw4
rfQKo+ggKAnbT3RaCa0uvPMXx8Dv/21PuLZL2y6k7BB/GXNpc4NoSHSkqEBeK7lU
lEaSIhEPVbztVasr/7UJmepVtFkFIe6jbgubF9Sv2jKFXO17SXwCPG+/OUqEw7G8
cHpLmomVctZHmQ01sepmbbjaOU009SO87zBhSWrdL1fIEXlc84X5YohyyKKIdGiH
d+yFouT0FHLH5y2VO+4Kea/EahR1aL70lO+xZxgeoJuBXMvLj/k/oJl1m3HzXRks
b3hGFuZ79JznDcmgi1TfiY0nOslLEA5CDa+w9B/hfpmYfuzI2i46EtI0Ffq44NE6
23R2g9ggy8N+xk48IWwxq/rLmXEtT83fouCgzLdi6ZrrsXXJT7m3hag3V8oA1/Us
r/wMhwfX0Y0g/A0UfTXopYgtBphuIedmiitHM3Bxaltt+mZ6PxDUKoEiy3tfaDt2
1yQozdahWRDD5U3iYXnxdWPyul0dVRN71yJ3cnTtkg3gL8IwtBGP5tdp5utoGWPG
XkxZU0DX//jkn9ui/efA
=cioi
-----END PGP SIGNATURE-----

--5QAgd0e35j3NYeGe--
