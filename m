Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3JCRO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:14:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60668 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab3JCRO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:14:56 -0400
Date: Thu, 3 Oct 2013 18:14:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        Imre Deak <imre.deak@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Message-ID: <20131003171440.GD27287@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hmb9n29fjuiORm2l"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Build failure after merge of the drm-intel tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hmb9n29fjuiORm2l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

After merging the drm-intel tree into -next an x86 allmodconfig build fails
with:

In file included from include/linux/kobject.h:29:0,
                 from include/linux/cpufreq.h:16,
                 from drivers/gpu/drm/i915/intel_pm.c:28:
drivers/gpu/drm/i915/intel_pm.c: In function =E2=80=98intel_pm_init=E2=80=
=99:
drivers/gpu/drm/i915/intel_pm.c:5883:34: error: =E2=80=98struct intel_gen6_=
power_mgmt=E2=80=99 has no member named =E2=80=98vlv_work=E2=80=99
  INIT_DELAYED_WORK(&dev_priv->rps.vlv_work, vlv_rps_timer_work);
                                  ^
include/linux/workqueue.h:216:16: note: in definition of macro =E2=80=98__I=
NIT_WORK=E2=80=99
   __init_work((_work), _onstack);    \
                ^
include/linux/workqueue.h:244:3: note: in expansion of macro =E2=80=98INIT_=
WORK=E2=80=99
   INIT_WORK(&(_work)->work, (_func));   \
   ^
include/linux/workqueue.h:260:2: note: in expansion of macro =E2=80=98__INI=
T_DELAYED_WORK=E2=80=99
  __INIT_DELAYED_WORK(_work, _func, 0)
  ^
drivers/gpu/drm/i915/intel_pm.c:5883:2: note: in expansion of macro =E2=80=
=98INIT_DELAYED_WORK=E2=80=99
  INIT_DELAYED_WORK(&dev_priv->rps.vlv_work, vlv_rps_timer_work);
  ^
drivers/gpu/drm/i915/intel_pm.c:5883:34: error: =E2=80=98struct intel_gen6_=
power_mgmt=E2=80=99 has no member named =E2=80=98vlv_work=E2=80=99
  INIT_DELAYED_WORK(&dev_priv->rps.vlv_work, vlv_rps_timer_work);
                                  ^
and so on caused by 671952a2a290a (drm/i915: fix rps.vlv_work
initialization) in the drm-intel-fixes tree interacting with ac3a48b3036
(drm/i915: Boost RPS frequency for CPU stalls) from the drm-intel tree.

I have used the fix below for today:

=46rom 4f4dccef92d64393e2a7e867f7c2755c09178c48 Mon Sep 17 00:00:00 2001
=46rom: Mark Brown <broonie@linaro.org>
Date: Thu, 3 Oct 2013 18:10:55 +0100
Subject: [PATCH] drm/i915: Resolve interaction with drm-fixes tree

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/gpu/drm/i915/intel_pm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_p=
m.c
index 7cdac0b..0b4de57 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5879,7 +5879,5 @@ void intel_pm_init(struct drm_device *dev)
=20
 	INIT_DELAYED_WORK(&dev_priv->rps.delayed_resume_work,
 			  intel_gen6_powersave_work);
-
-	INIT_DELAYED_WORK(&dev_priv->rps.vlv_work, vlv_rps_timer_work);
 }
=20
--=20
1.8.4.rc3


--Hmb9n29fjuiORm2l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTaX9AAoJELSic+t+oim97ngP+wQN0VYuA79Zf8sTDdGXmr3z
qTyoZJvOWfbOwnbD5Swlwu8amgGuIdLqhLXzN6CB80ujNZUBXNEj+v6oRIWqXyhP
2IDidwuZ7ksQWr552688kvxREiTokpfohIjOSHkwCBseSm0uYelDvl97LKkPV0tA
A+CTXETR7AJymHam2miY5LlTAIlV+4UxCBAocxo8Pxcvedaycc7VeLBELrl3OPrI
IsHPxbzUkJSIz8a9EmrkOiiLlGOe4ev2asS1rkZsqzCVdXZePIjX1VQ0q4WdH5mj
9iTSE5h/YXxV+n7BqgFtWHBYtY1SlMp35+8uLL0RumoqN/mv6Y3fCZvbvZC0xwnV
P60zdAfe35YkPu/xApitF5dckn6tQug5+xXQ85KQ8EkzIjU+uxTObAKjE5dNVpGe
lsbDZTbRHpL+oNASAg6/D4KFYbqffhQcIrJIf+DsMt3VAu9O0oRDrHFqS3W5huQK
51/IF7xepBlDVcCXMbi9QTiHuBDBgYzDShr6YBlIBG2cKSum7/s0XFjjZ18znPkb
Y/Ez8NlRRZJ/A9NWFPgOSXvLu2R6ND3Rt3IQvYFiHC06mEkNzKRFKLI1MeYsoeTB
7rXkOxzq4emWDMsKdW+l6H0jcjouzFYNi/Vfy+4qjLVnXZgFdos1o6IfvkLB9H4D
FypFV3Abc7IcK8A3Wq8n
=ROso
-----END PGP SIGNATURE-----

--Hmb9n29fjuiORm2l--
