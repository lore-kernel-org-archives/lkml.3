Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbaDBMPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:15:44 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54703 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663AbaDBMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:15:42 -0400
Message-ID: <533BFF69.1060701@monstr.eu>
Date: Wed, 02 Apr 2014 14:15:37 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>
Subject: Re: [PATCH 06/10] ARM: EXYNOS: Add support for mapping PMU base address
 via DT
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com> <1396425058-4012-7-git-send-email-pankaj.dubey@samsung.com> <533BF905.6070701@samsung.com>
In-Reply-To: <533BF905.6070701@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9FDrGSik0x3iHNLqXDosbrSCHjQdt3cB6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9FDrGSik0x3iHNLqXDosbrSCHjQdt3cB6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/02/2014 01:48 PM, Sylwester Nawrocki wrote:
> On 02/04/14 09:50, Pankaj Dubey wrote:
>> From: Young-Gun Jang <yg1004.jang@samsung.com>
>>
>> Add support for mapping Exynos Power Management Unit (PMU) base addres=
s
>> from device tree. Code will use existing samsung pmu binding informati=
on.
>> This patch also adds "get_exynos_pmubase" a helper function to return =
mapped base
>> address to various other files under "mach-exynos".
>>
>> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>  arch/arm/mach-exynos/common.h |    2 ++
>>  arch/arm/mach-exynos/exynos.c |   44 ++++++++++++++++++++++++++++++++=
+++++++++
>>  2 files changed, 46 insertions(+)
>>
> [...]
>>  #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exyn=
os.c
>> index a5e1349..a5127fb 100644
>> --- a/arch/arm/mach-exynos/exynos.c
>> +++ b/arch/arm/mach-exynos/exynos.c
>> @@ -35,6 +35,8 @@
>>  #define L2_AUX_VAL 0x7C470001
>>  #define L2_AUX_MASK 0xC200ffff
>> =20
>> +static void __iomem *exynos_pmu_base __initdata;
>> +
>>  static struct map_desc exynos4_iodesc[] __initdata =3D {
>>  	{
>>  		.virtual	=3D (unsigned long)S3C_VA_SYS,
>> @@ -245,6 +247,47 @@ void __init exynos_init_late(void)
>>  	exynos_pm_init();
>>  }
>> =20
>> +static char const *exynos_dt_pmu_match[] __initconst =3D {
>> +	"samsung,exynos4210-pmu",
>> +	"samsung,exynos4212-pmu",
>> +	"samsung,exynos4412-pmu",
>> +	"samsung,exynos5250-pmu",
>> +	NULL
>> +};
>> +
>> +static int __init exynos_fdt_map_pmu(unsigned long node,
>> +		const char *uname, int depth, void *data)
>> +{
>> +	struct map_desc iodesc;
>> +	__be32 *reg;
>> +	unsigned long len;
>> +
>> +	if (of_flat_dt_match(node, exynos_dt_pmu_match)) {
>> +		phys_addr_t phys_addr;
>> +		reg =3D of_get_flat_dt_prop(node, "reg", &len);
>> +		if (reg =3D=3D NULL || len !=3D (sizeof(unsigned long) * 2))
>> +			return 0;
>> +
>> +		phys_addr =3D be32_to_cpu(reg[0]);
>> +		iodesc.pfn =3D __phys_to_pfn(phys_addr);
>> +		iodesc.length =3D be32_to_cpu(reg[1]) - 1;
>> +		iodesc.virtual =3D (unsigned long)S5P_VA_PMU;
>> +		iodesc.type =3D MT_DEVICE;
>> +		iotable_init(&iodesc, 1);
>=20
> Are you sure...you need this in addition to ioremap() below ?
> Can't you just use the Linux syscon API ?
> There were some patches posted for syscon to make it available in earli=
er
> system initialization stage: https://lkml.org/lkml/2014/2/19/218

I haven't finished this yet. I have to look at it again.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--9FDrGSik0x3iHNLqXDosbrSCHjQdt3cB6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM7/2kACgkQykllyylKDCECUgCeJ3+bOw48VpTbeStAgsgY8XbV
1xoAnRM5V6AfnKiFjb69OgmXhzepol/a
=X/hw
-----END PGP SIGNATURE-----

--9FDrGSik0x3iHNLqXDosbrSCHjQdt3cB6--
