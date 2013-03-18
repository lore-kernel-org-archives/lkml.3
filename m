Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3CREc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:32:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58048 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3CREbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:52 -0400
Date: Mon, 18 Mar 2013 15:31:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the tegra tree with the arm-soc tree
Message-Id: <20130318153140.100bdf364d5614ce31f12eae@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Mar_2013_15_31_40_+1100_qW+nzfEQQMLwfw0_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Mar_2013_15_31_40_+1100_qW+nzfEQQMLwfw0_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
drivers/clocksource/tegra20_timer.c between commit 1d16cfb3aeba
("clocksource: tegra20: use the device_node pointer passed to init") from
the arm-soc tree and commit 6f88fb8af6c6 ("clocksource: tegra: move to
of_clk_get") from the tegra tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clocksource/tegra20_timer.c
index 2e4d8a6,bc4b8ad..0000000
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@@ -218,34 -259,12 +218,34 @@@ static void __init tegra20_init_timer(s
  	tegra_clockevent.irq =3D tegra_timer_irq.irq;
  	clockevents_config_and_register(&tegra_clockevent, 1000000,
  					0x1, 0x1fffffff);
 -#ifdef CONFIG_HAVE_ARM_TWD
 -	twd_local_timer_of_register();
 -#endif
 +}
 +CLOCKSOURCE_OF_DECLARE(tegra20_timer, "nvidia,tegra20-timer", tegra20_ini=
t_timer);
 +
 +static void __init tegra20_init_rtc(struct device_node *np)
 +{
 +	struct clk *clk;
 +
 +	rtc_base =3D of_iomap(np, 0);
 +	if (!rtc_base) {
 +		pr_err("Can't map RTC registers");
 +		BUG();
 +	}
 +
 +	/*
 +	 * rtc registers are used by read_persistent_clock, keep the rtc clock
 +	 * enabled
 +	 */
- 	clk =3D clk_get_sys("rtc-tegra", NULL);
++	clk =3D of_clk_get(np, 0);
 +	if (IS_ERR(clk))
 +		pr_warn("Unable to get rtc-tegra clock\n");
 +	else
 +		clk_prepare_enable(clk);
 +
 +	of_node_put(np);
 +
  	register_persistent_clock(NULL, tegra_read_persistent_clock);
  }
 -CLOCKSOURCE_OF_DECLARE(tegra20, "nvidia,tegra20-timer", tegra20_init_time=
r);
 +CLOCKSOURCE_OF_DECLARE(tegra20_rtc, "nvidia,tegra20-rtc", tegra20_init_rt=
c);
 =20
  #ifdef CONFIG_PM
  static u32 usec_config;

--Signature=_Mon__18_Mar_2013_15_31_40_+1100_qW+nzfEQQMLwfw0_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRRpisAAoJEECxmPOUX5FEQAEP/0LdUcfpiGHoR9Ydwu3TrY5C
EWLkhGk6/m/gatMvvOtPcib19/q5QDHHAoDjsG//5rOQ0A3MykcGGnffwNnjuVRD
DGMRu4aJyY+qgHo+9918bzz92RV4rkOyZLz/UsaWJQ6XkhOB9yvz/8W+nIAJBn42
mAJQnGLwmgHuXP4iFcuBNmYKprUSpSyniFOW7p0h3V60L3VDhZpUt33Utn1V1BTE
6Ltx3BWnOt2bRQnzvhGsIC69r5fusaNR/zVLJEXaU7BDChKivqwzE/IFzpaS9A9y
jduvNWINUhl/sdKzgcegko2eyzOWR/Sf1/BKP9psvGex/b7FsWBIvMfhiOwnCLFP
cORSik4yHiMhjSkdQm+e1O0WPdiUKlicrCHqgqVRKKFCkv6RjLyeuGoRpUwD9BvQ
EYnmURhbFq6VJF8t0SP3fPbk/a6oArI0UvGiROjJVAWd8gW33B7I1cV91WBwXFM0
PuJrxEbcmCXNcX5C/9crnnmegjU0PFGUgJL5g0l3mp0qiJjD3FpX9gn3+D0cMypA
bMp26X19VLuLR2hhHw3q0ejsB6aM+8xcf9N84t4BXQVEYMKDC+9x92tLt5ptPEwQ
GoE1m/cj0jmrXmPRrPxrMAciBEd8NM+kXUT6fi2cR90UIwjdIKS7r6wCKLOz7dtH
3FDmw7zlBIvQtUGclj5P
=/oBP
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Mar_2013_15_31_40_+1100_qW+nzfEQQMLwfw0_--
