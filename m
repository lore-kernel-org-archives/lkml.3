Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaEBPjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:39:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43640 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaEBPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 011/151] mach64: fix cursor when character width is not a multiple of 8 pixels
Date: Fri,  2 May 2014 08:36:39 -0700
Message-Id: <1399045139-4531-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/video/aty/mach64_cursor.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/video/aty/mach64_cursor.c b/drivers/video/aty/mach64_cursor.c
index 95ec042..0fe02e2 100644
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
1.9.1

