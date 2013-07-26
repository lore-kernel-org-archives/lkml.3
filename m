Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab3GZN2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:28:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34121 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab3GZN23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:28:29 -0400
Message-ID: <51F2792E.2060301@ti.com>
Date: Fri, 26 Jul 2013 09:27:10 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <wni@nvidia.com>,
        <l.stach@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <cpufreq@vger.kernel.org>
Subject: Re: [RESEND PATCH V1 1/9] cpufreq: cpufreq-cpu0: add dt node parsing
 for 'needs-cooling'
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com> <1374074248-31690-2-git-send-email-eduardo.valentin@ti.com> <36180776.zbN9qNcjis@vostro.rjw.lan>
In-Reply-To: <36180776.zbN9qNcjis@vostro.rjw.lan>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="e5RuxGNAJE5XqC7EoHja7LRJ5mviribGX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e5RuxGNAJE5XqC7EoHja7LRJ5mviribGX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 25-07-2013 19:28, Rafael J. Wysocki wrote:
> On Wednesday, July 17, 2013 11:17:20 AM Eduardo Valentin wrote:
>> This patch changes the cpufreq-cpu0 driver to consider if
>> a cpu needs cooling (with cpufreq). In case the cooling is needed,
>> it can be flagged at the cpu0 device tree node, with the boolean
>> property 'needs-cooling'.
>>
>> In case this boolean is present, the driver will
>> load a cpufreq cooling device in the system. The cpufreq-cpu0
>> driver is not interested in determining how the system should
>> be using the cooling device. The driver is responsible
>> only of loading the cooling device.
>>
>> Describing how the cooling device will be used can be
>> accomplished by setting up a thermal zone that references
>> and is composed by the cpufreq cooling device.
>>
>> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>=20
> FWIW, this change is fine by me, but I guess it should be handled along=
 with
> the entire series.

Raphael, thanks for your review.

Yeah, this change must be handled along with the other changes in this
series. There is still ongoing discussion in DT mailing list with
respect to thermal bindings. Thus, for now, this patch is on hold.

>=20
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: cpufreq@vger.kernel.org
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt | 3 +++
>>  drivers/cpufreq/cpufreq-cpu0.c                             | 8 ++++++=
++
>>  2 files changed, 11 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.tx=
t b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
>> index 051f764..e8ff916 100644
>> --- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
>> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
>> @@ -15,6 +15,8 @@ Optional properties:
>>  - clock-latency: Specify the possible maximum transition latency for =
clock,
>>    in unit of nanoseconds.
>>  - voltage-tolerance: Specify the CPU voltage tolerance in percentage.=

>> +- needs-cooling: The generic cpu cooling (freq clipping) is loaded by=
 the
>> +generic cpufreq-cpu0 driver in case the device tree node has this boo=
lean.
>> =20
>>  Examples:
>> =20
>> @@ -33,6 +35,7 @@ cpus {
>>  			198000  850000
>>  		>;
>>  		clock-latency =3D <61036>; /* two CLK32 periods */
>> +		needs-cooling;
>>  	};
>> =20
>>  	cpu@1 {
>> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-=
cpu0.c
>> index ad1fde2..4a8747a 100644
>> --- a/drivers/cpufreq/cpufreq-cpu0.c
>> +++ b/drivers/cpufreq/cpufreq-cpu0.c
>> @@ -20,6 +20,9 @@
>>  #include <linux/platform_device.h>
>>  #include <linux/regulator/consumer.h>
>>  #include <linux/slab.h>
>> +#include <linux/thermal.h>
>> +#include <linux/cpu_cooling.h>
>> +#include <linux/cpumask.h>
>> =20
>>  static unsigned int transition_latency;
>>  static unsigned int voltage_tolerance; /* in percentage */
>> @@ -28,6 +31,7 @@ static struct device *cpu_dev;
>>  static struct clk *cpu_clk;
>>  static struct regulator *cpu_reg;
>>  static struct cpufreq_frequency_table *freq_table;
>> +static struct thermal_cooling_device *cdev;
>> =20
>>  static int cpu0_verify_speed(struct cpufreq_policy *policy)
>>  {
>> @@ -268,6 +272,9 @@ static int cpu0_cpufreq_probe(struct platform_devi=
ce *pdev)
>>  		goto out_free_table;
>>  	}
>> =20
>> +	if (of_property_read_bool(np, "needs-cooling"))
>> +		cdev =3D cpufreq_cooling_register(cpu_present_mask);
>> +
>>  	of_node_put(np);
>>  	of_node_put(parent);
>>  	return 0;
>> @@ -283,6 +290,7 @@ out_put_parent:
>> =20
>>  static int cpu0_cpufreq_remove(struct platform_device *pdev)
>>  {
>> +	cpufreq_cooling_unregister(cdev);
>>  	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
>>  	opp_free_cpufreq_table(cpu_dev, &freq_table);
>> =20
>>


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--e5RuxGNAJE5XqC7EoHja7LRJ5mviribGX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHyeTEACgkQCXcVR3XQvP2YKwD8D8GXupOvyy+jcynhYLxoYaBx
FIXrgeG5Dfxug/t9nI4BAOB6ErkWo5qIKUzOebHmcPLGPeDcU4JUHkMxvRdkxEBN
=nW/X
-----END PGP SIGNATURE-----

--e5RuxGNAJE5XqC7EoHja7LRJ5mviribGX--
