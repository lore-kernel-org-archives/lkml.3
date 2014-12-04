Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaLDKQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:16:55 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56055 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbaLDKQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:16:50 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH v2] platform: x86: dell-laptop: Add support for keyboard backlight
Date: Thu, 4 Dec 2014 11:16:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com,
        Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com> <1416754245-15550-1-git-send-email-pali.rohar@gmail.com> <20141203084319.GA52608@vmdeb7>
In-Reply-To: <20141203084319.GA52608@vmdeb7>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1941016.eko9c05Ma7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412041116.47542@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1941016.eko9c05Ma7
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 03 December 2014 09:43:21 Darren Hart wrote:
> On Sun, Nov 23, 2014 at 03:50:45PM +0100, Pali Roh=C3=A1r wrote:
> > This patch adds support for configuring keyboard backlight
> > settings on supported Dell laptops. It exports kernel leds
> > interface and uses Dell SMBIOS tokens or keyboard class
> > interface.
> >=20
> > With this patch it is possible to set:
> > * keyboard backlight level
> > * timeout after which will be backlight automatically turned
> > off * input activity triggers (keyboard, touchpad, mouse)
> > which enable backlight * ambient light settings
> >=20
> > Settings are exported via sysfs:
> > /sys/class/leds/dell::kbd_backlight/
> >=20
> > Code is based on newly released documentation by Dell in
> > libsmbios project.
>=20
> Hi Pali,
>=20
> I would really like to see this broken up. Possibly adding
> levels and timeouts as separate patches for example. It is
> quite difficult to review this all at once in a reasonable
> amount of time.
>=20
> During this review I caught a few more CodingStyle violations,
> and raised some questions about the timeout and levels
> mechanisms.
>=20
> > @@ -62,6 +71,10 @@ struct calling_interface_structure {
> >=20
> >  struct quirk_entry {
> > =20
> >  	u8 touchpad_led;
> >=20
> > +
> > +	/* Ordered list of timeouts expressed in seconds.
> > +	 * The list must end with -1 */
>=20
> Despite other instances in this file, block comments are
> documented in CodingStyle as:
>=20
> /*
>  * Comment text.
>  */
>=20
> The old ones should be cleaned up eventually, but new ones
> need to be done according to CodingStyle. Please correct
> throughout.
>=20
> > +	int kbd_timeouts[];
> >=20
> >  };
> > =20
> >  static struct quirk_entry *quirks;
> >=20
> > @@ -76,6 +89,10 @@ static int __init dmi_matched(const
> > struct dmi_system_id *dmi)
> >=20
> >  	return 1;
> > =20
> >  }
> >=20
> > +static struct quirk_entry quirk_dell_xps13_9333 =3D {
> > +	.kbd_timeouts =3D { 0, 5, 15, 60, 5*60, 15*60, -1 },
>=20
> Where did these values come from? Were they documented in the
> libsmbios project? Can you provide a URL to that? These
> really should be described by the firmware, but if they
> aren't, nothing we can do about it.
>=20

They comes from some Windows Dell GUI utility. It is not=20
documented in libsmbios project and people behind libsmbios do=20
not know why only those values are accepted by BIOS for XPS=20
laptop...

> > @@ -790,6 +842,964 @@ static void touchpad_led_exit(void)
> >=20
> >  	led_classdev_unregister(&touchpad_led);
> > =20
> >  }
> >=20
> > +/* Derived from information in smbios-keyboard-ctl:
> See block comment above.
>=20
> > +
> > + cbClass 4
> > + cbSelect 11
> > + Keyboar illumination
>=20
> Keyboard
>=20
> > + cbArg1 determines the function to be performed
> > +
> > + cbArg1 0x0 =3D Get Feature Information
> > +  cbRES1         Standard return codes (0, -1, -2)
> > +  cbRES2, word0  Bitmap of user-selectable modes
> > +     bit 0     Always off (All systems)
> > +     bit 1     Always on (Travis ATG, Siberia)
> > +     bit 2     Auto: ALS-based On; ALS-based Off (Travis
> > ATG) +     bit 3     Auto: ALS- and input-activity-based
> > On; input-activity based Off +     bit 4     Auto:
> > Input-activity-based On; input-activity based Off +     bit
> > 5     Auto: Input-activity-based On (illumination level
> > 25%); input-activity based Off +     bit 6     Auto:
> > Input-activity-based On (illumination level 50%);
> > input-activity based Off +     bit 7     Auto:
> > Input-activity-based On (illumination level 75%);
> > input-activity based Off +     bit 8     Auto:
> > Input-activity-based On (illumination level 100%);
> > input-activity based Off +     bits 9-15 Reserved for
> > future use
> > +  cbRES2, byte2  Reserved for future use
> > +  cbRES2, byte3  Keyboard illumination type
> > +     0         Reserved
> > +     1         Tasklight
> > +     2         Backlight
> > +     3-255     Reserved for future use
> > +  cbRES3, byte0  Supported auto keyboard illumination
> > trigger bitmap. +     bit 0     Any keystroke
> > +     bit 1     Touchpad activity
> > +     bit 2     Pointing stick
> > +     bit 3     Any mouse
> > +     bits 4-7  Reserved for future use
> > +  cbRES3, byte1  Supported timeout unit bitmap
> > +     bit 0     Seconds
> > +     bit 1     Minutes
> > +     bit 2     Hours
> > +     bit 3     Days
> > +     bits 4-7  Reserved for future use
> > +  cbRES3, byte2  Number of keyboard light brightness levels
> > +  cbRES4, byte0  Maximum acceptable seconds value (0 if
> > seconds not supported). +  cbRES4, byte1  Maximum
> > acceptable minutes value (0 if minutes not supported). +=20
> > cbRES4, byte2  Maximum acceptable hours value (0 if hours
> > not supported). +  cbRES4, byte3  Maxiomum acceptable days
> > value (0 if days not supported)
>=20
> Maximum             ^
>=20
> This interface appears to define all possible values for the
> timeout between cbRES3[1] and cbRES4[*]. Why is the
> kbd_timeouts[] array a quirk with fixed values? It seems it
> could indeed be dynamically determined.
>=20

BIOS bug (or BIOS feature?). No idea. For invalid value on XPS=20
BIOS just reset keyboard backlight to someting default...

> > +
> > +struct kbd_info {
> > +	u16 modes;
> > +	u8 type;
> > +	u8 triggers;
> > +	u8 levels;
> > +	u8 seconds;
> > +	u8 minutes;
> > +	u8 hours;
> > +	u8 days;
> > +};
> > +
> > +
> > +static u8 kbd_mode_levels[16];
> > +static int kbd_mode_levels_count;
>=20
> I'm confused by these. How are they different from
> kbd_info.levels?
>=20

There are two interfaces how to set keyboard backlight. Both are=20
documented above. One via kbd mode and one via kbd level. Some=20
laptops (e.g my E6440) support only kbd mode and some (e.g XPS)=20
support only kbd level. So we need to implement both interfaces=20
in kernel if we want to support as more machines as possible.

> We seem to check the latter first and fall back to these if
> that is 0.... why?
>=20

Because if maximum possible kbd level is 0 then we cannot use it.

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
> > +	if (ret) {
> > +		ret =3D dell_smi_error(ret);
> > +		goto out;
> > +	}
> > +
> > +	info->modes =3D buffer->output[1] & 0xFFFF;
> > +	info->type =3D (buffer->output[1] >> 24) & 0xFF;
> > +	info->triggers =3D buffer->output[2] & 0xFF;
> > +	units =3D (buffer->output[2] >> 8) & 0xFF;
> > +	info->levels =3D (buffer->output[2] >> 16) & 0xFF;
> > +
> > +	if (units & BIT(0))
> > +		info->seconds =3D (buffer->output[3] >> 0) & 0xFF;
> > +	if (units & BIT(1))
> > +		info->minutes =3D (buffer->output[3] >> 8) & 0xFF;
> > +	if (units & BIT(2))
> > +		info->hours =3D (buffer->output[3] >> 16) & 0xFF;
> > +	if (units & BIT(3))
> > +		info->days =3D (buffer->output[3] >> 24) & 0xFF;
> > +
>=20
> > +out:
> Please indent gotos by one space. This improves diffs context
> by not treating the goto label like a function.
>=20
> > +	release_buffer();
> > +	return ret;
> > +}
> > +
> > +static unsigned int kbd_get_max_level(void)
> > +{
> > +	if (kbd_info.levels !=3D 0)
> > +		return kbd_info.levels;
> > +	if (kbd_mode_levels_count > 0)
> > +		return kbd_mode_levels_count - 1;
>=20
> Here for example. In what scenario does this happen?
>=20

When laptop does not support configuring keyboard backlight=20
level. You can see that in documentation are more properties=20
which can be configured, so if BIOS tell us that this one (level)=20
does not support we cannot change it.

> > +	return 0;
> > +}
> > +
> >=20
> >=20
> >=20
> > +static inline int kbd_init_info(void)
> > +{
> > +	struct kbd_state state;
> > +	int ret;
> > +	int i;
> > +
> > +	ret =3D kbd_get_info(&kbd_info);
> > +	if (ret)
> > +		return ret;
> > +
> > +	kbd_get_state(&state);
> > +
> > +	/* NOTE: timeout value is stored in 6 bits so max value is
> > 63 */ +	if (kbd_info.seconds > 63)
> > +		kbd_info.seconds =3D 63;
> > +	if (kbd_info.minutes > 63)
> > +		kbd_info.minutes =3D 63;
> > +	if (kbd_info.hours > 63)
> > +		kbd_info.hours =3D 63;
> > +	if (kbd_info.days > 63)
> > +		kbd_info.days =3D 63;
> > +
> > +	/* NOTE: On tested machines ON mode did not work and
> > caused +	 *       problems (turned backlight off) so do not
> > use it +	 */
> > +	kbd_info.modes &=3D ~BIT(KBD_MODE_BIT_ON);
> > +
> > +	kbd_previous_level =3D kbd_get_level(&state);
> > +	kbd_previous_mode_bit =3D state.mode_bit;
> > +
> > +	if (kbd_previous_level =3D=3D 0 && kbd_get_max_level() !=3D 0)
> > +		kbd_previous_level =3D 1;
> > +
> > +	if (kbd_previous_mode_bit =3D=3D KBD_MODE_BIT_OFF) {
> > +		kbd_previous_mode_bit =3D
> > +			ffs(kbd_info.modes & ~BIT(KBD_MODE_BIT_OFF));
> > +		if (kbd_previous_mode_bit !=3D 0)
> > +			kbd_previous_mode_bit--;
> > +	}
> > +
> > +	if (kbd_info.modes & (BIT(KBD_MODE_BIT_ALS) |
> > +			      BIT(KBD_MODE_BIT_TRIGGER_ALS)))
> > +		kbd_als_supported =3D true;
> > +
> > +	if (kbd_info.modes & (
> > +	    BIT(KBD_MODE_BIT_TRIGGER_ALS) |
> > BIT(KBD_MODE_BIT_TRIGGER) | +	  =20
> > BIT(KBD_MODE_BIT_TRIGGER_25) | BIT(KBD_MODE_BIT_TRIGGER_50)
> > | +	    BIT(KBD_MODE_BIT_TRIGGER_75) |
> > BIT(KBD_MODE_BIT_TRIGGER_100) +	   ))
> > +		kbd_triggers_supported =3D true;
> > +
> > +	for (i =3D 0; i < 16; ++i)
>=20
> Doesn't this only apply to bits 5-8? Why not just loop through
> those?
>=20

