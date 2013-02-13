Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab3BMEtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 23:49:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50679 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab3BMEtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 23:49:11 -0500
Date: Wed, 13 Feb 2013 15:48:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20130213154859.8cc81206f401e6f30e673178@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Feb_2013_15_48_59_+1100_cdRDlN=r/zHREkzm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Feb_2013_15_48_59_+1100_cdRDlN=r/zHREkzm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/radeon/evergreen_cs.c between commit de0babd60d8d
("drm/radeon: enforce use of radeon_get_ib_value when reading user cmd")
from Linus' tree and commit 0fcb6155cb5c ("radeon/kms: cleanup async dma
packet checking") from the drm tree.

I fixed it up (I think (I did it fairly mechanically) - see below) and
can carry the fix as necessary (no action is required - but it might be
worth doing this merge yourself before asking Linus to pull - you could
just *merge* the above commit from Linus' tree (or the head of the branch
that Linus merged)).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/radeon/evergreen_cs.c
index ee4cff5,d8f5d5f..0000000
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@@ -2908,15 -2708,19 +2708,19 @@@ int evergreen_dma_cs_parse(struct radeo
  				DRM_ERROR("bad DMA_PACKET_WRITE\n");
  				return -EINVAL;
  			}
- 			if (tiled) {
+ 			switch (sub_cmd) {
+ 			/* tiled */
+ 			case 8:
 -				dst_offset =3D ib[idx+1];
 +				dst_offset =3D radeon_get_ib_value(p, idx+1);
  				dst_offset <<=3D 8;
 =20
  				ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
  				p->idx +=3D count + 7;
- 			} else {
+ 				break;
+ 			/* linear */
+ 			case 0:
 -				dst_offset =3D ib[idx+1];
 -				dst_offset |=3D ((u64)(ib[idx+2] & 0xff)) << 32;
 +				dst_offset =3D radeon_get_ib_value(p, idx+1);
 +				dst_offset |=3D ((u64)(radeon_get_ib_value(p, idx+2) & 0xff)) << 32;
 =20
  				ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
  				ib[idx+2] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
@@@ -2939,338 -2747,330 +2747,330 @@@
  				DRM_ERROR("bad DMA_PACKET_COPY\n");
  				return -EINVAL;
  			}
- 			if (tiled) {
- 				idx_value =3D radeon_get_ib_value(p, idx + 2);
- 				if (new_cmd) {
- 					switch (misc) {
- 					case 0:
- 						/* L2T, frame to fields */
- 						if (idx_value & (1 << 31)) {
- 							DRM_ERROR("bad L2T, frame to fields DMA_PACKET_COPY\n");
- 							return -EINVAL;
- 						}
- 						r =3D r600_dma_cs_next_reloc(p, &dst2_reloc);
- 						if (r) {
- 							DRM_ERROR("bad L2T, frame to fields DMA_PACKET_COPY\n");
- 							return -EINVAL;
- 						}
- 						dst_offset =3D radeon_get_ib_value(p, idx+1);
- 						dst_offset <<=3D 8;
- 						dst2_offset =3D radeon_get_ib_value(p, idx+2);
- 						dst2_offset <<=3D 8;
- 						src_offset =3D radeon_get_ib_value(p, idx+8);
- 						src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+9) & 0xff)) << 32;
- 						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2T, frame to fields src buffer too small (%=
llu %lu)\n",
- 								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
- 							return -EINVAL;
- 						}
- 						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2T, frame to fields buffer too small (%llu =
%lu)\n",
- 								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
- 							return -EINVAL;
- 						}
- 						if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj))=
 {
- 							dev_warn(p->dev, "DMA L2T, frame to fields buffer too small (%llu =
%lu)\n",
- 								 dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
- 							return -EINVAL;
- 						}
- 						ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
- 						ib[idx+2] +=3D (u32)(dst2_reloc->lobj.gpu_offset >> 8);
- 						ib[idx+8] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
- 						ib[idx+9] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
- 						p->idx +=3D 10;
- 						break;
- 					case 1:
- 						/* L2T, T2L partial */
- 						if (p->family < CHIP_CAYMAN) {
- 							DRM_ERROR("L2T, T2L Partial is cayman only !\n");
- 							return -EINVAL;
- 						}
- 						/* detile bit */
- 						if (idx_value & (1 << 31)) {
- 							/* tiled src, linear dst */
- 							ib[idx+1] +=3D (u32)(src_reloc->lobj.gpu_offset >> 8);
-=20
- 							ib[idx+7] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
- 							ib[idx+8] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
- 						} else {
- 							/* linear src, tiled dst */
- 							ib[idx+7] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
- 							ib[idx+8] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-=20
- 							ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
- 						}
- 						p->idx +=3D 12;
- 						break;
- 					case 3:
- 						/* L2T, broadcast */
- 						if (idx_value & (1 << 31)) {
- 							DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
- 							return -EINVAL;
- 						}
- 						r =3D r600_dma_cs_next_reloc(p, &dst2_reloc);
- 						if (r) {
- 							DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
- 							return -EINVAL;
- 						}
- 						dst_offset =3D radeon_get_ib_value(p, idx+1);
- 						dst_offset <<=3D 8;
- 						dst2_offset =3D radeon_get_ib_value(p, idx+2);
- 						dst2_offset <<=3D 8;
- 						src_offset =3D radeon_get_ib_value(p, idx+8);
- 						src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+9) & 0xff)) << 32;
- 						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2T, broadcast src buffer too small (%llu %l=
u)\n",
- 								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
- 							return -EINVAL;
- 						}
- 						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2T, broadcast dst buffer too small (%llu %l=
u)\n",
- 								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
- 							return -EINVAL;
- 						}
- 						if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj))=
 {
- 							dev_warn(p->dev, "DMA L2T, broadcast dst2 buffer too small (%llu %=
lu)\n",
- 								 dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
- 							return -EINVAL;
- 						}
- 						ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
- 						ib[idx+2] +=3D (u32)(dst2_reloc->lobj.gpu_offset >> 8);
- 						ib[idx+8] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
- 						ib[idx+9] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
- 						p->idx +=3D 10;
- 						break;
- 					case 4:
- 						/* L2T, T2L */
- 						/* detile bit */
- 						if (idx_value & (1 << 31)) {
- 							/* tiled src, linear dst */
- 							src_offset =3D radeon_get_ib_value(p, idx+1);
- 							src_offset <<=3D 8;
- 							ib[idx+1] +=3D (u32)(src_reloc->lobj.gpu_offset >> 8);
-=20
- 							dst_offset =3D radeon_get_ib_value(p, idx+7);
- 							dst_offset |=3D ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 3=
2;
- 							ib[idx+7] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
- 							ib[idx+8] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
- 						} else {
- 							/* linear src, tiled dst */
- 							src_offset =3D radeon_get_ib_value(p, idx+7);
- 							src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 3=
2;
- 							ib[idx+7] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
- 							ib[idx+8] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-=20
- 							dst_offset =3D radeon_get_ib_value(p, idx+1);
- 							dst_offset <<=3D 8;
- 							ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
- 						}
- 						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2T, T2L src buffer too small (%llu %lu)\n",
- 								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
- 							return -EINVAL;
- 						}
- 						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2T, T2L dst buffer too small (%llu %lu)\n",
- 								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
- 							return -EINVAL;
- 						}
- 						p->idx +=3D 9;
- 						break;
- 					case 5:
- 						/* T2T partial */
- 						if (p->family < CHIP_CAYMAN) {
- 							DRM_ERROR("L2T, T2L Partial is cayman only !\n");
- 							return -EINVAL;
- 						}
- 						ib[idx+1] +=3D (u32)(src_reloc->lobj.gpu_offset >> 8);
- 						ib[idx+4] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
- 						p->idx +=3D 13;
- 						break;
- 					case 7:
- 						/* L2T, broadcast */
- 						if (idx_value & (1 << 31)) {
- 							DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
- 							return -EINVAL;
- 						}
- 						r =3D r600_dma_cs_next_reloc(p, &dst2_reloc);
- 						if (r) {
- 							DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
- 							return -EINVAL;
- 						}
- 						dst_offset =3D radeon_get_ib_value(p, idx+1);
- 						dst_offset <<=3D 8;
- 						dst2_offset =3D radeon_get_ib_value(p, idx+2);
- 						dst2_offset <<=3D 8;
- 						src_offset =3D radeon_get_ib_value(p, idx+8);
- 						src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+9) & 0xff)) << 32;
- 						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2T, broadcast src buffer too small (%llu %l=
u)\n",
- 								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
- 							return -EINVAL;
- 						}
- 						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2T, broadcast dst buffer too small (%llu %l=
u)\n",
- 								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
- 							return -EINVAL;
- 						}
- 						if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj))=
 {
- 							dev_warn(p->dev, "DMA L2T, broadcast dst2 buffer too small (%llu %=
lu)\n",
- 								 dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
- 							return -EINVAL;
- 						}
- 						ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
- 						ib[idx+2] +=3D (u32)(dst2_reloc->lobj.gpu_offset >> 8);
- 						ib[idx+8] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
- 						ib[idx+9] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
- 						p->idx +=3D 10;
- 						break;
- 					default:
- 						DRM_ERROR("bad DMA_PACKET_COPY misc %u\n", misc);
- 						return -EINVAL;
- 					}
+ 			switch (sub_cmd) {
+ 			/* Copy L2L, DW aligned */
+ 			case 0x00:
+ 				/* L2L, dw */
 -				src_offset =3D ib[idx+2];
 -				src_offset |=3D ((u64)(ib[idx+4] & 0xff)) << 32;
 -				dst_offset =3D ib[idx+1];
 -				dst_offset |=3D ((u64)(ib[idx+3] & 0xff)) << 32;
++				src_offset =3D radeon_get_ib_value(p, idx+2);
++				src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+4) & 0xff)) << 32;
++				dst_offset =3D radeon_get_ib_value(p, idx+1);
++				dst_offset |=3D ((u64)(radeon_get_ib_value(p, idx+3) & 0xff)) << 32;
+ 				if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2L, dw src buffer too small (%llu %lu)\n",
+ 							src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2L, dw dst buffer too small (%llu %lu)\n",
+ 							dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
+ 				ib[idx+2] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
+ 				ib[idx+3] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
+ 				ib[idx+4] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
+ 				p->idx +=3D 5;
+ 				break;
+ 			/* Copy L2T/T2L */
+ 			case 0x08:
+ 				/* detile bit */
 -				if (ib[idx + 2] & (1 << 31)) {
++				if (radeon_get_ib_value(p, idx + 2) & (1 << 31)) {
+ 					/* tiled src, linear dst */
 -					src_offset =3D ib[idx+1];
++					src_offset =3D radeon_get_ib_value(p, idx+1);
+ 					src_offset <<=3D 8;
+ 					ib[idx+1] +=3D (u32)(src_reloc->lobj.gpu_offset >> 8);
+=20
+ 					dst_offset =3D radeon_get_ib_value(p, idx + 7);
 -					dst_offset |=3D ((u64)(ib[idx+8] & 0xff)) << 32;
++					dst_offset |=3D ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 32;
+ 					ib[idx+7] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
+ 					ib[idx+8] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
  				} else {
- 					switch (misc) {
- 					case 0:
- 						/* detile bit */
- 						if (idx_value & (1 << 31)) {
- 							/* tiled src, linear dst */
- 							src_offset =3D radeon_get_ib_value(p, idx+1);
- 							src_offset <<=3D 8;
- 							ib[idx+1] +=3D (u32)(src_reloc->lobj.gpu_offset >> 8);
-=20
- 							dst_offset =3D radeon_get_ib_value(p, idx+7);
- 							dst_offset |=3D ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 3=
2;
- 							ib[idx+7] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
- 							ib[idx+8] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
- 						} else {
- 							/* linear src, tiled dst */
- 							src_offset =3D radeon_get_ib_value(p, idx+7);
- 							src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 3=
2;
- 							ib[idx+7] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
- 							ib[idx+8] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-=20
- 							dst_offset =3D radeon_get_ib_value(p, idx+1);
- 							dst_offset <<=3D 8;
- 							ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
- 						}
- 						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2T, broadcast src buffer too small (%llu %l=
u)\n",
- 								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
- 							return -EINVAL;
- 						}
- 						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2T, broadcast dst buffer too small (%llu %l=
u)\n",
- 								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
- 							return -EINVAL;
- 						}
- 						p->idx +=3D 9;
- 						break;
- 					default:
- 						DRM_ERROR("bad DMA_PACKET_COPY misc %u\n", misc);
- 						return -EINVAL;
- 					}
+ 					/* linear src, tiled dst */
 -					src_offset =3D ib[idx+7];
 -					src_offset |=3D ((u64)(ib[idx+8] & 0xff)) << 32;
