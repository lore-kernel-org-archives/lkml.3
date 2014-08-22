Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbaHVSAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:00:04 -0400
Received: from server102.greatnet.de ([83.133.97.2]:39725 "EHLO
	server102.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaHVSAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:00:01 -0400
Message-ID: <53F78516.3040607@mageta.org>
Date: Fri, 22 Aug 2014 19:59:50 +0200
From: Benjamin Block <bebl@mageta.org>
Reply-To: bebl@mageta.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lan Tianyu <tianyu.lan@intel.com>
CC: lenb@kernel.org, davem@davemloft.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Run fixed button devices' notify callback in the
 process context
References: <1408693091-16268-1-git-send-email-tianyu.lan@intel.com> <3313221.quKCYo2xmm@vostro.rjw.lan>
In-Reply-To: <3313221.quKCYo2xmm@vostro.rjw.lan>
OpenPGP: url=http://mageta.org/pgp/bblock.private.asc
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jcnP2A9R7oLCVKLLsxCrieJLxfXGKbBUw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jcnP2A9R7oLCVKLLsxCrieJLxfXGKbBUw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/22/2014 07:33 PM, Rafael J. Wysocki wrote:
> On Friday, August 22, 2014 03:37:55 PM Lan Tianyu wrote:
>> Currently fixed button devices' notify callbacks are running in the
>> interrupt context. It's not necessary and prevent calling functions
>> with mutex lock(E,G evaluating ACPI method). Otherwise, it's different=

>> with non-fixed button device whose notify callback is running in the p=
rocess
>> context. This patch is to make fixed button device's notify
>> callback in the process context and this also can avoid dead lock
>> when using netlink to report button event to user space.
>=20
> I guess this is the main reason for the patch?
>=20
> Is there a bug report regarding this?
>

There is: https://lkml.org/lkml/2014/8/21/606

>=20
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> ---
>>  drivers/acpi/scan.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
>> index 0a817ad..bfb7fc5 100644
>> --- a/drivers/acpi/scan.c
>> +++ b/drivers/acpi/scan.c
>> @@ -922,12 +922,17 @@ static void acpi_device_notify(acpi_handle handl=
e, u32 event, void *data)
>>  	device->driver->ops.notify(device, event);
>>  }
>> =20
>> -static acpi_status acpi_device_notify_fixed(void *data)
>> +static void acpi_device_notify_fixed_run(void *data)
>>  {
>>  	struct acpi_device *device =3D data;
>> =20
>> -	/* Fixed hardware devices have no handles */
>>  	acpi_device_notify(NULL, ACPI_FIXED_HARDWARE_EVENT, device);
>> +}
>> +
>> +static acpi_status acpi_device_notify_fixed(void *data)
>> +{
>> +	/* Fixed hardware devices have no handles */
>> +	acpi_os_execute(OSL_NOTIFY_HANDLER, acpi_device_notify_fixed_run, da=
ta);
>>  	return AE_OK;
>>  }
>> =20
>>
>=20



--jcnP2A9R7oLCVKLLsxCrieJLxfXGKbBUw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQGcBAEBAgAGBQJT94UeAAoJEEbgTgVnoy6ea8sL/0/hY3daEZsVMmpSn9aIK/Bg
1UnOQJDHl+7h8nGnzGzVBHyJRl3effw3YVK3y3MnB5q26OJxrurdO3ztLeWfO2gz
apGhOxvbikMq6C0nBAululJ1mdA2kUX79fa8jQbuDfyRMr/1QfLXEH/6Ad3UneTa
1Y3xl1eOsZPgDJnnIr9JLth2fZ3eNez8xG0zzMmUn7rERbQG+b3SreiTcs2SEVd9
LZ9Wip6KXMrnX3loh0dvbb1s9d9u0WJdJZ/J/oMlXxIC1PFRLSJsXfpDyQ0A5v4f
qoKhSSKX2hiH3lPLC/RJhBRIUMAwcE/wEQVoU5VW0OGhy89Lyv92d+10UjIV/lke
N2T0GsW5CW3kE547U4DDPhiFolMZYfMcuMaJ/Jer2E2Wt7gtuiZxc+axfUFaRKCB
E26OD6qngul6D3WffbGFizLiobh6bslDsgg7Qb0lVItgwRYzTIVzckFrDVGIWez6
85YtreuS/pYjd+2NQCX9zHugMMSz2zTVMII5dI4zSg==
=/aBT
-----END PGP SIGNATURE-----

--jcnP2A9R7oLCVKLLsxCrieJLxfXGKbBUw--
