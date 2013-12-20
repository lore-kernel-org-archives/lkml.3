Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3LTDsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:48:40 -0500
Received: from ozlabs.org ([203.10.76.45]:35135 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab3LTDsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:48:39 -0500
Date: Fri, 20 Dec 2013 14:48:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Anatolij Gustschin <agust@denx.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gerhard Sittig <gsi@denx.de>, Jingoo Han <jg1.han@samsung.com>
Subject: linux-next: manual merge of the spi tree with the mpc5xxx tree
Message-Id: <20131220144831.234673a46206ecc9287724fb@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Dec_2013_14_48_31_+1100_.d6BlH73jlJBV35Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Dec_2013_14_48_31_+1100_.d6BlH73jlJBV35Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

Today's linux-next merge of the spi tree got a conflict in
drivers/spi/spi-mpc512x-psc.c between commit 9d37619fb37f ("spi: mpc512x:
adjust to OF based clock lookup") from the mpc5xxx tree and commit
e1d0cd473be4 ("spi: mpc512x: Use devm_*() functions") from the spi tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

diff --cc drivers/spi/spi-mpc512x-psc.c
index 2babea28b310,46d2313f7c6f..000000000000
--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@@ -519,10 -519,12 +518,10 @@@ static int mpc512x_psc_spi_do_probe(str
  		goto free_master;
  	init_completion(&mps->txisrdone);
 =20
 -	psc_num =3D master->bus_num;
 -	snprintf(clk_name, sizeof(clk_name), "psc%d_mclk", psc_num);
 -	clk =3D devm_clk_get(dev, clk_name);
 +	clk =3D devm_clk_get(dev, "mclk");
  	if (IS_ERR(clk)) {
  		ret =3D PTR_ERR(clk);
- 		goto free_irq;
+ 		goto free_master;
  	}
  	ret =3D clk_prepare_enable(clk);
  	if (ret)
@@@ -550,15 -542,9 +549,11 @@@
 =20
  	return ret;
 =20
 -free_clock:
 +free_ipg_clock:
 +	clk_disable_unprepare(mps->clk_ipg);
 +free_mclk_clock:
  	clk_disable_unprepare(mps->clk_mclk);
- free_irq:
- 	free_irq(mps->irq, mps);
  free_master:
- 	if (mps->psc)
- 		iounmap(mps->psc);
  	spi_master_put(master);
 =20
  	return ret;
@@@ -570,10 -556,6 +565,7 @@@ static int mpc512x_psc_spi_do_remove(st
  	struct mpc512x_psc_spi *mps =3D spi_master_get_devdata(master);
 =20
  	clk_disable_unprepare(mps->clk_mclk);
 +	clk_disable_unprepare(mps->clk_ipg);
- 	free_irq(mps->irq, mps);
- 	if (mps->psc)
- 		iounmap(mps->psc);
 =20
  	return 0;
  }

--Signature=_Fri__20_Dec_2013_14_48_31_+1100_.d6BlH73jlJBV35Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSs74UAAoJEMDTa8Ir7ZwVkOwP+QEuJmyPrkkTkr8LFGI03DzQ
etC/IYP0fzXfl3zzRZPScApSlYcqzqeq1AO2pD3fJrRJp93bd6qSvZCURnZF+yg1
Q7rrpiz+Lmunu6Xy0XvtmLcIXrul1RhfmCHS2UTTrvR+4xrBuADlyHPiGnAoDREZ
AO59r8qw8NCN8EOLGDtum6SrG6V+owYZ0U6Utw83RmszBpsqTrlhEqjTJCcHLQMN
nShdnJ4xDmOWZIkdTRBA2JAj6pigIkzmqsXe6/OEVOK2oRy0JHFL/7VWJVA8taVt
EEmDQp5lZuGSoP7ho0Z5qDuKsv7ag6DwSwq/yZGqCwdb9/kiUyifojh/hS+58IZw
Mm5rMAIClLease99/f+aEcDnGmy6MTUyLYhOUIgkjE2Lr3U1AnVjemznOQDCi9rl
jTj79x9KSZ00gWOXUZ2jO8EYREidGl7U8Wn7qil2ylqVfk9TIy2CyAJpk3UjmiLB
2Y6UbgxGysMboVuR9oJ5FNvyzKh4DG5UupKqzNa1zNJrCR+gfJkGkDV4DnewlJGH
lja0vzf8TJyfN23iY7xPuMsedot+NALHHdv/B5nmAgImWLYf+tFvWs6zgwTsHX/M
jeiGBLYQ2fvb+wxX5GuB94tonqUYUVPmMgwRa2IIPj8gbktmyr3JYyQw4zI5SAKi
4esnMABTOdxObJzDb0tg
=yM+D
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Dec_2013_14_48_31_+1100_.d6BlH73jlJBV35Q--
