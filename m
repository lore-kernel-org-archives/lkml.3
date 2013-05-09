Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3EITrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:47:02 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53001 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab3EITq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:46:59 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC/PATCH v2 4/8] drm,agpgart: Use pgprot_writecombine for AGP maps and make the MTRR optional
Date: Thu,  9 May 2013 12:46:23 -0700
Message-Id: <3b4e9864e52428a9f73289c92baa37a073a33077.1368128020.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1368128020.git.luto@amacapital.net>
References: <cover.1368128020.git.luto@amacapital.net>
In-Reply-To: <cover.1368128020.git.luto@amacapital.net>
References: <cover.1368128020.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure I understand the intent of the previous behavior.  mmap
on /dev/agpgart and DRM_AGP maps had no cache flags set, so they
would be fully cacheable.  But the DRM code (most of the time) would
add a write-combining MTRR that would change the effective memory
type to WC.

The new behavior just requests WC explicitly for all AGP maps.

If there is any code out there that expects cacheable access to the
AGP aperture (because the drm driver doesn't request an MTRR or
because it's using /dev/agpgart directly), then it will now end up
with a UC or WC mapping, depending on the architecture and PAT
availability.  But cacheable access to the aperture seems like it's
asking for trouble, because, AIUI, the aperture is an alias of RAM.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

It's conceivable that libpciaccess could have issues with this due to
memtype conflicts, but I think this is unlikely (as long as a WC
mapping gets there first, I think the conflict resolution rules will
all work out).  In any case, everything that maps the AGP aperture
ought to be using /dev/agpgart or the DRM API, in which case
everything should be okay.

I don't have anything with an AGP slot to test AFAIK.

 drivers/char/agp/frontend.c |  8 +++++---
 drivers/gpu/drm/drm_pci.c   |  8 ++++----
 drivers/gpu/drm/drm_stub.c  | 10 ++--------
 drivers/gpu/drm/drm_vm.c    | 11 ++++-------
 4 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index 2e04433..1b19239 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -603,7 +603,8 @@ static int agp_mmap(struct file *file, struct vm_area_struct *vma)
 			vma->vm_ops = kerninfo.vm_ops;
 		} else if (io_remap_pfn_range(vma, vma->vm_start,
 				(kerninfo.aper_base + offset) >> PAGE_SHIFT,
-					    size, vma->vm_page_prot)) {
+				size,
+				pgprot_writecombine(vma->vm_page_prot))) {
 			goto out_again;
 		}
 		mutex_unlock(&(agp_fe.agp_mutex));
@@ -618,8 +619,9 @@ static int agp_mmap(struct file *file, struct vm_area_struct *vma)
 		if (kerninfo.vm_ops) {
 			vma->vm_ops = kerninfo.vm_ops;
 		} else if (io_remap_pfn_range(vma, vma->vm_start,
-					    kerninfo.aper_base >> PAGE_SHIFT,
-					    size, vma->vm_page_prot)) {
+				kerninfo.aper_base >> PAGE_SHIFT,
+				size,
+				pgprot_writecombine(vma->vm_page_prot))) {
 			goto out_again;
 		}
 		mutex_unlock(&(agp_fe.agp_mutex));
diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index bd719e9..d0f6699 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -278,10 +278,10 @@ int drm_pci_agp_init(struct drm_device *dev)
 		}
 		if (drm_core_has_MTRR(dev)) {
 			if (dev->agp)
-				dev->agp->agp_mtrr =
-					mtrr_add(dev->agp->agp_info.aper_base,
-						 dev->agp->agp_info.aper_size *
-						 1024 * 1024, MTRR_TYPE_WRCOMB, 1);
+				dev->agp->agp_mtrr = arch_phys_wc_add(
+					dev->agp->agp_info.aper_base,
+					dev->agp->agp_info.aper_size *
+					1024 * 1024);
 		}
 	}
 	return 0;
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 7d30802..9e2acdf 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -451,14 +451,8 @@ void drm_put_dev(struct drm_device *dev)
 
 	drm_lastclose(dev);
 
-	if (drm_core_has_MTRR(dev) && drm_core_has_AGP(dev) &&
-	    dev->agp && dev->agp->agp_mtrr >= 0) {
-		int retval;
-		retval = mtrr_del(dev->agp->agp_mtrr,
-				  dev->agp->agp_info.aper_base,
-				  dev->agp->agp_info.aper_size * 1024 * 1024);
-		DRM_DEBUG("mtrr_del=%d\n", retval);
-	}
+	if (drm_core_has_MTRR(dev) && drm_core_has_AGP(dev) && dev->agp)
+		arch_phys_wc_del(dev->agp->agp_mtrr);
 
 	if (dev->driver->unload)
 		dev->driver->unload(dev);
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index 163f436..b1e4ec8 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -49,13 +49,10 @@ static pgprot_t drm_io_prot(struct drm_local_map *map,
 	pgprot_t tmp = vm_get_page_prot(vma->vm_flags);
 
 #if defined(__i386__) || defined(__x86_64__)
-	if (map->type != _DRM_AGP) {
-		if (map->type == _DRM_FRAME_BUFFER ||
-		    map->flags & _DRM_WRITE_COMBINING)
-			tmp = pgprot_writecombine(tmp);
-		else
-			tmp = pgprot_noncached(tmp);
-	}
+	if (map->type == _DRM_REGISTERS && !(map->flags & _DRM_WRITE_COMBINING))
+		tmp = pgprot_noncached(tmp);
+	else
+		tmp = pgprot_writecombine(tmp);
 #elif defined(__powerpc__)
 	pgprot_val(tmp) |= _PAGE_NO_CACHE;
 	if (map_type == _DRM_REGISTERS)
-- 
1.8.1.4

