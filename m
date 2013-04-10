Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936727Ab3DJMaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:30:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37664 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935332Ab3DJMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:30:10 -0400
Date: Wed, 10 Apr 2013 13:30:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: mfd, arizona: Fix the deadlock between interrupt handler and
 dpm_suspend
Message-ID: <20130410123003.GZ9243@opensource.wolfsonmicro.com>
References: <1365597549.12565.4.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3gXTOHwNCYOUonZC"
Content-Disposition: inline
In-Reply-To: <1365597549.12565.4.camel@cliu38-desktop-build>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3gXTOHwNCYOUonZC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2013 at 08:39:09PM +0800, Chuansheng Liu wrote:

> Here the arizona irq is not NOSUSPEND irq, so when doing device suspend,
> we can disable the arizona irq, and enable it until devices resuming fini=
shed.

Hrm, well - actually the primary IRQ probably ought to be a nosuspend in
the first place so this probably isn't what we want.  Something like the
below which does a similar thing to what we do on resume might help
here...  needs testing though.

=46rom 538e817db94dc0c689ecfea7151b1a3f86bb204a Mon Sep 17 00:00:00 2001
=46rom: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 10 Apr 2013 12:40:26 +0100
Subject: [PATCH] mfd: arizona: Disable interrupts during suspend

We aren't able to handle interrupts after the device has suspended since
we need to runtime resume it in order to do so but the controller may not
be available any more. Handle this in the same way as we handle a similar
issue on resume.

Reported-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 98023d8..c6be1f6 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -399,6 +399,26 @@ static int arizona_runtime_suspend(struct device *dev)
 #endif
=20
 #ifdef CONFIG_PM_SLEEP
+static int arizona_suspend(struct device *dev)
+{
+	struct arizona *arizona =3D dev_get_drvdata(dev);
+
+	dev_dbg(arizona->dev, "Suspend, disabling IRQ\n");
+	disable_irq(arizona->irq);
+
+	return 0;
+}
+
+static int arizona_suspend_late(struct device *dev)
+{
+	struct arizona *arizona =3D dev_get_drvdata(dev);
+
+	dev_dbg(arizona->dev, "Late suspend, reenabling IRQ\n");
+	enable_irq(arizona->irq);
+
+	return 0;
+}
+
 static int arizona_resume_noirq(struct device *dev)
 {
 	struct arizona *arizona =3D dev_get_drvdata(dev);
@@ -424,8 +444,9 @@ const struct dev_pm_ops arizona_pm_ops =3D {
 	SET_RUNTIME_PM_OPS(arizona_runtime_suspend,
 			   arizona_runtime_resume,
 			   NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, arizona_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(arizona_suspend, arizona_resume)
 #ifdef CONFIG_PM_SLEEP
+	.suspend_late =3D arizona_suspend_late,
 	.resume_noirq =3D arizona_resume_noirq,
 #endif
 };
--=20
1.7.10.4


--3gXTOHwNCYOUonZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZVsvAAoJELSic+t+oim925gP+wd///u7RC/LafAdQHkxIrHU
wgc0AuWpfaZno9jTkoOTBZmb8m6ysCiG8+8sZPiCEhYtuNX3YD+79s5dk+io8S8B
hQ5Fm3cB12CIQPMB878nhXlWmiY4akLM7R5NeRpDmVOdj8RC2sQG9erJz+1NApGb
gVv1c/l1tS5clXgC6lZCQCN5GnHszbefYcXrgthc7ezr6C+UIRrO+TOkDQu/7VHU
US+M/bpLh1jndRpb3V14A15GsqThzDawi8+zy8etbfySiAIFFACW6qmh27PTORms
8CiLj1yVOfGicSxqqJsyRzUJJKh6eagy4upHnbbFtpvseUVt0FSBAMjjXtABSz0u
xQazEonOL7cnBaoZG7l6Jt7gMroj18uGktWva3qjoqG28tQOtrokUvOAxwwrGiax
VfEcV4XTRJvZDUij63nAs7UmPye8WpaXjmXDt2Eb5n+HDHqKeemo7P7kHSzpuLqR
nkqu2MANuojG7LHGMIVFbcyKZ3vACG6e/4gkH3lBggxwVpd3IAzHX8AFJQqJZuuv
MJZiBB0B/3FTTZqGJKGuzWdsjhBDtNskLc2z+jieluZ0tBptA8cJz/vNoZ+901LJ
ZHLH4zXzNq9BxjuxjZivQSTvs5ljw1qnrjinezEBNCH9WVLmHBYiagCjEuVKrgOv
g2iobx3mQi04QwZY0Ppi
=/0DR
-----END PGP SIGNATURE-----

--3gXTOHwNCYOUonZC--
