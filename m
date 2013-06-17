Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab3FQGsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:48:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44124 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab3FQGso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:48:44 -0400
Date: Mon, 17 Jun 2013 16:48:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Jingoo Han <jg1.han@samsung.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the arm-soc tree with the tty tree
Message-Id: <20130617164841.41561f78f3465bd4007411b6@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_16_48_41_+1000_wO2HOueQvgRAXmYu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_16_48_41_+1000_wO2HOueQvgRAXmYu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/tty/serial/xilinx_uartps.c between commit 696faedd616e ("serial:
use platform_{get,set}_drvdata()") from the tty tree and commit
30e1e28598c2 ("arm: zynq: Migrate platform to clock controller") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/xilinx_uartps.c
index 6c91745,a4a3028..0000000
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@@ -972,14 -1004,15 +1004,14 @@@ static int xuartps_probe(struct platfor
  		port->mapbase =3D res->start;
  		port->irq =3D res2->start;
  		port->dev =3D &pdev->dev;
- 		port->uartclk =3D clk_get_rate(clk);
- 		port->private_data =3D clk;
+ 		port->uartclk =3D clk_get_rate(xuartps_data->refclk);
+ 		port->private_data =3D xuartps_data;
 -		dev_set_drvdata(&pdev->dev, port);
 +		platform_set_drvdata(pdev, port);
  		rc =3D uart_add_one_port(&xuartps_uart_driver, port);
  		if (rc) {
  			dev_err(&pdev->dev,
  				"uart_add_one_port() failed; err=3D%i\n", rc);
- 			return rc;
 -			dev_set_drvdata(&pdev->dev, NULL);
+ 			goto err_out_clk_disable;
  		}
  		return 0;
  	}
@@@ -993,14 -1039,19 +1038,18 @@@ err_out_free
   **/
  static int xuartps_remove(struct platform_device *pdev)
  {
 -	struct uart_port *port =3D dev_get_drvdata(&pdev->dev);
 +	struct uart_port *port =3D platform_get_drvdata(pdev);
- 	struct clk *clk =3D port->private_data;
+ 	struct xuartps *xuartps_data =3D port->private_data;
  	int rc;
 =20
  	/* Remove the xuartps port from the serial core */
  	rc =3D uart_remove_one_port(&xuartps_uart_driver, port);
 -	dev_set_drvdata(&pdev->dev, NULL);
  	port->mapbase =3D 0;
- 	clk_disable_unprepare(clk);
+ 	clk_disable_unprepare(xuartps_data->refclk);
+ 	clk_disable_unprepare(xuartps_data->aperclk);
+ 	clk_put(xuartps_data->refclk);
+ 	clk_put(xuartps_data->aperclk);
+ 	kfree(xuartps_data);
  	return rc;
  }
 =20

--Signature=_Mon__17_Jun_2013_16_48_41_+1000_wO2HOueQvgRAXmYu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvrFJAAoJEECxmPOUX5FEko0P/RdRdEH5z2ReuWy353vudtil
EqCTXKZYpDUy8cME9UENlQsEDO/2MS3qikf+jY+dkXH4U+iW+RWU4NP5fVYElDYr
3Anui8FBMERX3uG8TPi1iF1qvA716JDJdldUFDc2ZRhZQmQ+bEb+f0QMvOB7wwcW
2txOW4kSe4/ntpgKpDybblqIoNffGqT0OjkEOcRyDN3RrWImA6jjAF5p6S311q87
wElOjNMHFpFFeU4LzLeQhtSVxU8aDZA7lJSVpae1cahLX2U3lf1pfmVJSGtLTF2P
5wDRIrxOry26izP9qJBd9dCGjlaxiEiVp8WF2LYfB7rl3d46cIXVVBRUBKf1fDb1
0m3WpjkHzFNmdT1P0x/XOB1BjPWvCDKQ97BIFjpE68h8Mtz19lKaonydvOBQRUQ7
LkpXStCqh4nLi1gaa7RpdJjb3vWc56cuHgpLAIQQrhTB6X54TDx7KX40K+9Ow49x
NomOZM0m/Y6jWHz8Z/SaoCc+PL9JF3bqnuPMeZcY6Th/aWC4EY0fmiWr1icKXRKi
sVKVxLtq5D/brJW+jqrV1GGAhhhIX1VpzexEdcp4PSMR4bmQ2dVJcKpNAD4Glclg
mLEoT5tP/SsDv7FsuOkZgrNk84O9AxU1JjNrKydh88NziFUOu+dE3+UrTCKRbk9v
nXQ8Q0SXke6OmBs9Ml2I
=MR5m
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_16_48_41_+1000_wO2HOueQvgRAXmYu--
