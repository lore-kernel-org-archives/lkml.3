Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935283Ab3BOBXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 20:23:24 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52120 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab3BOBXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 20:23:22 -0500
Date: Fri, 15 Feb 2013 12:23:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: linux-next: manual merge of the pm tree with the pci tree
Message-Id: <20130215122313.19a651c33ef3bb60c0f3d827@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Feb_2013_12_23_13_+1100_EUh5.gf3darh=Fcu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2013_12_23_13_+1100_EUh5.gf3darh=Fcu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got conflicts in
drivers/acpi/scan.c and drivers/pci/hotplug/acpiphp_glue.c between
commits 668192b67820 ("PCI: acpiphp: Move host bridge hotplug to
pci_root.c") and be6d2867b4f6 ("PCI: acpiphp: Remove dead code for PCI
host bridge hotplug") from the pci tree and commit 3757b94802fb ("ACPI /
hotplug: Fix concurrency issues and memory leaks") from the pm tree.

I fixed it up (thanks to Yinghai Lu for the resolution - see below) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/scan.c
index a363f87,daee749..0000000
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@@ -1707,7 -1804,7 +1804,9 @@@ int __init acpi_scan_init(void
 =20
  	acpi_update_all_gpes();
 =20
 +	acpi_pci_root_hp_init();
 +
- 	return 0;
+  out:
+ 	mutex_unlock(&acpi_scan_lock);
+ 	return result;
  }
diff --cc drivers/pci/hotplug/acpiphp_glue.c
index 4681d2c,a951c22..0000000
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@@ -1136,11 -1214,29 +1132,13 @@@ static void _handle_hotplug_event_bridg
  	acpi_handle handle;
  	u32 type;
 =20
 -	hp_work =3D container_of(work, struct acpiphp_hp_work, work);
 +	hp_work =3D container_of(work, struct acpi_hp_work, work);
  	handle =3D hp_work->handle;
  	type =3D hp_work->type;
 +	bridge =3D (struct acpiphp_bridge *)hp_work->context;
 =20
+ 	acpi_scan_lock_acquire();
+=20
 -	if (acpi_bus_get_device(handle, &device)) {
 -		/* This bridge must have just been physically inserted */
 -		handle_bridge_insertion(handle, type);
 -		goto out;
 -	}
 -
 -	bridge =3D acpiphp_handle_to_bridge(handle);
 -	if (type =3D=3D ACPI_NOTIFY_BUS_CHECK) {
 -		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, ACPI_UINT32_MAX,
 -			count_sub_bridges, NULL, &num_sub_bridges, NULL);
 -	}
 -
 -	if (!bridge && !num_sub_bridges) {
 -		err("cannot get bridge info\n");
 -		goto out;
 -	}
 -
  	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 =20
  	switch (type) {
@@@ -1195,6 -1296,8 +1193,7 @@@
  		break;
  	}
 =20
 -out:
+ 	acpi_scan_lock_release();
  	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
  }
 =20
@@@ -1237,6 -1342,10 +1236,8 @@@ static void _handle_hotplug_event_func(
 =20
  	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 =20
 -	func =3D (struct acpiphp_func *)context;
 -
+ 	acpi_scan_lock_acquire();
+=20
  	switch (type) {
  	case ACPI_NOTIFY_BUS_CHECK:
  		/* bus re-enumerate */

--Signature=_Fri__15_Feb_2013_12_23_13_+1100_EUh5.gf3darh=Fcu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHY4BAAoJEECxmPOUX5FElA0P/RLvuRoPwHfJpdDCM6mha+Op
/tZoz8xChDIOUy/ijT14NazORuvQFR7CyVol5VnAPlhKlOO4bkLzGolbE72KMSX0
tPpPq9M2Ma/UN6JhLLgeqP3VcPqLFIK44M0mF2Ud+eG4cTv4I2sc1I/27pFCiaSi
EHs4UY224G8bou1MCP2LeqZyEbbMjueqaIT4Cyp7NW6iCFtm/0x7saE2Xy6r7fN+
pyD8+PvWyesQG/rmDgR9Mdqt/XI6avA0xQULmQKr91eaIAAjpdGAtyj5ZzYZe0Pc
+CGetGeI9xwHWE8VjFiKp9TNZnxuNly65SNhkLaMDN3fGT7NFjQ0Z7gYFZIGt4wt
B9t0WM3Q0h6fqtQGHx09wfv4QdVT8pQYOyxpebmCdL4eTmE3V5gxacs+uG9VNkuu
AWTSqUKW5O/6VNMstXazuCXoDSLTeN3Q8BmcReCrHw/WQwQ2g0Z+qd02sioTILnX
TrTmBNwy3khBYBjlqwZvG3RKfL4RAhQLB9OsLfZuXLDg5RwpApJPjo1Fu9hhHpcC
Vn73yR4IH+t2We/PUBtKK8BWc0MjgqaqU8ZHkGiLCMCZ0tf0RNB0Qz5FSEXsp9CF
3cS+1yxHuKpjCCnjYqLh+meOhRZNlw2inz0RF3fyepPXbJOBiY3fDFxsHsRlyUhx
HnOyzTtvvvmFLu+Tq8f7
=pB2J
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2013_12_23_13_+1100_EUh5.gf3darh=Fcu--