++					src_offset =3D radeon_get_ib_value(p, idx+7);
++					src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 32;
+ 					ib[idx+7] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
+ 					ib[idx+8] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
+=20
 -					dst_offset =3D ib[idx+1];
++					dst_offset =3D radeon_get_ib_value(p, idx+1);
+ 					dst_offset <<=3D 8;
+ 					ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
  				}
- 			} else {
- 				if (new_cmd) {
- 					switch (misc) {
- 					case 0:
- 						/* L2L, byte */
- 						src_offset =3D radeon_get_ib_value(p, idx+2);
- 						src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+4) & 0xff)) << 32;
- 						dst_offset =3D radeon_get_ib_value(p, idx+1);
- 						dst_offset |=3D ((u64)(radeon_get_ib_value(p, idx+3) & 0xff)) << 32;
- 						if ((src_offset + count) > radeon_bo_size(src_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2L, byte src buffer too small (%llu %lu)\n",
- 								 src_offset + count, radeon_bo_size(src_reloc->robj));
- 							return -EINVAL;
- 						}
- 						if ((dst_offset + count) > radeon_bo_size(dst_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2L, byte dst buffer too small (%llu %lu)\n",
- 								 dst_offset + count, radeon_bo_size(dst_reloc->robj));
- 							return -EINVAL;
- 						}
- 						ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xffffffff);
- 						ib[idx+2] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xffffffff);
- 						ib[idx+3] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
- 						ib[idx+4] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
- 						p->idx +=3D 5;
- 						break;
- 					case 1:
- 						/* L2L, partial */
- 						if (p->family < CHIP_CAYMAN) {
- 							DRM_ERROR("L2L Partial is cayman only !\n");
- 							return -EINVAL;
- 						}
- 						ib[idx+1] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xffffffff);
- 						ib[idx+2] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
- 						ib[idx+4] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xffffffff);
- 						ib[idx+5] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
-=20
- 						p->idx +=3D 9;
- 						break;
- 					case 4:
- 						/* L2L, dw, broadcast */
- 						r =3D r600_dma_cs_next_reloc(p, &dst2_reloc);
- 						if (r) {
- 							DRM_ERROR("bad L2L, dw, broadcast DMA_PACKET_COPY\n");
- 							return -EINVAL;
- 						}
- 						dst_offset =3D radeon_get_ib_value(p, idx+1);
- 						dst_offset |=3D ((u64)(radeon_get_ib_value(p, idx+4) & 0xff)) << 32;
- 						dst2_offset =3D radeon_get_ib_value(p, idx+2);
- 						dst2_offset |=3D ((u64)(radeon_get_ib_value(p, idx+5) & 0xff)) << 3=
2;
- 						src_offset =3D radeon_get_ib_value(p, idx+3);
- 						src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+6) & 0xff)) << 32;
- 						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2L, dw, broadcast src buffer too small (%ll=
u %lu)\n",
- 								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
- 							return -EINVAL;
- 						}
- 						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
- 							dev_warn(p->dev, "DMA L2L, dw, broadcast dst buffer too small (%ll=
u %lu)\n",
- 								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
- 							return -EINVAL;
- 						}
- 						if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj))=
 {
- 							dev_warn(p->dev, "DMA L2L, dw, broadcast dst2 buffer too small (%l=
lu %lu)\n",
- 								 dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
- 							return -EINVAL;
- 						}
- 						ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
- 						ib[idx+2] +=3D (u32)(dst2_reloc->lobj.gpu_offset & 0xfffffffc);
- 						ib[idx+3] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
- 						ib[idx+4] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
- 						ib[idx+5] +=3D upper_32_bits(dst2_reloc->lobj.gpu_offset) & 0xff;
- 						ib[idx+6] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
- 						p->idx +=3D 7;
- 						break;
- 					default:
- 						DRM_ERROR("bad DMA_PACKET_COPY misc %u\n", misc);
- 						return -EINVAL;
- 					}
+ 				if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, src buffer too small (%llu %lu)\n",
+ 							src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, dst buffer too small (%llu %lu)\n",
+ 							dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				p->idx +=3D 9;
+ 				break;
+ 			/* Copy L2L, byte aligned */
+ 			case 0x40:
+ 				/* L2L, byte */
 -				src_offset =3D ib[idx+2];
 -				src_offset |=3D ((u64)(ib[idx+4] & 0xff)) << 32;
 -				dst_offset =3D ib[idx+1];
 -				dst_offset |=3D ((u64)(ib[idx+3] & 0xff)) << 32;
