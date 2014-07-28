Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072AbaG1Qb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:31:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38077 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaG1QbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:31:25 -0400
Message-ID: <53D67AD5.2000500@pengutronix.de>
Date: Mon, 28 Jul 2014 18:31:17 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
References: <cover.1405428166.git.stefan@agner.ch> <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch> <53C5398F.2000005@pengutronix.de> <1b8a8ca03b4a160027a79b722f697e25@agner.ch> <601adb6fe47279c115c1cc607365a00e@agner.ch> <53D25C9D.5080803@pengutronix.de> <e88108c655e2c16dc9cf6c4194547e73@agner.ch>
In-Reply-To: <e88108c655e2c16dc9cf6c4194547e73@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="lBTU58tSi5tjKohNCkSxOVxSF24uwL2gW"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lBTU58tSi5tjKohNCkSxOVxSF24uwL2gW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/28/2014 06:20 PM, Stefan Agner wrote:
[...]

> However, I got once this Kernel panic after I reconfigured to normal
> mode. But I could not reproduce this.
>=20
> [  461.954394] flexcan_irq, esr=3D00059d82
> [  461.958093] flexcan_irq, ctrl=3D17092051
> [  461.961873] ------------[ cut here ]------------
> [  461.966536] WARNING: CPU: 0 PID: 0 at kernel/locking/mutex.c:826
> mutex_trylock+0x1b0/0x208()
> [  461.974982] DEBUG_LOCKS_WARN_ON(in_interrupt())

Please use this updated version of your patch:

Marc

---

=46rom b6b8ae7cdb04f1a3b9d3a6dd83f8146bfaf48553 Mon Sep 17 00:00:00 2001
From: Stefan Agner <stefan@agner.ch>
Date: Tue, 15 Jul 2014 14:56:20 +0200
Subject: [PATCH] can: flexcan: flexcan_get_berr_counter(): switch on cloc=
ks
 before accessing ecr register

The funcion flexcan_get_berr_counter() may be called from userspace even =
if the
interface is down, this the clocks are disabled. This patch switches on t=
he
clocks before accessing the ecr register.

Reported-by: Ashutosh Singh <ashuleapyear@gmail.com>
Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index f425ec2..6bfe24a 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -378,8 +378,9 @@ static int flexcan_chip_softreset(struct flexcan_priv=
 *priv)
 	return 0;
 }
=20
-static int flexcan_get_berr_counter(const struct net_device *dev,
-				    struct can_berr_counter *bec)
+
+static int __flexcan_get_berr_counter(const struct net_device *dev,
+				      struct can_berr_counter *bec)
 {
 	const struct flexcan_priv *priv =3D netdev_priv(dev);
 	struct flexcan_regs __iomem *regs =3D priv->base;
@@ -391,6 +392,29 @@ static int flexcan_get_berr_counter(const struct net=
_device *dev,
 	return 0;
 }
=20
+static int flexcan_get_berr_counter(const struct net_device *dev,
+				    struct can_berr_counter *bec)
+{
+	const struct flexcan_priv *priv =3D netdev_priv(dev);
+	int err;
+
+	err =3D clk_prepare_enable(priv->clk_ipg);
+	if (err)
+		return err;
+
+	err =3D clk_prepare_enable(priv->clk_per);
+	if (err)
+		goto out_disable_ipg;
+
+	err =3D __flexcan_get_berr_counter(dev, bec);
+
+	clk_disable_unprepare(priv->clk_per);
+ out_disable_ipg:
+	clk_disable_unprepare(priv->clk_ipg);
+
+	return err;
+}
+
 static int flexcan_start_xmit(struct sk_buff *skb, struct net_device *de=
v)
 {
 	const struct flexcan_priv *priv =3D netdev_priv(dev);
@@ -503,7 +527,7 @@ static void do_state(struct net_device *dev,
 	struct flexcan_priv *priv =3D netdev_priv(dev);
 	struct can_berr_counter bec;
=20
-	flexcan_get_berr_counter(dev, &bec);
+	__flexcan_get_berr_counter(dev, &bec);
=20
 	switch (priv->can.state) {
 	case CAN_STATE_ERROR_ACTIVE:
--=20
2.0.1

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--lBTU58tSi5tjKohNCkSxOVxSF24uwL2gW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPWetUACgkQjTAFq1RaXHNwtQCfSSIUBwxDjt2HI1GygotU8pKz
wbkAnii3JlSmtXAX/t0ngCkpmsdJH/AK
=pdA8
-----END PGP SIGNATURE-----

--lBTU58tSi5tjKohNCkSxOVxSF24uwL2gW--
