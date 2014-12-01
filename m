Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaLAMBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:01:33 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41448 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbaLAMBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:01:32 -0500
Message-ID: <547C5890.2020306@aurabindo.in>
Date: Mon, 01 Dec 2014 17:31:20 +0530
From: Jay Aurabind <mail@aurabindo.in>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915 Trouble with minimum brightness
References: <5478C9AA.2010600@aurabindo.in> <87k32bbtmo.fsf@intel.com>
In-Reply-To: <87k32bbtmo.fsf@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="f7sqtOVbGmq6fMMfLoWhmX3QKgXqd96Lg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--f7sqtOVbGmq6fMMfLoWhmX3QKgXqd96Lg
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/01/2014 03:04 PM, Jani Nikula wrote:
> On Fri, 28 Nov 2014, Jay Aurabind <mail@aurabindo.in> wrote:
>> Hello all,
>>
>> I notice that some activity has been going on with the minimum value
>> of display brightness recently (e1c412e7575).
>>
>> But the minimum value thats currently chosen is not at all acceptable
>> for my eyes. My display is working perfectly without that restriction
>> on minimum intensity.  I tend to stare at the screen a lot and the
>> current minimum settings is straining my eyes.
>>
>> Even if you say that it may not be good for the devices, I still
>> insist, because I want my *display* to fail first, not my eyes.  So
>> please try providing a way for the needy users to override this
>> minimum settings. I hope adding a module parameter would be easy fix.
>>
>> Something like this: ? (I dont call myself a kernel programmer yet,
>> just scratching the surface)
>>
>>
>> Provide provision for users to disable restriction on minimum brightne=
ss
>> value introduced in:
>>
>>     commit e1c412e75754ab7b7002f3e18a2652d999c40d4b
>>     Author: Jani Nikula <jani.nikula@intel.com>
>>     Date:   Wed Nov 5 14:46:31 2014 +0200
>>
>>         drm/i915: safeguard against too high minimum brightness
>>
>> There are systems which work reliably without restriction on minimum
>> value of display brightness. Also the arbitrary value may be too high
>> for many users as well.
>=20
> Please file a new bug at [1], reference this mail, and attach
> /sys/kernel/debug/dri/0/i915_opregion.

Thank you for the response. But the file you mentioned to attach seems to=
 be
a binary file, because I'm getting lot of junk characters. Is this normal=
 ?

>=20
> The minimum value is chosen and provided by the OEM. There's still some=

> open questions about the interpretation of the value though (which lead=

> to the commit you referenced), so I'm hesitant to make changes before w=
e
> have those cleared up.

=46rom a user's point of view, the reason many people and myself stick to=
 linux
is the flexibility it provides and the power the user has, and when=20
you introduce a new policy without an easy "roll back" to get back the=20
previous "mechanism", I would like to let you know that it matters.


> In general I am not fond of adding new module parameters for tuning
> things. Every new knob is another point of failure that we need to test=
,
> and they are pretty much part of the ABI we can't easily drop or change=
=2E

Would it be difficult to remove a parameter, if it is marked "experimenta=
l" ?

Is there a fix this without changing ABI ? I mean can you make this polic=
y
apply only on those hardware which seems to have a problem with the value=
 of
minimum backlight? Since they are the minority, why should a policy for f=
ixing them=20
affect the rest of us ?


--
Thanks and Regards,
Aurabindo J

