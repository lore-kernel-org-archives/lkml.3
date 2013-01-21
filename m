Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3AUHfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:35:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:28694 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab3AUHfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:35:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,504,1355126400"; 
   d="asc'?scan'208";a="274544626"
Date: Mon, 21 Jan 2013 02:25:56 -0500
From: Chen Gong <gong.chen@linux.intel.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] clocksource: Enlarge the maxim time interval
 when configuring the scale and shift
Message-ID: <20130121072556.GA11915@gchen.bj.intel.com>
Mail-Followup-To: Feng Tang <feng.tang@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
	Len Brown <lenb@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	linux-kernel@vger.kernel.org
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <1358750325-21217-5-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <1358750325-21217-5-git-send-email-feng.tang@intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 02:38:44PM +0800, Feng Tang wrote:
> Date:	Mon, 21 Jan 2013 14:38:44 +0800
> From: Feng Tang <feng.tang@intel.com>
> To: Thomas Gleixner <tglx@linutronix.de>, John Stultz
>  <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin"
>  <hpa@linux.intel.com>, x86@kernel.org, Len Brown <lenb@kernel.org>,
>  "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
>  linux-kernel@vger.kernel.org
> Cc: Feng Tang <feng.tang@intel.com>
> Subject: [RFC PATCH 4/5] clocksource: Enlarge the maxim time interval when
>  configuring the scale and shift
> X-Mailer: git-send-email 1.7.9.5
>=20
> On our x86 platform, we see a failure case of calling clocksource_cyc2ns(=
),
> which return a negative value. The reason is the time interval was large
> (more than 1000 seconds), while its TSC frequency is 2GHz, so the followi=
ng
> fomular overflowed:
> 	((u64) cycles * mult) >> shift
>=20
> So enlarge the time interval from 10 mins to 40 mins to fix the bug.
>=20
> Another solution may be adding a "max_interval" in struct clocksource, and
> use a default value (like current 10 minutes) when clocksource driver
> doesn't set it.
>=20
As you said, it looks like it is a littleb it arbitrary from 10m -> 40m, I
think max_interval is a better choice, if timer guys not minding too many
control knobs :-).

> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  kernel/time/clocksource.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index c958338..48fbfcb 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -663,7 +663,7 @@ void __clocksource_updatefreq_scale(struct clocksourc=
e *cs, u32 scale, u32 freq)
>  	 * Calc the maximum number of seconds which we can run before
>  	 * wrapping around. For clocksources which have a mask > 32bit
>  	 * we need to limit the max sleep time to have a good
> -	 * conversion precision. 10 minutes is still a reasonable
> +	 * conversion precision. 40 minutes is still a reasonable
>  	 * amount. That results in a shift value of 24 for a
>  	 * clocksource with mask >=3D 40bit and f >=3D 4GHz. That maps to
>  	 * ~ 0.06ppm granularity for NTP. We apply the same 12.5%
> @@ -674,8 +674,8 @@ void __clocksource_updatefreq_scale(struct clocksourc=
e *cs, u32 scale, u32 freq)
>  	do_div(sec, scale);
>  	if (!sec)
>  		sec =3D 1;
> -	else if (sec > 600 && cs->mask > UINT_MAX)
> -		sec =3D 600;
> +	else if (sec > 2400 && cs->mask > UINT_MAX)
> +		sec =3D 2400;
> =20
>  	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
>  			       NSEC_PER_SEC / scale, sec * scale);
> --=20
> 1.7.9.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/O2DAAoJEI01n1+kOSLH/HYP/jluhyitLpJVOBsk3OKC0Uxi
RLKPRODwZSdaR+Y+7w/xPySPFdOmWJd0DD2VJzmBdO6L5NldSv0iOwE0zihOoM98
RM/xDniLpk3SEjAOC+EzorbNz2xdJn0h3URBxMs73geHarW3+WF30h2ou5Y4X9WN
V0Tb6htlD7uRErCf7lbWn/HR0NdZkji7n2k3MU+7kYtaTCv5278TMjRSMCSRN5R4
f0BSVBOcq6+3mm6zlosCS+6aBi86p0zkpyY8E3t3WL6xjbs+U2kqCY+rwgGgZ2Uk
uQE8A82r0yB2NtGhIPgD9YBTZ9dG0uoAi59qH9FpCszNo4qntOM910bdFR4AKGlR
7dWo4uL0hPGq8tFvKfXTx6Ja1LicHc7SSAs4P3zBiSbYqsOno0jgh2BL8y4hMITy
E2M2hDBr3VRdmZTV0na8FVaFxQjYIsdjC8k3wTlJfGEPRqAEqPkbi6IZUPeQ1Qkx
1d4Wk33ob9c450MXR6v8kNy691c0osO9z0aPYPdiiteb9ymVzwBPuOkoMAIqt2+i
p6RdO+F2suh2+uBcjzURx0u/LgKdB+Me/f4UTeZgwmAng95cdFfXbtWPnIZWohac
90whRbVBJq78QtX3NLqtM/SFn11m30Q9KsPr13v23I2bBXDypJ8l4jLWv99tz1it
JAkzCosA+K6f2ePuTn7D
=Q1W3
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
