Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaESCvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 22:51:35 -0400
Received: from ozlabs.org ([103.22.144.67]:44963 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbaESCve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 22:51:34 -0400
Date: Mon, 19 May 2014 12:51:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: linux-next: manual merge of the pm tree with the samsung tree
Message-ID: <20140519125124.6504764d@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/n+GoYBpTr9ERl.sTIEYr/Og"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/n+GoYBpTr9ERl.sTIEYr/Og
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got conflicts in
drivers/cpufreq/exynos-cpufreq.c and drivers/cpufreq/exynos-cpufreq.h
between commit 2b07f4085479 ("cpufreq: exynos: Fix the compile error")
from the samsung tree and commit e5eaa445b0dc ("cpufreq: exynos: Use
dev_err/info function instead of pr_err/info") from the pm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/cpufreq/exynos-cpufreq.c
index e8a4a7ed38c1,c3e55aa28cf8..000000000000
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@@ -164,22 -163,16 +164,24 @@@ static int exynos_cpufreq_probe(struct=20
  	if (!exynos_info)
  		return -ENOMEM;
 =20
+ 	exynos_info->dev =3D &pdev->dev;
+=20
 -	if (soc_is_exynos4210())
 +	if (of_machine_is_compatible("samsung,exynos4210")) {
 +		exynos_info->type =3D EXYNOS_SOC_4210;
  		ret =3D exynos4210_cpufreq_init(exynos_info);
 -	else if (soc_is_exynos4212() || soc_is_exynos4412())
 +	} else if (of_machine_is_compatible("samsung,exynos4212")) {
 +		exynos_info->type =3D EXYNOS_SOC_4212;
  		ret =3D exynos4x12_cpufreq_init(exynos_info);
 -	else if (soc_is_exynos5250())
 +	} else if (of_machine_is_compatible("samsung,exynos4412")) {
 +		exynos_info->type =3D EXYNOS_SOC_4412;
 +		ret =3D exynos4x12_cpufreq_init(exynos_info);
 +	} else if (of_machine_is_compatible("samsung,exynos5250")) {
 +		exynos_info->type =3D EXYNOS_SOC_5250;
  		ret =3D exynos5250_cpufreq_init(exynos_info);
 -	else
 -		return 0;
 +	} else {
 +		pr_err("%s: Unknown SoC type\n", __func__);
 +		return -ENODEV;
 +	}
 =20
  	if (ret)
  		goto err_vdd_arm;
diff --cc drivers/cpufreq/exynos-cpufreq.h
index f189547bb447,b72ff10a040e..000000000000
--- a/drivers/cpufreq/exynos-cpufreq.h
+++ b/drivers/cpufreq/exynos-cpufreq.h
@@@ -41,7 -34,7 +41,8 @@@ struct apll_freq=20
  };
 =20
  struct exynos_dvfs_info {
+ 	struct device	*dev;
 +	enum exynos_soc_type type;
  	unsigned long	mpll_freq_khz;
  	unsigned int	pll_safe_idx;
  	struct clk	*cpu_clk;

--Sig_/n+GoYBpTr9ERl.sTIEYr/Og
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTeXGyAAoJEMDTa8Ir7ZwV2L4P/3ADOIlnqY9zX2uFiy+5rjX+
AGMy4rS3XexGAPzq5CVTDn3iwLeeKZH3zgMNyTJujziwwNJ4wFfQvYt1UO1cHOWV
ipb5UDXimc5b1yrQR+41IXljFPxYiMi58L+MEsDUo45LY+RpnT5QfFJ0RIL/2bjR
1/RedTuohh0kbcbF8cQEc9SwgF/MFoXKpSYb998/JVILgrYy3r5QEbyK6kaGBK7K
+MAvqywagslYKqta8a1th9vrWXw1sHZO7bm+7tivGcH+8xsR0eBXcPGNFfD5bRgr
0qoyf8BGkzHrsv3lLq8SQE+/WlTO4jBoYvkxgXHI7qBpW98NkiIfq3tN8OfsZbh7
+vFldrUfRBS5uZWG1YVSkmfExaCIvuPJhsAjt8Zd2Ve1AnqizvvzHhZcp0glxfj2
fNPJsVmU9vrqjYhzlYrJ4TkshzGCqlOjVg4D+d2APRfT4uLKAuhO/wQo5Y8mqI7I
k94QepLvIY7KKoZTXY+vEEGQp7wq7Kyd554Xp1TEv5hcIcXFQgr/KCFYlFMNg1SR
VB1mLT6rCjxZLyfdsgyE6uj9+22604EmLAFYR3MBWPZJo+ITe9FUHJWFIwJRtYdL
nR63Gk8meX1E+W4axVzfkMggGCNv4vkKO/lW7jL3K7kjn04CjgjaZJL6AwPUpwtK
f3cRGcCXv+SHT+hMZrxS
=vAvp
-----END PGP SIGNATURE-----

--Sig_/n+GoYBpTr9ERl.sTIEYr/Og--
