Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaKFSyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:54:43 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:41451 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaKFSyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:54:40 -0500
Date: Thu, 6 Nov 2014 03:49:13 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rui.zhang@intel.com, amit.daniel@samsung.com, viresh.kumar@linaro.org,
        linux-samsung-soc@vger.kernel.org, yadi.brar01@gmail.com
Subject: Re: [PATCH] thermal: cpu_cooling: Update always cpufreq policy with
 thermal constraints
Message-ID: <20141106074907.GA8176@developer>
References: <1415189785-18593-1-git-send-email-yadi.brar@samsung.com>
 <20141105204638.GB5243@developer>
 <004c01cff9b0$6b450740$41cf15c0$%brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <004c01cff9b0$6b450740$41cf15c0$%brar@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Yadwinder,

On Thu, Nov 06, 2014 at 04:26:27PM +0530, Yadwinder Singh Brar wrote:
> Hello Eduardo Valentin,
>=20
> On Thursday, November 06, 2014 2:17 AM, Eduardo Valentin wrote:
> > Hello Yadwinder,
> >=20
> > On Wed, Nov 05, 2014 at 05:46:25PM +0530, Yadwinder Singh Brar wrote:
> > > Existing code updates cupfreq policy only while executing
> > > cpufreq_apply_cooling() function (i.e. when notify_device !=3D
> > NOTIFY_INVALID).
> >=20
> > Correct. The case you mention is when we receive a notification from
> > cpufreq. But also, updates the cpufreq policy when the cooling device
> > changes state, a call from thermal framework.
>=20
> I mentioned thermal framework case only, existing code updates
> cupfreq policy only when (notify_device !=3D NOTIFY_INVALID),
> which happens only when notification comes from cpufreq_update_policy
> while changing cooling device's state(i.e. cpufreq_apply_cooling()).
> In case of other notifications notify_device is always NOTIFY_INVALID.

I see your point.

>=20
> >=20
> > > It doesn't apply constraints when cpufreq policy update happens from
> > > any other place but it should update the cpufreq policy with thermal
> > > constraints every time when there is a cpufreq policy update, to keep
> > > state of cpufreq_cooling_device and max_feq of cpufreq policy in
> > sync.
> >=20
> > I am not sure I follow you here. Can you please elaborate on 'any other
> > places'? Could you please mention (also in the commit log) what are the
> > case the current code does not cover? For instance, the
> > cpufreq_apply_cooling gets called on notification coming from thermal
> > subsystem, and for changes in cpufreq subsystem,
> > cpufreq_thermal_notifier is called.
> >=20
>=20
> "Other places" mean possible places from where cpufreq_update_policy()
> can be called at runtime, an instance in present kernel is cpufreq_resume=
().
> But since cpufreq_update_policy() is an exposed API, I think
> for robustness, generic cpu cooling should be able to take care of any
> possible case(in future as well).
>=20

OK. I understand now. Can you please improve your commit message by
adding the descriptions you mentioned here?

> > >
> > > This patch modifies code to maintain a global cpufreq_dev_list and
> > get
> > > corresponding cpufreq_cooling_device for policy's cpu from
> > > cpufreq_dev_list when there is any policy update.
> >=20
> > OK. Please give real examples of when the current code fails to catch
> > the event.
> >=20
>=20
> While resuming cpufreq updates cpufreq_policy for boot cpu and it
> restores default policy->usr_policy irrespective of cooling device's
> cpufreq_state since notification gets missed because (notify_device =3D=3D
> NOTIFY_INVALID).
> Another thing, Rather I would say an issue, I observed is that
> Userspace is able to change max_freq irrespective of cooling
> device's state, as notification gets missed.
>

Include also the examples above you gave.

Have you verified if with this patch the issue with userland goes away?
  =20
