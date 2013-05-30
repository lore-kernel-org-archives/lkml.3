Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967496Ab3E3DiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:38:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54774 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967382Ab3E3Dhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:37:51 -0400
Message-ID: <51A6C986.2000700@ti.com>
Date: Wed, 29 May 2013 23:37:42 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <ruslan.ruslichenko@ti.com>,
        Durgadoss R <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFT][PATCH 1/1] thermal: step_wise: return instance->target
 by default
References: <1369868285-18049-1-git-send-email-eduardo.valentin@ti.com> <1369878129.3368.15.camel@rzhang1-mobl4>
In-Reply-To: <1369878129.3368.15.camel@rzhang1-mobl4>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2WXPJHUHBEGLPNEMMGPCO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2WXPJHUHBEGLPNEMMGPCO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 29-05-2013 21:42, Zhang Rui wrote:
> On Wed, 2013-05-29 at 18:58 -0400, Eduardo Valentin wrote:
>> In case the trend is not changing or when there is no
>> request for throttling, it is expected that the instance
>> would not change its requested target. This patch improves
>> the code implementation to cover for this expected behavior.
>>
> right. agreed.
>=20
>> With current implementation, the instance will always
>> reset to cdev.cur_state, even in not expected cases,
>> like those mentioned above.
>>
>> This patch changes the step_wise governor implementation
>> of get_target so that we accomplish:
>> (a) - default value will be current instance->target, so
>> we do not change the thermal instance target unnecessarily.
>=20
>> (b) - the code now it is clear about what is the intention.
>> There is a clear statement of what are the expected outcomes
>> (c) - removal of hardcoded constants, now it is put in use
>> the THERMAL_NO_TARGET macro.
>=20
>> (d) - variable names are also improved so that reader can
>> clearly understand the difference between instance cur target,
>> next target and cdev cur_state.
>>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: Durgadoss R <durgadoss.r@intel.com>
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Reported-by: Ruslan Ruslichenko <ruslan.ruslichenko@ti.com>
>> Signed-of-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  drivers/thermal/step_wise.c | 29 ++++++++++++++++++-----------
>>  1 file changed, 18 insertions(+), 11 deletions(-)
>> ---
>>
>> Hello all,
>>
>> I am requesting for tests on this patch. Based on an internal
>> discussion with Ruslan, I concluded that this code needs improvement.
>>
>> Ruslan, I did not keep your original code because I believe the
>> get_target_state needs a better implementation for code readiness.
>> Besides, I also believe we are facing the bug of emul_temp in your cas=
e [1],
>> so this patch is not really fixing anything, but improving the
>> code quality and making sure the instance behaves as expected.
>> The fact you see the cooling device stuck at 1 is most probably becaus=
e
>> the thermal core uses trend computed by the driver, not by emul_temp.
>>
>> I have implemented a different improvement as you may find below. But
>> I kept a Reported-by under your name.
>>
> it would be good to let me know what the problem is.
> As I'm fixing a couple of thermal bugs recently.
> Most of them are suspend/hibernate related, and I've been changing this=

> piece of code a lot.


Rui,

This specific patch does not address a bug per si. Just makes sure that
we avoid changing the target state of an instance when it is not
necessary to change it.

>=20
> thanks,
> rui
>> In any case, because I believe this change in step_wise is significant=
,
>> I am sending this patch for broader review and I kindly ask interested=

>> audience for testing it.
>>
>> [1] - https://patchwork.kernel.org/patch/2632831/

The patch above, on the other hand, does fix a bug.

>>
>> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c=

>> index 4d4ddae..769bfa3 100644
>> --- a/drivers/thermal/step_wise.c
>> +++ b/drivers/thermal/step_wise.c
>> @@ -51,44 +51,51 @@ static unsigned long get_target_state(struct therm=
al_instance *instance,
>>  {
>>  	struct thermal_cooling_device *cdev =3D instance->cdev;
>>  	unsigned long cur_state;
>> +	unsigned long next_target;
>> =20
>> +	/*
>> +	 * We keep this instance the way it is by default.
>> +	 * Otherwise, we use the current state of the
>> +	 * cdev in use to determine the next_target.
>> +	 */
>>  	cdev->ops->get_cur_state(cdev, &cur_state);
>> +	next_target =3D instance->target;
>> =20
>>  	switch (trend) {
>>  	case THERMAL_TREND_RAISING:
>>  		if (throttle) {
>> -			cur_state =3D cur_state < instance->upper ?
>> +			next_target =3D cur_state < instance->upper ?
>>  				    (cur_state + 1) : instance->upper;
>> -			if (cur_state < instance->lower)
>> -				cur_state =3D instance->lower;
>> +			if (next_target < instance->lower)
>> +				next_target =3D instance->lower;
>>  		}
>>  		break;
>>  	case THERMAL_TREND_RAISE_FULL:
>>  		if (throttle)
>> -			cur_state =3D instance->upper;
>> +			next_target =3D instance->upper;
>>  		break;
>>  	case THERMAL_TREND_DROPPING:
>>  		if (cur_state =3D=3D instance->lower) {
>>  			if (!throttle)
>> -				cur_state =3D -1;
>> +				next_target =3D THERMAL_NO_TARGET;
>>  		} else {
>> -			cur_state -=3D 1;
>> -			if (cur_state > instance->upper)
>> -				cur_state =3D instance->upper;
>> +			next_target =3D cur_state - 1;
>> +			if (next_target > instance->upper)
>> +				next_target =3D instance->upper;
>>  		}
>>  		break;
>>  	case THERMAL_TREND_DROP_FULL:
>>  		if (cur_state =3D=3D instance->lower) {
>>  			if (!throttle)
>> -				cur_state =3D -1;
>> +				next_target =3D THERMAL_NO_TARGET;
>>  		} else
>> -			cur_state =3D instance->lower;
>> +			next_target =3D instance->lower;
>>  		break;
>>  	default:
>>  		break;
>>  	}
>> =20
>> -	return cur_state;
>> +	return next_target;
>>  }
>> =20
>>  static void update_passive_instance(struct thermal_zone_device *tz,
>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2WXPJHUHBEGLPNEMMGPCO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGmyYYACgkQCXcVR3XQvP2wNwD/fOnPFuHMY1puxr6dFRcNDJl8
fLSAkhv/YDfLrxwwXhoA/i3fhr9uVu/BPzs2gMxRcktRpLt7hwuvWhrOrQkpBTVh
=5PSO
-----END PGP SIGNATURE-----

------enig2WXPJHUHBEGLPNEMMGPCO--
