Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbbAZVFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:05:05 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:58237 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbbAZVFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:05:02 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: mmc does not work in qemu n900
Date: Mon, 26 Jan 2015 22:04:59 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2140942.rm5U7zV4qW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501262204.59305@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2140942.rm5U7zV4qW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

for unknown reason kernel in qemu n900 machine is not able to=20
detect internal eMMC memory. External SD card is detected without=20
problem.

If I apply this one-line patch eMMC in qemu start working:

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 9584bff..0d4461c 100644
=2D-- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2337,6 +2337,9 @@ static int mmc_rescan_try_freq(
 		return 0;
 	if (!mmc_attach_sd(host))
 		return 0;
+
+	mmc_go_idle(host);
+
 	if (!mmc_attach_mmc(host))
 		return 0;

I played with mmc and qemu n900 a bit and also this simple patch=20
(without first) fix problem (that mmc is not detected by kernel):

diff --git a/drivers/mmc/core/mmc_ops.c=20
b/drivers/mmc/core/mmc_ops.c
index 3b044c5..0c93a2c 100644
=2D-- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -157,6 +157,10 @@ int mmc_send_op_cond(
=20
 	BUG_ON(!host);
=20
+	/* reset mmc before calling op_cond */
+	memset(&cmd, 0, sizeof(struct mmc_command));
+	mmc_wait_for_cmd(host, &cmd, MMC_CMD_RETRIES);
+
 	cmd.opcode =3D MMC_SEND_OP_COND;
 	cmd.arg =3D mmc_host_is_spi(host) ? 0 : ocr;
 	cmd.flags =3D MMC_RSP_SPI_R1 | MMC_RSP_R3 | MMC_CMD_BCR;
=20

I have no idea where is problem. I also do not understand mmc=20
kernel code, but second patch I have on my HDD since 2.6.37.

Can somebody with knowledge of mmc subsystem look at this=20
problem? Why any of these two patches fix problem when mmc is not=20
detected by kernel in qemu (machine n900)? Detection of mmc fails=20
because function mmc_send_op_cond() without one of above patches=20
fails.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2140942.rm5U7zV4qW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTGq/sACgkQi/DJPQPkQ1LpbQCbB9rsxOTbfxx9Jw/lRHFG4fak
bJ8An3uQy5wmH0DbPFFon01Y7LNIC/wZ
=D3yF
-----END PGP SIGNATURE-----

--nextPart2140942.rm5U7zV4qW--
