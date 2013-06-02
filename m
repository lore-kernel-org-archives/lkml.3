Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3FBOr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 10:47:58 -0400
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:45432
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab3FBOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 10:47:48 -0400
Date: Sun, 2 Jun 2013 10:47:26 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Ajitpal Singh <ajitpal.singh@stericsson.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cw1200: fix some obvious mistakes
Message-ID: <20130602144725.GC3875@shaftnet.org>
References: <1370126241-2528420-1-git-send-email-arnd@arndb.de>
 <20130602122954.GA3875@shaftnet.org>
 <8513280.folT80711V@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
In-Reply-To: <8513280.folT80711V@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 02, 2013 at 03:59:12PM +0200, Arnd Bergmann wrote:
> The driver doesn't reliably build, and I'm trying to fix it.
> From my perspective, we can just mark it 'depends on !ARM'
> to get it off my radar, but other people are doing build
> testing on x86 and will run into the same issues.

AFAIK the only remaining build problem is when CONFIG_CW1200_SAGRAD is=20
not defined so there's no "platform" data provided.

> If the hardware cannot be identified from register access, the
> information should get passed through firmware. On most architectures
> that means device tree data, on x86 that would be ACPI tables.

The cw1200 has specific reset sequencing requirements.  Some designs use=20
a hardware reset circuit (such as the Sagrad EVK/Reference design), but=20
most others use GPIOs for cost resons.

Without that reset sequence, the device will never attach itself to the=20
SDIO bus so we will never get to the point where we can probe it via=20
register accesses (and program the DPLL value) to discern enough=20
information to load the appropriate firmware.

(The DPLL value is part of the so-called 'SDD' file, but that file is=20
 also tied to the specific implemntation.  You have to love those=20
 chicken-and-egg problems...)

> The code does not look particularly off-the-shelf though:
> static struct resource cw1200_href_resources[] =3D {

That code is #ifdef'd out, and was purely left there as a reference. =20
It's gone now.  :)

> We can use platform_data if there is convincing evidence that people
> are going to be using that in mainline kernels. However, your SDIO driver
> doesn't actually do that, it just hardcodes settings in cw1200_sagrad.c
> and calls a local function to get that data, rather than getting the data
> from the dev_get_platdata() in it's probe callback at a point where
> it knows the device is actually there.

As I mentioned earlier, we don't know the device is there until after we=20
get enough information from the platform_data to power it up and deal=20
with the finiky reset sequence.

Basically the Sagrad SD-slot-form-factor EVK is a special case only=20
meant for evaluation purposes.  The "normal" use case for thise driver=20
is a hard-wired, permanently attached design.
=20
> If we only care about two cases a) a default sagrad card that can use
> hardcoded data and b) a board that uses the same chip and requires
> custom data, then I would suggest including the sagrad data in the
> sdio driver as a default (as my patch does) but allow overriding
> it with platform data.

Yes, those are the only use cases we care about.  And that sounds like a=20
viable approach, so I'll code that up.

I guess adding a function along the lines of=20
"cw1200_sdio_set_platform_data()" (to be called by the board/platform=20
setup code) would be the right way to do this?

As an aside, I wish I'd received this feedback a couple of months ago.

> The problem with this is that it is impossible to build a kernel that
> supports both, or even two devices of the same type.

Adding proper devicetree support will solve this problem down the line,=20
but I don't think there's any way to fix this for non-DT systems thanks=20
to that chicken-and-egg probing situation.

(I wish I had a DT-capable platform handy to develop against..)

> I mean arch/arm/mach-nomadik, which is the platform that originally
> defined NOMADIK_GPIO_TO_IRQ(). Note that in recent kernels, mach-ux500
> also uses this macro internally, but it's already gone in nomadik
> and will stop working in ux500 in the future.

Ah, okay.  FWIW that was a leftover bit from the original driver authors=20
who'd tied the code rather tightly to the ux500 platform.  That=20
reference is gone now in any case.

> I don't mind the backports supporting that, but we should probably
> move on in mainline. The existance of backports is no excuse for
> keeping around broken code.

I already have one patch queued up for backports to re-enable <2.6.36=20
support, and I have no problem adding more. =20

That said, until all SDIO/SPI-supporting targets in the mainline are=20
converted to a devicetree (or equivalent) model, I imagine the=20
platform_data crap will have to remain.

> just look in include/linux/platform_data/. The most common type for
> gpio numbers is 'int'.

I've already posted a patch that converts them over.

> Sorry for misinterpreting that, the cw1200_sagrad file really looked
> like it was written for some out-of-tree board and subsequently
> all lines that didn't compile got commented out.

No problem.  I just needed to make it clear that this driver did in fact=20
work -- and it also compiled cleanly on x86_64 as long as the sagrad=20
symbol was defined.

> In fact my mobile phone has a cw1200 chip that was working until
> recently. Now it just crashes when I do 'ifconfig wlan0 up'
> or enable WLAN in the Android settings menu. :(
>=20
> I'm not blaming you for that ;-)

What model, out of curiousity?
=20
> I think the most important part is separating the generic sagrad
> add-on card code from any platform-specific code and removing the
> use of cw1200_get_platform_data() function that breaks the build.

I'll convert SDIO driver to using the sagrad data as default and add a=20
'set_platform_data' sort of function to allow it to be optionally=20
overridden.  It shouldn't take long, and I'll post the patch as soon as=20
I'm finished.

(I don't know how long it'll take to get merged though.. none of the=20
 already-posted followup cw1200 patches have been merged into=20
 wireless-next yet)

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRq1r9PuLgii2759ARArx2AKCsMiKbe1uyzVd31gUNR8Uupbg2RwCcD0dd
Zza70FpX3uyP/nQl0c4xpm8=
=yW0L
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
