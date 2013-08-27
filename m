Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3H0IdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:33:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42497 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3H0IdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:33:17 -0400
Date: Tue, 27 Aug 2013 18:33:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: linux-next: manual merge of the arm-soc tree with the pm tree
Message-Id: <20130827183313.aa7d51c6dd0b21cd8168aa35@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_18_33_13_+1000_SrurXuJyzmAiLZRy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_18_33_13_+1000_SrurXuJyzmAiLZRy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-mvebu/platsmp.c between commit f6cec7cd0777 ("ARM: mvebu:
remove device tree parsing for cpu nodes") from the  tree and commit
994c8c94b419 ("ARM: mvebu: Remove the harcoded BootROM window
allocation") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mvebu/platsmp.c
index 594b63d,4f960f0..0000000
--- a/arch/arm/mach-mvebu/platsmp.c
+++ b/arch/arm/mach-mvebu/platsmp.c
@@@ -29,28 -30,31 +30,31 @@@
  #include "pmsu.h"
  #include "coherency.h"
 =20
+ #define AXP_BOOTROM_BASE 0xfff00000
+ #define AXP_BOOTROM_SIZE 0x100000
+=20
 +static struct clk *__init get_cpu_clk(int cpu)
 +{
 +	struct clk *cpu_clk;
 +	struct device_node *np =3D of_get_cpu_node(cpu, NULL);
 +
 +	if (WARN(!np, "missing cpu node\n"))
 +		return NULL;
 +	cpu_clk =3D of_clk_get(np, 0);
 +	if (WARN_ON(IS_ERR(cpu_clk)))
 +		return NULL;
 +	return cpu_clk;
 +}
 +
  void __init set_secondary_cpus_clock(void)
  {
 -	int thiscpu;
 +	int thiscpu, cpu;
  	unsigned long rate;
 -	struct clk *cpu_clk =3D NULL;
 -	struct device_node *np =3D NULL;
 +	struct clk *cpu_clk;
 =20
  	thiscpu =3D smp_processor_id();
 -	for_each_node_by_type(np, "cpu") {
 -		int err;
 -		int cpu;
 -
 -		err =3D of_property_read_u32(np, "reg", &cpu);
 -		if (WARN_ON(err))
 -			return;
 -
 -		if (cpu =3D=3D thiscpu) {
 -			cpu_clk =3D of_clk_get(np, 0);
 -			break;
 -		}
 -	}
 -	if (WARN_ON(IS_ERR(cpu_clk)))
 +	cpu_clk =3D get_cpu_clk(thiscpu);
 +	if (!cpu_clk)
  		return;
  	clk_prepare_enable(cpu_clk);
  	rate =3D clk_get_rate(cpu_clk);

--Signature=_Tue__27_Aug_2013_18_33_13_+1000_SrurXuJyzmAiLZRy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHGRJAAoJEECxmPOUX5FErSYP/1HeP3Jq0+XG6HEYPQ8K5Z2n
G5i/yx03OKYEz2TO5DOaTuxHl4J30xxelvpjah+ReAQmlNADTkgY91EMYehTBH0F
j51JWfTYcusmSPvrOwTywJ9LyKpayHRu/z5XKLKslI70zeIorhKdwNP7oPsZ/kWj
nLzO5dlj1pafgSFe7JnOJn2yGGGM0J24MgtJHRgJgK4ShEyfmtofyjh8gVr+eg23
3eeBFMF4GqpriuWCqM45D/QoVL9LeOxXt0uBUtPyXt/wyAa+Nq1wL+9g0vLP8sHR
3psRfpxHlvqFZzsD4gf6lj5PliHxLdEJ4QGV7AHkIvxxk/Wn5GrlZt3m2LmE+mcQ
Vle8qoUn2ivXfZa8Ow9/QMp74FC05I0qm+2PL1eGgovU32C2gaJmvUKmcckLb1Me
fCGVmbPgvI40vJkI2pm7uGmDx8mNS6CzDdLhoD1ndZM/ROqhIB8l3U6h7b+dtZvK
wZNsE+iRXBhITngjrhiA/qPDl+v22qgnwAh27sKeJxAvjJHwz2oSxG2wAplxfajH
/a48j4JTs7giKGoT2hm0E0MXA81C/IKCjlYoT/+QRF1Yo5P5hsgknCOfZG3o0xwI
BkztJFC5qJIbOy2qtMN1cTxX3eKJjFdy+0UmqX0uCGP5e9PxDJLTsHu1EfPwmOWk
+Q9rBkfsPo7b4ISx7dSM
=pQqz
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_18_33_13_+1000_SrurXuJyzmAiLZRy--