>=20
> BR,
> Jani.
>=20
> [1] https://bugs.freedesktop.org/enter_bug.cgi?product=3DDRI&component=3D=
DRM/Intel
>=20
>=20
>>
>> Signed-off-by: Aurabindo J <mail@aurabindo.in>
>> ---
>>  drivers/gpu/drm/i915/i915_drv.h    |  1 +
>>  drivers/gpu/drm/i915/i915_params.c |  6 ++++++
>>  drivers/gpu/drm/i915/intel_panel.c | 14 ++++++++++----
>>  3 files changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i9=
15_drv.h
>> index 16a6f6d..55d2ead 100644
>> --- a/drivers/gpu/drm/i915/i915_drv.h
>> +++ b/drivers/gpu/drm/i915/i915_drv.h
>> @@ -2213,6 +2213,7 @@ struct i915_params {
>>  	int disable_power_well;
>>  	int enable_ips;
>>  	int invert_brightness;
>> +	int restrict_min_brightness;
>>  	int enable_cmd_parser;
>>  	/* leave bools at the end to not create holes */
>>  	bool enable_hangcheck;
>> diff --git a/drivers/gpu/drm/i915/i915_params.c b/drivers/gpu/drm/i915=
/i915_params.c
>> index c91cb20..0601c2a 100644
>> --- a/drivers/gpu/drm/i915/i915_params.c
>> +++ b/drivers/gpu/drm/i915/i915_params.c
>> @@ -46,6 +46,7 @@ struct i915_params i915 __read_mostly =3D {
>>  	.prefault_disable =3D 0,
>>  	.reset =3D true,
>>  	.invert_brightness =3D 0,
>> +	.restrict_min_brightness =3D 1,
>>  	.disable_display =3D 0,
>>  	.enable_cmd_parser =3D 1,
>>  	.disable_vtd_wa =3D 0,
>> @@ -155,6 +156,11 @@ MODULE_PARM_DESC(invert_brightness,
>>  	"to dri-devel@lists.freedesktop.org, if your machine needs it. "
>>  	"It will then be included in an upcoming module version.");
>>
>> +module_param_named(restrict_min_brightness, i915.restrict_min_brightn=
ess, int, 0600);
>> +MODULE_PARM_DESC(restrict_min_brightness,
>> +	"Restrict minimum brightness "
>> +	"(-1 disable restriction, 0 value from VBT, 1 arbitrary value )");
>> +
>>  module_param_named(disable_display, i915.disable_display, bool, 0600)=
;
>>  MODULE_PARM_DESC(disable_display, "Disable display (default: false)")=
;
>>
>> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915=
/intel_panel.c
>> index 41b3be2..def9f4e 100644
>> --- a/drivers/gpu/drm/i915/intel_panel.c
>> +++ b/drivers/gpu/drm/i915/intel_panel.c
>> @@ -1109,10 +1109,16 @@ static u32 get_backlight_min_vbt(struct intel_=
connector *connector)
>>  	 * against this by letting the minimum be at most (arbitrarily chose=
n)
>>  	 * 25% of the max.
>>  	 */
>> -	min =3D clamp_t(int, dev_priv->vbt.backlight.min_brightness, 0, 64);=

>> -	if (min !=3D dev_priv->vbt.backlight.min_brightness) {
>> -		DRM_DEBUG_KMS("clamping VBT min backlight %d/255 to %d/255\n",
>> -			      dev_priv->vbt.backlight.min_brightness, min);
>> +	if (i915.restrict_min_brightness < 0)
>> +		min =3D 0;
>> +	else if (i915.restrict_min_brightness =3D=3D 0)
>> +		min =3D dev_priv->vbt.backlight.min_brightness;
>> +	else {
>> +		min =3D clamp_t(int, dev_priv->vbt.backlight.min_brightness, 0, 64)=
;
>> +		if (min !=3D dev_priv->vbt.backlight.min_brightness) {
>> +			DRM_DEBUG_KMS("clamping VBT min backlight %d/255 to %d/255\n",
>> +					dev_priv->vbt.backlight.min_brightness, min);
>> +	    }
>>  	}
>>
>>  	/* vbt value is a coefficient in range [0..255] */
>> --=20
>> 2.1.3
>>
>>
>>
>>
>>
>=20



--f7sqtOVbGmq6fMMfLoWhmX3QKgXqd96Lg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlR8WJUACgkQq5pl9aLRKAVMjQD+NPXc3H5iHhMEaVzdxi1CcEMJ
TgZ3K5omdozPFHqjPLMA/RP5BXnRqogpUpSSLTKYMlowMjzQnAaqQENdermQZT1t
=yStz
-----END PGP SIGNATURE-----

--f7sqtOVbGmq6fMMfLoWhmX3QKgXqd96Lg--
