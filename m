Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaE0Aw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:52:58 -0400
Received: from ozlabs.org ([103.22.144.67]:58928 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaE0Aw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:52:57 -0400
Date: Tue, 27 May 2014 10:52:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20140527105248.546d95bf@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TUcNQml.hEsn0gockPuaN4W"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TUcNQml.hEsn0gockPuaN4W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-zynq/common.c between commit e1e4ccb5b1b6 ("ARM: l2c:
zynq: convert to generic l2c OF initialisation") from the arm tree and
commit 00f7dc636366 ("ARM: zynq: Add support for SOC_BUS") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-zynq/common.c
index d1e992e6403e,edbd9d83f407..000000000000
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@@ -66,8 -105,43 +105,38 @@@ static int __init zynq_get_revision(voi
  static void __init zynq_init_machine(void)
  {
  	struct platform_device_info devinfo =3D { .name =3D "cpufreq-cpu0", };
+ 	struct soc_device_attribute *soc_dev_attr;
+ 	struct soc_device *soc_dev;
+ 	struct device *parent =3D NULL;
+=20
 -	/*
 -	 * 64KB way size, 8-way associativity, parity disabled
 -	 */
 -	l2x0_of_init(0x02060000, 0xF0F0FFFF);
 -
+ 	soc_dev_attr =3D kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+ 	if (!soc_dev_attr)
+ 		goto out;
+=20
+ 	system_rev =3D zynq_get_revision();
+=20
+ 	soc_dev_attr->family =3D kasprintf(GFP_KERNEL, "Xilinx Zynq");
+ 	soc_dev_attr->revision =3D kasprintf(GFP_KERNEL, "0x%x", system_rev);
+ 	soc_dev_attr->soc_id =3D kasprintf(GFP_KERNEL, "0x%x",
+ 					 zynq_slcr_get_device_id());
+=20
+ 	soc_dev =3D soc_device_register(soc_dev_attr);
+ 	if (IS_ERR(soc_dev)) {
+ 		kfree(soc_dev_attr->family);
+ 		kfree(soc_dev_attr->revision);
+ 		kfree(soc_dev_attr->soc_id);
+ 		kfree(soc_dev_attr);
+ 		goto out;
+ 	}
+=20
+ 	parent =3D soc_device_to_device(soc_dev);
 =20
- 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+ out:
+ 	/*
+ 	 * Finished with the static registrations now; fill in the missing
+ 	 * devices
+ 	 */
+ 	of_platform_populate(NULL, of_default_bus_match_table, NULL, parent);
 =20
  	platform_device_register(&zynq_cpuidle_device);
  	platform_device_register_full(&devinfo);

--Sig_/TUcNQml.hEsn0gockPuaN4W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTg+HmAAoJEMDTa8Ir7ZwVqK0P/A5Vk/Ft3aSMj6VdsmsMs2Qf
JZ26anoTplDny0gX3k9voHFqkiYmphuV/hx+2LjrpgmuDb+0ALFmakBhCGqNf+i7
YfoLiFKFKytzOpflTEHV1R0n9PI68gbcOByKEx9AGpuM/eOoEmoFZSEZFLr9GcBO
v8YeCNN7OWNFRzCeG6SOvt5EATpQFPVLktrUV3CGYb2o7JiDfA/Za+0aeso2vJ6K
f5lWuPa4lPrXDukZPy/cA6Cf89LP8fl6mfpIRvygMJVgoRqjxTGNou7YtFqV62fv
Gq6mqdIxT1dEPhMgFFHXQkK24gAxEZ+eKPCmKlz4Xa7PexVxExFDNqwod7b9Uc91
vh6JIF/8Nr/cszlo6I7RwDnxlEVExF+JUr5OctusvMuc5kkA+SAG4XLqmUvmapzf
k/Bvyid1349WrW8rjYlxHAAdeCPRVMtHIPDy/4KpDho2CuBEa7omu1WMTBgCI6mP
CBinhogZ+yEnUgPZGmh0rZHEr6H1/VJWByZ85ZCpeegkr3G4zaQdzBGiDgbXsHxi
Cs4TQGQdvuH+WPDWTpojptcxov0KMTfyIeB0rBNtBNWp/PZSEpF96RSg5pt5wwa9
eSv5A5JAfPRun+2XQ0id+BQTYzOFrV7R5dLPs2a7eInUgP3d9BDY364TMLYmOa/6
vXrL+M/fJEqXm/9V0h9r
=w2uR
-----END PGP SIGNATURE-----

--Sig_/TUcNQml.hEsn0gockPuaN4W--
