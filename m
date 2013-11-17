Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3KQX3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 18:29:37 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42045 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3KQX32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 18:29:28 -0500
Date: Mon, 18 Nov 2013 10:29:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Kryger <tim.kryger@linaro.org>
Subject: linux-next: build failure after merge of the i2c tree
Message-Id: <20131118102916.2a81b09818d07a6863f6b003@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Nov_2013_10_29_16_+1100_ONHIZq0Kn8_dWabs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Nov_2013_10_29_16_+1100_ONHIZq0Kn8_dWabs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wolfram,

After merging the i2c tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/i2c/busses/i2c-bcm-kona.c: In function 'bcm_kona_send_i2c_cmd':
drivers/i2c/busses/i2c-bcm-kona.c:268:2: error: implicit declaration of fun=
ction 'INIT_COMPLETION' [-Werror=3Dimplicit-function-declaration]

Caused by commit 93d17247118c ("i2c: bcm-kona: Introduce Broadcom I2C
Driver") interacting with commit 62026aedaace ("sched: remove
INIT_COMPLETION") from Linus` tree.

I have applied the following merge fix patch and can carry it as
necessary (please inform Linus of this when you ask him to merge your
tree).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 18 Nov 2013 10:26:37 +1100
Subject: [PATCH] i2c: bcm-kona: fix for INIT_COMPLETION -> reinit_completion
 API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/i2c/busses/i2c-bcm-kona.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bcm-kona.c b/drivers/i2c/busses/i2c-bcm=
-kona.c
index 7b7b7622b0d1..865e5dd9e655 100644
--- a/drivers/i2c/busses/i2c-bcm-kona.c
+++ b/drivers/i2c/busses/i2c-bcm-kona.c
@@ -265,7 +265,7 @@ static int bcm_kona_send_i2c_cmd(struct bcm_kona_i2c_de=
v *dev,
 	writel(IER_I2C_INT_EN_MASK, dev->base + IER_OFFSET);
=20
 	/* Mark as incomplete before sending the command */
-	INIT_COMPLETION(dev->done);
+	reinit_completion(&dev->done);
=20
 	/* Send the command */
 	bcm_kona_i2c_send_cmd_to_ctrl(dev, cmd);
@@ -295,7 +295,7 @@ static int bcm_kona_i2c_read_fifo_single(struct bcm_kon=
a_i2c_dev *dev,
 	unsigned long time_left =3D msecs_to_jiffies(I2C_TIMEOUT);
=20
 	/* Mark as incomplete before starting the RX FIFO */
-	INIT_COMPLETION(dev->done);
+	reinit_completion(&dev->done);
=20
 	/* Unmask the read complete interrupt */
 	writel(IER_READ_COMPLETE_INT_MASK, dev->base + IER_OFFSET);
@@ -372,7 +372,7 @@ static int bcm_kona_i2c_write_byte(struct bcm_kona_i2c_=
dev *dev, uint8_t data,
 	writel(IER_I2C_INT_EN_MASK, dev->base + IER_OFFSET);
=20
 	/* Mark as incomplete before sending the data */
-	INIT_COMPLETION(dev->done);
+	reinit_completion(&dev->done);
=20
 	/* Send one byte of data */
 	writel(data, dev->base + DAT_OFFSET);
@@ -407,7 +407,7 @@ static int bcm_kona_i2c_write_fifo_single(struct bcm_ko=
na_i2c_dev *dev,
 	unsigned int fifo_status;
=20
 	/* Mark as incomplete before sending data to the TX FIFO */
-	INIT_COMPLETION(dev->done);
+	reinit_completion(&dev->done);
=20
 	/* Unmask the fifo empty and nak interrupt */
 	writel(IER_FIFO_INT_EN_MASK | IER_NOACK_EN_MASK,
--=20
1.8.4.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__18_Nov_2013_10_29_16_+1100_ONHIZq0Kn8_dWabs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSiVFQAAoJEMDTa8Ir7ZwVZ2oP/3tGn4VeAoWJksfDla2GFOzn
edx+Xw/3icafATyArsHpYWlUDWPFKX/jQPORD3h3sI/w2YXeKCDWHe2gsX30bcZN
Z0l+rLSGWsDAfWS6bvyApgouoMNVPqe4Cj1pg+OzYO1218IKhZ6gZ+zQpUalysTz
7rrjg5u1hKNBNuL364X7YOZK2S8YvVjMlAinEpT68XC+mXPDZvLQc5QqTiT8oKE8
0pUonkNm3pILcOd8Y6hIYL+U4C7zDo2IYo3iN2YDAIcZ3KHG7SpyWdKwZuxWG3MB
dHuLeKi2v5WW14SaT4nXA2CWAgXINxdNSyhs/6nO7x60qXB8lpP2R/GKyQCJRSzR
pmqFMLpuiQ3WO2GfLChOivA0b6m7wjB/M+X7xvRZeX5r1J9VpJGwYMpNSs2ZD3vp
ruYJm2iMIqNvYyEfQk08rYppl6IeiONVmqv3NgYOZaGeUS4hnDA4qKl4igi1+SUQ
e3OKte0p9mP+DGOlbYyeF1TXSVZJUmcV7XY/1sqqV5t3Bu5bXIE3Fflq1GhP26uu
EttMWE1xLgrQFcy3jkEV9qOeaDNo6yVVPVKZRJZlsrgxes4RM8temhx2wPWiA2oY
N44mO0bfVamXO+zREBAbEwpkVjJRSU5uL5VILTdzuNKRky35DHLSD1KCjvB9Zmz2
VcrXAKWJubjVsoJZ4BDf
=ZBPe
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Nov_2013_10_29_16_+1100_ONHIZq0Kn8_dWabs--
