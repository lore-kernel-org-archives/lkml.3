Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaD3CiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:38:04 -0400
Received: from ozlabs.org ([103.22.144.67]:51952 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaD3CiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:38:01 -0400
Date: Wed, 30 Apr 2014 12:37:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-Id: <20140430123753.16dd13b23d29e09548a4bd56@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Apr_2014_12_37_53_+1000_pqN4Wux4IR7CmFMp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Apr_2014_12_37_53_+1000_pqN4Wux4IR7CmFMp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/i915_gem_gtt.c between commitcfa7c862982b
("drm/i915: Sanitize the enable_ppgtt module option once") from the
drm-intel-fixes tree tree and commit 5db6c735ead5 ("drm/i915: dmesg
output for VT-d testing") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem_gtt.c
index 154b0f8bb88d,496916298e8a..000000000000
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@@ -62,62 -48,13 +62,9 @@@ static int sanitize_enable_ppgtt(struc
  	}
  #endif
 =20
 -	/* Full ppgtt disabled by default for now due to issues. */
 -	if (full)
 -		return HAS_PPGTT(dev) && (i915.enable_ppgtt =3D=3D 2);
 -	else
 -		return HAS_ALIASING_PPGTT(dev);
 +	return HAS_ALIASING_PPGTT(dev) ? 1 : 0;
  }
 =20
- #define GEN6_PPGTT_PD_ENTRIES 512
- #define I915_PPGTT_PT_ENTRIES (PAGE_SIZE / sizeof(gen6_gtt_pte_t))
- typedef uint64_t gen8_gtt_pte_t;
- typedef gen8_gtt_pte_t gen8_ppgtt_pde_t;
-=20
- /* PPGTT stuff */
- #define GEN6_GTT_ADDR_ENCODE(addr)	((addr) | (((addr) >> 28) & 0xff0))
- #define HSW_GTT_ADDR_ENCODE(addr)	((addr) | (((addr) >> 28) & 0x7f0))
-=20
- #define GEN6_PDE_VALID			(1 << 0)
- /* gen6+ has bit 11-4 for physical addr bit 39-32 */
- #define GEN6_PDE_ADDR_ENCODE(addr)	GEN6_GTT_ADDR_ENCODE(addr)
-=20
- #define GEN6_PTE_VALID			(1 << 0)
- #define GEN6_PTE_UNCACHED		(1 << 1)
- #define HSW_PTE_UNCACHED		(0)
- #define GEN6_PTE_CACHE_LLC		(2 << 1)
- #define GEN7_PTE_CACHE_L3_LLC		(3 << 1)
- #define GEN6_PTE_ADDR_ENCODE(addr)	GEN6_GTT_ADDR_ENCODE(addr)
- #define HSW_PTE_ADDR_ENCODE(addr)	HSW_GTT_ADDR_ENCODE(addr)
-=20
- /* Cacheability Control is a 4-bit value. The low three bits are stored i=
n *
-  * bits 3:1 of the PTE, while the fourth bit is stored in bit 11 of the P=
TE.
-  */
- #define HSW_CACHEABILITY_CONTROL(bits)	((((bits) & 0x7) << 1) | \
- 					 (((bits) & 0x8) << (11 - 3)))
- #define HSW_WB_LLC_AGE3			HSW_CACHEABILITY_CONTROL(0x2)
- #define HSW_WB_LLC_AGE0			HSW_CACHEABILITY_CONTROL(0x3)
- #define HSW_WB_ELLC_LLC_AGE0		HSW_CACHEABILITY_CONTROL(0xb)
- #define HSW_WB_ELLC_LLC_AGE3		HSW_CACHEABILITY_CONTROL(0x8)
- #define HSW_WT_ELLC_LLC_AGE0		HSW_CACHEABILITY_CONTROL(0x6)
- #define HSW_WT_ELLC_LLC_AGE3		HSW_CACHEABILITY_CONTROL(0x7)
-=20
- #define GEN8_PTES_PER_PAGE		(PAGE_SIZE / sizeof(gen8_gtt_pte_t))
- #define GEN8_PDES_PER_PAGE		(PAGE_SIZE / sizeof(gen8_ppgtt_pde_t))
-=20
- /* GEN8 legacy style addressis defined as a 3 level page table:
-  * 31:30 | 29:21 | 20:12 |  11:0
-  * PDPE  |  PDE  |  PTE  | offset
-  * The difference as compared to normal x86 3 level page table is the PDP=
Es are
-  * programmed via register.
-  */
- #define GEN8_PDPE_SHIFT			30
- #define GEN8_PDPE_MASK			0x3
- #define GEN8_PDE_SHIFT			21
- #define GEN8_PDE_MASK			0x1ff
- #define GEN8_PTE_SHIFT			12
- #define GEN8_PTE_MASK			0x1ff
-=20
- #define PPAT_UNCACHED_INDEX		(_PAGE_PWT | _PAGE_PCD)
- #define PPAT_CACHED_PDE_INDEX		0 /* WB LLC */
- #define PPAT_CACHED_INDEX		_PAGE_PAT /* WB LLCeLLC */
- #define PPAT_DISPLAY_ELLC_INDEX		_PAGE_PCD /* WT eLLC */
 =20
  static void ppgtt_bind_vma(struct i915_vma *vma,
  			   enum i915_cache_level cache_level,
@@@ -2041,14 -1971,10 +1981,18 @@@ int i915_gem_gtt_init(struct drm_devic
  		 gtt->base.total >> 20);
  	DRM_DEBUG_DRIVER("GMADR size =3D %ldM\n", gtt->mappable_end >> 20);
  	DRM_DEBUG_DRIVER("GTT stolen size =3D %zdM\n", gtt->stolen_size >> 20);
 +	/*
 +	 * i915.enable_ppgtt is read-only, so do an early pass to validate the
 +	 * user's requested state against the hardware/driver capabilities.  We
 +	 * do this now so that we can print out any log messages once rather
 +	 * than every time we check intel_enable_ppgtt().
 +	 */
 +	i915.enable_ppgtt =3D sanitize_enable_ppgtt(dev, i915.enable_ppgtt);
 +	DRM_DEBUG_DRIVER("ppgtt mode: %i\n", i915.enable_ppgtt);
+ #ifdef CONFIG_INTEL_IOMMU
+ 	if (intel_iommu_gfx_mapped)
+ 		DRM_INFO("VT-d active for gfx access\n");
+ #endif
 =20
  	return 0;
  }

