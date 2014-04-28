Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaD1BbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42980 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696AbaD1B3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tomi Valkeinen" <tomi.valkeinen@ti.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.267579113@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 29/94] mach64: fix cursor when character width is not
 a multiple of 8 pixels
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/aty/mach64_cursor.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/video/aty/mach64_cursor.c
+++ b/drivers/video/aty/mach64_cursor.c
@@ -5,6 +5,7 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include "../fb_draw.h"
 
 #include <asm/io.h>
 
@@ -157,24 +158,33 @@ static int atyfb_cursor(struct fb_info *
 
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

