Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbaICQYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:24:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48497 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaICQYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:24:22 -0400
Date: Wed, 3 Sep 2014 17:23:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Heiko =?ISO-8859-1?Q?St=FCb?= =?ISO-8859-1?Q?ner?= 
	<heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140903172326.51b4b19f0cc7b901bcaaf218@kernel.org>
X-Mailer: Sylpheed 3.5.0beta1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Sep_2014_17_23_26_+0100_RlN+axJ0a3CGFADO"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the akpm-current tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Sep_2014_17_23_26_+0100_RlN+axJ0a3CGFADO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in drivers=
/clk/rockchip/clk.h and drivers/clk/rockchip/clk.c between commits like fe9=
4f974e9c8b8 ("clk: rockchip: protect critical clocks from getting disabled"=
) from the clk tree and "clk: rockchip: add restart handler" from the akpm-=
current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc drivers/clk/rockchip/clk.c
index d9c6db2151ba,aa41433eb34f..000000000000
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@@ -297,15 -244,26 +298,39 @@@ void __init rockchip_clk_register_branc
  	}
  }
 =20
 +void __init rockchip_clk_protect_critical(const char *clocks[], int ncloc=
ks)
 +{
 +	int i;
 +
 +	/* Protect the clocks that needs to stay on */
 +	for (i =3D 0; i < nclocks; i++) {
 +		struct clk *clk =3D __clk_lookup(clocks[i]);
 +
 +		if (clk)
 +			clk_prepare_enable(clk);
 +	}
 +}
++
+ static unsigned int reg_restart;
+ static int rockchip_restart_notify(struct notifier_block *this,
+ 				   unsigned long mode, void *cmd)
+ {
+ 	writel(0xfdb9, reg_base + reg_restart);
+ 	return NOTIFY_DONE;
+ }
+=20
+ static struct notifier_block rockchip_restart_handler =3D {
+ 	.notifier_call =3D rockchip_restart_notify,
+ 	.priority =3D 128,
+ };
+=20
+ void __init rockchip_register_restart_notifier(unsigned int reg)
+ {
+ 	int ret;
+=20
+ 	reg_restart =3D reg;
+ 	ret =3D register_restart_handler(&rockchip_restart_handler);
+ 	if (ret)
+ 		pr_err("%s: cannot register restart handler, %d\n",
+ 		       __func__, ret);
+ }
diff --cc drivers/clk/rockchip/clk.h
index 2b0bca19db47,0b5eab5b521f..000000000000
--- a/drivers/clk/rockchip/clk.h
+++ b/drivers/clk/rockchip/clk.h
@@@ -329,7 -329,7 +329,8 @@@ void rockchip_clk_register_branches(str
  				    unsigned int nr_clk);
  void rockchip_clk_register_plls(struct rockchip_pll_clock *pll_list,
  				unsigned int nr_pll, int grf_lock_offset);
 +void rockchip_clk_protect_critical(const char *clocks[], int nclocks);
+ void rockchip_register_restart_notifier(unsigned int reg);
 =20
  #define ROCKCHIP_SOFTRST_HIWORD_MASK	BIT(0)
 =20

--Signature=_Wed__3_Sep_2014_17_23_26_+0100_RlN+axJ0a3CGFADO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUB0B+AAoJELSic+t+oim99LQP/jzTLCyYE39kHriPSOuW+wyP
EC7anhOeJL8PMZH+zPZ6quP1JjSoOe6jSMB0g1JgPgJWVQzMAjrk72VDTTnpMRmq
fgZfN3y+5uiDGMEbWLaxUKN/cUDUD4lk4vwW3+m4oKLpDRqcrdhDLpG9vYEbYV0B
PwJYXXtdbHpMtgoXINb8MwnDct8nX8J6RrqdoipwFSTTEufMHa9DluO+9j3fbb5m
GHeJ2NrWGoBM22Q9bxigd0qeq31ddqDhsHyoR1WyTeXl8laf9iLv9AnbvHY6JmjY
cTQzVFh6J4JKG3zh8XZr8aj12B6G1ChPekIl0Tkm/kZ03UqTtvXktb8DYu4OB07X
4ngjVTs4UUDHxdSz31Mri3H2J6cIumLO3NkPO4bnVQfFJHpQotu7P8EeFtbddZuT
ushqmjYIdfV0mnG5uyxjtIYTF1JnqllHLl0TPUqOu81EDGT7ekbJsNEKx/+Aasqd
pa7BUyvbbKCAyMqVEdcO1KPXeVs73Lxka/9xx8L24JYN9qLkBLQfc06kefPpfz6J
Lt22XhifDqIO8NBr0eeVqaiUSsl3YfMK+RpeuYxi0pTUfxtLEgKWS4gwjLlSmAdM
R6Ayl73ropQXuSsxOH/LVOBAyNSt3K0cidU2IbayE6nMgvcYvCK2N3keuH/7iPXU
WXg6s7XqtRFSqctJMFxN
=3BeQ
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Sep_2014_17_23_26_+0100_RlN+axJ0a3CGFADO--
