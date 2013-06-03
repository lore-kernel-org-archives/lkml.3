Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab3FCPES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:04:18 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41915 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3FCPEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:04:15 -0400
Message-ID: <51ACB06A.2050206@monstr.eu>
Date: Mon, 03 Jun 2013 17:04:10 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3] arm: zynq: Add cpuidle support
References: <2ba502c172f5374ed2e424292fb50345c9dd007a.1370266815.git.michal.simek@xilinx.com> <51ACA237.8070004@linaro.org>
In-Reply-To: <51ACA237.8070004@linaro.org>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2DWNNTBHRIXHUSFJBOHFD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2DWNNTBHRIXHUSFJBOHFD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/03/2013 04:03 PM, Daniel Lezcano wrote:
> On 06/03/2013 03:40 PM, Michal Simek wrote:
>> Add support for cpuidle.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>> Changes in v3:
>> - Move driver to drivers/cpuidle/
>> - Check zynq compatible string suggested by Arnd
>> - Use zynq_ function prefix because of multiplatform kernel
>> - Incorporate comments from Daniel Lezcano
>> - Rebase on the top of git://git.kernel.org/pub/scm/linux/kernel/git/r=
afael/linux-pm.git linux-next
>>
>> Changes in v2:
>> - Fix file header
>>
>> Changes in v1:
>> - It was the part of Zynq core changes
>>   https://patchwork.kernel.org/patch/2342511/
>>
>>  drivers/cpuidle/Kconfig        |   6 +++
>>  drivers/cpuidle/Makefile       |   1 +
>>  drivers/cpuidle/cpuidle-zynq.c | 100 ++++++++++++++++++++++++++++++++=
+++++++++
>>  3 files changed, 107 insertions(+)
>>  create mode 100644 drivers/cpuidle/cpuidle-zynq.c
>>
>> diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
>> index c4cc27e..8272a08 100644
>> --- a/drivers/cpuidle/Kconfig
>> +++ b/drivers/cpuidle/Kconfig
>> @@ -39,4 +39,10 @@ config CPU_IDLE_CALXEDA
>>  	help
>>  	  Select this to enable cpuidle on Calxeda processors.
>>
>> +config CPU_IDLE_ZYNQ
>> +	bool "CPU Idle Driver for Xilinx Zynq processors"
>> +	depends on ARCH_ZYNQ
>> +	help
>> +	  Select this to enable cpuidle on Xilinx Zynq processors.
>> +
>>  endif
>> diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
>> index 0d8bd55..8767a7b 100644
>> --- a/drivers/cpuidle/Makefile
>> +++ b/drivers/cpuidle/Makefile
>> @@ -7,3 +7,4 @@ obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) +=3D coupled=
=2Eo
>>
>>  obj-$(CONFIG_CPU_IDLE_CALXEDA) +=3D cpuidle-calxeda.o
>>  obj-$(CONFIG_ARCH_KIRKWOOD) +=3D cpuidle-kirkwood.o
>> +obj-$(CONFIG_CPU_IDLE_ZYNQ) +=3D cpuidle-zynq.o
>> diff --git a/drivers/cpuidle/cpuidle-zynq.c b/drivers/cpuidle/cpuidle-=
zynq.c
>> new file mode 100644
>> index 0000000..afe6af3
>> --- /dev/null
>> +++ b/drivers/cpuidle/cpuidle-zynq.c
>> @@ -0,0 +1,100 @@
>> +/*
>> + * Copyright (C) 2012-2013 Xilinx
>> + *
>> + * CPU idle support for Xilinx Zynq
>> + *
>> + * based on arch/arm/mach-at91/cpuidle.c
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + *
>> + * The cpu idle uses wait-for-interrupt and RAM self refresh in order=

>> + * to implement two idle states -
>> + * #1 wait-for-interrupt
>> + * #2 wait-for-interrupt and RAM self refresh
>> + */
>=20
> Please check you headers, it seems you are including unused headers.
>=20
>> +#include <linux/kernel.h>
>> +#include <linux/init.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/cpuidle.h>
>> +#include <linux/io.h>
>=20
> ^^^^^
>=20
>> +#include <linux/export.h>
>=20
> ^^^^^
>=20
>> +#include <linux/clockchips.h>
>=20
> ^^^^^
>=20
>> +#include <linux/cpu_pm.h>
>> +#include <linux/clk.h>
>=20
> ^^^^
>=20
>> +#include <linux/err.h>
>> +#include <linux/of.h>
>> +#include <asm/proc-fns.h>
>> +#include <asm/cpuidle.h>
>> +
>> +#define ZYNQ_MAX_STATES		2
>> +
>> +static DEFINE_PER_CPU(struct cpuidle_device, zynq_cpuidle_device);
>=20
> see below.
>=20
>> +
>> +/* Actual code that puts the SoC in different idle states */
>> +static int zynq_enter_idle(struct cpuidle_device *dev,
>> +		struct cpuidle_driver *drv, int index)
>=20
> Indentation.
>=20
>> +{
>> +	/* Devices must be stopped here */
>> +	cpu_pm_enter();
>> +
>> +	/* Add code for DDR self refresh start */
>> +	cpu_do_idle();
>> +
>> +	/* Add code for DDR self refresh stop */
>> +	cpu_pm_exit();
>> +
>> +	return index;
>> +}
>> +
>> +static struct cpuidle_driver zynq_idle_driver =3D {
>> +	.name =3D "zynq_idle",
>> +	.owner =3D THIS_MODULE,
>> +	.states =3D {
>> +		ARM_CPUIDLE_WFI_STATE,
>> +		{
>> +			.enter            =3D zynq_enter_idle,
>> +			.exit_latency     =3D 10,
>> +			.target_residency =3D 10000,
>> +			.flags            =3D CPUIDLE_FLAG_TIME_VALID,
>> +					    CPUIDLE_FLAG_TIMER_STOP,
>> +			.name             =3D "RAM_SR",
>> +			.desc             =3D "WFI and RAM Self Refresh",
>> +		},
>> +	},
>> +	.safe_state_index =3D 0,
>> +	.state_count =3D ZYNQ_MAX_STATES,
>> +};
>> +
>> +/* Initialize CPU idle by registering the idle states */
>> +static int zynq_init_cpuidle(void)
>> +{
>> +	unsigned int cpu;
>> +	struct cpuidle_device *device;
>> +	int ret;
>> +
>> +	if (!of_machine_is_compatible("xlnx,zynq-7000"))
>> +		return -ENODEV;
>> +
>> +	ret =3D cpuidle_register_driver(&zynq_idle_driver);
>> +	if (ret) {
>> +		pr_err("%s: Driver registration failed\n", __func__);
>> +		return ret;
>> +	}
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		device =3D &per_cpu(zynq_cpuidle_device, cpu);
>> +		device->cpu =3D cpu;
>> +		ret =3D cpuidle_register_device(device);
>> +		if (ret) {
>> +			pr_err("%s: Device registration failed\n", __func__);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	pr_info("Xilinx Zynq CpuIdle Driver started\n");
>=20
> Hi Michal,
>=20
> actually you can replace this code by
>=20
> cpuidle_register(&zynq_idle_driver, NULL);
>=20
> and remove the zynq_cpuidle_device.
>=20
> The framework will take care of registering the driver and the devices.=


Will change.


>> +	return 0;
>> +}
>> +module_init(zynq_init_cpuidle);
>=20
> Do you really want it as module ?

kirkwood is a module
but in Makefile depends directly on ARCH
obj-$(CONFIG_ARCH_KIRKWOOD) +=3D cpuidle-kirkwood.o

Calxeda uses module_init() which is in this configuration device_initcall=
=2E

Any advantage to write it as module?
Maybe for testing purpose will be helpful to have it as module too.
What do you think?

BTW: I will also add entry to MAINTAINERS file and list myself in this he=
ader.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2DWNNTBHRIXHUSFJBOHFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGssGoACgkQykllyylKDCEqVQCdHfY5vquqa7DbHjbRo8c5s0ru
FdQAn2z6tiCIsTdjKDI6wcUbX45Sw6yq
=LJQN
-----END PGP SIGNATURE-----

------enig2DWNNTBHRIXHUSFJBOHFD--
