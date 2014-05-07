Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaEGDY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:24:56 -0400
Received: from ozlabs.org ([103.22.144.67]:56657 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaEGDYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:24:55 -0400
Date: Wed, 7 May 2014 13:24:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: linux-next: manual merge of the drm tree with the drm-intel-fixes
 tree
Message-Id: <20140507132448.d1f892070fa01733ff10b933@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_May_2014_13_24_48_+1000__FWZYjVfy3q+4bIT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_May_2014_13_24_48_+1000__FWZYjVfy3q+4bIT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_gem_gtt.c between commit cfa7c862982b
("drm/i915: Sanitize the enable_ppgtt module option once") from the
drm-intel-fixes tree and commit 5db6c735ead5 ("drm/i915: dmesg output for
VT-d testing") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem_gtt.c
index 154b0f8bb88d,0d514ff9b94c..000000000000
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
@@@ -2041,15 -1962,11 +1972,20 @@@ int i915_gem_gtt_init(struct drm_devic
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
 +
+ #ifdef CONFIG_INTEL_IOMMU
+ 	if (intel_iommu_gfx_mapped)
+ 		DRM_INFO("VT-d active for gfx access\n");
+ #endif
+=20
  	return 0;
  }
 =20

--Signature=_Wed__7_May_2014_13_24_48_+1000__FWZYjVfy3q+4bIT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTaaeFAAoJEMDTa8Ir7ZwVUh8P/0XlhOXl2jcs4Ie41l6khiUx
r3doXTFt5DN0X22hYU0v9gPyr2JbhPtiT52x2S01qj3rG0f4RE5xaOPoaV9YA1Ea
ls9T/X4zIgvqfgPYLOlg/M6mV+nQaDeBDvwrJWCl4yhbXEAUu1EgS5DBFxH/dSVr
ElW4jKu0SbWt2gNLsk8O40L7XeMyHKCGwkzBDoluKKaby0RTipo+zr/q2GLPWOLY
Z05QOGNujQ/hqrvdWRPLEwG56GRobTCPnRFj5Bh/dVBgSw4/tA+N+mJ5MGth+Czb
4XuRwMf1UUyU/2OhaQTrONlh5nn3i92Oi1bxIabWw+USPrmXNuC+S54KPAH6wqDV
eBxIHGPV6ECOoH4mckAyP/x06vyf6dGYmcmnqbdXOdeC4riP//Y4hgbxszcoS0sV
bN4HkIDmX92Uw7KQVZ6JFAK+HjLQJR/Gr4+2TRu7zpHZfHdHv6Ci2O1WJoiR/vtU
8A0g0f2Ms0VbMUfBAXx60yor4OO+LQxuuwS+4aHnR5UBlDacXOnwjdZXpCTqJ5RN
evFAuDtzTLXkJhh6goypuLR5PQJiQneztC71LPzyiIY8m4ETG0c/1TZQnhPMxweL
3AgZcRXjDdmp7OBFq6nT/kqFBuWQ/k40r8ULF6U/uVhcrok9IoVlY/Z1KsxobFJh
LZBuVglaJPfVWjgmggIr
=RYF4
-----END PGP SIGNATURE-----

--Signature=_Wed__7_May_2014_13_24_48_+1000__FWZYjVfy3q+4bIT--