++				src_offset =3D radeon_get_ib_value(p, idx+2);
++				src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+4) & 0xff)) << 32;
++				dst_offset =3D radeon_get_ib_value(p, idx+1);
++				dst_offset |=3D ((u64)(radeon_get_ib_value(p, idx+3) & 0xff)) << 32;
+ 				if ((src_offset + count) > radeon_bo_size(src_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2L, byte src buffer too small (%llu %lu)\n",
+ 							src_offset + count, radeon_bo_size(src_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst_offset + count) > radeon_bo_size(dst_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2L, byte dst buffer too small (%llu %lu)\n",
+ 							dst_offset + count, radeon_bo_size(dst_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xffffffff);
+ 				ib[idx+2] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xffffffff);
+ 				ib[idx+3] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
+ 				ib[idx+4] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
+ 				p->idx +=3D 5;
+ 				break;
+ 			/* Copy L2L, partial */
+ 			case 0x41:
+ 				/* L2L, partial */
+ 				if (p->family < CHIP_CAYMAN) {
+ 					DRM_ERROR("L2L Partial is cayman only !\n");
+ 					return -EINVAL;
+ 				}
+ 				ib[idx+1] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xffffffff);
+ 				ib[idx+2] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
+ 				ib[idx+4] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xffffffff);
+ 				ib[idx+5] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
+=20
+ 				p->idx +=3D 9;
+ 				break;
+ 			/* Copy L2L, DW aligned, broadcast */
+ 			case 0x44:
+ 				/* L2L, dw, broadcast */
+ 				r =3D r600_dma_cs_next_reloc(p, &dst2_reloc);
+ 				if (r) {
+ 					DRM_ERROR("bad L2L, dw, broadcast DMA_PACKET_COPY\n");
+ 					return -EINVAL;
+ 				}
 -				dst_offset =3D ib[idx+1];
 -				dst_offset |=3D ((u64)(ib[idx+4] & 0xff)) << 32;
 -				dst2_offset =3D ib[idx+2];
 -				dst2_offset |=3D ((u64)(ib[idx+5] & 0xff)) << 32;
 -				src_offset =3D ib[idx+3];
 -				src_offset |=3D ((u64)(ib[idx+6] & 0xff)) << 32;
