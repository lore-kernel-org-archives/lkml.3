Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389Ab3ECXBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 19:01:05 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34077 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934258Ab3ECXBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 19:01:00 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/7] drm: Update drm_addmap and drm_mmap to use PAT WC instead of MTRRs
Date: Fri,  3 May 2013 16:00:31 -0700
Message-Id: <d6e5e371e464b7de1115a00f02b5b834315cd986.1367621039.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1367621038.git.luto@amacapital.net>
References: <cover.1367621038.git.luto@amacapital.net>
In-Reply-To: <cover.1367621038.git.luto@amacapital.net>
References: <cover.1367621038.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

This needs careful review.  I don't really know what this code does, nor
do I have the hardware.  (I don't understand AGP and the associated
caching implications.)

 drivers/gpu/drm/drm_bufs.c | 11 ++++-------
 drivers/gpu/drm/drm_vm.c   | 13 +++++++------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index 0128147..0ae9cbb 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -210,8 +210,8 @@ static int drm_addmap_core(struct drm_device * dev, resource_size_t offset,
 		if (drm_core_has_MTRR(dev)) {
 			if (map->type == _DRM_FRAME_BUFFER ||
 			    (map->flags & _DRM_WRITE_COMBINING)) {
-				map->mtrr = mtrr_add(map->offset, map->size,
-						     MTRR_TYPE_WRCOMB, 1);
+				map->mtrr =
+					drm_mtrr_add_wc(map->offset, map->size);
 			}
 		}
 		if (map->type == _DRM_REGISTERS) {
@@ -451,11 +451,8 @@ int drm_rmmap_locked(struct drm_device *dev, struct drm_local_map *map)
 		iounmap(map->handle);
 		/* FALLTHROUGH */
 	case _DRM_FRAME_BUFFER:
-		if (drm_core_has_MTRR(dev) && map->mtrr >= 0) {
-			int retcode;
-			retcode = mtrr_del(map->mtrr, map->offset, map->size);
-			DRM_DEBUG("mtrr_del=%d\n", retcode);
-		}
+		if (drm_core_has_MTRR(dev))
+			drm_mtrr_del_wc(map->mtrr);
 		break;
 	case _DRM_SHM:
 		vfree(map->handle);
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index db7bd29..b255fd7 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -43,15 +43,16 @@
 static void drm_vm_open(struct vm_area_struct *vma);
 static void drm_vm_close(struct vm_area_struct *vma);
 
-static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
+static pgprot_t drm_io_prot(struct drm_local_map *map,
+			    struct vm_area_struct *vma)
 {
 	pgprot_t tmp = vm_get_page_prot(vma->vm_flags);
 
 #if defined(__i386__) || defined(__x86_64__)
-	if (boot_cpu_data.x86 > 3 && map_type != _DRM_AGP) {
-		pgprot_val(tmp) |= _PAGE_PCD;
-		pgprot_val(tmp) &= ~_PAGE_PWT;
-	}
+	if (map->flags & _DRM_WRITE_COMBINING)
+		tmp = pgprot_writecombine(tmp);
+	else if (map->type != _DRM_AGP)
+		tmp = pgprot_noncached(tmp);
 #elif defined(__powerpc__)
 	pgprot_val(tmp) |= _PAGE_NO_CACHE;
 	if (map_type == _DRM_REGISTERS)
@@ -617,7 +618,7 @@ int drm_mmap_locked(struct file *filp, struct vm_area_struct *vma)
 	case _DRM_REGISTERS:
 		offset = drm_core_get_reg_ofs(dev);
 		vma->vm_flags |= VM_IO;	/* not in core dump */
-		vma->vm_page_prot = drm_io_prot(map->type, vma);
+		vma->vm_page_prot = drm_io_prot(map, vma);
 		if (io_remap_pfn_range(vma, vma->vm_start,
 				       (map->offset + offset) >> PAGE_SHIFT,
 				       vma->vm_end - vma->vm_start,
-- 
1.8.1.4

