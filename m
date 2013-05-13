Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3EMX7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:59:15 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49018 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab3EMX7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:59:06 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 3/9] drm: Update drm_addmap and drm_mmap to use PAT WC instead of MTRRs
Date: Mon, 13 May 2013 16:58:42 -0700
Message-Id: <b1c6c2652b302431a4d4cff46ac872db8e520b6a.1368485053.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1368485053.git.luto@amacapital.net>
References: <cover.1368485053.git.luto@amacapital.net>
In-Reply-To: <cover.1368485053.git.luto@amacapital.net>
References: <cover.1368485053.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, DRM_FRAME_BUFFER mappings, as well as DRM_REGISTERS
mappings with DRM_WRITE_COMBINING set, resulted in an unconditional
MTRR being added but the actual mappings being created as UC-.

Now these mappings have the MTRR added only if needed, but they will
be mapped with pgprot_writecombine.

The non-WC DRM_REGISTERS case now uses pgprot_noncached instead of
hardcoding the bit twiddling.

The DRM_AGP case is unchanged for now.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/gpu/drm/drm_bufs.c | 17 +++++++++--------
 drivers/gpu/drm/drm_vm.c   | 23 +++++++++++------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index 0128147..0190fce 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -210,12 +210,16 @@ static int drm_addmap_core(struct drm_device * dev, resource_size_t offset,
 		if (drm_core_has_MTRR(dev)) {
 			if (map->type == _DRM_FRAME_BUFFER ||
 			    (map->flags & _DRM_WRITE_COMBINING)) {
-				map->mtrr = mtrr_add(map->offset, map->size,
-						     MTRR_TYPE_WRCOMB, 1);
+				map->mtrr =
+					arch_phys_wc_add(map->offset, map->size);
 			}
 		}
 		if (map->type == _DRM_REGISTERS) {
-			map->handle = ioremap(map->offset, map->size);
+			if (map->flags & _DRM_WRITE_COMBINING)
+				map->handle = ioremap_wc(map->offset,
+							 map->size);
+			else
+				map->handle = ioremap(map->offset, map->size);
 			if (!map->handle) {
 				kfree(map);
 				return -ENOMEM;
@@ -451,11 +455,8 @@ int drm_rmmap_locked(struct drm_device *dev, struct drm_local_map *map)
 		iounmap(map->handle);
 		/* FALLTHROUGH */
 	case _DRM_FRAME_BUFFER:
-		if (drm_core_has_MTRR(dev) && map->mtrr >= 0) {
-			int retcode;
-			retcode = mtrr_del(map->mtrr, map->offset, map->size);
-			DRM_DEBUG("mtrr_del=%d\n", retcode);
-		}
+		if (drm_core_has_MTRR(dev))
+			arch_phys_wc_del(map->mtrr);
 		break;
 	case _DRM_SHM:
 		vfree(map->handle);
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index db7bd29..163f436 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -43,14 +43,18 @@
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
+	if (map->type != _DRM_AGP) {
+		if (map->type == _DRM_FRAME_BUFFER ||
+		    map->flags & _DRM_WRITE_COMBINING)
+			tmp = pgprot_writecombine(tmp);
+		else
+			tmp = pgprot_noncached(tmp);
 	}
 #elif defined(__powerpc__)
 	pgprot_val(tmp) |= _PAGE_NO_CACHE;
@@ -250,13 +254,8 @@ static void drm_vm_shm_close(struct vm_area_struct *vma)
 			switch (map->type) {
 			case _DRM_REGISTERS:
 			case _DRM_FRAME_BUFFER:
-				if (drm_core_has_MTRR(dev) && map->mtrr >= 0) {
-					int retcode;
-					retcode = mtrr_del(map->mtrr,
-							   map->offset,
-							   map->size);
-					DRM_DEBUG("mtrr_del = %d\n", retcode);
-				}
+				if (drm_core_has_MTRR(dev))
+					arch_phys_wc_del(map->mtrr);
 				iounmap(map->handle);
 				break;
 			case _DRM_SHM:
@@ -617,7 +616,7 @@ int drm_mmap_locked(struct file *filp, struct vm_area_struct *vma)
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

