Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaEMFKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 01:10:54 -0400
Received: from ozlabs.org ([103.22.144.67]:46916 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbaEMFKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 01:10:53 -0400
Date: Tue, 13 May 2014 15:10:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the dt-rh tree with Linus' tree
Message-ID: <20140513151045.2e640394@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/RUtkFMFrcawWDepH+5RSEkd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RUtkFMFrcawWDepH+5RSEkd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rob,

Today's linux-next merge of the dt-rh tree got a conflict in
drivers/of/selftest.c between commit 82c0f5897a87 ("of: selftest: add
deferred probe interrupt test") from Linus' tree and commit
ae7c987bc3a7 ("of/selftest: add testcase for nodes with same name and
address") from the dt-rh tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/of/selftest.c
index fe70b86bcffb,c93cb4ae5a21..000000000000
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@@ -430,32 -430,23 +430,49 @@@ static void __init of_selftest_match_no
 =20
  static void __init of_selftest_platform_populate(void)
  {
 -	struct device_node *np, *child;
 +	int irq;
 +	struct device_node *np;
 +	struct platform_device *pdev;
++	struct device_node *child;
+ 	int rc;
+ 	struct of_device_id match[] =3D {
+ 		{ .compatible =3D "test-device", },
+ 		{}
+ 	};
 =20
 +	np =3D of_find_node_by_path("/testcase-data");
 +	of_platform_populate(np, of_default_bus_match_table, NULL, NULL);
 +
 +	/* Test that a missing irq domain returns -EPROBE_DEFER */
 +	np =3D of_find_node_by_path("/testcase-data/testcase-device1");
 +	pdev =3D of_find_device_by_node(np);
 +	if (!pdev)
 +		selftest(0, "device 1 creation failed\n");
 +	irq =3D platform_get_irq(pdev, 0);
 +	if (irq !=3D -EPROBE_DEFER)
 +		selftest(0, "device deferred probe failed - %d\n", irq);
 +
 +	/* Test that a parsing failure does not return -EPROBE_DEFER */
 +	np =3D of_find_node_by_path("/testcase-data/testcase-device2");
 +	pdev =3D of_find_device_by_node(np);
 +	if (!pdev)
 +		selftest(0, "device 2 creation failed\n");
 +	irq =3D platform_get_irq(pdev, 0);
 +	if (irq >=3D 0 || irq =3D=3D -EPROBE_DEFER)
 +		selftest(0, "device parsing error failed - %d\n", irq);
 +
 +	selftest(1, "passed");
++
+ 	np =3D of_find_node_by_path("/testcase-data/platform-tests");
+ 	if (!np) {
+ 		pr_err("No testcase data in device tree\n");
+ 		return;
+ 	}
+=20
+ 	for_each_child_of_node(np, child) {
+ 		rc =3D of_platform_populate(child, match, NULL, NULL);
+ 		selftest(!rc, "Could not create device for node '%s'\n", child->name);
+ 	}
  }
 =20
  static int __init of_selftest(void)

--Sig_/RUtkFMFrcawWDepH+5RSEkd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcalbAAoJEMDTa8Ir7ZwVeDoP/RCw6UNg6JNvArYrF82mDYye
6vWhmD3saHJF/p5/5sB/F4oJC/XVoiIoGr10nEZgYOPl1AnkthoZQWIBMcv17m8U
Pk3g2gNZgAjqzs99D8kxmxKQSmuEU1WSkmthimhbLr0dfYYTHs74JegUdqzTmx8Q
APlOv8seaxvCG54kOF9fseC/drQuSHBzlSOUqusRKMX1bp5zZ3dEsos7W/iLUzCm
Wec6y65YOYcDmgKRzXpnsJp9tLqIjGlrTFil9NElLIABPr37kaM81XGGWcarY9K0
uHpqwQLFgl4zwu2soX9G2LjZB6RH1wbTJ4oWvyII0Cl26SsXlDiXvj7OQbe7ZdEZ
5HZpGHKj04y5dyOo1sDE/dFMkPxK9JEoLJnxQ4qL7f4sMFMuFrjWzUPsKrblEn08
Q8aB0skDwTWH2mTxuDk/zMefopwfJlPVgzIR5kuhWSXUR/acY/Q8eUZ+nvziGAcH
RthKlS5RWYa/OFR0AUJy0kZnxNo19GfgY2/P9lJYoHlBNBgKE9A0iDkjdm0iAle2
qu7WCnPjP+GcaIHaP0hNJpVLQCf3YnrxYGImqKdW9mfdDE75aGJCBv8p3UYNEjaO
+Bds8UklmffPsUBouAm3MTsF9zfFkGFlbeEcE17rYgFp6pmaDq5u6j8uus1f7ufz
vck8SYCH2g6An/zQUhmU
=IT51
-----END PGP SIGNATURE-----

--Sig_/RUtkFMFrcawWDepH+5RSEkd--
