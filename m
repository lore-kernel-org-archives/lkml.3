Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaL0UBE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:01:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52695 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751581AbaL0UBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:01:01 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: nick <xerofoify@gmail.com>, Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [Intel-gfx] 3.19-rc1 errors when opening LID
Date: Sat, 27 Dec 2014 21:22:56 +0100
Message-ID: <1818900.MY9q0yfluC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <201412270919.49540@pali>
References: <201412241951.48652@pali> <549C4278.5080707@gmail.com> <201412270919.49540@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart10465392.Boglpc3bMo"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart10465392.Boglpc3bMo
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Saturday, December 27, 2014 09:19:49 AM Pali Roh=C3=A1r wrote:
> Hello,
>=20
> in attachment is output of ls -l /sys/bus/acpi/devices from both=20
> 3.13 and 3.19 kernels.
> =20
> Anyway Gabriele Mazzotta wrote me that new acpi devices could be=20
> created after commit faae404ebdc6bba (ACPICA: Add "Windows 2013"=20
> string to _OSI support).
>=20
> Maybe this another output could help you:
>=20
> $ cat /sys/bus/acpi/devices/INT33C5\:00/status
> 0
> $ cat /sys/bus/acpi/devices/INT33C5\:00/power_state
> (unknown)
>=20
> Device INT33C5 is in that dmesg log:
> acpi INT33C5:00: Cannot transition to non-D0 state from D3

The appended patch should make these messages go away, please test.

> And status 0 in sysnode could indicate that acpi device is not=20
> present right?

That's correct.

=2D--
 drivers/acpi/device_pm.c |    7 ++++---
 include/acpi/acpi_bus.h  |    3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -589,7 +589,8 @@ static inline u32 acpi_target_system_sta
=20
 static inline bool acpi_device_power_manageable(struct acpi_device *ad=
ev)
 {
=2D=09return adev->flags.power_manageable;
+=09return adev->flags.power_manageable
+=09=09&& (adev->status.present || adev->status.functional);
 }
=20
 static inline bool acpi_device_can_wakeup(struct acpi_device *adev)
Index: linux-pm/drivers/acpi/device_pm.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -68,7 +68,8 @@ int acpi_device_get_power(struct acpi_de
 {
 =09int result =3D ACPI_STATE_UNKNOWN;
=20
=2D=09if (!device || !state)
+=09if (!device || !state
+=09    || !(device->status.present || device->status.functional))
 =09=09return -EINVAL;
=20
 =09if (!device->flags.power_manageable) {
@@ -156,7 +157,7 @@ int acpi_device_set_power(struct acpi_de
 =09int result =3D 0;
 =09bool cut_power =3D false;
=20
=2D=09if (!device || !device->flags.power_manageable
+=09if (!device || !acpi_device_power_manageable(device)
 =09    || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
 =09=09return -EINVAL;
=20
@@ -361,7 +362,7 @@ bool acpi_bus_power_manageable(acpi_hand
 =09int result;
=20
 =09result =3D acpi_bus_get_device(handle, &device);
=2D=09return result ? false : device->flags.power_manageable;
+=09return result ? false : acpi_device_power_manageable(device);
 }
 EXPORT_SYMBOL(acpi_bus_power_manageable);
=20

--nextPart10465392.Boglpc3bMo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJUnxUmAAoJEILEb/54YlRxXZcP/RqBjLESb+ZgJK3pwB6uaL/R
UNz3bHMXjeNK6YPhT3yanUYTTBQjBoyZwxAT6UUjo/nG+eWDPyNM15zpMh4rQgIb
09Pf80khZ9wrk75agl3WUR7EKGOoHd2yPCXsuVQYD6LZvgGSAwsABPHkDh3rw8py
L25Fdar4H0O6mYCTVUTomYGI81/kagPw3VfdfHIdDIavD05nQbxsyL0dCGChn24+
tTV2lS7+/ih4/+TEYxbtqXfiIB6vD0448OQZh4X+ta91oHp04cQL+1Jm2jSrcgaf
C/GjQXwGOtJeLohW3Jsc7lowL9HbZUQ61qMhfFPdPkW1g9xPqVEdVCv5tDmOLeTi
msoc/564EBYt42KX85w74KxioQVuwtgpxUmOsCwiWr3MfrIaJhlmhmuL1uyy2Fjg
9YMMHdON6fv9wIE3ysV8jCnYfF+H9XrV6HjX9QZJd7wla3g9YmuUSC0xT82vJDGF
LZ4Ax01U0lswnLV7gfD1isTP3SKuSOB+kIzkfjZyiwe5/GfBhIMsCqhu7wlEhJFD
JGb4qFEzlIfiekQhA4BhA8BmzmvPg+By2peWa0zpBZ9u9Y5kBN0LXJ0lSN8jcPjC
194M4mF8pIUm74GMfxzxtMeJv+tuXRi1vBHgvfwxEcbSlAA6jjxFZmmQ1Ok9rl29
VKuU1VWsL7g/yKtvzJPc
=bGp0
-----END PGP SIGNATURE-----

--nextPart10465392.Boglpc3bMo--

