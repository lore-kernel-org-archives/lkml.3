Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbaKSUlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:41:25 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58852 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbaKSUlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:41:23 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH] platform: x86: dell-laptop: Add support for keyboard backlight
Date: Wed, 19 Nov 2014 21:41:20 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com,
        Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com> <20141119183416.GA100640@vmdeb7>
In-Reply-To: <20141119183416.GA100640@vmdeb7>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8385116.2bBT56UXkC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411192141.20190@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8385116.2bBT56UXkC
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I removed other lines so mail is not too long.

On Wednesday 19 November 2014 19:34:16 Darren Hart wrote:
> > +static int kbd_get_info(struct kbd_info *info)
> > +{
> > +	u8 units;
> > +	int ret;
> > +
> > +	get_buffer();
> > +
> > +	buffer->input[0] =3D 0x0;
> > +	dell_send_request(buffer, 4, 11);
> > +	ret =3D buffer->output[0];
> > +
> > +	if (ret =3D=3D 0) {
>=20
> Generally speaking, check for error to keep the main logic
> from getting indented.
>=20
> 	if (buffer->output[0]) {
> 		ret =3D -EINVAL;
> 		goto out;
> 	}
>=20
> > +		info->modes =3D buffer->output[1] & 0xFFFF;
> > +		info->type =3D (buffer->output[1] >> 24) & 0xFF;
> > +		info->triggers =3D buffer->output[2] & 0xFF;
> > +		units =3D (buffer->output[2] >> 8) & 0xFF;
> > +		info->levels =3D (buffer->output[2] >> 16) & 0xFF;
> > +		if (units & BIT(0))
> > +			info->seconds =3D (buffer->output[3] >> 0) & 0xFF;
> > +		if (units & BIT(1))
> > +			info->minutes =3D (buffer->output[3] >> 8) & 0xFF;
> > +		if (units & BIT(2))
> > +			info->hours =3D (buffer->output[3] >> 16) & 0xFF;
> > +		if (units & BIT(3))
> > +			info->days =3D (buffer->output[3] >> 24) & 0xFF;
> > +	}
> > +
>=20
>  out:
> > +	release_buffer();
> > +
> > +	if (ret)
> > +		return -EINVAL;
>=20
> Drop this.
>=20
> > +	return 0;
>=20
> return ret;
>=20
> In this particular case, it might be shorter by a line or two
> to drop the ret variable and simply release_buffer() and
> return -EINVAL in the error check above and just return 0
> here.
>=20

Ok. But somewhere it is not possible.

> > +}
> > +
> > +static unsigned int kbd_get_max_level(void)
> > +{
> > +	if (kbd_info.levels !=3D 0)
> > +		return kbd_info.levels;
>=20
> This test.... does nothing? if it is 0, you still return 0
> below :-)
>=20
> > +	if (kbd_mode_levels_count > 0)
> > +		return kbd_mode_levels_count - 1;
> > +	return 0;
>=20
> So the function is:
>=20
> return kbd_mode_levels_count > 0 ? kbd_mode_levels_count - 1 :
> kbd_info.levels;
>=20
> The if blocks are more legible, so that's fine, but the first
> one doesn't seem to do anything and you can replace the final
> return with return kbd_info.levels.
>=20

There are two main way for setting keyboard backlight level. One=20
is setting level register and other one is setting special=20
keyboard mode. And some dell laptops support only first and some=20
only second. So this code choose first available/valid method and=20
then return correct data. I'm not sure if those two methods are=20
only one and also do not know if in future there will be=20
something other. Because of this I use code pattern:

if (check_method_1) return value_method_1;
if (check_method_2) return value_method_2;
=2E..
return unsupported;

Same pattern logic is used in all functions which doing something=20
with keyboard backlight level. (I will not other functions).

