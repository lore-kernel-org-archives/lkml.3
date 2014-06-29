Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaF2Ldx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 07:33:53 -0400
Received: from mout.web.de ([212.227.15.14]:53593 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaF2Ldw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 07:33:52 -0400
Message-ID: <53AFF992.5030403@web.de>
Date: Sun, 29 Jun 2014 13:33:38 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Hui Wang <jason77.wang@gmail.com>, tiwai@suse.de,
        alsa-devel@alsa-project.org
CC: hui.wang@canonical.com, alex.hung@canonical.com, yk@canonical.com,
        david.henningsson@canonical.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [V2 PATCH] ALSA: hda - Enable mute/mic-mute LEDs for more Thinkpads
 with Conexant codec
References: <1385534846-20829-1-git-send-email-hui.wang@canonical.com>
In-Reply-To: <1385534846-20829-1-git-send-email-hui.wang@canonical.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="q8vmVHoes7wLPVuAAe5uf02lp4XqxmLIq"
X-Provags-ID: V03:K0:Cxjc82uxYnK7XSn0A2/EqWULYRvoQTRNka8plW4f3oHhscKcQCA
 cbvs9lZkcdVBKVEtnC4SFXz9UlZdhJih3Fq5s/B2pTZW2DNutsJGOqFQWdA15yPW3V3EpDP
 BZ4CQ3+wajfGvEtioHAdJ+oqaNeCOw9mrObRXideAdTkfatapBSqJzboDmVAy/TVjTGFGhx
 YVjW70w7GrxawKR6gI/AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q8vmVHoes7wLPVuAAe5uf02lp4XqxmLIq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-11-27 07:47, Hui Wang wrote:
> Most Thinkpad Edge series laptops use conexant codec, so far although
> the codecs have different minor Vendor Id and minor Subsystem Id,
> they all belong to the cxt5066 family, this change can make the
> mute/mic-mute LEDs support more generic among cxt_5066 family.
>=20
> This design refers to the similar solution for the realtek codec
> ALC269 family in the patch_realtek.c.
>=20
> Cc: Alex Hung <alex.hung@canonical.com>
> Cc: David Henningsson <david.henningsson@canonical.com>
> Signed-off-by: Hui Wang <hui.wang@canonical.com>
> ---
>  sound/pci/hda/patch_conexant.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>=20
> diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conex=
ant.c
> index c205bb1..1f2717f 100644
> --- a/sound/pci/hda/patch_conexant.c
> +++ b/sound/pci/hda/patch_conexant.c
> @@ -3244,9 +3244,29 @@ enum {
>  #if IS_ENABLED(CONFIG_THINKPAD_ACPI)
> =20
>  #include <linux/thinkpad_acpi.h>
> +#include <acpi/acpi.h>
> =20
>  static int (*led_set_func)(int, bool);
> =20
> +static acpi_status acpi_check_cb(acpi_handle handle, u32 lvl, void *co=
ntext,
> +				 void **rv)
> +{
> +	bool *found =3D context;
> +	*found =3D true;
> +	return AE_OK;
> +}
> +
> +static bool is_thinkpad(struct hda_codec *codec)
> +{
> +	bool found =3D false;
> +	if (codec->subsystem_id >> 16 !=3D 0x17aa)
> +		return false;
> +	if (ACPI_SUCCESS(acpi_get_devices("LEN0068", acpi_check_cb, &found, N=
ULL)) && found)
> +		return true;
> +	found =3D false;
> +	return ACPI_SUCCESS(acpi_get_devices("IBM0068", acpi_check_cb, &found=
, NULL)) && found;
> +}
> +
>  static void update_tpacpi_mute_led(void *private_data, int enabled)
>  {
>  	struct hda_codec *codec =3D private_data;
> @@ -3279,6 +3299,8 @@ static void cxt_fixup_thinkpad_acpi(struct hda_co=
dec *codec,
>  	bool removefunc =3D false;
> =20
>  	if (action =3D=3D HDA_FIXUP_ACT_PROBE) {
> +		if (!is_thinkpad(codec))
> +			return;
>  		if (!led_set_func)
>  			led_set_func =3D symbol_request(tpacpi_led_set);
>  		if (!led_set_func) {
> @@ -3494,6 +3516,7 @@ static const struct snd_pci_quirk cxt5066_fixups[=
] =3D {
>  	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),=

>  	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_FIXUP_STEREO=
_DMIC),
>  	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
> +	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad", CXT_FIXUP_THINKPAD_ACPI),
>  	SND_PCI_QUIRK(0x1c06, 0x2011, "Lemote A1004", CXT_PINCFG_LEMOTE_A1004=
),
>  	SND_PCI_QUIRK(0x1c06, 0x2012, "Lemote A1205", CXT_PINCFG_LEMOTE_A1205=
),
>  	{}
>=20

Starting with this patch, my Lenovo Thinkpad X121e netbook (it's without
any mute LEDs, BTW, there is only a power LED) considers the power
button as hard reset. I have to exclude my machine from that ACPI fixup
(this is on top of current Linus master):

diff --git a/sound/pci/hda/thinkpad_helper.c b/sound/pci/hda/thinkpad_hel=
per.c
index 6ba0b55..7e1a179 100644
--- a/sound/pci/hda/thinkpad_helper.c
+++ b/sound/pci/hda/thinkpad_helper.c
@@ -21,7 +21,8 @@ static acpi_status acpi_check_cb(acpi_handle handle, u3=
2 lvl, void *context,
 static bool is_thinkpad(struct hda_codec *codec)
 {
 	bool found =3D false;
-	if (codec->subsystem_id >> 16 !=3D 0x17aa)
+	if (codec->subsystem_id >> 16 !=3D 0x17aa ||
+	    codec->subsystem_id =3D=3D 0x17aa21ec)
 		return false;
 	if (ACPI_SUCCESS(acpi_get_devices("LEN0068", acpi_check_cb, &found, NUL=
L)) && found)
 		return true;


Is that the way to address it? Then I can send a proper patch. Any hints
regarding the "why" will be incorporated into its description.

Thanks,
Jan


--q8vmVHoes7wLPVuAAe5uf02lp4XqxmLIq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOv+ZgACgkQitSsb3rl5xR5TwCfQU8n5BYp0T49g6reQKzKORbI
VrkAoM70vChOimUjK8qpKpx+PLtbeS9b
=G9pw
-----END PGP SIGNATURE-----

--q8vmVHoes7wLPVuAAe5uf02lp4XqxmLIq--