Some bits are reserved for future use (now undocumented). So once=20
we know what they means we can adjust global enum/macro and=20
changing this for loop will not be needed.=20

> for (i =3D KBD_MODE_BIT_TRIGGER_25; i <=3D
> KBD_MODE_BIT_TRIGGER_100)
>=20
> The level_mode_bit check becomes unecessary.
>=20

I tried to write general code which check all possible modes if=20
they are of type which configure level. And because some of them=20
are undocumented I used this approach, so in future global=20
enum/macro could be extended.

> > +		if (kbd_is_level_mode_bit(i) && (BIT(i) &
> > kbd_info.modes))
> > +			kbd_mode_levels[1+kbd_mode_levels_count++] =3D i;
>=20
> One space around operators like + please.
>=20
> What is kbd_mode_levels[0] reserved for? The current level?
> Isn't that what kbd_state.level is for?
>=20

Reserved for off mode -- keyboard backlight turned off.

kbd level is for laptops which support kbd level. kbd mode is for=20
laptops which support setting level via kbd mode.

> > +
> > +	if (kbd_mode_levels_count > 0) {
> > +		for (i =3D 0; i < 16; ++i) {
>=20
> If 0-4 don't apply here, why loop through them? Should we just
> set levels[0] to 0 if it isn't one of 5-8?
>=20

We know that BIOSes are buggy, so I can imagine that off mode=20
(which is enum =3D 0) does not have to be supported... So for=20
kbd_mode_levels[0] we set first supported mode (if off is not=20
supported we will choose something other, so kernel code will not=20
call unsupported mode).

> If bits 9-16 are reserved, it seems it would be best to avoid
> checking for them as they might return a false positive, and
> we'd be setting kbd_mode_levels to an undefined value.
>=20
> > +			if (BIT(i) & kbd_info.modes) {
> > +				kbd_mode_levels[0] =3D i;
> > +				break;
> > +			}
> > +		}
> > +		kbd_mode_levels_count++;
> > +	}
> > +
> > +	return 0;

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1941016.eko9c05Ma7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSANI8ACgkQi/DJPQPkQ1KD4QCfXDAqN2z3b7cHacuO1PbrTAJH
8Z0AnjuraKRLVbchxgxNeFlDWWpz+6dm
=7lDp
-----END PGP SIGNATURE-----

--nextPart1941016.eko9c05Ma7--