> > +static int kbd_set_state(struct kbd_state *state)
> > +{
> > +	int ret;
> > +
> > +	get_buffer();
> > +	buffer->input[0] =3D 0x2;
> > +	buffer->input[1] =3D BIT(state->mode_bit) & 0xFFFF;
> > +	buffer->input[1] |=3D (state->triggers & 0xFF) << 16;
> > +	buffer->input[1] |=3D (state->timeout_value & 0x3F) << 24;
> > +	buffer->input[1] |=3D (state->timeout_unit & 0x3) << 30;
> > +	buffer->input[2] =3D state->als_setting & 0xFF;
> > +	buffer->input[2] |=3D (state->level & 0xFF) << 16;
> > +	dell_send_request(buffer, 4, 11);
> > +	ret =3D buffer->output[0];
> > +	release_buffer();
> > +
> > +	if (ret)
> > +		return -EINVAL;
>=20
> Also, is EINVAL right here and elsewhere? Or did something
> fail? EXIO?
>=20

According to Dell documentation, return value is stored in=20
buffer->output[0] and can be:

0   Completed successfully
=2D1  Completed with error
=2D2  Function not supported

So we can return something other too (not always -EINVAL). Do you=20
have any idea which errno should we return for -1 and -2?

> > +
> > +	return 0;
> > +}
> > +
> > +static int kbd_set_state_safe(struct kbd_state *state,
> > struct kbd_state *old) +{
> > +	int ret;
> > +
> > +	ret =3D kbd_set_state(state);
> > +	if (ret =3D=3D 0)
> > +		return 0;
> > +
> > +	if (kbd_set_state(old))
> > +		pr_err("Setting old previous keyboard state=20
failed\n");
>=20
> And if we got an error and kbd_set_state(old) doesn't return
> !0, what's the state of things? Still a failure a presume?
>=20

In some cases some laptops do not have to support everything. And=20
when I (and Gabriele too) tried to set something unsupported Dell=20
BIOS just resetted all settings to some default values. So this=20
function try to set new state and if it fails then it try to=20
restore previous settings.

> > +
> > +	return ret;
> > +}

> > +static void kbd_init(void)
> > +{
> > +	struct kbd_state state;
> > +	int ret;
> > +	int i;
> > +
> > +	ret =3D kbd_get_info(&kbd_info);
> > +
> > +	if (ret =3D=3D 0) {
> > +
>=20
> Checking for success, let's invert and avoid the indentation
> here too.
>=20

Again this is hard and not possible. This function first process=20
data from kbd_get_info (if does not fail), then process data for=20
kbd_tokens (via function find_token_id) and then set=20
kbd_led_present to true if at least kbd_get_info or kbd_tokens=20
succed.

> > +		....
> > +
> > +	}
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(kbd_tokens); ++i)
> > +		if (find_token_id(kbd_tokens[i]) !=3D -1)
> > +			kbd_token_bits |=3D BIT(i);
> > +
> > +	if (kbd_token_bits !=3D 0 || ret =3D=3D 0)
> > +		kbd_led_present =3D true;
> > +}
> > +
> > +static ssize_t kbd_led_timeout_store(struct device *dev,
> > +				     struct device_attribute *attr,
> > +				     const char *buf, size_t count)
> > +{
> > +	struct kbd_state state;
> > +	struct kbd_state new_state;
> > +	int ret;
> > +	bool convert;
> > +	char ch;
> > +	u8 unit;
> > +	int value;
> > +	int i;
>=20
> Decreasing line lenth please.
>=20

What do you mean?

> > +	if (convert) {
> > +		/* NOTE: this switch fall down */
>=20
> "fall down" ? As in, it intentionally doesn't have breaks?
>=20

This code convert "value" in "units" to new value in minutes=20
units. So for unit =3D=3D days it is: 24*60*60... So no breaks.

> > +		switch (unit) {
> > +		case KBD_TIMEOUT_DAYS:
> > +			value *=3D 24;
> > +		case KBD_TIMEOUT_HOURS:
> > +			value *=3D 60;
> > +		case KBD_TIMEOUT_MINUTES:
> > +			value *=3D 60;
> > +			unit =3D KBD_TIMEOUT_SECONDS;
> > +	 	}
> > +
> > +		if (value <=3D kbd_info.seconds && kbd_info.seconds) {
> > +			unit =3D KBD_TIMEOUT_SECONDS;
> > +		} else if (value/60 <=3D kbd_info.minutes &&
> > kbd_info.minutes) {
>=20
> One space around operators like / and * please, applies
> throughout.
>=20

Ok.

> > +	if (kbd_als_supported)
> > +		als_enabled =3D kbd_is_als_mode_bit(state.mode_bit);
> > +	else
> > +		als_enabled =3D false;
> > +
> > +	if (kbd_triggers_supported)
> > +		triggers_enabled =3D
> > kbd_is_trigger_mode_bit(state.mode_bit); +	else
> > +		triggers_enabled =3D false;
>=20
> Could skip the else blocks with initial assignments.
>=20

Ok.

> > +
> > +	enable_als =3D false;
> > +	disable_als =3D false;
>=20
> Can skip these too.
>=20

Ok.

> > +			if (triggers_enabled) {
> > +				new_state.mode_bit =3D KBD_MODE_BIT_TRIGGER;
> > +				kbd_set_level(&new_state, kbd_previous_level);
> > +			} else
> > +				new_state.mode_bit =3D KBD_MODE_BIT_ON;
>=20
> if one block needs braces, use them throughout.
> Apply throughout.
>=20

Ok.

> > +static enum led_brightness kbd_led_level_get(struct
> > led_classdev *led_cdev) +{
> > +	int ret;
> > +	u16 num;
> > +	struct kbd_state state;
> > +
> > +	if (kbd_get_max_level()) {
> > +		ret =3D kbd_get_state(&state);
> > +		if (ret)
> > +			return 0;
> > +		ret =3D kbd_get_level(&state);
> > +		if (ret < 0)
> > +			return 0;
> > +		return ret;
> > +	} else if (kbd_get_valid_token_counts()) {
> > +		ret =3D kbd_get_first_active_token_bit();
> > +		if (ret < 0)
> > +			return 0;
> > +		for (num =3D kbd_token_bits; num !=3D 0 && ret > 0; --ret)
> > +			num &=3D num - 1; /* clear the first bit set */
> > +		if (num =3D=3D 0)
> > +			return 0;
> > +		return ffs(num) - 1;
> > +	} else {
> > +		pr_warn("Keyboard brightness level control not
> > supported\n"); +		return 0;
> > +	}
>=20
> You can drop the else blocks from the above as every case
> returns explicitly.
>=20
> if (condA)
> 	return retA;
> if (condB)
> 	return retB
> return ret
>=20
> (checkpatch.pl catches this)
>=20

Ok, this is possible. I will change it.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart8385116.2bBT56UXkC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRtAHAACgkQi/DJPQPkQ1I7gQCeMbRx3E+WnTPzrGAfsvPQbTMV
aX8AoKp9jti7KE4LJvmuH26o4S4iq8/J
=wPIh
-----END PGP SIGNATURE-----

--nextPart8385116.2bBT56UXkC--
