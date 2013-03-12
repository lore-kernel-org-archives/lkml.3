Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab3CLDrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:47:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48871 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab3CLDra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:47:30 -0400
Date: Tue, 12 Mar 2013 14:47:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-Id: <20130312144714.39749c5b0bd1aea14c4d2ff8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_14_47_14_+1100_rbuXJK9wBX=ufRyx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_14_47_14_+1100_rbuXJK9wBX=ufRyx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/rtc/rtc-mv.c between commit 89c58c198b25 ("rtc: rtc-mv: Add
support for clk to avoid lockups") from the arm-soc tree and commit "rtc:
rtc-mv: use devm_rtc_device_register()" from the akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/rtc/rtc-mv.c
index f378e17,1ee8551..0000000
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@@ -272,16 -262,15 +272,17 @@@ static int __init mv_rtc_probe(struct p
 =20
  	if (pdata->irq >=3D 0) {
  		device_init_wakeup(&pdev->dev, 1);
- 		pdata->rtc =3D rtc_device_register(pdev->name, &pdev->dev,
+ 		pdata->rtc =3D devm_rtc_device_register(&pdev->dev, pdev->name,
  						 &mv_rtc_alarm_ops,
  						 THIS_MODULE);
- 	} else
- 		pdata->rtc =3D rtc_device_register(pdev->name, &pdev->dev,
+ 	} else {
+ 		pdata->rtc =3D devm_rtc_device_register(&pdev->dev, pdev->name,
  						 &mv_rtc_ops, THIS_MODULE);
+ 	}
 -	if (IS_ERR(pdata->rtc))
 -		return PTR_ERR(pdata->rtc);
 +	if (IS_ERR(pdata->rtc)) {
 +		ret =3D PTR_ERR(pdata->rtc);
 +		goto out;
 +	}
 =20
  	if (pdata->irq >=3D 0) {
  		writel(0, pdata->ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
@@@ -308,10 -292,6 +309,9 @@@ static int __exit mv_rtc_remove(struct=20
  	if (pdata->irq >=3D 0)
  		device_init_wakeup(&pdev->dev, 0);
 =20
- 	rtc_device_unregister(pdata->rtc);
 +	if (!IS_ERR(pdata->clk))
 +		clk_disable_unprepare(pdata->clk);
 +
  	return 0;
  }
 =20

--Signature=_Tue__12_Mar_2013_14_47_14_+1100_rbuXJK9wBX=ufRyx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPqVCAAoJEECxmPOUX5FEJo0QAKcd316DsC5yJo6aO0aVMW+e
Akgl37DM4oxN2riH081+mDSLdeF289+vzikCMapIVcHBXD/f3Yuo+hLZ7dLF8TbR
cy3oZVz1yFXfmtWe50MzDmtRSV4hlal6jFwfupbkmmPqWmF6omS7dEXx+7xwBmGm
C4gvUMH2q/W2eB+R/k3JvLHtCzuIHnaOdLDMwRcgkjEe31C7j+qwP3gJNjdBf5si
cNhf58zmktV/kPC3vppGafw5YiOSTTvi2GiXdVskjph9+nOXdhsnZF7Mr4zI+QAZ
jyNmt8Ia8wYWPOIOPf92tKjpTqP7VM3D2IzWTbFdEv2bsqyjjBE1Pj6mTUBJJ6HL
5GPteINyolqj0juKeO7nzFiZGcJ/0DC9E3oU0JZx8V/0sdePmmj1EXD/Q/epU8Pn
eRZnWMtyrJ+O0adCt+OB9MrOCIId5zQJlDaRgZR+dFaQoS2CKHUQA0slfv1JP8IT
4FaeDr/Np0BhpDN08H+FLoICZmqkYQF75/q93a+SNERRTmIOSolISeg/5fl+xthb
G+kRFQyRLu7WPghtAcTisral3f1rw+tuuDepbE8DtfK4D5MPe/v/ySyQIAvPbQhA
tEEoCCbdG9XQ9oOErVkY1lkJCb/xLVxeEdAxHd0GySmsC4QmU7+o7UNZ1WqLdvjG
6Cjanqu3/a7yqyoy8ivG
=0coy
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_14_47_14_+1100_rbuXJK9wBX=ufRyx--
