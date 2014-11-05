Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaKEUqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:46:47 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:33942 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaKEUqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:46:44 -0500
Date: Wed, 5 Nov 2014 16:46:43 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rui.zhang@intel.com, amit.daniel@samsung.com, viresh.kumar@linaro.org,
        linux-samsung-soc@vger.kernel.org, yadi.brar01@gmail.com
Subject: Re: [PATCH] thermal: cpu_cooling: Update always cpufreq policy with
 thermal constraints
Message-ID: <20141105204638.GB5243@developer>
References: <1415189785-18593-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <1415189785-18593-1-git-send-email-yadi.brar@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Yadwinder,

On Wed, Nov 05, 2014 at 05:46:25PM +0530, Yadwinder Singh Brar wrote:
> Existing code updates cupfreq policy only while executing
> cpufreq_apply_cooling() function (i.e. when notify_device !=3D NOTIFY_INV=
ALID).

Correct. The case you mention is when we receive a notification from
cpufreq. But also, updates the cpufreq policy when the cooling device
changes state, a call from thermal framework.

> It doesn't apply constraints when cpufreq policy update happens from any =
other
> place but it should update the cpufreq policy with thermal constraints ev=
ery
> time when there is a cpufreq policy update, to keep state of
> cpufreq_cooling_device and max_feq of cpufreq policy in sync.

I am not sure I follow you here. Can you please elaborate on 'any other
places'? Could you please mention (also in the commit log) what are the
case the current code does not cover? For instance, the
cpufreq_apply_cooling gets called on notification coming from thermal
subsystem, and for changes in cpufreq subsystem,
cpufreq_thermal_notifier is called.=20

>=20
> This patch modifies code to maintain a global cpufreq_dev_list and get
> corresponding cpufreq_cooling_device for policy's cpu from cpufreq_dev_li=
st
> when there is any policy update.

OK. Please give real examples of when the current code fails to catch
the event.


BR,

Eduardo Valentin

>=20
> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> ---
>  drivers/thermal/cpu_cooling.c |   37 ++++++++++++++++++++---------------=
--
>  1 files changed, 20 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 1ab0018..5546278 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -50,15 +50,14 @@ struct cpufreq_cooling_device {
>  	unsigned int cpufreq_state;
>  	unsigned int cpufreq_val;
>  	struct cpumask allowed_cpus;
> +	struct list_head node;
>  };
>  static DEFINE_IDR(cpufreq_idr);
>  static DEFINE_MUTEX(cooling_cpufreq_lock);
> =20
>  static unsigned int cpufreq_dev_count;
> =20
> -/* notify_table passes value to the CPUFREQ_ADJUST callback function. */
> -#define NOTIFY_INVALID NULL
> -static struct cpufreq_cooling_device *notify_device;
> +static LIST_HEAD(cpufreq_dev_list);
> =20
>  /**
>   * get_idr - function to get a unique id.
> @@ -287,15 +286,12 @@ static int cpufreq_apply_cooling(struct cpufreq_coo=
ling_device *cpufreq_device,
> =20
>  	cpufreq_device->cpufreq_state =3D cooling_state;
>  	cpufreq_device->cpufreq_val =3D clip_freq;
> -	notify_device =3D cpufreq_device;
> =20
>  	for_each_cpu(cpuid, mask) {
>  		if (is_cpufreq_valid(cpuid))
>  			cpufreq_update_policy(cpuid);
>  	}
> =20
> -	notify_device =3D NOTIFY_INVALID;
> -
>  	return 0;
>  }
> =20
> @@ -316,21 +312,27 @@ static int cpufreq_thermal_notifier(struct notifier=
_block *nb,
>  {
>  	struct cpufreq_policy *policy =3D data;
>  	unsigned long max_freq =3D 0;
> +	struct cpufreq_cooling_device *cpufreq_dev;
> =20
> -	if (event !=3D CPUFREQ_ADJUST || notify_device =3D=3D NOTIFY_INVALID)
> +	if (event !=3D CPUFREQ_ADJUST)
>  		return 0;
> =20
> -	if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
> -		max_freq =3D notify_device->cpufreq_val;
> -	else
> -		return 0;
> +	mutex_lock(&cooling_cpufreq_lock);
> +	list_for_each_entry(cpufreq_dev, &cpufreq_dev_list, node) {
> +		if (!cpumask_test_cpu(policy->cpu,
> +					&cpufreq_dev->allowed_cpus))
> +			continue;
> =20
> -	/* Never exceed user_policy.max */
> -	if (max_freq > policy->user_policy.max)
> -		max_freq =3D policy->user_policy.max;
> +		max_freq =3D cpufreq_dev->cpufreq_val;
> =20
> -	if (policy->max !=3D max_freq)
> -		cpufreq_verify_within_limits(policy, 0, max_freq);
> +		/* Never exceed user_policy.max */
> +		if (max_freq > policy->user_policy.max)
> +			max_freq =3D policy->user_policy.max;
> +
> +		if (policy->max !=3D max_freq)
> +			cpufreq_verify_within_limits(policy, 0, max_freq);
> +	}
> +	mutex_unlock(&cooling_cpufreq_lock);

So, the problem is when we have several cpu cooling devices and you want
to search for the real max among the existing cpu cooling devices?

> =20
>  	return 0;
>  }
> @@ -486,7 +488,7 @@ __cpufreq_cooling_register(struct device_node *np,
>  		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
>  					  CPUFREQ_POLICY_NOTIFIER);
>  	cpufreq_dev_count++;
> -
> +	list_add(&cpufreq_dev->node, &cpufreq_dev_list);
>  	mutex_unlock(&cooling_cpufreq_lock);
> =20
>  	return cool_dev;
> @@ -549,6 +551,7 @@ void cpufreq_cooling_unregister(struct thermal_coolin=
g_device *cdev)
> =20
>  	cpufreq_dev =3D cdev->devdata;
>  	mutex_lock(&cooling_cpufreq_lock);
> +	list_del(&cpufreq_dev->node);
>  	cpufreq_dev_count--;
> =20
>  	/* Unregister the notifier for the last cpufreq cooling device */
> --=20
> 1.7.0.4
>=20

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWouNAAoJEMLUO4d9pOJWeScH/02U92f6C94aZib8gULCw3zq
JYBXqBEucH3P3pU/8l0kRxdOomdfaQT6mi3pfnzxNTmZdA3ZR2jVXYaP+4U7ZOaF
GiBDAFwo8a8majCLBReBJyofbUox1IqCJdipp2y4R1iHN94tUVFwtOFK0XX33I4q
86Pvb66hikSXqL5lmM5KC6oT1KvB2DOC4/wgw8Y1LVn0nwCmYTBrd/l6WcPbarrn
bgiD9SJiylWv9TT+iYN+Ys/3ZuVVQUp4TcMIZOFLrAfhtu4YdpgEjuLRatZvglWc
NWfsgJZCMaW7jAq7j1X2L8z+xKzZkNYjr7SQCEyHCDEplYk5zX/yxuB33qS+SUM=
=YdnX
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