> >=20
> > BR,
> >=20
> > Eduardo Valentin
> >=20
> > >
> > > Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> > > ---
> > >  drivers/thermal/cpu_cooling.c |   37 ++++++++++++++++++++-----------
> > ------
> > >  1 files changed, 20 insertions(+), 17 deletions(-)
> > >
> > > diff --git a/drivers/thermal/cpu_cooling.c
> > > b/drivers/thermal/cpu_cooling.c index 1ab0018..5546278 100644
> > > --- a/drivers/thermal/cpu_cooling.c
> > > +++ b/drivers/thermal/cpu_cooling.c
> > > @@ -50,15 +50,14 @@ struct cpufreq_cooling_device {
> > >  	unsigned int cpufreq_state;
> > >  	unsigned int cpufreq_val;
> > >  	struct cpumask allowed_cpus;
> > > +	struct list_head node;
> > >  };
> > >  static DEFINE_IDR(cpufreq_idr);
> > >  static DEFINE_MUTEX(cooling_cpufreq_lock);
> > >
> > >  static unsigned int cpufreq_dev_count;
> > >
> > > -/* notify_table passes value to the CPUFREQ_ADJUST callback
> > function.
> > > */ -#define NOTIFY_INVALID NULL -static struct cpufreq_cooling_device
> > > *notify_device;
> > > +static LIST_HEAD(cpufreq_dev_list);
> > >
> > >  /**
> > >   * get_idr - function to get a unique id.
> > > @@ -287,15 +286,12 @@ static int cpufreq_apply_cooling(struct
> > > cpufreq_cooling_device *cpufreq_device,
> > >
> > >  	cpufreq_device->cpufreq_state =3D cooling_state;
> > >  	cpufreq_device->cpufreq_val =3D clip_freq;
> > > -	notify_device =3D cpufreq_device;
> > >
> > >  	for_each_cpu(cpuid, mask) {
> > >  		if (is_cpufreq_valid(cpuid))
> > >  			cpufreq_update_policy(cpuid);
> > >  	}
> > >
> > > -	notify_device =3D NOTIFY_INVALID;
> > > -
> > >  	return 0;
> > >  }
> > >
> > > @@ -316,21 +312,27 @@ static int cpufreq_thermal_notifier(struct
> > > notifier_block *nb,  {
> > >  	struct cpufreq_policy *policy =3D data;
> > >  	unsigned long max_freq =3D 0;
> > > +	struct cpufreq_cooling_device *cpufreq_dev;
> > >
> > > -	if (event !=3D CPUFREQ_ADJUST || notify_device =3D=3D NOTIFY_INVALI=
D)
> > > +	if (event !=3D CPUFREQ_ADJUST)
> > >  		return 0;
> > >
> > > -	if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
> > > -		max_freq =3D notify_device->cpufreq_val;
> > > -	else
> > > -		return 0;
> > > +	mutex_lock(&cooling_cpufreq_lock);
> > > +	list_for_each_entry(cpufreq_dev, &cpufreq_dev_list, node) {
> > > +		if (!cpumask_test_cpu(policy->cpu,
> > > +					&cpufreq_dev->allowed_cpus))
> > > +			continue;
> > >
> > > -	/* Never exceed user_policy.max */
> > > -	if (max_freq > policy->user_policy.max)
> > > -		max_freq =3D policy->user_policy.max;
> > > +		max_freq =3D cpufreq_dev->cpufreq_val;
> > >
>=20
> I think I missed to post updated patch,
> Actually it should be :
>=20
> +	if (!cpufreq_dev->cpufreq_val)
> +		cpufreq_dev->cpufreq_val =3D get_cpu_frequency(
> +
> cpumask_any(&cpufreq_dev->allowed_cpus),
> +							cpufreq_dev->state);
> +	max_freq =3D cpufreq_dev->cpufreq_val;
>=20
> I will send another version of patch.

ok.

>=20
> > > -	if (policy->max !=3D max_freq)
> > > -		cpufreq_verify_within_limits(policy, 0, max_freq);
> > > +		/* Never exceed user_policy.max */
> > > +		if (max_freq > policy->user_policy.max)
> > > +			max_freq =3D policy->user_policy.max;
> > > +
> > > +		if (policy->max !=3D max_freq)
> > > +			cpufreq_verify_within_limits(policy, 0, max_freq);
> > > +	}
> > > +	mutex_unlock(&cooling_cpufreq_lock);
> >=20
> > So, the problem is when we have several cpu cooling devices and you
> > want to search for the real max among the existing cpu cooling devices?
> >

By max, I meant the maximun constraint (lowest frequency).

>=20
> Sorry I didn't get your question completely I think.
> No, above code doesn't find max among existing cooling devices.
> It simply finds cooling device corresponding to policy's cpu
> and applies updates policy accordingly.

yeah, that's what it does, but for all matching devices, correct?

well, in fact your code is going through all cpu cooling devices that
match the cpu ids and applying their max allowed freq, when they differ
=66rom policy->max. cpufreq_verify_within_limits will update the policy if
your request is lower than policy max. Then you will, in the end, apply
the lowest among the existing matching cpu cooling devices.

Which, turns out to be the correct thing to do, since we are not doing
it per request in single cooling devices.

Can you please also add a comment about this strategy?


BR,=20

Eduardo Valentin

>=20
> Regards,
> Yadwinder
> =20
> > >  	return 0;
> > >  }
> > > @@ -486,7 +488,7 @@ __cpufreq_cooling_register(struct device_node
> > *np,
> > >  		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
> > >  					  CPUFREQ_POLICY_NOTIFIER);
> > >  	cpufreq_dev_count++;
> > > -
> > > +	list_add(&cpufreq_dev->node, &cpufreq_dev_list);
> > >  	mutex_unlock(&cooling_cpufreq_lock);
> > >
> > >  	return cool_dev;
> > > @@ -549,6 +551,7 @@ void cpufreq_cooling_unregister(struct
> > > thermal_cooling_device *cdev)
> > >
> > >  	cpufreq_dev =3D cdev->devdata;
> > >  	mutex_lock(&cooling_cpufreq_lock);
> > > +	list_del(&cpufreq_dev->node);
> > >  	cpufreq_dev_count--;
> > >
> > >  	/* Unregister the notifier for the last cpufreq cooling device */
> > > --
> > > 1.7.0.4
> > >
>=20

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWyeMAAoJEMLUO4d9pOJWZIAH/iCuBYoKxnIo7ppmKc6of9Q7
Hhcaw6ttXTDQEzuuNsQYTK5jc/5PZu10wvMubR3XL1UCGP/nrbx2dP/2PboeFCtj
lr44xhIBSrP9MxXyiasBVoa6jafeyCjevPKhCe324Ze/YIDUhDoWjAgubSUgBJKp
Hx7FK0XDauFG21b1clUpyGOIEliI/x0QAd2+DfZWi3Yedl2ufAbL8Kr/A8AD/Dy0
BlptPZFwS/L05dFC9D4/KvRddZFQqMGkuVnoukvqbqqzF8+1+TEMFl143EKNRmDC
/wS++TRfahgCtYy1XCrkU893Imckq76bXHBWyK8/fGjhhLqwbgnWr8gzwYr/q9o=
=uYlz
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