++				dst_offset =3D radeon_get_ib_value(p, idx+1);
++				dst_offset |=3D ((u64)(radeon_get_ib_value(p, idx+4) & 0xff)) << 32;
++				dst2_offset =3D radeon_get_ib_value(p, idx+2);
++				dst2_offset |=3D ((u64)(radeon_get_ib_value(p, idx+5) & 0xff)) << 32;
++				src_offset =3D radeon_get_ib_value(p, idx+3);
++				src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+6) & 0xff)) << 32;
+ 				if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2L, dw, broadcast src buffer too small (%llu =
%lu)\n",
+ 							src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2L, dw, broadcast dst buffer too small (%llu =
%lu)\n",
+ 							dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2L, dw, broadcast dst2 buffer too small (%llu=
 %lu)\n",
+ 							dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
+ 				ib[idx+2] +=3D (u32)(dst2_reloc->lobj.gpu_offset & 0xfffffffc);
+ 				ib[idx+3] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
+ 				ib[idx+4] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
+ 				ib[idx+5] +=3D upper_32_bits(dst2_reloc->lobj.gpu_offset) & 0xff;
+ 				ib[idx+6] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
+ 				p->idx +=3D 7;
+ 				break;
+ 			/* Copy L2T Frame to Field */
+ 			case 0x48:
 -				if (ib[idx + 2] & (1 << 31)) {
++				if (radeon_get_ib_value(p, idx + 2) & (1 << 31)) {
+ 					DRM_ERROR("bad L2T, frame to fields DMA_PACKET_COPY\n");
+ 					return -EINVAL;
+ 				}
+ 				r =3D r600_dma_cs_next_reloc(p, &dst2_reloc);
+ 				if (r) {
+ 					DRM_ERROR("bad L2T, frame to fields DMA_PACKET_COPY\n");
+ 					return -EINVAL;
+ 				}
 -				dst_offset =3D ib[idx+1];
++				dst_offset =3D radeon_get_ib_value(p, idx+1);
+ 				dst_offset <<=3D 8;
 -				dst2_offset =3D ib[idx+2];
++				dst2_offset =3D radeon_get_ib_value(p, idx+2);
+ 				dst2_offset <<=3D 8;
 -				src_offset =3D ib[idx+8];
 -				src_offset |=3D ((u64)(ib[idx+9] & 0xff)) << 32;
++				src_offset =3D radeon_get_ib_value(p, idx+8);
++				src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+9) & 0xff)) << 32;
+ 				if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, frame to fields src buffer too small (%ll=
u %lu)\n",
+ 							src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, frame to fields buffer too small (%llu %l=
u)\n",
+ 							dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, frame to fields buffer too small (%llu %l=
u)\n",
+ 							dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
+ 				ib[idx+2] +=3D (u32)(dst2_reloc->lobj.gpu_offset >> 8);
+ 				ib[idx+8] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
+ 				ib[idx+9] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
+ 				p->idx +=3D 10;
+ 				break;
+ 			/* Copy L2T/T2L, partial */
+ 			case 0x49:
+ 				/* L2T, T2L partial */
+ 				if (p->family < CHIP_CAYMAN) {
+ 					DRM_ERROR("L2T, T2L Partial is cayman only !\n");
+ 					return -EINVAL;
+ 				}
+ 				/* detile bit */
 -				if (ib[idx + 2 ] & (1 << 31)) {
++				if (radeon_get_ib_value(p, idx + 2 ) & (1 << 31)) {
+ 					/* tiled src, linear dst */
+ 					ib[idx+1] +=3D (u32)(src_reloc->lobj.gpu_offset >> 8);
+=20
+ 					ib[idx+7] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
+ 					ib[idx+8] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
+ 				} else {
+ 					/* linear src, tiled dst */
+ 					ib[idx+7] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
+ 					ib[idx+8] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
+=20
+ 					ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
+ 				}
+ 				p->idx +=3D 12;
+ 				break;
+ 			/* Copy L2T broadcast */
+ 			case 0x4b:
+ 				/* L2T, broadcast */
 -				if (ib[idx + 2] & (1 << 31)) {
++				if (radeon_get_ib_value(p, idx + 2) & (1 << 31)) {
+ 					DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
+ 					return -EINVAL;
+ 				}
+ 				r =3D r600_dma_cs_next_reloc(p, &dst2_reloc);
+ 				if (r) {
+ 					DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
+ 					return -EINVAL;
+ 				}
 -				dst_offset =3D ib[idx+1];
++				dst_offset =3D radeon_get_ib_value(p, idx+1);
+ 				dst_offset <<=3D 8;
 -				dst2_offset =3D ib[idx+2];
++				dst2_offset =3D radeon_get_ib_value(p, idx+2);
+ 				dst2_offset <<=3D 8;
 -				src_offset =3D ib[idx+8];
 -				src_offset |=3D ((u64)(ib[idx+9] & 0xff)) << 32;
++				src_offset =3D radeon_get_ib_value(p, idx+8);
++				src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+9) & 0xff)) << 32;
+ 				if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, broadcast src buffer too small (%llu %lu)=
\n",
+ 							src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, broadcast dst buffer too small (%llu %lu)=
\n",
+ 							dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, broadcast dst2 buffer too small (%llu %lu=
)\n",
+ 							dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
+ 				ib[idx+2] +=3D (u32)(dst2_reloc->lobj.gpu_offset >> 8);
+ 				ib[idx+8] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
+ 				ib[idx+9] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
+ 				p->idx +=3D 10;
+ 				break;
+ 			/* Copy L2T/T2L (tile units) */
+ 			case 0x4c:
+ 				/* L2T, T2L */
+ 				/* detile bit */
 -				if (ib[idx + 2] & (1 << 31)) {
++				if (radeon_get_ib_value(p, idx + 2) & (1 << 31)) {
+ 					/* tiled src, linear dst */
 -					src_offset =3D ib[idx+1];
++					src_offset =3D radeon_get_ib_value(p, idx+1);
+ 					src_offset <<=3D 8;
+ 					ib[idx+1] +=3D (u32)(src_reloc->lobj.gpu_offset >> 8);
+=20
 -					dst_offset =3D ib[idx+7];
 -					dst_offset |=3D ((u64)(ib[idx+8] & 0xff)) << 32;
++					dst_offset =3D radeon_get_ib_value(p, idx+7);
++					dst_offset |=3D ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 32;
+ 					ib[idx+7] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
+ 					ib[idx+8] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
  				} else {
- 					/* L2L, dw */
- 					src_offset =3D radeon_get_ib_value(p, idx+2);
- 					src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+4) & 0xff)) << 32;
+ 					/* linear src, tiled dst */
 -					src_offset =3D ib[idx+7];
 -					src_offset |=3D ((u64)(ib[idx+8] & 0xff)) << 32;
