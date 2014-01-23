Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaAWOQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:16:01 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:61722 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaAWOP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:15:56 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Ingo Molnar <mingo@kernel.org>, linux-fbdev@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 05/11] x86: sysfb: store apertures in simplefb platform-data
Date: Thu, 23 Jan 2014 15:14:57 +0100
Message-Id: <1390486503-1504-6-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get a generic remove_conflicting_framebuffers() for
firmware-framebuffers, we need to store the apertures in the platform-data
of each framebuffer. So make x86-sysfb do that for simple-framebuffer
devices.

Unfortunately, "struct apertures_struct" contains a VLA so we cannot
easily embed it. Thus, we have to use a "apert_buf" buffer with enough
room for one "struct aperture".

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 arch/x86/include/asm/sysfb.h           |  6 +--
 arch/x86/kernel/sysfb.c                |  2 +-
 arch/x86/kernel/sysfb_simplefb.c       | 68 ++++++++++++++++++++--------------
 include/linux/platform_data/simplefb.h |  1 +
 4 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/sysfb.h b/arch/x86/include/asm/sysfb.h
index 6f95b8d..4f9fda2 100644
--- a/arch/x86/include/asm/sysfb.h
+++ b/arch/x86/include/asm/sysfb.h
@@ -81,8 +81,7 @@ static inline void sysfb_apply_efi_quirks(void)
 
 bool parse_mode(const struct screen_info *si,
 		struct simplefb_platform_data *mode);
-int create_simplefb(const struct screen_info *si,
-		    const struct simplefb_platform_data *mode);
+int create_simplefb(const struct simplefb_platform_data *mode);
 
 #else /* CONFIG_X86_SYSFB */
 
@@ -92,8 +91,7 @@ static inline bool parse_mode(const struct screen_info *si,
 	return false;
 }
 
-static inline int create_simplefb(const struct screen_info *si,
-				  const struct simplefb_platform_data *mode)
+static inline int create_simplefb(const struct simplefb_platform_data *mode)
 {
 	return -EINVAL;
 }
diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c
index ba9ff26..fd07b09 100644
--- a/arch/x86/kernel/sysfb.c
+++ b/arch/x86/kernel/sysfb.c
@@ -117,7 +117,7 @@ static __init int sysfb_init(void)
 	/* try to create a simple-framebuffer device */
 	compatible = parse_mode(si, &mode);
 	if (compatible) {
-		ret = create_simplefb(si, &mode);
+		ret = create_simplefb(&mode);
 		if (!ret)
 			return 0;
 	}
diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index a760d47..9338427 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -31,9 +31,12 @@ static const struct simplefb_format formats[] = SIMPLEFB_FORMATS;
 __init bool parse_mode(const struct screen_info *si,
 		       struct simplefb_platform_data *mode)
 {
+	struct apertures_struct *apert = (void*)mode->apert_buf;
 	const struct simplefb_format *f;
+	unsigned long len;
 	__u8 type;
 	unsigned int i;
+	u64 size;
 
 	type = si->orig_video_isVGA;
 	if (type != VIDEO_TYPE_VLFB && type != VIDEO_TYPE_EFI)
@@ -41,47 +44,56 @@ __init bool parse_mode(const struct screen_info *si,
 
 	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
 		f = &formats[i];
-		if (si->lfb_depth == f->bits_per_pixel &&
-		    si->red_size == f->red.length &&
-		    si->red_pos == f->red.offset &&
-		    si->green_size == f->green.length &&
-		    si->green_pos == f->green.offset &&
-		    si->blue_size == f->blue.length &&
-		    si->blue_pos == f->blue.offset &&
-		    si->rsvd_size == f->transp.length &&
-		    si->rsvd_pos == f->transp.offset) {
-			mode->format = f->name;
-			mode->width = si->lfb_width;
-			mode->height = si->lfb_height;
-			mode->stride = si->lfb_linelength;
-			return true;
+		if (si->lfb_depth != f->bits_per_pixel ||
+		    si->red_size != f->red.length ||
+		    si->red_pos != f->red.offset ||
+		    si->green_size != f->green.length ||
+		    si->green_pos != f->green.offset ||
+		    si->blue_size != f->blue.length ||
+		    si->blue_pos != f->blue.offset ||
+		    si->rsvd_size != f->transp.length ||
+		    si->rsvd_pos != f->transp.offset)
+			continue;
+
+		/* lfb_size is in bytes except for VLFB it's in 64kb blocks */
+		size = si->lfb_size;
+		if (type == VIDEO_TYPE_VLFB)
+			size <<= 16;
+
+		/* don't use lfb_size as it may contain the whole VMEM instead
+		 * of only the part that is occupied by the framebuffer */
+		len = si->lfb_height * (unsigned long)si->lfb_linelength;
+		if (len > size) {
+			printk(KERN_WARNING "sysfb: VRAM smaller than advertised framebuffer (%llu > %llu)\n",
+			       (unsigned long long)len,
+			       (unsigned long long)size);
+			return false;
 		}
+
+		mode->format = f->name;
+		mode->width = si->lfb_width;
+		mode->height = si->lfb_height;
+		mode->stride = si->lfb_linelength;
+		apert->count = 1;
+		apert->ranges[0].base = si->lfb_base;
+		apert->ranges[0].size = len;
+		return true;
 	}
 
 	return false;
 }
 
-__init int create_simplefb(const struct screen_info *si,
-			   const struct simplefb_platform_data *mode)
+__init int create_simplefb(const struct simplefb_platform_data *mode)
 {
+	const struct apertures_struct *apert = (void*)mode->apert_buf;
 	struct resource res;
-	unsigned long len;
-
-	/* don't use lfb_size as it may contain the whole VMEM instead of only
-	 * the part that is occupied by the framebuffer */
-	len = mode->height * mode->stride;
-	len = PAGE_ALIGN(len);
-	if (len > (u64)si->lfb_size << 16) {
-		printk(KERN_WARNING "sysfb: VRAM smaller than advertised\n");
-		return -EINVAL;
-	}
 
 	/* setup IORESOURCE_MEM as framebuffer memory */
 	memset(&res, 0, sizeof(res));
 	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	res.name = simplefb_resname;
-	res.start = si->lfb_base;
-	res.end = si->lfb_base + len - 1;
+	res.start = apert->ranges[0].base;
+	res.end = res.start + apert->ranges[0].size - 1;
 	if (res.end <= res.start)
 		return -EINVAL;
 
diff --git a/include/linux/platform_data/simplefb.h b/include/linux/platform_data/simplefb.h
index 077303c..21983cc 100644
--- a/include/linux/platform_data/simplefb.h
+++ b/include/linux/platform_data/simplefb.h
@@ -59,6 +59,7 @@ struct simplefb_platform_data {
 	u32 height;
 	u32 stride;
 	const char *format;
+	u8 apert_buf[sizeof(struct apertures_struct) + sizeof(struct aperture)];
 };
 
 #endif /* __PLATFORM_DATA_SIMPLEFB_H__ */
-- 
1.8.5.3

