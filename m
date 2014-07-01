Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaGAHim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:38:42 -0400
Received: from mout.web.de ([212.227.17.11]:60902 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbaGAHil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:38:41 -0400
Message-ID: <53B26575.1000003@web.de>
Date: Tue, 01 Jul 2014 09:38:29 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Hui Wang <hui.wang@canonical.com>
CC: Hui Wang <jason77.wang@gmail.com>, tiwai@suse.de,
        alsa-devel@alsa-project.org, alex.hung@canonical.com, yk@canonical.com,
        david.henningsson@canonical.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [V2 PATCH] ALSA: hda - Enable mute/mic-mute LEDs for more Thinkpads
 with Conexant codec
References: <1385534846-20829-1-git-send-email-hui.wang@canonical.com> <53AFF992.5030403@web.de> <53B0C596.6090007@canonical.com> <53B1078B.4090101@web.de> <53B219DF.6090807@canonical.com>
In-Reply-To: <53B219DF.6090807@canonical.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="NmVLcdK0vSpIAsKlHTTHOVlfM85fQoi1G"
X-Provags-ID: V03:K0:UbWpBoFzrgsLZeamtbSrMC5pg8Xdh4o8fFG6ehBvrYsAHgP4YQd
 9AAxtjKcXERyccFsF9E00zE0ZY2ZkPJR+Bsp9tdPPpHMdUJstM58X6eb58sr8mP7gV6qEt7
 cqgQImhjHP06Yhb1nE8c2KvOOIWb/dcoJHLG8xAw58w9uSMoj8GuGLdduLVKFNMfBD7Ranc
 mdFotaTdOvE1C2qSqOFhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NmVLcdK0vSpIAsKlHTTHOVlfM85fQoi1G
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-07-01 04:15, Hui Wang wrote:
> On 06/30/2014 02:45 PM, Jan Kiszka wrote:
>> On 2014-06-30 04:04, Hui Wang wrote:
>>> On 06/29/2014 07:33 PM, Jan Kiszka wrote:
>>>> On 2013-11-27 07:47, Hui Wang wrote:
>>>>> Most Thinkpad Edge series laptops use conexant codec, so far althou=
gh
>>>>> the codecs have different minor Vendor Id and minor Subsystem Id,
>>>>> they all belong to the cxt5066 family, this change can make the
>>>>> mute/mic-mute LEDs support more generic among cxt_5066 family.
>>>>>
>>>>> This design refers to the similar solution for the realtek codec
>>>>> ALC269 family in the patch_realtek.c.
>>>>>
>>>>> Cc: Alex Hung <alex.hung@canonical.com>
>>>>> Cc: David Henningsson <david.henningsson@canonical.com>
>>>>> Signed-off-by: Hui Wang <hui.wang@canonical.com>
>>>>> ---
>>>>>    sound/pci/hda/patch_conexant.c | 23 +++++++++++++++++++++++
>>>>>    1 file changed, 23 insertions(+)
>>>>>
>>>>> diff --git a/sound/pci/hda/patch_conexant.c
>>>>> b/sound/pci/hda/patch_conexant.c
>>>>> index c205bb1..1f2717f 100644
>>>>> --- a/sound/pci/hda/patch_conexant.c
>>>>> +++ b/sound/pci/hda/patch_conexant.c
>>>>> @@ -3244,9 +3244,29 @@ enum {
>>>>>    #if IS_ENABLED(CONFIG_THINKPAD_ACPI)
>>>>>      #include <linux/thinkpad_acpi.h>
>>>>> +#include <acpi/acpi.h>
>>>>>      static int (*led_set_func)(int, bool);
>>>>>    +static acpi_status acpi_check_cb(acpi_handle handle, u32 lvl, v=
oid
>>>>> *context,
>>>>> +                 void **rv)
>>>>> +{
>>>>> +    bool *found =3D context;
>>>>> +    *found =3D true;
>>>>> +    return AE_OK;
>>>>> +}
>>>>> +
>>>>> +static bool is_thinkpad(struct hda_codec *codec)
>>>>> +{
>>>>> +    bool found =3D false;
>>>>> +    if (codec->subsystem_id >> 16 !=3D 0x17aa)
>>>>> +        return false;
>>>>> +    if (ACPI_SUCCESS(acpi_get_devices("LEN0068", acpi_check_cb,
>>>>> &found, NULL)) && found)
>>>>> +        return true;
>>>>> +    found =3D false;
>>>>> +    return ACPI_SUCCESS(acpi_get_devices("IBM0068", acpi_check_cb,=

>>>>> &found, NULL)) && found;
>>>>> +}
>>>>> +
>>>>>    static void update_tpacpi_mute_led(void *private_data, int enabl=
ed)
>>>>>    {
>>>>>        struct hda_codec *codec =3D private_data;
>>>>> @@ -3279,6 +3299,8 @@ static void cxt_fixup_thinkpad_acpi(struct
>>>>> hda_codec *codec,
>>>>>        bool removefunc =3D false;
>>>>>          if (action =3D=3D HDA_FIXUP_ACT_PROBE) {
>>>>> +        if (!is_thinkpad(codec))
>>>>> +            return;
>>>>>            if (!led_set_func)
>>>>>                led_set_func =3D symbol_request(tpacpi_led_set);
>>>>>            if (!led_set_func) {
>>>>> @@ -3494,6 +3516,7 @@ static const struct snd_pci_quirk
>>>>> cxt5066_fixups[] =3D {
>>>>>        SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s",
>>>>> CXT_FIXUP_STEREO_DMIC),
>>>>>        SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310",
>>>>> CXT_FIXUP_STEREO_DMIC),
>>>>>        SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205",
>>>>> CXT_FIXUP_STEREO_DMIC),
>>>>> +    SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad",
>>>>> CXT_FIXUP_THINKPAD_ACPI),
>>>>>        SND_PCI_QUIRK(0x1c06, 0x2011, "Lemote A1004",
>>>>> CXT_PINCFG_LEMOTE_A1004),
>>>>>        SND_PCI_QUIRK(0x1c06, 0x2012, "Lemote A1205",
>>>>> CXT_PINCFG_LEMOTE_A1205),
>>>>>        {}
>>>>>
>>>> Starting with this patch, my Lenovo Thinkpad X121e netbook (it's
>>>> without
>>>> any mute LEDs, BTW, there is only a power LED) considers the power
>>>> button as hard reset. I have to exclude my machine from that ACPI fi=
xup
>>>> (this is on top of current Linus master):
>>> It seems more like a firmware issue, in the acpi code, the "SSMS" is =
for
>>> mute led, and the "MMTS" is for micmute led, I don't know why your
>>> machine can pass "SSMS" or "MMTS" scanning even without mute LEDs.
>>>
>> Is there anything I can debug or any information I can collect from my=

>> box to examine this?
> What is the linux distribution on your machine? And use showkey to catc=
h
> the keycode of that button.

I'm running OpenSUSE 13.1. The reported keycode of the power button is 11=
6.

Jan



--NmVLcdK0vSpIAsKlHTTHOVlfM85fQoi1G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOyZXUACgkQitSsb3rl5xQ9zACeIcjAxqON183YtX79atfxGoX1
eAYAoNnelPb3XGqHDcoUn9Lu15yJwIB9
=Qb3x
-----END PGP SIGNATURE-----

--NmVLcdK0vSpIAsKlHTTHOVlfM85fQoi1G--
