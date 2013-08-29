Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab3H2HRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:17:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46573 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3H2HRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:17:17 -0400
Date: Thu, 29 Aug 2013 17:17:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Sherman Yin <syin@broadcom.com>
Subject: linux-next: manual merge of the pinctrl tree with Linus' tree
Message-Id: <20130829171704.7a7630dd19d19ccdb9aaf384@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_17_17_04_+1000_XmkXVoQxD.QLYN1K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_17_17_04_+1000_XmkXVoQxD.QLYN1K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
drivers/pinctrl/pinctrl-sunxi.c between commit 1bee963db9dd ("pinctrl:
sunxi: Add spinlocks") from Linus' tree and commit 03b054e9696c
("pinctrl: Pass all configs to driver on pin_config_set()") from the
pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pinctrl/pinctrl-sunxi.c
index 94716c7,8dbd465..0000000
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@@ -282,56 -282,47 +283,60 @@@ static int sunxi_pconf_group_set(struc
  	u32 val, mask;
  	u16 strength;
  	u8 dlevel;
+ 	int i;
 =20
- 	switch (pinconf_to_config_param(config)) {
- 	case PIN_CONFIG_DRIVE_STRENGTH:
- 		strength =3D pinconf_to_config_argument(config);
- 		if (strength > 40)
- 			return -EINVAL;
- 		/*
- 		 * We convert from mA to what the register expects:
- 		 *   0: 10mA
- 		 *   1: 20mA
- 		 *   2: 30mA
- 		 *   3: 40mA
- 		 */
- 		dlevel =3D strength / 10 - 1;
-=20
- 		spin_lock_irqsave(&pctl->lock, flags);
-=20
- 		val =3D readl(pctl->membase + sunxi_dlevel_reg(g->pin));
- 	        mask =3D DLEVEL_PINS_MASK << sunxi_dlevel_offset(g->pin);
- 		writel((val & ~mask) | dlevel << sunxi_dlevel_offset(g->pin),
- 			pctl->membase + sunxi_dlevel_reg(g->pin));
-=20
- 		spin_unlock_irqrestore(&pctl->lock, flags);
- 		break;
- 	case PIN_CONFIG_BIAS_PULL_UP:
- 		spin_lock_irqsave(&pctl->lock, flags);
+ 	for (i =3D 0; i < num_configs; i++) {
+ 		switch (pinconf_to_config_param(configs[i])) {
+ 		case PIN_CONFIG_DRIVE_STRENGTH:
+ 			strength =3D pinconf_to_config_argument(configs[i]);
+ 			if (strength > 40)
+ 				return -EINVAL;
+ 			/*
+ 			 * We convert from mA to what the register expects:
+ 			 *   0: 10mA
+ 			 *   1: 20mA
+ 			 *   2: 30mA
+ 			 *   3: 40mA
+ 			 */
+ 			dlevel =3D strength / 10 - 1;
++
++			spin_lock_irqsave(&pctl->lock, flags);
++
+ 			val =3D readl(pctl->membase + sunxi_dlevel_reg(g->pin));
+ 			mask =3D DLEVEL_PINS_MASK << sunxi_dlevel_offset(g->pin);
+ 			writel((val & ~mask)
+ 				| dlevel << sunxi_dlevel_offset(g->pin),
+ 				pctl->membase + sunxi_dlevel_reg(g->pin));
++
++			spin_unlock_irqrestore(&pctl->lock, flags);
+ 			break;
+ 		case PIN_CONFIG_BIAS_PULL_UP:
++			spin_lock_irqsave(&pctl->lock, flags);
 +
- 		val =3D readl(pctl->membase + sunxi_pull_reg(g->pin));
- 		mask =3D PULL_PINS_MASK << sunxi_pull_offset(g->pin);
- 		writel((val & ~mask) | 1 << sunxi_pull_offset(g->pin),
- 			pctl->membase + sunxi_pull_reg(g->pin));
+ 			val =3D readl(pctl->membase + sunxi_pull_reg(g->pin));
+ 			mask =3D PULL_PINS_MASK << sunxi_pull_offset(g->pin);
+ 			writel((val & ~mask) | 1 << sunxi_pull_offset(g->pin),
+ 				pctl->membase + sunxi_pull_reg(g->pin));
 +
- 		spin_unlock_irqrestore(&pctl->lock, flags);
- 		break;
- 	case PIN_CONFIG_BIAS_PULL_DOWN:
- 		spin_lock_irqsave(&pctl->lock, flags);
++			spin_unlock_irqrestore(&pctl->lock, flags);
+ 			break;
+ 		case PIN_CONFIG_BIAS_PULL_DOWN:
++			spin_lock_irqsave(&pctl->lock, flags);
 +
- 		val =3D readl(pctl->membase + sunxi_pull_reg(g->pin));
- 		mask =3D PULL_PINS_MASK << sunxi_pull_offset(g->pin);
- 		writel((val & ~mask) | 2 << sunxi_pull_offset(g->pin),
- 			pctl->membase + sunxi_pull_reg(g->pin));
+ 			val =3D readl(pctl->membase + sunxi_pull_reg(g->pin));
+ 			mask =3D PULL_PINS_MASK << sunxi_pull_offset(g->pin);
+ 			writel((val & ~mask) | 2 << sunxi_pull_offset(g->pin),
+ 				pctl->membase + sunxi_pull_reg(g->pin));
 +
- 		spin_unlock_irqrestore(&pctl->lock, flags);
- 		break;
- 	default:
- 		break;
- 	}
++			spin_unlock_irqrestore(&pctl->lock, flags);
+ 			break;
+ 		default:
+ 			break;
+ 		}
 =20
- 	/* cache the config value */
- 	g->config =3D config;
+ 		/* cache the config value */
+ 		g->config =3D configs[i];
+ 	} /* for each config */
 =20
  	return 0;
  }

--Signature=_Thu__29_Aug_2013_17_17_04_+1000_XmkXVoQxD.QLYN1K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHvV1AAoJEECxmPOUX5FE3XAQAIv5UP+9DLJWzJ8lAA6cj7B7
ocovw5w1bKsDTRt5NlrTS8xn9HRTPQD2fNvBrTo0RZ/vF+OYE5x6R0aBXhaE9/ET
ObPsyWRRi4yTqs+p3zqxFTq4/lTzN5ljbIBF/duK4OUMZ1MV+t/c7Nm2cYcUwoQ7
Ksss2GdIMUUB7Dbf/iO4skxrIoUZTZ70Eyh+0cbjGIVIEM3F2HfxoXUDJFez2RxT
FaSdZzzI1XBqUm7wcEQUlvf0V3L7cacwCYk/6BuasYQIafbNpVjjgytRwYq8vLx2
VZwFZPCPgV61cJsd9oLBPRnb25nkNaMr2RFBvYoB83H636T8yPWQpiaIjAuL3Ps5
HQ0DdCQEgU3oupH1Z2YIalQg4oqDpRYBlJ+UEDsfVKyJbcRrn0j2BmtuE1WA7+mE
uF96CCgmxFCm0BB1P3lyL6AVAQIIF0FFMPpUxaKiFBBs+Q5Yf9+v8Jp6qwwO7nTQ
hll8UO9hK+vOqKzoCJ8Ciynpe/29u1UNDXHhO3sv+RhjIi5PptvQjoCoq5Q8BFhH
Uq1O1qc+sgf0rynBNe/WrHlSFDja9BZB6EeBRYItNPXkiy5rYlSWwqivSK1n6L1t
gFm6bXP3j816rkIdRMMX30gXbjRxDGFtxUvbaRJni5kUvU+AWjOxkuCcb0CPC6IW
At0U1cVIh7nAPUlDl+q6
=bABg
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_17_17_04_+1000_XmkXVoQxD.QLYN1K--
