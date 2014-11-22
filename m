Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaKVSqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 13:46:33 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:54906 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaKVSq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 13:46:29 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH] platform: x86: dell-laptop: Add support for keyboard backlight
Date: Sat, 22 Nov 2014 19:46:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com,
        Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Linux ACPI Mailing List <linux-acpi@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@intel.com>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com> <201411192141.20190@pali> <20141121203930.GA74402@vmdeb7>
In-Reply-To: <20141121203930.GA74402@vmdeb7>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2936538.hTsUPPScBG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411221946.25314@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2936538.hTsUPPScBG
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 21 November 2014 21:39:30 Darren Hart wrote:
> On Wed, Nov 19, 2014 at 09:41:20PM +0100, Pali Roh=C3=A1r wrote:
> > Hello,
>=20
> Hi Pali,
>=20
> > I removed other lines so mail is not too long.
>=20
> > On Wednesday 19 November 2014 19:34:16 Darren Hart wrote:
> ...
>=20
> > > > +}
> > > > +
> > > > +static unsigned int kbd_get_max_level(void)
> > > > +{
> > > > +	if (kbd_info.levels !=3D 0)
> > > > +		return kbd_info.levels;
> > >=20
> > > This test.... does nothing? if it is 0, you still return 0
> > > below :-)
> > >=20
> > > > +	if (kbd_mode_levels_count > 0)
> > > > +		return kbd_mode_levels_count - 1;
> > > > +	return 0;
> > >=20
> > > So the function is:
> > >=20
> > > return kbd_mode_levels_count > 0 ? kbd_mode_levels_count -
> > > 1 : kbd_info.levels;
> > >=20
> > > The if blocks are more legible, so that's fine, but the
> > > first one doesn't seem to do anything and you can replace
> > > the final return with return kbd_info.levels.
> >=20
> > There are two main way for setting keyboard backlight level.
> > One is setting level register and other one is setting
> > special keyboard mode. And some dell laptops support only
> > first and some only second. So this code choose first
> > available/valid method and then return correct data. I'm
> > not sure if those two methods are only one and also do not
> > know if in future there will be something other. Because of
> > this I use code pattern:
> >=20
> > if (check_method_1) return value_method_1;
> > if (check_method_2) return value_method_2;
> > ...
> > return unsupported;
> >=20
> > Same pattern logic is used in all functions which doing
> > something with keyboard backlight level. (I will not other
> > functions).
>=20
> Fair enough. Clear, legible, consistent coding is preferable
> to a few micro optimizations that the compiler is likely to
> catch anyway. I withdraw the comment :-)
>=20

Ok.

> > > > +static int kbd_set_state(struct kbd_state *state)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	get_buffer();
> > > > +	buffer->input[0] =3D 0x2;
> > > > +	buffer->input[1] =3D BIT(state->mode_bit) & 0xFFFF;
> > > > +	buffer->input[1] |=3D (state->triggers & 0xFF) << 16;
> > > > +	buffer->input[1] |=3D (state->timeout_value & 0x3F) <<
> > > > 24; +	buffer->input[1] |=3D (state->timeout_unit & 0x3)
> > > > << 30; +	buffer->input[2] =3D state->als_setting & 0xFF;
> > > > +	buffer->input[2] |=3D (state->level & 0xFF) << 16;
> > > > +	dell_send_request(buffer, 4, 11);
> > > > +	ret =3D buffer->output[0];
> > > > +	release_buffer();
> > > > +
> > > > +	if (ret)
> > > > +		return -EINVAL;
> > >=20
> > > Also, is EINVAL right here and elsewhere? Or did something
> > > fail? EXIO?
> >=20
> > According to Dell documentation, return value is stored in
> > buffer->output[0] and can be:
> >=20
> > 0   Completed successfully
> > -1  Completed with error
> > -2  Function not supported
> >=20
> > So we can return something other too (not always -EINVAL).
> > Do you have any idea which errno should we return for -1
> > and -2?
>=20
> For -1, I should think  -EIO (I/O Error)
> For -2, I'd expect -ENXIO (No such device or address)
>=20

What about -ENOSYS for -2?

