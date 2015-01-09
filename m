Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbbAIMVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:21:32 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:60256 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbbAIMVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:21:30 -0500
Date: Fri, 9 Jan 2015 13:21:26 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-tegra@vger.kernel.org,
        Allen Martin <amartin@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>, pwalmsley@nvidia.com
Subject: Re: [PATCH] clocksource: tegra: wrap arch/arm-specific sections in
 CONFIG_ARM
Message-ID: <20150109122120.GJ16465@ulmo>
References: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
 <54AEB719.5060103@linaro.org>
 <alpine.DEB.2.02.1501090135280.28771@utopia.booyaka.com>
 <54AF91CC.2090007@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TC23+W66xmFESAX"
Content-Disposition: inline
In-Reply-To: <54AF91CC.2090007@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TC23+W66xmFESAX
Content-Type: multipart/mixed; boundary="KZLWU/9q3evlN4nQ"
Content-Disposition: inline


--KZLWU/9q3evlN4nQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 09:31:08AM +0100, Daniel Lezcano wrote:
> On 01/09/2015 03:09 AM, Paul Walmsley wrote:
> >Hello Daniel
> >
> >On Thu, 8 Jan 2015, Daniel Lezcano wrote:
> >
> >>On 12/09/2014 11:07 PM, Paul Walmsley wrote:
> >>>
> >>>Like several of the other files in drivers/clocksource,
> >>>tegra20_timer.c contains code that can only compile when CONFIG_ARM is
> >>>enabled.  This causes obvious problems when trying to compile this
> >>>code for NVIDIA ARM64-based SoCs, such as Tegra132.  The same timer IP
> >>>blocks exist, so it seems appropriate to provide support for them.
> >>>
> >>>So until we figure out a better way to partition this code, wrap the
> >>>delay_timer and persistent_clock support code with preprocessor tests
> >>>for CONFIG_ARM.
> >>>
> >>>  (The delay_timer code should not be needed at all on
> >>>ARM64 due to the presence of the ARMv8 architected timer.  The
> >>>persistent_clock support code could become important once power
> >>>management modes are implemented that turn off the CPU complex.)
> >>
> >>IIUC, the cpuidle driver is not yet ready, right ?
> >>
> >>If it is the case, this driver is not needed yet, no ?
> >
> >The point of the patch is to allow the hardware drivers selected by
> >CONFIG_ARCH_TEGRA to build for an arm64 kernel, just as they build for
> >32-bit ARM.
> >
> >There's nothing CPUIdle-specific about the patch - that is, this timer c=
an
> >be selected as a clockevent and clocksource provider without the use of
> >CPUIdle - although low-power PM idle is likely to be a primary use-case.
>=20
> What I meant is this timer is not needed for the moment.
>=20
> >>Perhaps you can rework a bit this driver in the meantime to have a bett=
er fix
> >>than disabling the code with macros ?
> >
> >I'm happy to do that, but it would be nice to get the driver compiling
> >first for ARM64 :-)
> >
> >>Otherwise, please try at least to group the code into a minimal set of =
macros.
> >
> >So, would it be accurate to say that you would prefer a patch that chang=
es
> >more lines of code, but minimizes preprocessor directives, to the current
> >patch?
>=20
> Yes at least an attempt to factor out a bit the driver. Those #ifdef are
> like #if 0, which is a quick fix. I am not strongly against this patch, b=
ut
> it would be nice to take the opportunity to reorganize it a bit.

How about we do something like the attached patch instead for now. That
avoids any #ifdef'ery and still we don't attempt (and fail) to build the
driver on 64-bit ARM.

With that applied we can incrementally make the changes to untangle the
ARM-specific parts and when the driver can build on 64-bit ARM we simply
select TEGRA_TIMER via Kconfig.

Thierry

--KZLWU/9q3evlN4nQ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="0001-clocksource-Build-Tegra-timer-on-32-bit-ARM-only.patch"
Content-Transfer-Encoding: quoted-printable

=46rom dccf6b8e0dcf5695eb29a8749406472e578b972e Mon Sep 17 00:00:00 2001
=46rom: Thierry Reding <treding@nvidia.com>
Date: Mon, 7 Jul 2014 15:26:30 +0200
Subject: [PATCH] clocksource: Build Tegra timer on 32-bit ARM only

Instead of directly using the ARCH_TEGRA Kconfig symbol to enable this
driver, add a new, non-user-visible Kconfig symbol (TEGRA_TIMER) which
can be selected by the various SoCs.

