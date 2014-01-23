Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbaAWSUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:20:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398AbaAWST3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:19:29 -0500
Date: Thu, 23 Jan 2014 13:19:26 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/10] mach64: fix cursor when character width is not a multiple
 of 8 pixels
In-Reply-To: <alpine.LRH.2.02.1401231307120.31739@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1401231308070.31739@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231305390.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231306220.31739@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401231307120.31739@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org

---
 drivers/video/aty/mach64_cursor.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

Index: linux-3.4.3-fast/drivers/video/aty/mach64_cursor.c
===================================================================
--- linux-3.4.3-fast.orig/drivers/video/aty/mach64_cursor.c	2012-07-02 01:15:38.000000000 +0200
+++ linux-3.4.3-fast/drivers/video/aty/mach64_cursor.c	2012-07-02 01:54:10.000000000 +0200
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
+			    	(cursor_bits_lookup[(b ^ m) & 0x0f] << 8);
 			    break;
 			case ROP_COPY:
 			    // Upper 4 bits of mask data
-			    fb_writeb(cursor_bits_lookup[(b & m) >> 4], dst++);
+			    l = cursor_bits_lookup[(b & m) >> 4] |
 			    // Lower 4 bits of mask
-			    fb_writeb(cursor_bits_lookup[(b & m) & 0x0f],
-				      dst++);
+			    	(cursor_bits_lookup[(b & m) & 0x0f] << 8);
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