++					src_offset =3D radeon_get_ib_value(p, idx+7);
++					src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 32;
+ 					ib[idx+7] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
+ 					ib[idx+8] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
+=20
 -					dst_offset =3D ib[idx+1];
 +					dst_offset =3D radeon_get_ib_value(p, idx+1);
- 					dst_offset |=3D ((u64)(radeon_get_ib_value(p, idx+3) & 0xff)) << 32;
- 					if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
- 						dev_warn(p->dev, "DMA L2L, dw src buffer too small (%llu %lu)\n",
- 							 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
- 						return -EINVAL;
- 					}
- 					if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
- 						dev_warn(p->dev, "DMA L2L, dw dst buffer too small (%llu %lu)\n",
- 							 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
- 						return -EINVAL;
- 					}
- 					ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
- 					ib[idx+2] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
- 					ib[idx+3] +=3D upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
- 					ib[idx+4] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
- 					p->idx +=3D 5;
+ 					dst_offset <<=3D 8;
+ 					ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
  				}
+ 				if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, T2L src buffer too small (%llu %lu)\n",
+ 							src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, T2L dst buffer too small (%llu %lu)\n",
+ 							dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				p->idx +=3D 9;
+ 				break;
+ 			/* Copy T2T, partial (tile units) */
+ 			case 0x4d:
+ 				/* T2T partial */
+ 				if (p->family < CHIP_CAYMAN) {
+ 					DRM_ERROR("L2T, T2L Partial is cayman only !\n");
+ 					return -EINVAL;
+ 				}
+ 				ib[idx+1] +=3D (u32)(src_reloc->lobj.gpu_offset >> 8);
+ 				ib[idx+4] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
+ 				p->idx +=3D 13;
+ 				break;
+ 			/* Copy L2T broadcast (tile units) */
+ 			case 0x4f:
+ 				/* L2T, broadcast */
 -				if (ib[idx + 2] & (1 << 31)) {
++				if (radeon_get_ib_value(p, idx + 2) & (1 << 31)) {
+ 					DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
+ 					return -EINVAL;
+ 				}
+ 				r =3D r600_dma_cs_next_reloc(p, &dst2_reloc);
+ 				if (r) {
+ 					DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
+ 					return -EINVAL;
+ 				}
 -				dst_offset =3D ib[idx+1];
++				dst_offset =3D radeon_get_ib_value(p, idx+1);
+ 				dst_offset <<=3D 8;
 -				dst2_offset =3D ib[idx+2];
++				dst2_offset =3D radeon_get_ib_value(p, idx+2);
+ 				dst2_offset <<=3D 8;
 -				src_offset =3D ib[idx+8];
 -				src_offset |=3D ((u64)(ib[idx+9] & 0xff)) << 32;
++				src_offset =3D radeon_get_ib_value(p, idx+8);
++				src_offset |=3D ((u64)(radeon_get_ib_value(p, idx+9) & 0xff)) << 32;
+ 				if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, broadcast src buffer too small (%llu %lu)=
\n",
+ 							src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, broadcast dst buffer too small (%llu %lu)=
\n",
+ 							dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj)) {
+ 					dev_warn(p->dev, "DMA L2T, broadcast dst2 buffer too small (%llu %lu=
)\n",
+ 							dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
+ 					return -EINVAL;
+ 				}
+ 				ib[idx+1] +=3D (u32)(dst_reloc->lobj.gpu_offset >> 8);
+ 				ib[idx+2] +=3D (u32)(dst2_reloc->lobj.gpu_offset >> 8);
+ 				ib[idx+8] +=3D (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
+ 				ib[idx+9] +=3D upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
+ 				p->idx +=3D 10;
+ 				break;
+ 			default:
 -				DRM_ERROR("bad DMA_PACKET_COPY [%6d] 0x%08x invalid sub cmd\n", idx, =
ib[idx+0]);
++				DRM_ERROR("bad DMA_PACKET_COPY [%6d] 0x%08x invalid sub cmd\n", idx, =
radeon_get_ib_value(p, idx+0));
+ 				return -EINVAL;
  			}
  			break;
  		case DMA_PACKET_CONSTANT_FILL:

