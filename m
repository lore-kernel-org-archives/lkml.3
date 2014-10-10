Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaJJBKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 21:10:44 -0400
Received: from ozlabs.org ([103.22.144.67]:54508 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaJJBKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 21:10:42 -0400
Date: Fri, 10 Oct 2014 12:10:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sudip Mukherjee <sudip@vectorindia.org>, Aaron Lu <aaron.lu@intel.com>
Subject: linux-next: manual merge of the thermal tree with the pm tree
Message-ID: <20141010121033.38dc4d0e@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kxSB4sA3jG48E7o7NZMuVLz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kxSB4sA3jG48E7o7NZMuVLz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Zhang,

Today's linux-next merge of the thermal tree got a conflict in
drivers/acpi/fan.c between commit 88989fd26a74 ("ACPI / fan: printk
replacement") from the pm tree and commits 71532a58d2b0 ("ACPI / fan:
remove unused macro") and ff39c76855e8 ("ACPI / fan: convert to
platform driver") from the thermal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/fan.c
index 5328b1090e08,e007c4987bea..000000000000
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@@ -27,15 -27,11 +27,11 @@@
  #include <linux/module.h>
  #include <linux/init.h>
  #include <linux/types.h>
 -#include <asm/uaccess.h>
 +#include <linux/uaccess.h>
  #include <linux/thermal.h>
  #include <linux/acpi.h>
-=20
- #define ACPI_FAN_CLASS			"fan"
- #define ACPI_FAN_FILE_STATE		"state"
-=20
- #define _COMPONENT		ACPI_FAN_COMPONENT
- ACPI_MODULE_NAME("fan");
+ #include <linux/platform_device.h>
+ #include <linux/sort.h>
 =20
  MODULE_AUTHOR("Paul Diefenbaugh");
  MODULE_DESCRIPTION("ACPI Fan Driver");
@@@ -125,25 -221,128 +221,129 @@@ static const struct thermal_cooling_dev
  };
 =20
  /* ----------------------------------------------------------------------=
----
 -                                 Driver Interface
 -   ----------------------------------------------------------------------=
---- */
 + *                               Driver Interface
 + * ----------------------------------------------------------------------=
----
 +*/
 =20
- static int acpi_fan_add(struct acpi_device *device)
+ static bool acpi_fan_is_acpi4(struct acpi_device *device)
  {
- 	int result =3D 0;
- 	struct thermal_cooling_device *cdev;
+ 	return acpi_has_method(device->handle, "_FIF") &&
+ 	       acpi_has_method(device->handle, "_FPS") &&
+ 	       acpi_has_method(device->handle, "_FSL") &&
+ 	       acpi_has_method(device->handle, "_FST");
+ }
 =20
- 	if (!device)
- 		return -EINVAL;
+ static int acpi_fan_get_fif(struct acpi_device *device)
+ {
+ 	struct acpi_buffer buffer =3D { ACPI_ALLOCATE_BUFFER, NULL };
+ 	struct acpi_fan *fan =3D acpi_driver_data(device);
+ 	struct acpi_buffer format =3D { sizeof("NNNN"), "NNNN" };
+ 	struct acpi_buffer fif =3D { sizeof(fan->fif), &fan->fif };
+ 	union acpi_object *obj;
+ 	acpi_status status;
+=20
+ 	status =3D acpi_evaluate_object(device->handle, "_FIF", NULL, &buffer);
+ 	if (ACPI_FAILURE(status))
+ 		return status;
+=20
+ 	obj =3D buffer.pointer;
+ 	if (!obj || obj->type !=3D ACPI_TYPE_PACKAGE) {
+ 		dev_err(&device->dev, "Invalid _FIF data\n");
+ 		status =3D -EINVAL;
+ 		goto err;
+ 	}
 =20
- 	strcpy(acpi_device_name(device), "Fan");
- 	strcpy(acpi_device_class(device), ACPI_FAN_CLASS);
+ 	status =3D acpi_extract_package(obj, &format, &fif);
+ 	if (ACPI_FAILURE(status)) {
+ 		dev_err(&device->dev, "Invalid _FIF element\n");
+ 		status =3D -EINVAL;
+ 	}
 =20
- 	result =3D acpi_bus_update_power(device->handle, NULL);
- 	if (result) {
- 		dev_err(&device->dev, "Setting initial power state\n");
- 		goto end;
+ err:
+ 	kfree(obj);
+ 	return status;
+ }
+=20
+ static int acpi_fan_speed_cmp(const void *a, const void *b)
+ {
+ 	const struct acpi_fan_fps *fps1 =3D a;
+ 	const struct acpi_fan_fps *fps2 =3D b;
+ 	return fps1->speed - fps2->speed;
+ }
+=20
+ static int acpi_fan_get_fps(struct acpi_device *device)
+ {
+ 	struct acpi_fan *fan =3D acpi_driver_data(device);
+ 	struct acpi_buffer buffer =3D { ACPI_ALLOCATE_BUFFER, NULL };
+ 	union acpi_object *obj;
+ 	acpi_status status;
+ 	int i;
+=20
+ 	status =3D acpi_evaluate_object(device->handle, "_FPS", NULL, &buffer);
+ 	if (ACPI_FAILURE(status))
+ 		return status;
+=20
+ 	obj =3D buffer.pointer;
+ 	if (!obj || obj->type !=3D ACPI_TYPE_PACKAGE || obj->package.count < 2) {
+ 		dev_err(&device->dev, "Invalid _FPS data\n");
+ 		status =3D -EINVAL;
+ 		goto err;
+ 	}
+=20
+ 	fan->fps_count =3D obj->package.count - 1; /* minus revision field */
+ 	fan->fps =3D devm_kzalloc(&device->dev,
+ 				fan->fps_count * sizeof(struct acpi_fan_fps),
+ 				GFP_KERNEL);
+ 	if (!fan->fps) {
+ 		dev_err(&device->dev, "Not enough memory\n");
+ 		status =3D -ENOMEM;
+ 		goto err;
+ 	}
+ 	for (i =3D 0; i < fan->fps_count; i++) {
+ 		struct acpi_buffer format =3D { sizeof("NNNNN"), "NNNNN" };
+ 		struct acpi_buffer fps =3D { sizeof(fan->fps[i]), &fan->fps[i] };
+ 		status =3D acpi_extract_package(&obj->package.elements[i + 1],
+ 					      &format, &fps);
+ 		if (ACPI_FAILURE(status)) {
+ 			dev_err(&device->dev, "Invalid _FPS element\n");
+ 			break;
+ 		}
+ 	}
+=20
+ 	/* sort the state array according to fan speed in increase order */
+ 	sort(fan->fps, fan->fps_count, sizeof(*fan->fps),
+ 	     acpi_fan_speed_cmp, NULL);
+=20
+ err:
+ 	kfree(obj);
+ 	return status;
+ }
+=20
+ static int acpi_fan_probe(struct platform_device *pdev)
+ {
+ 	int result =3D 0;
+ 	struct thermal_cooling_device *cdev;
+ 	struct acpi_fan *fan;
+ 	struct acpi_device *device =3D ACPI_COMPANION(&pdev->dev);
+=20
+ 	fan =3D devm_kzalloc(&pdev->dev, sizeof(*fan), GFP_KERNEL);
+ 	if (!fan) {
+ 		dev_err(&device->dev, "No memory for fan\n");
+ 		return -ENOMEM;
+ 	}
+ 	device->driver_data =3D fan;
+ 	platform_set_drvdata(pdev, fan);
+=20
+ 	if (acpi_fan_is_acpi4(device)) {
+ 		if (acpi_fan_get_fif(device) || acpi_fan_get_fps(device))
+ 			goto end;
+ 		fan->acpi4 =3D true;
+ 	} else {
+ 		result =3D acpi_device_update_power(device, NULL);
+ 		if (result) {
+ 			dev_err(&device->dev, "Setting initial power state\n");
+ 			goto end;
+ 		}
  	}
 =20
  	cdev =3D thermal_cooling_device_register("Fan", device,

--Sig_/kxSB4sA3jG48E7o7NZMuVLz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUNzIPAAoJEMDTa8Ir7ZwVp/AP/38WKYFofaOoWWE6IQ3rfyIh
NPpK57eLvEn21DX9FGruiQC0HEEsvc9Or9G/Aa4jDu69rclpcuu2n+OBeHT595bx
fYPoT60l2r6dSAQ6vjD53LFCpfw4e9IJga97zA94iqbHNnsazJNadtMlaK/+zP3b
aBk2PmwXKBMnodZFEKMILAIUFV08G4A/R+4bfpgex4X45h+Egs6GuAv15EfJe3M5
D1uIksdDDNH+0OdoBczABPhH3Ued+/Ixb6vgj+hMf9EEL3HlAWpMckDNhnehxr9s
+LWizauilhxaaLzHI5r4HkxsR2+RGnOH2VETr0/fRHwvIrNLrINS9D/PNEDnSzQj
p0Kk6caea4vg2s+wXP5VjzThn6EHMf0LRVyIYhU8TDp1eq407q8MEewFcRTyzfs1
sx3apQMActdaQDKSvTZgE5KfwPTTB+zyIIcGjQGs2QzwX4GGkZ4OCEKgJosVXzot
dzurDiGfsuL5180cKjhdaRO/c2L/xmvcuWzIiCZN+OJaeqwQERG7CNRUxm3vcT27
yb/zJ/PuzOUKo7oAxVzaz7T3mi7VyAwm+9EJTu9tD9uFEwT3K6eYPMwPPr5aHRld
4lTSEKgXaomuT5Q4EbBRY1wPZtRoEXykt9AY6rar4qLxNTgDQw3jdjTzjmvZ1Fk3
2Pzh7U3aE5MNxpdsQ98h
=CKZp
-----END PGP SIGNATURE-----

--Sig_/kxSB4sA3jG48E7o7NZMuVLz--