--Signature=_Wed__30_Apr_2014_12_37_53_+1000_pqN4Wux4IR7CmFMp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTYGIGAAoJEMDTa8Ir7ZwVHrIP/2Mvt6zorQK9C9Cnd4X4Cw05
bjUJOzMvpQro8Q5ho3xXJgMfHAaG0XN2FyBln1JHup1nXKhlWVrsKiFa/AsdSOVX
B6CxMkbQ1/l1MNSrssk8HnR2+9tT5zYBd3tl8+htmiW/EQigLvr0R+3QgY1JVamn
xdQ2U3R40foSCELFcbkmMsgHJ95ZRQXTRZLxf0MGAUSbFXSE7gUomCiBYSvA7YV0
+Cfuslz7eXJdrr6TdVo5PGBId0kkklKAG2azMHG+SKukUTVkFKE9GgbbhUukfEnr
ASo8ux0Hgh3Ye227SUV1cz8b45+fFAFctjcJ2TfE/E0VQYl4s+nXc1Nz+nfUCQtJ
3bYhHgUVoXDHjoreN3YsZER3j0G9hHtT3iYlWJjoW0gHhlErGDiPN8zW8W5rSSKy
M5zw28yzcdTqtjj4y+aro1Dr7FZF74tBoMhJAgb927tqE4nYVtZ98515bqkWu7Qa
MIMS6YyRCWRyy6Kb6K7BfWy9BrIsc9+xpvGwWKTDaXlPXNlAHI76AOB9hJQ6ejbl
VoS+Mxl+mKO7OUybnYjs7yBy/Tkommr4Nw0M2PpER1YUntnR83LH1VMU2+gT7tuL
Qmf8FHgEZCx0bJYaKjoXobgfQrX9Ki0cluMQr08TxRrr9vrQkiLj7QZZLsKFZHIe
pnSYLfDG5YfbTMbgQIn5
=PyIM
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Apr_2014_12_37_53_+1000_pqN4Wux4IR7CmFMp--