--Signature=_Wed__13_Feb_2013_15_48_59_+1100_cdRDlN=r/zHREkzm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGxs7AAoJEECxmPOUX5FEi2IP/0wrBs3v8uSNF1hQuQZRkID6
occVfadsfyu7twadMgyiRqy3q80Nla6OH0Z1trij0nHG1XKvnp8+o80uWhEBHKIE
5FIXx3U4zQV1XCjQ0pSM4icnf9kxSHYiQjpJHuHvo9FACuVO5ZEYj5vDrUdftzEH
YmTNkAR/we+IxrdldeghcnSlp2IZYJSJB8nPcZZk0TBkUZ19pwyXzHsDYOr0doXK
Izre5tRPVU5qQLBcRqd2KXSUBm+ELYY2Ed5i3fRjDp0vt80kTc3b2zlFXA29qch1
qwqe7oj8oBGmFPWFTuVISBXD0TXeBLCggxauDMOXwGSv+y29yzH5oTOzNUke/Llu
0H6DaT4tqfq6KAD9HBWI1xQe3D7jKXQ0OJtesMgeYBZFr99zbfsdE9+xqLLVcpoZ
Ba3sd2ivdp04UmRzJKHK/7rU3X1QCT7zMjv099XKsuFl8T1jEgfw9vRAygAL75ea
sRnDfc/pN7Zj1PLab2POWUtpUOei+BtTEkpZoshhjogqG73ZlCdWG/kAiz+wqsQZ
A6psxO6zPFw/6IBUB11QfLfeIHmUrvNjwzb/6oCfJrbRPD519R0jFly43sWWkl6i
BgzPgrDjVaUidQv5CuZ4u0HbGDVPMjmvDyuEsqOmBk2lmgjVsYCDCBTXP2nKloug
jbRxcI10ZSsiNEndXF4L
=h9ar
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Feb_2013_15_48_59_+1100_cdRDlN=r/zHREkzm--