> Cc Rafael, Mika, linux-acpi in case they have a better idea.
>=20
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static int kbd_set_state_safe(struct kbd_state *state,
> > > > struct kbd_state *old) +{
> > > > +	int ret;
> > > > +
> > > > +	ret =3D kbd_set_state(state);
> > > > +	if (ret =3D=3D 0)
> > > > +		return 0;
> > > > +
> > > > +	if (kbd_set_state(old))
> > > > +		pr_err("Setting old previous keyboard state
> >=20
> > failed\n");
> >=20
> > > And if we got an error and kbd_set_state(old) doesn't
> > > return !0, what's the state of things? Still a failure a
> > > presume?
> >=20
> > In some cases some laptops do not have to support
> > everything. And when I (and Gabriele too) tried to set
> > something unsupported Dell BIOS just resetted all settings
> > to some default values. So this function try to set new
> > state and if it fails then it try to restore previous
> > settings.
>=20
> OK, that deserves a comment then as the rationale isn't
> obvious.
>=20

Ok, I will add comment.

> > > > +
> > > > +	return ret;
> > > > +}
> > > >=20
> > > > +static void kbd_init(void)
> > > > +{
> > > > +	struct kbd_state state;
> > > > +	int ret;
> > > > +	int i;
> > > > +
> > > > +	ret =3D kbd_get_info(&kbd_info);
> > > > +
> > > > +	if (ret =3D=3D 0) {
> > > > +
> > >=20
> > > Checking for success, let's invert and avoid the
> > > indentation here too.
> >=20
> > Again this is hard and not possible. This function first
> > process data from kbd_get_info (if does not fail), then
> > process data for kbd_tokens (via function find_token_id)
> > and then set kbd_led_present to true if at least
> > kbd_get_info or kbd_tokens succed.
>=20
> The goal here is to avoid more than 3 levels of indentations
> for improved legibility. Often there are logical inversions
> and such we can make to accomplish this. When that fails, we
> break things up into functions, static inlines, etc.
>=20
> For reference:
> https://lkml.org/lkml/2007/6/15/449
>=20
> Which elaborates on CodingStyle Chapter 1: Indentation a bit.
>=20
> ...
>=20

Ok, I will move it into two static inline functions (one for=20
kbd_get_info and second for kbd_tokens).

> > > > +static ssize_t kbd_led_timeout_store(struct device
> > > > *dev, +				     struct device_attribute *attr,
> > > > +				     const char *buf, size_t count)
> > > > +{
> > > > +	struct kbd_state state;
> > > > +	struct kbd_state new_state;
> > > > +	int ret;
> > > > +	bool convert;
> > > > +	char ch;
> > > > +	u8 unit;
> > > > +	int value;
> > > > +	int i;
> > >=20
> > > Decreasing line lenth please.
> >=20
> > What do you mean?
>=20
> This is a nit, but one other maintainers have imposed on me,
> as a means to improve legibility. The preference is to
> declare variables in decreasing line length, longest to
> shortest:
>=20
> struct kbd_state new_state;
> struct kbd_state state;
> bool convert;
> int value;
> u8 unit;
> char ch;
> int ret;
> int i;
>=20
> This is a generalization and sometimes there are good reasons
> for doing something else, such as logical groupings for
> commenting groups, etc. But since this list appeared mostly
> random, defaulting to decreasing line length is preferred.
>=20

Ok. I'm not native English speaker and I did not understand what=20
"Decreasing line lenth" means...

> > > > +	if (convert) {
> > > > +		/* NOTE: this switch fall down */
> > >=20
> > > "fall down" ? As in, it intentionally doesn't have breaks?
> >=20
> > This code convert "value" in "units" to new value in minutes
> > units. So for unit =3D=3D days it is: 24*60*60... So no breaks.
>=20
> Right, so the language of the comment just wasn't clear, try:
>=20
> /* Convert value from seconds to minutes */
>=20

Err... to seconds :-) But OK, I will change comment.

> > > > +		switch (unit) {
> > > > +		case KBD_TIMEOUT_DAYS:
> > > > +			value *=3D 24;
> > > > +		case KBD_TIMEOUT_HOURS:
> > > > +			value *=3D 60;
> > > > +		case KBD_TIMEOUT_MINUTES:
> > > > +			value *=3D 60;
> > > > +			unit =3D KBD_TIMEOUT_SECONDS;
> > > > +	 	}
> > > > +

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2936538.hTsUPPScBG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRw2gEACgkQi/DJPQPkQ1KingCeLqwvoRUftMv7Xf6skaLyNLUi
5wwAn0iB5Oi9Gyv3/bVpT+kCSU4cFd/p
=GSOr
-----END PGP SIGNATURE-----

--nextPart2936538.hTsUPPScBG--
