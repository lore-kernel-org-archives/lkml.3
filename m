Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaEANO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:14:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbaEANO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:14:28 -0400
Date: Thu, 1 May 2014 21:15:48 +0800
From: Dave Young <dyoung@redhat.com>
To: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] earlyprintk=efi,keep fix
Message-ID: <20140501131548.GA15258@darkstar.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


earlyprintk=efi,keep will cause kernel hangs while freeing initmem like below:
[    2.826089] VFS: Mounted root (ext4 filesystem) readonly on device 254:2.
[    2.846592] devtmpfs: mounted
[    2.856974] Freeing unused kernel memory: 880K (ffffffff817d4000 - ffffffff818b0000)

It is caused by efi earlyprintk use __init function which will be freed later.
Such as early_efi_write is marked as __init, also it will use early_ioremap
which is init function as well.

To fix this issue, I added early initcall early_efi_map_fb which maps the whole
efi fb for later use. OTOH, adding a wrapper function early_efi_map which calls
early_ioremap before ioremap is available.

With this patch applied efi boot ok with earlyprintk=efi,keep console=efi

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/early_printk.c |   83 ++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 19 deletions(-)

--- linux-2.6.orig/arch/x86/platform/efi/early_printk.c
+++ linux-2.6/arch/x86/platform/efi/early_printk.c
@@ -14,48 +14,92 @@
 
 static const struct font_desc *font;
 static u32 efi_x, efi_y;
+static void *efi_fb;
+static bool early_efi_keep;
 
-static __init void early_efi_clear_scanline(unsigned int y)
+/*
+ * efi earlyprintk need use early_ioremap to map the framebuffer.
+ * But early_ioremap is not usable for earlyprintk=efi,keep, ioremap should
+ * be used instead. ioremap will be available after paging_init() which is
+ * earlier than initcall callbacks. Thus adding this early initcall function
+ * early_efi_map_fb to map the whole efi framebuffer.
+ */
+static __init int early_efi_map_fb(void)
 {
-	unsigned long base, *dst;
-	u16 len;
+	unsigned long base, size;
+
+	if (!early_efi_keep)
+		return 0;
 
 	base = boot_params.screen_info.lfb_base;
-	len = boot_params.screen_info.lfb_linelength;
+	size = boot_params.screen_info.lfb_size;
+	efi_fb = ioremap(base, size);
+
+	return efi_fb ? 0 : -ENOMEM;
+}
+early_initcall(early_efi_map_fb);
+
+/*
+ * early_efi_map maps efi framebuffer region [start, start + len -1]
+ * In case earlyprintk=efi,keep we have the whole framebuffer mapped already
+ * so just return the offset efi_fb + start.
+ */
+static __init_refok void *early_efi_map(unsigned long start, unsigned long len)
+{
+	unsigned long base;
+
+	base = boot_params.screen_info.lfb_base;
+
+	if (efi_fb)
+		return (efi_fb + start);
+	else
+		return early_ioremap(base + start, len);
+}
+
+static __init_refok void early_efi_unmap(void *addr, unsigned long len)
+{
+	if (!efi_fb)
+		early_iounmap(addr, len);
+}
 
-	dst = early_ioremap(base + y*len, len);
+static void early_efi_clear_scanline(unsigned int y)
+{
+	unsigned long *dst;
+	u16 len;
+
+	len = boot_params.screen_info.lfb_linelength;
+	dst = early_efi_map(y*len, len);
 	if (!dst)
 		return;
 
 	memset(dst, 0, len);
-	early_iounmap(dst, len);
+	early_efi_unmap(dst, len);
 }
 
-static __init void early_efi_scroll_up(void)
+static void early_efi_scroll_up(void)
 {
-	unsigned long base, *dst, *src;
+	unsigned long *dst, *src;
 	u16 len;
 	u32 i, height;
 
-	base = boot_params.screen_info.lfb_base;
 	len = boot_params.screen_info.lfb_linelength;
 	height = boot_params.screen_info.lfb_height;
 
 	for (i = 0; i < height - font->height; i++) {
-		dst = early_ioremap(base + i*len, len);
+		dst = early_efi_map(i*len, len);
 		if (!dst)
 			return;
 
-		src = early_ioremap(base + (i + font->height) * len, len);
+		src = early_efi_map((i + font->height) * len, len);
 		if (!src) {
-			early_iounmap(dst, len);
+			early_efi_unmap(dst, len);
 			return;
 		}
 
 		memmove(dst, src, len);
 
-		early_iounmap(src, len);
-		early_iounmap(dst, len);
+		early_efi_unmap(src, len);
+		early_efi_unmap(dst, len);
 	}
 }
 
@@ -79,16 +123,14 @@ static void early_efi_write_char(u32 *ds
 	}
 }
 
-static __init void
+static void
 early_efi_write(struct console *con, const char *str, unsigned int num)
 {
 	struct screen_info *si;
-	unsigned long base;
 	unsigned int len;
 	const char *s;
 	void *dst;
 
-	base = boot_params.screen_info.lfb_base;
 	si = &boot_params.screen_info;
 	len = si->lfb_linelength;
 
@@ -109,7 +151,7 @@ early_efi_write(struct console *con, con
 		for (h = 0; h < font->height; h++) {
 			unsigned int n, x;
 
-			dst = early_ioremap(base + (efi_y + h) * len, len);
+			dst = early_efi_map((efi_y + h) * len, len);
 			if (!dst)
 				return;
 
@@ -123,7 +165,7 @@ early_efi_write(struct console *con, con
 				s++;
 			}
 
-			early_iounmap(dst, len);
+			early_efi_unmap(dst, len);
 		}
 
 		num -= count;
@@ -179,6 +221,9 @@ static __init int early_efi_setup(struct
 	for (i = 0; i < (yres - efi_y) / font->height; i++)
 		early_efi_scroll_up();
 
+	/* early_console_register will unset CON_BOOT in case ,keep */
+	if (!(con->flags & CON_BOOT))
+		early_efi_keep = true;
 	return 0;
 }
 
