Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaA2LaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 06:30:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59486 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaA2LaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 06:30:19 -0500
Message-ID: <52E8E643.60408@ti.com>
Date: Wed, 29 Jan 2014 13:30:11 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        <chf.fritz@googlemail.com>, Tero Kristo <t-kristo@ti.com>, <nm@ti.com>
Subject: Re: [BISECTED] OMAP: DSS: clk rate mismatch
References: <52E697C0.6000202@gmail.com> <52E7614E.8010903@ti.com> <52E76EE0.2060006@ti.com> <52E7F451.7040708@gmail.com>
In-Reply-To: <52E7F451.7040708@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="3qQcAOrURL6exX3dCugF5If6S98H58eXg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3qQcAOrURL6exX3dCugF5If6S98H58eXg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-01-28 20:17, Ivaylo Dimitrov wrote:
>=20
>=20
> On 28.01.2014 10:48, Tomi Valkeinen wrote:
>=20
>> I made a somewhat hacky quickfix for beagle. Applying that and the
>> clk-divider from the link above makes things work for me. However, as =
I
>> said, the issue with n900 might be different, but it'd be interesting =
to
>> hear if it has any effect.
>>
>>   Tomi
>>
>=20
> Applying those 2 patches doesn't help, still get exactly the same warni=
ng.
>=20
> Find attached my clk_summary (with my hacky patch applied, otherwise I
> cannot boot the device)

Can you try this one:

=46rom e511789f7be00beeeee0712910c60a57c51b2705 Mon Sep 17 00:00:00 2001
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Wed, 29 Jan 2014 13:28:53 +0200
Subject: [PATCH] clkoutx2 fix

---
 arch/arm/mach-omap2/cclock3xxx_data.c |  7 +++++++
 arch/arm/mach-omap2/dpll3xxx.c        | 20 ++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/=
cclock3xxx_data.c
index 3b05aea56d1f..49247701a56c 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -428,12 +428,19 @@ static const char *dpll4_m5x2_ck_parent_names[] =3D=
 {
 	"dpll4_m5_ck",
 };
=20
+int omap3_clkoutx2_set_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long parent_rate);
+long omap3_clkoutx2_round_rate(struct clk_hw *hw, unsigned long target_r=
ate,
+		unsigned long *parent_rate);
+
 static const struct clk_ops dpll4_m5x2_ck_ops =3D {
 	.init		=3D &omap2_init_clk_clkdm,
 	.enable		=3D &omap2_dflt_clk_enable,
 	.disable	=3D &omap2_dflt_clk_disable,
 	.is_enabled	=3D &omap2_dflt_clk_is_enabled,
+	.set_rate	=3D &omap3_clkoutx2_set_rate,
 	.recalc_rate	=3D &omap3_clkoutx2_recalc,
+	.round_rate	=3D &omap3_clkoutx2_round_rate,
 };
=20
 static const struct clk_ops dpll4_m5x2_ck_3630_ops =3D {
diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xx=
x.c
index 3a0296cfcace..794665fe234b 100644
--- a/arch/arm/mach-omap2/dpll3xxx.c
+++ b/arch/arm/mach-omap2/dpll3xxx.c
@@ -669,6 +669,26 @@ unsigned long omap3_clkoutx2_recalc(struct clk_hw *h=
w,
 	return rate;
 }
=20
+int omap3_clkoutx2_set_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long parent_rate)
+{
+	return 0;
+}
+
+long omap3_clkoutx2_round_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long *prate)
+{
+	if (__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT) {
+		unsigned long best_parent;
+
+		best_parent =3D (rate / 2);
+		*prate =3D __clk_round_rate(__clk_get_parent(hw->clk),
+				best_parent);
+	}
+
+	return *prate * 2;
+}
+
 /* OMAP3/4 non-CORE DPLL clkops */
 const struct clk_hw_omap_ops clkhwops_omap3_dpll =3D {
 	.allow_idle	=3D omap3_dpll_allow_idle,
--=20
1.8.3.2




--3qQcAOrURL6exX3dCugF5If6S98H58eXg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS6OZDAAoJEPo9qoy8lh71YFYP/RQkvtDneum1Cmw3Yua0k+J6
udV4qeNhbDVA8lJgrGFWihIN7UYyC4X6kn84uiXePZZ6Vfe0K9UfP2LkFfZvhv8l
I4GChupl1sslV+eKtCBTWG2Hlbix4/nUqfkbAHiA7ljeDs7HtEQtUnWz9L0lAQYH
WPspFOZJ/KMjX3Z4try9do+nyM3uze+vjEOk22a25zhsbrVDoKv2gI4yT/4+RCUc
rVmLlZ2XLo0GNTykHuIurJnG4AWgMHH/GbIRNuRZ+gmy6UYXDtLw03p/yFqSFt8i
tjvtFS9Svl36EMkdya3meC9UPpxHtdSZqNOVvib0dRBDY2ZsK7/VPN3hlkYOJXWO
V15CQuS1MPGRGrRv2ARMZwEmabFbc4mhyKpqaSqn55PlnYirAxVGfJ0mcS+PWB00
orZ2yl1O/Z/TPaQR9DxOyCKxIi4csC15BofqH3ZytHMbJkPi6HawCWxs8Epkr12q
w2Zh+U2Kt3DVDqHm3j6lhtc4LPutqpoBtNYhtSemHQ508d5dWH74U0UYIQt2z4NU
u1oAsgnUE3VqppqYQyU4B+yAz5J9ttdS4u5HMcKvXm7QBtUOQrkD9PzIckhkblEH
0EV8TJU8+4Q1Fis+I87RREqEVBnaXio5tKAOjKTBlputokwhgKre69PdpCPgEYe5
imS82XIUZxK1ggbRJqNx
=hsce
-----END PGP SIGNATURE-----

--3qQcAOrURL6exX3dCugF5If6S98H58eXg--
