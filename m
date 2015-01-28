Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbbA2BzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:55:14 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63453 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbA2BzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:55:11 -0500
Date: Wed, 28 Jan 2015 01:23:33 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, broonie@kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 6/9] thermal: cpu_cooling: implement the power
 cooling device API
Message-ID: <20150128052330.GD29600@developer.hsd1.ca.comcast.net>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-7-git-send-email-javi.merino@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="10jrOL3x2xqLmOsH"
Content-Disposition: inline
In-Reply-To: <1417806260-9264-7-git-send-email-javi.merino@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--10jrOL3x2xqLmOsH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Javi,

On Fri, Dec 05, 2014 at 07:04:17PM +0000, Javi Merino wrote:
> Add a basic power model to the cpu cooling device to implement the
> power cooling device API.  The power model uses the current frequency,
> current load and OPPs for the power calculations.  The cpus must have
> registered their OPPs using the OPP library.
>=20
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>

<big cut>

> +
> +/**
> + * get_load() - get load for a cpu since last updated
> + * @cpufreq_device:	&struct cpufreq_cooling_device for this cpu
> + * @cpu:	cpu number
> + *
> + * Return: The average load of cpu @cpu in percentage since this
> + * function was last called.
> + */
> +static u32 get_load(struct cpufreq_cooling_device *cpufreq_device, int c=
pu)
> +{
> +	u32 load;
> +	u64 now, now_idle, delta_time, delta_idle;
> +
> +	now_idle =3D get_cpu_idle_time(cpu, &now, 0);
> +	delta_idle =3D now_idle - cpufreq_device->time_in_idle[cpu];
> +	delta_time =3D now - cpufreq_device->time_in_idle_timestamp[cpu];
> +
> +	if (delta_time <=3D delta_idle)
> +		load =3D 0;
> +	else
> +		load =3D div64_u64(100 * (delta_time - delta_idle), delta_time);
> +
> +	cpufreq_device->time_in_idle[cpu] =3D now_idle;
> +	cpufreq_device->time_in_idle_timestamp[cpu] =3D now;
> +
> +	return load;
> +}

<cut>

> =20
> +/**
> + * cpufreq_get_actual_power() - get the current power
> + * @cdev:	&thermal_cooling_device pointer
> + *
> + * Return the current power consumption of the cpus in milliwatts.
> + */
> +static u32 cpufreq_get_actual_power(struct thermal_cooling_device *cdev)
> +{
> +	unsigned long freq;
> +	int cpu;
> +	u32 static_power, dynamic_power, total_load =3D 0;
> +	struct cpufreq_cooling_device *cpufreq_device =3D cdev->devdata;
> +
> +	freq =3D cpufreq_quick_get(cpumask_any(&cpufreq_device->allowed_cpus));
> +
> +	for_each_cpu(cpu, &cpufreq_device->allowed_cpus) {
> +		u32 load;
> +
> +		if (cpu_online(cpu))
> +			load =3D get_load(cpufreq_device, cpu);
> +		else
> +			load =3D 0;
> +
> +		total_load +=3D load;
> +	}
> +
> +	cpufreq_device->last_load =3D total_load;
> +
> +	static_power =3D get_static_power(cpufreq_device, freq);
> +	dynamic_power =3D get_dynamic_power(cpufreq_device, freq);
> +
> +	return static_power + dynamic_power;
> +}

With respect to load computation vs. frequency usage vs. power
estimation, while getting actual power for a given interval T. What if
in interval T, we have used, say, 3 different cpu frequencies, and the
load on the first was 50%, on the second 80%, and on the last frequency,
the load was 60%, what should be the right load value for computing the
actual power?=20

I mean, we are using the total idle time for a given interval, but 1 -
idle not always seams to reflect actual load on different opps, if opps
change over time within T time interval window.

BR,


BR,

Eduardo Valentin

--10jrOL3x2xqLmOsH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUyHI+AAoJEMLUO4d9pOJWV1MH/3puQbfDZv3Vzl8tdJGRnIhu
Fuuz8r7rj7tHOuFlN/qzlQdnsPbs8dPZJRPlpzhVCImetlgZfIxKzodqFVoiBsix
i249x8nMZftQrAu77lgSqAjhh6tGCnBQcxjKabiw7R0b0jS9iyJn5QVWxodMFOPP
BP53HqTHObGN9P0ctfObzFSILCCw5lnwVAFK0K8Pw8cIQzmgPHXrjCX0WU5pDBMg
ZdOks96vUWDhF3kM4Tf/GvPmWJ/6YNLQclncdRymjvXe9y5o1Tdouc8uDoJxEa7L
DJbsTYMqGfOudGA/Io3Ak6ciqW8j/YiN0MMtDLiw4EXETMwsxhuET39NwAdBrHA=
=PA2V
-----END PGP SIGNATURE-----

--10jrOL3x2xqLmOsH--
