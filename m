Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaD3CLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:11:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbaD3CLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:11:46 -0400
Date: Wed, 30 Apr 2014 10:13:03 +0800
From: Dave Young <dyoung@redhat.com>
To: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] earlyprintk=efi,keep fix
Message-ID: <20140430021303.GA12316@darkstar.redhat.com>
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

To fix this issue, I added one early initcall efi_ioremap_fb which will map the whole
efi fb for later use. OTOH, adding a wrapper function efi_ioremap which will call
early_ioremap before ioremap is available.

With this patch applied efi boot ok with earlyprintk=efi,keep console=efi

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/early_printk.c |   54 +++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 12 deletions(-)

--- linux-2.6.orig/arch/x86/platform/efi/early_printk.c
+++ linux-2.6/arch/x86/platform/efi/early_printk.c
@@ -14,8 +14,38 @@
 
 static const struct font_desc *font;
 static u32 efi_x, efi_y;
+static void *efi_fb;
 
-static __init void early_efi_clear_scanline(unsigned int y)
+static __init int efi_ioremap_fb(void)
+{
+	unsigned long base, size;
+
+	base = boot_params.screen_info.lfb_base;
+	size = boot_params.screen_info.lfb_size;
+	efi_fb = ioremap(base, size);
+
+	return efi_fb ? 0 : -ENOMEM;
+}
+early_initcall(efi_ioremap_fb);
+
+static __init_refok void *efi_ioremap(unsigned long start, unsigned long len)
+{
+	unsigned long base;
+
+	base = boot_params.screen_info.lfb_base;
+	if (efi_fb)
+		return (efi_fb + start - base);
+	else
+		return early_ioremap(start, len);
+}
+
+static __init_refok void efi_iounmap(void *addr, unsigned long len)
+{
+	if (!efi_fb)
+		early_iounmap(addr, len);
+}
+
+static void early_efi_clear_scanline(unsigned int y)
 {
 	unsigned long base, *dst;
 	u16 len;
@@ -23,15 +53,15 @@ static __init void early_efi_clear_scanl
 	base = boot_params.screen_info.lfb_base;
 	len = boot_params.screen_info.lfb_linelength;
 
-	dst = early_ioremap(base + y*len, len);
+	dst = efi_ioremap(base + y*len, len);
 	if (!dst)
 		return;
 
 	memset(dst, 0, len);
-	early_iounmap(dst, len);
+	efi_iounmap(dst, len);
 }
 
-static __init void early_efi_scroll_up(void)
+static void early_efi_scroll_up(void)
 {
 	unsigned long base, *dst, *src;
 	u16 len;
@@ -42,20 +72,20 @@ static __init void early_efi_scroll_up(v
 	height = boot_params.screen_info.lfb_height;
 
 	for (i = 0; i < height - font->height; i++) {
-		dst = early_ioremap(base + i*len, len);
+		dst = efi_ioremap(base + i*len, len);
 		if (!dst)
 			return;
 
-		src = early_ioremap(base + (i + font->height) * len, len);
+		src = efi_ioremap(base + (i + font->height) * len, len);
 		if (!src) {
-			early_iounmap(dst, len);
+			efi_iounmap(dst, len);
 			return;
 		}
 
 		memmove(dst, src, len);
 
-		early_iounmap(src, len);
-		early_iounmap(dst, len);
+		efi_iounmap(src, len);
+		efi_iounmap(dst, len);
 	}
 }
 
@@ -79,7 +109,7 @@ static void early_efi_write_char(u32 *ds
 	}
 }
 
-static __init void
+static void
 early_efi_write(struct console *con, const char *str, unsigned int num)
 {
 	struct screen_info *si;
@@ -109,7 +139,7 @@ early_efi_write(struct console *con, con
 		for (h = 0; h < font->height; h++) {
 			unsigned int n, x;
 
-			dst = early_ioremap(base + (efi_y + h) * len, len);
+			dst = efi_ioremap(base + (efi_y + h) * len, len);
 			if (!dst)
 				return;
 
@@ -123,7 +153,7 @@ early_efi_write(struct console *con, con
 				s++;
 			}
 
-			early_iounmap(dst, len);
+			efi_iounmap(dst, len);
 		}
 
 		num -= count;
