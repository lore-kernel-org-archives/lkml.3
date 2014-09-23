Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbaIWUGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:06:10 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58165 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaIWUGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:06:07 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: ACPI/i915: Cannot configure display brightness on Dell Latitude E6440
Date: Tue, 23 Sep 2014 22:06:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.13.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1629955.uH7RlRkzQB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201409232206.02819@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1629955.uH7RlRkzQB
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

after big changes in acpi video/i915 code I cannot change display=20
brightness on my Dell Latitude E6440 with kernel 3.17-rc6. With=20
kernel 3.13 everything worked fine.

More information about this problem:

=46or configuring brightness on Dell laptops there are 4 ways:
1) via acpi video driver
2) via dell-laptop driver
3) via i915 drm driver
4) from userspace with special dell SMI call
   (e.g with program dellLcdBrightness from libsmbios package)

Methods 2) and 4) are same, both making special SMI call and Bios=20
handing this request (just 2 is from kernel and 4 from userspace)

Method 1) via acpi video driver working, but is not perfect.=20
Driver can be used to change brightness (but only some levels,=20
probably this depends on acpi/DSDT tables), but cannot be used to=20
retrieve current brightness (when BIOS/SMI change brightness acpi=20
driver report old incorrect value). So I prefer dell-laptop=20
driver instead acpi video.

Method 3) working even with 3.17-rc6 kernel but because that=20
backlight device exported by i915 is marked as raw, desktop=20
programs prefer to use other devices.

Moreover it looks like that methods 1) 2) and 4) just forward=20
request to method 3). So in any cased brightness is changed by=20
i915 drm driver.

I'm not sure (correct me if I'm wrong!) but I think that intel=20
i915 drm driver accept changes (file intel_opregion.c) only if=20
acpi function acpi_video_verify_backlight_support() returns true.

=46unction acpi_video_verify_backlight_support() returns true iff:
function acpi_video_backlight_support() returns true AND at least=20
one of these functions returns false:
acpi_osi_is_win8()
acpi_video_use_native_backlight()=20
backlight_device_registered(BACKLIGHT_RAW)

On my notebook acpi_osi_is_win8() returns true (as is win8=20
compliant), backlight_device_registered(BACKLIGHT_RAW) returns=20
true as I'm using intel i915 drm driver with raw backlight device=20
and acpi_video_use_native_backlight() returns true/false=20
depending on "video.use_native_backlight" kernel param. Default=20
is true.

So if I want to have working acpi video driver with display=20
brightness support I need to boot kernel with param:=20
"video.use_native_backlight=3D0". I tested it with kernel 3.17-rc6=20
and this param really enabled display brightness support via acpi=20
video driver -- which is good.

Driver dell-laptop creating backligh device for brightness=20
control only if acpi_video_backlight_support() returns false.=20
There is complicated condition for it and when kernel is booted=20
with "video.use_native_backlight=3D0" that function returns true.

So conclusion is: With current code in kernel 3.17-rc6 it is not=20
possible to control brightness of display with native driver=20
dell-laptop on Dell Latitude E6440 (and probably on others=20
too)!!!

And Because laptop is win8 compliant and you create decision to=20
use native driver (instead acpi one) it is not possible to=20
control display brightness without tweeks in kernel cmdline.

As I wrote I would rather to use native dell-laptop driver for=20
controlling brightness, but it is not possible.

So how to solve this problem?

Quick solution would be to set use_native_backlight false for=20
some Dell laptops which means, that acpi video will be used and=20
in this case intel i915 driver will *not* drop backlight change=20
request.

Another solution could be to disable check in dell_laptop driver=20
and add use_native_backlight=3D0 to hooks. But this create two=20
backlight interfaces (which is not good), but only way (for now)=20
how to make dell_laptop working again.

Better and maybe only one proper solution would be to teach intel=20
drm i915 driver to not drop backlight change request for Dell=20
laptops (or all??). (This allows to work both acpi video and=20
dell_laptop drivers without any change and with *any* value in=20
param use_native_backlight). I think that problematic code is in=20
function asle_set_backlight() in file intel_opregion.c (but I'm=20
not sure). My idea is that "drop" event function it is caused by=20
this commit 0b9f7d93ca6109048a4eb06332b666b6e29df4fe (but I'm not=20
sure).

At least something must be done as I think that I'm not only one=20
who has Dell laptop and brightness configuration is really=20
important...

Thanks.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1629955.uH7RlRkzQB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlQh0qoACgkQi/DJPQPkQ1Ks+gCeK9xnXepc3dAyp0BOP+IJhXmf
mwMAoJduky6C8mkj5e/XaJ795wj7pXnH
=BRDv
-----END PGP SIGNATURE-----

--nextPart1629955.uH7RlRkzQB--