This is useful to disable building the driver on Tegra132 (64-bit ARM)
where it doesn't currently compile but also isn't needed (yet).

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig  | 4 ++++
 drivers/clocksource/Kconfig  | 3 +++
 drivers/clocksource/Makefile | 2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index f87684e600c7..667a48e2f7d4 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -29,6 +29,7 @@ config ARCH_TEGRA_2x_SOC
 	select PINCTRL_TEGRA20
 	select PL310_ERRATA_727915 if CACHE_L2X0
 	select PL310_ERRATA_769419 if CACHE_L2X0
+	select TEGRA_TIMER
 	help
 	  Support for NVIDIA Tegra AP20 and T20 processors, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
@@ -39,6 +40,7 @@ config ARCH_TEGRA_3x_SOC
 	select ARM_ERRATA_764369 if SMP
 	select PINCTRL_TEGRA30
 	select PL310_ERRATA_769419 if CACHE_L2X0
+	select TEGRA_TIMER
 	help
 	  Support for NVIDIA Tegra T30 processor family, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
@@ -49,6 +51,7 @@ config ARCH_TEGRA_114_SOC
 	select ARM_L1_CACHE_SHIFT_6
 	select HAVE_ARM_ARCH_TIMER
 	select PINCTRL_TEGRA114
+	select TEGRA_TIMER
 	help
 	  Support for NVIDIA Tegra T114 processor family, based on the
 	  ARM CortexA15MP CPU
@@ -58,6 +61,7 @@ config ARCH_TEGRA_124_SOC
 	select ARM_L1_CACHE_SHIFT_6
 	select HAVE_ARM_ARCH_TIMER
 	select PINCTRL_TEGRA124
+	select TEGRA_TIMER
 	help
 	  Support for NVIDIA Tegra T124 processor family, based on the
 	  ARM CortexA15MP CPU
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index fc01ec27d3c8..c062b6105d49 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -47,6 +47,9 @@ config SUN5I_HSTIMER
 	select CLKSRC_MMIO
 	bool
=20
+config TEGRA_TIMER
+	bool
+
 config VT8500_TIMER
 	bool
=20
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 94d90b24b56b..ba9ebd868ec5 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -27,7 +27,7 @@ obj-$(CONFIG_ARCH_U300)		+=3D timer-u300.o
 obj-$(CONFIG_SUN4I_TIMER)	+=3D sun4i_timer.o
 obj-$(CONFIG_SUN5I_HSTIMER)	+=3D timer-sun5i.o
 obj-$(CONFIG_MESON6_TIMER)	+=3D meson6_timer.o
-obj-$(CONFIG_ARCH_TEGRA)	+=3D tegra20_timer.o
+obj-$(CONFIG_TEGRA_TIMER)	+=3D tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+=3D vt8500_timer.o
 obj-$(CONFIG_ARCH_NSPIRE)	+=3D zevio-timer.o
 obj-$(CONFIG_ARCH_BCM_MOBILE)	+=3D bcm_kona_timer.o
--=20
2.1.3


--KZLWU/9q3evlN4nQ--

--6TC23+W66xmFESAX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUr8fAAAoJEN0jrNd/PrOh+WkP+gNTk5TJNTIDre4Mp0yv2SHv
g5ndaRh+IqpfJLonJijrhZs0z2t7xVI0z+N1sGHIyARXgDc1U4lPxIjSBpFakA8L
OICfqn7TP8F7/luTZC5L/X3tLr0g2GS8ZgETliMZ7SuO7cD6M1lC+E9lOValRxug
gRBcUxLMNBKRtcUb5TP+/sN04XHBYS4KEngi/ExhcSdQtsdqa1hlhZTWYRbgr+Z4
KSEmjUckETeIm2HMOvMvAHDXdZM3iQ60/czNgfsJ1dHh4PIcWDchPpCQrvXhPVtD
fksyLYWUtmOS6xCOgmbTm28gchqlW+R4wErKDQCdlpntn2zZHLJCFrXvtLjO4UsH
ktOZkctdMAVrptV5z1bbPrrfSlMd20BFpEGB6u0PxsnNbYPnFWo4FAXX5BlEURjg
JU1ZyIpKX3M93xUpanWKqY1hY/TTWl5QlPxthN59HRZ5f4nRuowT60+WVG25SCVI
nbZiU9bVX2gleobtf+iZOggIzDhaA8VapOJVHoIVIp1Ec4Tyap1buzHFLThrqCKJ
VaJpqgo8eZrYqjlEqbZlUIgovEgCqWQS3gLaeiHCcyYce7gdRve0Ygxw1Wc/rL/S
Xao1ZuwEiMyGUk/K5xFclGzuhucAf5JsO/nzYho5cXqLz5EYV2HHQXwAIm6A1mRs
MmUUTGFQZmhbJkxejy5Y
=c6An
-----END PGP SIGNATURE-----

--6TC23+W66xmFESAX--
