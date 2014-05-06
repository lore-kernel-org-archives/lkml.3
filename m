Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017AbaEFGC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:02:29 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63289 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933851AbaEFGC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:02:27 -0400
Message-ID: <53687AE9.4010604@linux.com>
Date: Tue, 06 May 2014 08:02:17 +0200
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux ATA/IDE <linux-ide@vger.kernel.org>,
        Joe Thomas <Joe.Thomas@dothill.com>
Subject: Re: [PATCH] ahci: unregister acpi notify handler when a ZPODD is
 unbound
References: <1398873887-23920-1-git-send-email-levex@linux.com> <536853F5.7040107@intel.com>
In-Reply-To: <536853F5.7040107@intel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="02tvhI86JLUief2X4wM8rP771e01Wf1wp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--02tvhI86JLUief2X4wM8rP771e01Wf1wp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 05/06/2014 05:16 AM, Aaron Lu wrote:
> On 05/01/2014 12:04 AM, Levente Kurusa wrote:
>> When a ZPODD device is unbound via sysfs, the acpi notify handler
>> is not removed. This causes panics as observed in Bug #74601. The
>=20
> Ah...too bad, I forgot to consider this situation, thanks for tracking
> this.
>=20
>> panic only happens when the wake happens from outside the kernel
>> (i.e. inserting media or pressing a button). Implement a new
>> ahci_remove_one function which causes zpodd_exit to be called for all
>> ZPODD devices on the unbound PCI device.
>>
>> Signed-off-by: Levente Kurusa <levex@linux.com>
>> ---
>>
>> Hi,
>>
>> I am not sure if the loop below is correct. Maybe there is a better
>> solution to loop through all the devices which might use ZPODD?
>=20
> I didn't find a proper place either. For hotplug, we did the zpodd_exit=

> at ata_scsi_handle_link_detach. But for host controller pci device
> removal, we used scsi_remove_host in ata_port_detach and there is no
> place to add the zpodd_exit for a to-be-removed scsi device...
>=20
> Looks like we can only iterate the ata devices and call zpodd_exit
> explicitly for them if they are zpodd devices. Instead of adding a new
> remove callback, what about just embed that into the ata_port_detach
> like the following example?

Yes, this makes more sense as this doesn't tinker with exports and such..=
=2E
However this will throw unused variable compiler warnings if we add the
required #ifdefs... Maybe a new function? ata_zpodd_detach_port?

>=20
>=20
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 943cc8b83e59..43652da6fea6 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -6314,6 +6314,8 @@ int ata_host_activate(struct ata_host *host, int =
irq,
>  static void ata_port_detach(struct ata_port *ap)
>  {
>  	unsigned long flags;
> +	struct ata_link *link;
> +	struct ata_device *dev;
> =20
>  	if (!ap->ops->error_handler)
>  		goto skip_eh;
> @@ -6333,6 +6335,13 @@ static void ata_port_detach(struct ata_port *ap)=

>  	cancel_delayed_work_sync(&ap->hotplug_task);
> =20
>   skip_eh:
> +	/* clean up zpodd related stuffs on port removal */
> +	ata_for_each_link(link, ap, HOST_FIRST) {
> +		ata_for_each_dev(dev, link, ALL) {
> +			if (zpodd_dev_enabled(dev))
> +				zpodd_exit(dev);
> +		}
> +	}
>  	if (ap->pmp_link) {
>  		int i;
>  		for (i =3D 0; i < SATA_PMP_MAX_PORTS; i++)

--=20
Regards,
Levente Kurusa
PGP: 4EF5D641


--02tvhI86JLUief2X4wM8rP771e01Wf1wp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTaHrqAAoJELBqK2lO9dZBjlEH+wXJ6h0T65PrkYJoeet1hRNU
W1M9pkbcuzHT7jMFwcUgmOEnC+KBYpT6aMJ/swgopoC6eF0wFUpPQ5uz3yzC+fo5
m2UdozPx1OYMQFxMrdd2l/H+vT4YccjG4tvwnmkisHfr+aVgfJ6seq1MEE7aWx0U
HJWMt5jlO401oJINxclTnBITbOquclKI6NHjrqkkX6U++5KA90E6YJ4gx1ClTju3
hUmaw2epKKTlKjKmvkPZ9tJahAPu1We91xotYDAcNLyi1evnqY7fUszE253tutI8
UYPyHPf7XgIhfu09wdTvRIl7PCtJTgi8S4+NQZHd/vNARxwtorc+7+3aOy0ZnDM=
=6tFV
-----END PGP SIGNATURE-----

--02tvhI86JLUief2X4wM8rP771e01Wf1wp--
