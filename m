Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654AbaEMKLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933513AbaEMKLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:45 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 145/182] mach64: fix cursor when character width is not a multiple of 8 pixels
Date: Tue, 13 May 2014 11:28:17 +0200
Message-Id: <740de41995cec6b88eded5f639c4526e95c69664.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 43751a1b8ee2e70ce392bf31ef3133da324e68b3 upstream.

This patch fixes the hardware cursor on mach64 when font width is not a
multiple of 8 pixels.

If you load such a font, the cursor is expanded to the next 8-byte
boundary and a part of the next character after the cursor is not
visible.
For example, when you load a font with 12-pixel width, the cursor width
is 16 pixels and when the cursor is displayed, 4 pixels of the next
character are not visible.

The reason is this: atyfb_cursor is called with proper parameters to
load an image that is 12-pixel wide. However, the number is aligned on
the next 8-pixel boundary on the line
"unsigned int width = (cursor->image.width + 7) >> 3;" and the whole
function acts as it is was loading a 16-pixel image.

This patch fixes it so that the value written to the framebuffer is
padded with 0xaaaa (the transparent pattern) when the image size it not
a multiple of 8 pixels. The transparent pattern causes that the cursor
will not interfere with the next character.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/aty/mach64_cursor.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/video/aty/mach64_cursor.c b/drivers/video/aty/mach64_cursor.c
index 95ec042ddbf8..0fe02e22d9a4 100644
--- a/drivers/video/aty/mach64_cursor.c
+++ b/drivers/video/aty/mach64_cursor.c
@@ -5,6 +5,7 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include "../fb_draw.h"
 
 #include <asm/io.h>
 
@@ -157,24 +158,33 @@ static int atyfb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 
 	    for (i = 0; i < height; i++) {
 		for (j = 0; j < width; j++) {
+			u16 l = 0xaaaa;
 			b = *src++;
 			m = *msk++;
 			switch (cursor->rop) {
 			case ROP_XOR:
 			    // Upper 4 bits of mask data
-			    fb_writeb(cursor_bits_lookup[(b ^ m) >> 4], dst++);
+			    l = cursor_bits_lookup[(b ^ m) >> 4] |
 			    // Lower 4 bits of mask
-			    fb_writeb(cursor_bits_lookup[(b ^ m) & 0x0f],
-				      dst++);
+				    (cursor_bits_lookup[(b ^ m) & 0x0f] << 8);
 			    break;
 			case ROP_COPY:
 			    // Upper 4 bits of mask data
-			    fb_writeb(cursor_bits_lookup[(b & m) >> 4], dst++);
+			    l = cursor_bits_lookup[(b & m) >> 4] |
 			    // Lower 4 bits of mask
-			    fb_writeb(cursor_bits_lookup[(b & m) & 0x0f],
-				      dst++);
+				    (cursor_bits_lookup[(b & m) & 0x0f] << 8);
 			    break;
 			}
+			/*
+			 * If cursor size is not a multiple of 8 characters
+			 * we must pad it with transparent pattern (0xaaaa).
+			 */
+			if ((j + 1) * 8 > cursor->image.width) {
+				l = comp(l, 0xaaaa,
+				    (1 << ((cursor->image.width & 7) * 2)) - 1);
+			}
+			fb_writeb(l & 0xff, dst++);
+			fb_writeb(l >> 8, dst++);
 		}
 		dst += offset;
 	    }
-- 
1.9.3

