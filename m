Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab3IBJBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:01:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38650 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3IBJBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:01:35 -0400
Date: Mon, 2 Sep 2013 19:01:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: linux-next: build failure after merge of the final tree (drm tree
 related)
Message-Id: <20130902190123.e3cd30ac95fcefa1aaa95c8b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Sep_2013_19_01_23_+1000_E=+6H/YZgo46ENDt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Sep_2013_19_01_23_+1000_E=+6H/YZgo46ENDt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/gpu/drm/radeon/ci_dpm.c: In function 'ci_request_link_speed_change_=
before_state_change':
drivers/gpu/drm/radeon/ci_dpm.c:4212:4: error: implicit declaration of func=
tion 'radeon_acpi_pcie_performance_request' [-Werror=3Dimplicit-function-de=
claration]
    if (radeon_acpi_pcie_performance_request(rdev, PCIE_PERF_REQ_PECI_GEN3,=
 false) =3D=3D 0)
    ^

Caused by commit cc8dbbb4f62a ("drm/radeon: add dpm support for CI dGPUs
(v2)").  These calls need protecting with CONFIG_ACPI (like is done in
cypress_dpm.c, I guess).

I tried reverting commit 9c725e5bcdae ("Merge branch 'drm-next-3.12' of
git://people.freedesktop.org/~agd5f/linux into drm-next") but that failed
because that branch is based on v3.11-rc7 (!) which is later than the
base of the drm tree (v3.11-rc3).  :-(

I added this fix up patch for today (it may be wrong, butfixes the build
failure).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 2 Sep 2013 18:57:41 +1000
Subject: [PATCH] drm/radeon: protect ACPI calls with CONFIG_ACPI

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dp=
m.c
index 916630f..3cce533 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -4208,6 +4208,7 @@ static void ci_request_link_speed_change_before_state=
_change(struct radeon_devic
 	pi->pspp_notify_required =3D false;
 	if (target_link_speed > current_link_speed) {
 		switch (target_link_speed) {
+#ifdef CONFIG_ACPI
 		case RADEON_PCIE_GEN3:
 			if (radeon_acpi_pcie_performance_request(rdev, PCIE_PERF_REQ_PECI_GEN3,=
 false) =3D=3D 0)
 				break;
@@ -4217,6 +4218,7 @@ static void ci_request_link_speed_change_before_state=
_change(struct radeon_devic
 		case RADEON_PCIE_GEN2:
 			if (radeon_acpi_pcie_performance_request(rdev, PCIE_PERF_REQ_PECI_GEN2,=
 false) =3D=3D 0)
 				break;
+#endif
 		default:
 			pi->force_pcie_gen =3D ci_get_current_pcie_speed(rdev);
 			break;
@@ -4248,7 +4250,9 @@ static void ci_notify_link_speed_change_after_state_c=
hange(struct radeon_device
 		    (ci_get_current_pcie_speed(rdev) > 0))
 			return;
=20
+#ifdef CONFIG_ACPI
 		radeon_acpi_pcie_performance_request(rdev, request, false);
+#endif
 	}
 }
=20
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__2_Sep_2013_19_01_23_+1000_E=+6H/YZgo46ENDt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSJFPnAAoJEECxmPOUX5FEHlAQAJ6YOPAllK+gx/SJVaBElA3/
DFoVVphPrFTXjFdnZ44llfLlbSffcHta80AX1GJB1Kgqm0IaK+lqA6CRMA2LpYyG
WsRPeqb1reYwejPqnCQL++PJZnQ/X/ozaO+me6TigFOA72iAiHnB6N1qkgiI5Rts
0h57/1ZgfTlxdFl9Wk06gsH6Iw20tIJNXLqLUgovZGvLlnFRFJYJcbPYW7OCHU8E
CJMXqkQjyA2eFYUpGwJp8VYEbf6dosAkS4WWJYxnC91MRFk+zeiJlv4s/R8V75MO
IAG/+iHLSakWCVKgr6yyFkCK4vVRwk18Kp1HjYXlkYKkTebcx3wccIiPOngzksqc
BuZl3u2DV1FptuzsfvZKdMIp03GAc8+xWaIFEDmKcH7ZHg7L99L4TREbC8AfTM0s
NSBCytDf8DMUg9BNBAA+P5wLA5OxOv7bUwXZuswEeSb3GM78xgZDA5o+GH5YZ/ee
s7lkAMgVtcyOvQ8/ScyYhrYhfjSodOKRtwxgnLGP5cfqFeQr7Jac8gUmCVsY6vTb
3QGj1j4Ir3ASNtbJhm9g/xAMSVqiYYxawkGStlJWlNadUlVp6LSdfsUmi2jgxbmE
Co0U1ahQvnobryzU0Km3HifHd44kDA6RipIuA5eJ8gm6hLooCC7S9xwrP+MlBjcQ
uXDimN2GiwBeKxZx2eup
=uOoi
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Sep_2013_19_01_23_+1000_E=+6H/YZgo46ENDt--
