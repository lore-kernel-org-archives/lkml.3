Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3FBMkC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 08:40:02 -0400
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:42542
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752742Ab3FBMjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 08:39:55 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Jun 2013 08:39:55 EDT
Date: Sun, 2 Jun 2013 08:29:54 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Ajitpal Singh <ajitpal.singh@stericsson.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cw1200: fix some obvious mistakes
Message-ID: <20130602122954.GA3875@shaftnet.org>
References: <1370126241-2528420-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <1370126241-2528420-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 02, 2013 at 12:37:21AM +0200, Arnd Bergmann wrote:
> I got compile errors with the cw1200, which has lead me to take a
> closer look. It seems the driver still has a number of issues,
> and this addresses some of them and marks others as FIXME:

In short, NACK, at least not as posted.

The concerns are legitimate, but the time to object to such fundamental=20
stuff was at some point during the past *seven* rounds of patches I=20
posted over a period of nearly as many months.

Most of the objections you are raising are for deliberate=20
design/implementation decisions I made to deal with the realities of the=20
requirements of the cw1200 design and already-in-the-wild hardware that=20
this driver has to support.

> * The cw1200_sagrad.c file should not be there, hardcoding
>   hardware configuration in .c files has been obsolete since
>   Linux-2.4, so we should just remove it. Most of that file
>   was already commented out since it does not compile.

The problem with the cw1200 is that you need certain information about=20
the hardware design in order to initialize it; this information has to=20
come from somewhere.

The Sagrad wifi devices are available in a standard SD form factor=20
reference design that plugs into a standard SDIO-supporing slot.  The=20
cw1200_sagrad module is there to support these off-the-shelf devices.=20

Requiring users to recompile their kernel or update their devicetree=20
data for what amounts to an off-the-shelf hot-pluggable device is simply=20
not acceptable.

At the same time, if people plop the sagrad device directly on their=20
board (or independently do a chip-down design) they may need to make=20
changes to the platform data depending on how closely it tracks the=20
Sagrad reference design.

Further complicating things, there's no way to alter the SDIO=20
vendor/device IDs that the device reports in order to distingish between=20
any of this.

If you have a better suggestion on how to handle this set of conflicting=20
requirements then I'm all ears, but it's rather pointless to object to=20
code that's ugly because it has to support ugly hardware.

(That said, the commented-out bits in cw1200_sagrad are mostly there for=20
 documentation purposes, and it could be moved to a proper documentation=20
 file instead.)

> * Move the parts of cw1200_sagrad.c that actually got used into
>   cw1200_sdio.c, because it doesn't build otherwise.

The idea was that either you build cw1200_sagrad or provide your own=20
platform_data.  I separated all of the implemenation-specific code out=20
as cleanly as I could.

> * Make the platform_data for the sdio driver private to
>   cw1200_sdio.c. The platform that was referenced here is
>   going to use device tree based probing only in the future,
>   which means the platform data has to go away anyway.

When you say "the platform" what are you referring to?  SDIO?  There's=20
no mention of any specific board (or even arch/subarch) in cw1200_sdio=20
or cw1200_sagrad.

In the real world, this driver will have to support non-devicetree=20
operation for as long as Linux does, and indeed longer, thanks to=20
compat-drivers/backports.

And for what it's worth, none of the platforms I have access to have=20
devicetree support since I'm stuck using vendor-supplied kernels.

> * Move the platform_data for the spi driver to
>   include/linux/platform_data/net-cw1200.h where all other
>   drivers have their platform_data.

Not all drivers, but fair enough.
=20
> * Add comments about passing GPIO numbers in platform_data:
>   You should not use IORESOURCE_IO, which is for legacy ISA
>   I/O ports on PCs, not for GPIOs.

Fair enough.  The use of resources was something already in the driver=20
when I inherited it, but I've seen this pattern a lot elsewhere.  Is=20
there a specific driver I should reference instead?

> It may actually be easier to remove the sdio driver entirely,
> since it clearly doesn't work and requires a lot of cleanup.

Several hundred thousand in-the-field devices already deployed with this=20
driver clearly disagree with you.

I've personally tested this driver on six different hardware platforms,=20
using mainline kernels for some and vendor-supplied kernels for others. =20
With module-down and SD-slot designs.  Others have tested other=20
platforms.  Every configurable option and line item in both the SPI and=20
SDIO platform data is there because it needs to be in order to support=20
the variety of hardware designs already in the wild.

This driver will also be part of the compat-drivers/backports project,=20
and as such has to work within that framework as well.

If you have constructive suggestions on how to handle this set of=20
requirements in a cleaner manner, I'm all ears.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRqzrCPuLgii2759ARAlxLAJ9RD06bXE/Ei/ltAP/0aYXp7OdjWgCfZzE2
R2Iv14gmrk/er+OBRMF3jbU=
=OmG6
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
