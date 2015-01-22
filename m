Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbbAVCXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:23:08 -0500
Received: from ozlabs.org ([103.22.144.67]:54474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbbAVCW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:22:56 -0500
Date: Thu, 22 Jan 2015 13:22:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Goz <ben.goz@amd.com>, Oded Gabbay <oded.gabbay@amd.com>
Subject: linux-next: manual merge of the drm tree with Linus'  tree
Message-ID: <20150122132249.28ffba12@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/W.Y7KVCxNXnbYT5uAYTl0iv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/W.Y7KVCxNXnbYT5uAYTl0iv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/radeon/radeon_kfd.c between commit b64b8afcca9d
("drm/amd: Fixing typos in kfd<->kgd interface") from Linus'  tree and
commit a84a9903b588 ("drm/radeon: Implement SDMA interface functions")
from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/radeon/radeon_kfd.c
index 8bf87f1203cc,cae11eefecf0..000000000000
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@@ -71,8 -70,8 +70,8 @@@ static int kgd_init_pipeline(struct kgd
 =20
  static int kgd_hqd_load(struct kgd_dev *kgd, void *mqd, uint32_t pipe_id,
  			uint32_t queue_id, uint32_t __user *wptr);
-=20
+ static int kgd_hqd_sdma_load(struct kgd_dev *kgd, void *mqd);
 -static bool kgd_hqd_is_occupies(struct kgd_dev *kgd, uint64_t queue_addre=
ss,
 +static bool kgd_hqd_is_occupied(struct kgd_dev *kgd, uint64_t queue_addre=
ss,
  				uint32_t pipe_id, uint32_t queue_id);
 =20
  static int kgd_hqd_destroy(struct kgd_dev *kgd, uint32_t reset_type,
@@@ -92,8 -92,11 +92,11 @@@ static const struct kfd2kgd_calls kfd2k
  	.init_memory =3D kgd_init_memory,
  	.init_pipeline =3D kgd_init_pipeline,
  	.hqd_load =3D kgd_hqd_load,
+ 	.hqd_sdma_load =3D kgd_hqd_sdma_load,
 -	.hqd_is_occupies =3D kgd_hqd_is_occupies,
 +	.hqd_is_occupied =3D kgd_hqd_is_occupied,
+ 	.hqd_sdma_is_occupied =3D kgd_hqd_sdma_is_occupied,
  	.hqd_destroy =3D kgd_hqd_destroy,
+ 	.hqd_sdma_destroy =3D kgd_hqd_sdma_destroy,
  	.get_fw_version =3D get_fw_version
  };
 =20
@@@ -533,7 -528,46 +544,46 @@@ static int kgd_hqd_load(struct kgd_dev=20
  	return 0;
  }
 =20
+ static int kgd_hqd_sdma_load(struct kgd_dev *kgd, void *mqd)
+ {
+ 	struct cik_sdma_rlc_registers *m;
+ 	uint32_t sdma_base_addr;
+=20
+ 	m =3D get_sdma_mqd(mqd);
+ 	sdma_base_addr =3D get_sdma_base_addr(m);
+=20
+ 	write_register(kgd,
+ 			sdma_base_addr + SDMA0_RLC0_VIRTUAL_ADDR,
+ 			m->sdma_rlc_virtual_addr);
+=20
+ 	write_register(kgd,
+ 			sdma_base_addr + SDMA0_RLC0_RB_BASE,
+ 			m->sdma_rlc_rb_base);
+=20
+ 	write_register(kgd,
+ 			sdma_base_addr + SDMA0_RLC0_RB_BASE_HI,
+ 			m->sdma_rlc_rb_base_hi);
+=20
+ 	write_register(kgd,
+ 			sdma_base_addr + SDMA0_RLC0_RB_RPTR_ADDR_LO,
+ 			m->sdma_rlc_rb_rptr_addr_lo);
+=20
+ 	write_register(kgd,
+ 			sdma_base_addr + SDMA0_RLC0_RB_RPTR_ADDR_HI,
+ 			m->sdma_rlc_rb_rptr_addr_hi);
+=20
+ 	write_register(kgd,
+ 			sdma_base_addr + SDMA0_RLC0_DOORBELL,
+ 			m->sdma_rlc_doorbell);
+=20
+ 	write_register(kgd,
+ 			sdma_base_addr + SDMA0_RLC0_RB_CNTL,
+ 			m->sdma_rlc_rb_cntl);
+=20
+ 	return 0;
+ }
+=20
 -static bool kgd_hqd_is_occupies(struct kgd_dev *kgd, uint64_t queue_addre=
ss,
 +static bool kgd_hqd_is_occupied(struct kgd_dev *kgd, uint64_t queue_addre=
ss,
  				uint32_t pipe_id, uint32_t queue_id)
  {
  	uint32_t act;

--Sig_/W.Y7KVCxNXnbYT5uAYTl0iv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwF7+AAoJEMDTa8Ir7ZwVFRQQAIxdHRuq0dIQJs+wF58WiQJy
luGf1AY7H2ER7GJLjByJ+VzF6hzr2pGd/1QEQW5dwJgogMLpTiNUcYukCfc+f7tT
tDKt92SYGpfYPCzKM7f6v1jT3bMM6mfy36FxCHRQdJovMxWZRQv1QOodJJv81VRM
BWvAEKhzeyX4UzZ9uIddER+UDQoSUjLcJkFz+F7H5TSPemnZJPEoDHZaTvrh+EJN
CB6zu0YsJkqqzzWoitJLl+9+iewNe2DaVIgbWQAy/MtGuRXvRMSgaFng5F9jZbr8
K1X/bnmEP90EPsleb+tFVDEaTAMc141ivUi3NSNM0H3Clf0vYqFj8Hz2DNtMT24+
cPkOgqJhcTJ6F5XG4mXbMIsUZdayV4ACGAfW7h8X/+q+yN0zXVcepp+7ANj4Jvhx
4H2Id3EH4/GIse1P2ndKJUKKFeW1XZPiGU61chxYdq0/6/6F/FviVoa0bsMnjg1i
JoahH2GZbmXBLsyWQvr1uUgoXf1Jdj7bfJVuxksotNMaFCAM0JaFDLfYbxPkc9yB
QiseQC0OjVR2wdqXPzQm/YuK+Hj3gj7DPI9pk+4yHFTLD/uC7A4sOin9NoMPRjol
JYcAVu/Vc46532DGPJHW5+HNqoBvf6P15C+cNexTbglQuTI+YXwgRbiuDlLyeTf4
Q3bMo5iyd389ekiOdEiF
=qmvo
-----END PGP SIGNATURE-----

--Sig_/W.Y7KVCxNXnbYT5uAYTl0iv--
