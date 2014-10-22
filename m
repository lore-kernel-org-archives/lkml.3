Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbaJVKvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:51:25 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39096 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaJVKvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:51:22 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH] dell-wmi: Update code for processing WMI events
Date: Wed, 22 Oct 2014 12:51:17 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
References: <1413843324-13662-1-git-send-email-pali.rohar@gmail.com> <20141021213212.GE20951@vmdeb7>
In-Reply-To: <20141021213212.GE20951@vmdeb7>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2216826.R5R8tv9Tle";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410221251.17977@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2216826.R5R8tv9Tle
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 21 October 2014 23:32:12 Darren Hart wrote:
> On Tue, Oct 21, 2014 at 12:15:24AM +0200, Pali Roh=C3=A1r wrote:
> > WMI buffer can contains more events. First value in buffer
> > is length of event followed by data of specified length.
> > After that is next length and next data. When length is
> > zero then there is no more events in bufffer.
> >=20
> > This patch adds support for processing all events in buffer
> > (not only first) and parse more event types (not only
> > hotkey events). Because of variable length of events
> > sometimes BIOS fills more hotkeys (or other values) into
> > single WMI event. In this case this patch process also
> > these multiple hotkeys (and not only first one).
> >=20
> > Some event types are just ignored because kernel is not
> > interested for them (e.g. NIC Link status, battery unplug,
> > ...).
> >=20
> > This patch is based on DSDT table from Dell Latitude E6440.
> > Code should be backward compatible so will process other
> > events of old types same as before this patch.
> >=20
> > This patch also fixes problem when in kernel log are written
> > messages about unknown WMI events. Now all know events are
> > parsed and those which are not interesting for kernel are
> > dropped without unknown message.
>=20
> This should probably be done in a separate patch.
>=20

It is not possible, because my patch rewrite code for handling=20
events. Kernel does not print "unknown event" messages when it=20
parse WMI event and understand specified part.

> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > Tested-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Well yes, I should hope so ;-)
>=20
> > ---
> >=20
> >  drivers/platform/x86/dell-wmi.c |  157
> >  +++++++++++++++++++++++++++++++-------- 1 file changed,
> >  127 insertions(+), 30 deletions(-)
> >=20
> > diff --git a/drivers/platform/x86/dell-wmi.c
> > b/drivers/platform/x86/dell-wmi.c index 25721bf..3d15949
> > 100644
> > --- a/drivers/platform/x86/dell-wmi.c
> > +++ b/drivers/platform/x86/dell-wmi.c
> > @@ -145,11 +145,35 @@ static const u16
> > bios_to_linux_keycode[256] __initconst =3D {
> >=20
> >  static struct input_dev *dell_wmi_input_dev;
> >=20
> > +static void dell_wmi_process_key(int reported_key)
> > +{
> > +	const struct key_entry *key;
> > +
> > +	key =3D
> > sparse_keymap_entry_from_scancode(dell_wmi_input_dev,
> > +						reported_key);
> > +	if (!key) {
> > +		pr_info("Unknown key %x pressed\n", reported_key);
> > +		return;
> > +	}
> > +
> > +	pr_debug("Key %x pressed\n", reported_key);
> > +
> > +	/* Don't report brightness notifications that will also
> > come via ACPI */ +	if ((key->keycode =3D=3D KEY_BRIGHTNESSUP ||
> > +	     key->keycode =3D=3D KEY_BRIGHTNESSDOWN) && acpi_video)
> > +		return;
> > +
> > +	sparse_keymap_report_entry(dell_wmi_input_dev, key, 1,
> > true); +}
> > +
> >=20
> >  static void dell_wmi_notify(u32 value, void *context)
> >  {
> > =20
> >  	struct acpi_buffer response =3D { ACPI_ALLOCATE_BUFFER, NULL
> >  	}; union acpi_object *obj;
> >  	acpi_status status;
> >=20
> > +	acpi_size buffer_size;
> > +	u16 *buffer_entry, *buffer_end;
> > +	int len, i;
> >=20
> >  	status =3D wmi_get_event_data(value, &response);
> >  	if (status !=3D AE_OK) {
> >=20
> > @@ -158,44 +182,117 @@ static void dell_wmi_notify(u32
> > value, void *context)
> >=20
> >  	}
> >  =09
> >  	obj =3D (union acpi_object *)response.pointer;
> >=20
> > +	if (!obj) {
> > +		pr_info("no response\n");
> > +		return;
> > +	}
>=20
> If you intend to print this, it should probably be a bit more
> informative. Is "info" the right level here? I would imagine
> either WARN if this was a bad thing, or DEBUG if this is more
> for debugging the driver.
>=20

So what you (or somebody else) prefer? warn or debug?

> > -	if (obj && obj->type =3D=3D ACPI_TYPE_BUFFER) {
> > -		const struct key_entry *key;
> > -		int reported_key;
> > -		u16 *buffer_entry =3D (u16 *)obj->buffer.pointer;
> > -		int buffer_size =3D obj->buffer.length/2;
> > -
> > -		if (buffer_size >=3D 2 && dell_new_hk_type &&
> > buffer_entry[1] !=3D 0x10) { -			pr_info("Received=20
unknown
> > WMI event (0x%x)\n",
> > -				buffer_entry[1]);
> > -			kfree(obj);
> > -			return;
> > -		}
> > +	if (obj->type !=3D ACPI_TYPE_BUFFER) {
> > +		pr_info("bad response type %x\n", obj->type);
> > +		kfree(obj);
> > +		return;
> > +	}
> > +
> > +	pr_debug("Received WMI event (%*ph)\n",
> > +		obj->buffer.length, obj->buffer.pointer);
> >=20
> > -		if (buffer_size >=3D 3 && (dell_new_hk_type ||
> > buffer_entry[1] =3D=3D 0x0)) -			reported_key =3D
> > (int)buffer_entry[2];
> > +	buffer_entry =3D (u16 *)obj->buffer.pointer;
> > +	buffer_size =3D obj->buffer.length/2;
> > +
> > +	if (!dell_new_hk_type) {
> > +		if (buffer_size >=3D 3 && buffer_entry[1] =3D=3D 0x0)
> > +			dell_wmi_process_key(buffer_entry[2]);
> >=20
> >  		else if (buffer_size >=3D 2)
> >=20
> > -			reported_key =3D (int)buffer_entry[1] & 0xffff;
> > -		else {
> > +			dell_wmi_process_key(buffer_entry[1]);
>=20
> Why can we drop the 0xffff mask now?
>=20

Because it is useless (or correct me if not!). Variable=20
buffer_entry has type u16* so operation "AND 0xFFFF" on 16bit=20
integer do nothing.

> > +		else
> >=20
> >  			pr_info("Received unknown WMI event\n");
> >=20
> > -			kfree(obj);
> > -			return;
> > +		kfree(obj);
> > +		return;
> > +	}
> > +
> > +	buffer_end =3D buffer_entry + buffer_size;
> > +
> > +	while (buffer_entry < buffer_end) {
> > +
> > +		len =3D buffer_entry[0];
> > +		if (len =3D=3D 0)
> > +			break;
> > +
> > +		len++;
> > +
>=20
> Why increment len here? Are you trying to avoid a "len + 1" in
> the comparisons below? If so, is using "len * 2" in the debug
> message below correct? Please clarify.
>=20

in buffer_entry[0] (16 bit integer) is stored length of event (in=20
16bit units) without first (length) value. And "%*ph" takes size=20
in bytes (u8). So length in bytes (u8) units is 2 * length in u16=20
units.

> > +		if (buffer_entry+len > buffer_end) {
>=20
> See coding style documentation on operators. Please run
> patches through checkpatch.
>=20

checkpatch.pl does not show any problem for these lines.

> > +			pr_info("Invalid length of WMI event\n");
>=20
> info doesn't see correct here either.
>=20

debug or warn?

> > +			break;
> >=20
> >  		}
> >=20
> > -		key =3D
> > sparse_keymap_entry_from_scancode(dell_wmi_input_dev,
> > -							reported_key);
> > -		if (!key) {
> > -			pr_info("Unknown key %x pressed\n", reported_key);
> > -		} else if ((key->keycode =3D=3D KEY_BRIGHTNESSUP ||
> > -			    key->keycode =3D=3D KEY_BRIGHTNESSDOWN) &&=20
acpi_video) {
> > -			/* Don't report brightness notifications that will=20
also
> > -			 * come via ACPI */
> > -			;
> > -		} else {
> > -			sparse_keymap_report_entry(dell_wmi_input_dev,=20
key,
> > -						   1, true);
> > +		pr_debug("Process buffer (%*ph)\n", len*2,=20
buffer_entry);
> > +
> > +		switch (buffer_entry[1]) {
> > +		case 0x00:
> > +			for (i =3D 2; i < len; ++i) {
> > +				switch (buffer_entry[i]) {
> > +				case 0xe043:
> > +					/* NIC Link is Up */
> > +					pr_debug("NIC Link is Up\n");
> > +					break;
> > +				case 0xe044:
> > +					/* NIC Link is Down */
> > +					pr_debug("NIC Link is Down\n");
> > +					break;
> > +				case 0xe045:
> > +					/* Unknown event but defined in DSDT */
> > +				default:
> > +					/* Unknown event */
> > +					pr_info("Unknown WMI event type 0x00: "
> > +						"0x%x\n", (int)buffer_entry[i]);
> > +					break;
> > +				}
> > +			}
> > +			break;
> > +		case 0x10:
> > +			/* Keys pressed */
> > +			for (i =3D 2; i < len; ++i)
> > +				dell_wmi_process_key(buffer_entry[i]);
> > +			break;
> > +		case 0x11:
> > +			for (i =3D 2; i < len; ++i) {
> > +				switch (buffer_entry[i]) {
> > +				case 0xfff0:
> > +					/* Battery unplugged */
> > +					pr_debug("Battery unplugged\n");
> > +					break;
> > +				case 0xfff1:
> > +					/* Battery inserted */
> > +					pr_debug("Battery inserted\n");
> > +					break;
> > +				case 0x01e1:
> > +				case 0x02ea:
> > +				case 0x02eb:
> > +				case 0x02ec:
> > +				case 0x02f6:
> > +					/* Keyboard backlight level changed */
> > +					pr_debug("Keyboard backlight level "
> > +						 "changed\n");
> > +					break;
> > +				default:
> > +					/* Unknown event */
> > +					pr_info("Unknown WMI event type 0x11: "
> > +						"0x%x\n", (int)buffer_entry[i]);
> > +					break;
> > +				}
> > +			}
> > +			break;
> > +		default:
> > +			/* Unknown event */
> > +			pr_info("Unknown WMI event type 0x%x\n",
> > +				(int)buffer_entry[1]);
> > +			break;
> >=20
> >  		}
> >=20
> > +
> > +		buffer_entry +=3D len;
> > +
> >=20
> >  	}
> >=20
> > +
> >=20
> >  	kfree(obj);
> > =20
> >  }

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2216826.R5R8tv9Tle
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRHjCUACgkQi/DJPQPkQ1LMtACfbmPlxS5P9CKtrIonzVIKBGhE
FysAnAyU9Sp+z8WIXuEP1nUKq8KTfXkP
=SDUg
-----END PGP SIGNATURE-----

--nextPart2216826.R5R8tv9Tle--
