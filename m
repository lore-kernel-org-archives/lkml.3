Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164Ab3EACG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 22:06:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34366 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934003Ab3EACGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 22:06:49 -0400
Date: Wed, 1 May 2013 12:06:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the vfs tree with the powerpc tree
Message-Id: <20130501120636.0e54681b2dfb7ebe6aeb27c4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__1_May_2013_12_06_36_+1000_XYNZNJPro60xXbfT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_May_2013_12_06_36_+1000_XYNZNJPro60xXbfT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
arch/powerpc/kernel/rtas_flash.c between commit fb4696c39573
("powerpc/rtas_flash: Fix bad memory access") from the powerpc tree and
commits ad18a364f186 ("powerpc/rtas_flash: Free kmem upon module exit")
and 2352ad01409d ("ppc: Clean up rtas_flash driver somewhat") from the
vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/kernel/rtas_flash.c
index 243e184,5b77026..0000000
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@@ -310,9 -316,9 +328,9 @@@ static ssize_t rtas_flash_write(struct=20
  	 * proc file
  	 */
  	if (uf->flist =3D=3D NULL) {
 -		uf->flist =3D kmem_cache_alloc(flash_block_cache, GFP_KERNEL);
 +		uf->flist =3D kmem_cache_zalloc(flash_block_cache, GFP_KERNEL);
  		if (!uf->flist)
- 			return -ENOMEM;
+ 			goto nomem;
  	}
 =20
  	fl =3D uf->flist;
@@@ -321,18 -327,18 +339,18 @@@
  	next_free =3D fl->num_blocks;
  	if (next_free =3D=3D FLASH_BLOCKS_PER_NODE) {
  		/* Need to allocate another block_list */
 -		fl->next =3D kmem_cache_alloc(flash_block_cache, GFP_KERNEL);
 +		fl->next =3D kmem_cache_zalloc(flash_block_cache, GFP_KERNEL);
  		if (!fl->next)
- 			return -ENOMEM;
+ 			goto nomem;
  		fl =3D fl->next;
  		next_free =3D 0;
  	}
 =20
  	if (count > RTAS_BLK_SIZE)
  		count =3D RTAS_BLK_SIZE;
 -	p =3D kmem_cache_alloc(flash_block_cache, GFP_KERNEL);
 +	p =3D kmem_cache_zalloc(flash_block_cache, GFP_KERNEL);
  	if (!p)
- 		return -ENOMEM;
+ 		goto nomem;
  =09
  	if(copy_from_user(p, buffer, count)) {
  		kmem_cache_free(flash_block_cache, p);
@@@ -722,65 -694,13 +706,13 @@@ static int __init rtas_flash_init(void
  		return 1;
  	}
 =20
- 	firmware_flash_pde =3D create_flash_pde("powerpc/rtas/"
- 					      FIRMWARE_FLASH_NAME,
- 					      &rtas_flash_operations);
- 	if (firmware_flash_pde =3D=3D NULL) {
- 		rc =3D -ENOMEM;
- 		goto cleanup;
- 	}
-=20
- 	rc =3D initialize_flash_pde_data("ibm,update-flash-64-and-reboot",
- 			 	       sizeof(struct rtas_update_flash_t),=20
- 				       firmware_flash_pde);
- 	if (rc !=3D 0)
- 		goto cleanup;
-=20
- 	firmware_update_pde =3D create_flash_pde("powerpc/rtas/"
- 					       FIRMWARE_UPDATE_NAME,
- 					       &rtas_flash_operations);
- 	if (firmware_update_pde =3D=3D NULL) {
- 		rc =3D -ENOMEM;
- 		goto cleanup;
- 	}
-=20
- 	rc =3D initialize_flash_pde_data("ibm,update-flash-64-and-reboot",
- 			 	       sizeof(struct rtas_update_flash_t),=20
- 				       firmware_update_pde);
- 	if (rc !=3D 0)
- 		goto cleanup;
-=20
- 	validate_pde =3D create_flash_pde("powerpc/rtas/" VALIDATE_FLASH_NAME,
- 			      		&validate_flash_operations);
- 	if (validate_pde =3D=3D NULL) {
- 		rc =3D -ENOMEM;
- 		goto cleanup;
- 	}
-=20
- 	rc =3D initialize_flash_pde_data("ibm,validate-flash-image",
- 		                       sizeof(struct rtas_validate_flash_t),=20
- 				       validate_pde);
- 	if (rc !=3D 0)
- 		goto cleanup;
-=20
- 	manage_pde =3D create_flash_pde("powerpc/rtas/" MANAGE_FLASH_NAME,
- 				      &manage_flash_operations);
- 	if (manage_pde =3D=3D NULL) {
- 		rc =3D -ENOMEM;
- 		goto cleanup;
- 	}
-=20
- 	rc =3D initialize_flash_pde_data("ibm,manage-flash-image",
- 			               sizeof(struct rtas_manage_flash_t),
- 				       manage_pde);
- 	if (rc !=3D 0)
- 		goto cleanup;
-=20
- 	rtas_flash_term_hook =3D rtas_flash_firmware;
+ 	rtas_validate_flash_data.buf =3D kzalloc(VALIDATE_BUF_SIZE, GFP_KERNEL);
+ 	if (!rtas_validate_flash_data.buf)
+ 		return -ENOMEM;
 =20
  	flash_block_cache =3D kmem_cache_create("rtas_flash_cache",
 -					      RTAS_BLK_SIZE, RTAS_BLK_SIZE, 0,
 -					      rtas_block_ctor);
 +				RTAS_BLK_SIZE, RTAS_BLK_SIZE, 0,
 +				NULL);
  	if (!flash_block_cache) {
  		printk(KERN_ERR "%s: failed to create block cache\n",
  				__func__);
@@@ -800,20 -742,17 +754,22 @@@ enomem_buf
 =20
  static void __exit rtas_flash_cleanup(void)
  {
+ 	int i;
+=20
  	rtas_flash_term_hook =3D NULL;
 =20
 +	if (rtas_firmware_flash_list) {
 +		free_flash_list(rtas_firmware_flash_list);
 +		rtas_firmware_flash_list =3D NULL;
 +	}
 +
- 	if (flash_block_cache)
- 		kmem_cache_destroy(flash_block_cache);
+ 	for (i =3D 0; i < ARRAY_SIZE(rtas_flash_files); i++) {
+ 		const struct rtas_flash_file *f =3D &rtas_flash_files[i];
+ 		remove_proc_entry(f->filename, NULL);
+ 	}
 =20
- 	remove_flash_pde(firmware_flash_pde);
- 	remove_flash_pde(firmware_update_pde);
- 	remove_flash_pde(validate_pde);
- 	remove_flash_pde(manage_pde);
+ 	kmem_cache_destroy(flash_block_cache);
+ 	kfree(rtas_validate_flash_data.buf);
  }
 =20
  module_init(rtas_flash_init);

--Signature=_Wed__1_May_2013_12_06_36_+1000_XYNZNJPro60xXbfT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgHisAAoJEECxmPOUX5FEjEQP/iXqmm1eo+FfSL6lbQrwpO69
kfKyhQyB1fqd4IU1ZBcpnlClBMCcQlx4qIr8ox0M+fnhdaqXMgjwkeRJU1QtfDif
FLBLPH4awi+DqODSXtUcL1zRSOfVW3GVhvFylYeXx2v9HpFHsw6irREZMrcLGWOF
NpyXiWJjMsQOJYVYKjpdlsw+Z4nBURuPg1ddz1WwPNN1pqMUrS7r974Q+21l8C6j
23FMqJWbMK21U0IeWORpKNpT8Q/vyXRK89EnIv20YUNGU2oRFPI+6AQDcIHW4dqb
MpS4QxqkaNT2Jl6rNMZfFGXEuLfoD8r7xnjumoyBohgTPCl/W476sBfjYM0pmhQ0
y1MwLC8doGN3LQAzH1tGWaYm4leYMDwFq3k7gqOIj8BkAOOUWx7vZXHrFLzrTCr1
az1JRF7Ibbfb+MN8V5U+CtWxueIksrmhLxDV+RsJ1P/AaFqVZFa+Wv0B2pXhhkJ4
z0AK5NUXUuaAIRMtJY+dkwp3BtnPgpSxq3jh24Uts1ton6ls7WaZaMBdTw+s5QAe
V0V58JX6vi28khfNTYoKFUBSh6XPZYkLqZRyFwHWhd12ChTKeEZzyku+BlydDg1B
wYwRPRwGT/b6gB3V3Z0NjTIGM+59c284Cks5ULGXpkcbqskaBSRcz7rRsVcYLrCB
rfqXo/KJ2zgpWv5PPJXl
=iJ+g
-----END PGP SIGNATURE-----

--Signature=_Wed__1_May_2013_12_06_36_+1000_XYNZNJPro60xXbfT--
