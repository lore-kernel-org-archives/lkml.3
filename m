Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbaAWSSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:18:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224AbaAWSSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:18:48 -0500
Date: Thu, 23 Jan 2014 13:18:47 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/10] framebuffer: fix cfb_copyarea
In-Reply-To: <alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function cfb_copyarea is buggy when the copy operation is not aligned on
long boundary (4 bytes on 32-bit machines, 8 bytes on 64-bit machines).

How to reproduce:
- use x86-64 machine
- use a framebuffer driver without acceleration (for example uvesafb)
- set the framebuffer to 8-bit depth
	(for example fbset -a 1024x768-60 -depth 8)
- load a font with character width that is not a multiple of 8 pixels
	note: the console-tools package cannot load a font that has
	width different from 8 pixels. You need to install the packages
	"kbd" and "console-terminus" and use the program "setfont" to
	set font width (for example: setfont Uni2-Terminus20x10)
- move some text left and right on the bash command line and you get a
	screen corruption

To expose more bugs, put this line to the end of uvesafb_init_info:
info->flags |= FBINFO_HWACCEL_COPYAREA | FBINFO_READS_FAST;
- Now framebuffer console will use cfb_copyarea for console scrolling.
You get a screen corruption when console is scrolled.

This patch is a rewrite of cfb_copyarea. It fixes the bugs, with this
patch, console scrolling in 8-bit depth with a font width that is not a
multiple of 8 pixels works fine.

The cfb_copyarea code was very buggy and it looks like it was written
and never tried with non-8-pixel font.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/video/cfbcopyarea.c |  153 ++++++++++++++++++++++----------------------
 1 file changed, 78 insertions(+), 75 deletions(-)

Index: linux-3.4.3-fast/drivers/video/cfbcopyarea.c
===================================================================
--- linux-3.4.3-fast.orig/drivers/video/cfbcopyarea.c	2012-07-02 02:02:08.000000000 +0200
+++ linux-3.4.3-fast/drivers/video/cfbcopyarea.c	2012-07-02 02:03:33.000000000 +0200
@@ -43,13 +43,22 @@
      */
 
 static void
-bitcpy(struct fb_info *p, unsigned long __iomem *dst, int dst_idx,
-		const unsigned long __iomem *src, int src_idx, int bits,
+bitcpy(struct fb_info *p, unsigned long __iomem *dst, unsigned dst_idx,
+		const unsigned long __iomem *src, unsigned src_idx, int bits,
 		unsigned n, u32 bswapmask)
 {
 	unsigned long first, last;
 	int const shift = dst_idx-src_idx;
-	int left, right;
+
+#if 0
+	/*
+	 * If you suspect bug in this function, compare it with this simple
+	 * memmove implementation.
+	 */
+	fb_memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
+		   (char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
+	return;
+#endif
 
 	first = fb_shifted_pixels_mask_long(p, dst_idx, bswapmask);
 	last = ~fb_shifted_pixels_mask_long(p, (dst_idx+n) % bits, bswapmask);
@@ -98,9 +107,8 @@ bitcpy(struct fb_info *p, unsigned long
 		unsigned long d0, d1;
 		int m;
 
-		right = shift & (bits - 1);
-		left = -shift & (bits - 1);
-		bswapmask &= shift;
+		int const left = shift & (bits - 1);
+		int const right = -shift & (bits - 1);
 
 		if (dst_idx+n <= bits) {
 			// Single destination word
@@ -110,15 +118,15 @@ bitcpy(struct fb_info *p, unsigned long
 			d0 = fb_rev_pixels_in_long(d0, bswapmask);
 			if (shift > 0) {
 				// Single source word
-				d0 >>= right;
+				d0 <<= left;
 			} else if (src_idx+n <= bits) {
 				// Single source word
-				d0 <<= left;
+				d0 >>= right;
 			} else {
 				// 2 source words
 				d1 = FB_READL(src + 1);
 				d1 = fb_rev_pixels_in_long(d1, bswapmask);
-				d0 = d0<<left | d1>>right;
+				d0 = d0 >> right | d1 << left;
 			}
 			d0 = fb_rev_pixels_in_long(d0, bswapmask);
 			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
@@ -135,60 +143,59 @@ bitcpy(struct fb_info *p, unsigned long
 			if (shift > 0) {
 				// Single source word
 				d1 = d0;
-				d0 >>= right;
-				dst++;
+				d0 <<= left;
 				n -= bits - dst_idx;
 			} else {
 				// 2 source words
 				d1 = FB_READL(src++);
 				d1 = fb_rev_pixels_in_long(d1, bswapmask);
 
-				d0 = d0<<left | d1>>right;
-				dst++;
+				d0 = d0 >> right | d1 << left;
 				n -= bits - dst_idx;
 			}
 			d0 = fb_rev_pixels_in_long(d0, bswapmask);
 			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
 			d0 = d1;
+			dst++;
 
 			// Main chunk
 			m = n % bits;
 			n /= bits;
 			while ((n >= 4) && !bswapmask) {
 				d1 = FB_READL(src++);
-				FB_WRITEL(d0 << left | d1 >> right, dst++);
+				FB_WRITEL(d0 >> right | d1 << left, dst++);
 				d0 = d1;
 				d1 = FB_READL(src++);
-				FB_WRITEL(d0 << left | d1 >> right, dst++);
+				FB_WRITEL(d0 >> right | d1 << left, dst++);
 				d0 = d1;
 				d1 = FB_READL(src++);
-				FB_WRITEL(d0 << left | d1 >> right, dst++);
+				FB_WRITEL(d0 >> right | d1 << left, dst++);
 				d0 = d1;
 				d1 = FB_READL(src++);
-				FB_WRITEL(d0 << left | d1 >> right, dst++);
+				FB_WRITEL(d0 >> right | d1 << left, dst++);
 				d0 = d1;
 				n -= 4;
 			}
 			while (n--) {
 				d1 = FB_READL(src++);
 				d1 = fb_rev_pixels_in_long(d1, bswapmask);
-				d0 = d0 << left | d1 >> right;
+				d0 = d0 >> right | d1 << left;
 				d0 = fb_rev_pixels_in_long(d0, bswapmask);
 				FB_WRITEL(d0, dst++);
 				d0 = d1;
 			}
 
 			// Trailing bits
-			if (last) {
-				if (m <= right) {
+			if (m) {
+				if (m <= bits - right) {
 					// Single source word
-					d0 <<= left;
+					d0 >>= right;
 				} else {
 					// 2 source words
 					d1 = FB_READL(src);
 					d1 = fb_rev_pixels_in_long(d1,
 								bswapmask);
-					d0 = d0<<left | d1>>right;
+					d0 = d0 >> right | d1 << left;
 				}
 				d0 = fb_rev_pixels_in_long(d0, bswapmask);
 				FB_WRITEL(comp(d0, FB_READL(dst), last), dst);
@@ -202,43 +209,46 @@ bitcpy(struct fb_info *p, unsigned long
      */
 
 static void
-bitcpy_rev(struct fb_info *p, unsigned long __iomem *dst, int dst_idx,
-		const unsigned long __iomem *src, int src_idx, int bits,
+bitcpy_rev(struct fb_info *p, unsigned long __iomem *dst, unsigned dst_idx,
+		const unsigned long __iomem *src, unsigned src_idx, int bits,
 		unsigned n, u32 bswapmask)
 {
 	unsigned long first, last;
 	int shift;
 
-	dst += (n-1)/bits;
-	src += (n-1)/bits;
-	if ((n-1) % bits) {
-		dst_idx += (n-1) % bits;
-		dst += dst_idx >> (ffs(bits) - 1);
-		dst_idx &= bits - 1;
-		src_idx += (n-1) % bits;
-		src += src_idx >> (ffs(bits) - 1);
-		src_idx &= bits - 1;
-	}
+#if 0
+	/*
+	 * If you suspect bug in this function, compare it with this simple
+	 * memmove implementation.
+	 */
+	fb_memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
+		   (char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
+	return;
+#endif
+
+	dst += (dst_idx + n - 1) / bits;
+	src += (src_idx + n - 1) / bits;
+	dst_idx = (dst_idx + n - 1) % bits;
+	src_idx = (src_idx + n - 1) % bits;
 
 	shift = dst_idx-src_idx;
 
-	first = fb_shifted_pixels_mask_long(p, bits - 1 - dst_idx, bswapmask);
-	last = ~fb_shifted_pixels_mask_long(p, bits - 1 - ((dst_idx-n) % bits),
-					    bswapmask);
+	first = ~fb_shifted_pixels_mask_long(p, (dst_idx + 1) % bits, bswapmask);
+	last = fb_shifted_pixels_mask_long(p, (bits + dst_idx + 1 - n) % bits, bswapmask);
 
 	if (!shift) {
 		// Same alignment for source and dest
 
 		if ((unsigned long)dst_idx+1 >= n) {
 			// Single word
-			if (last)
-				first &= last;
-			FB_WRITEL( comp( FB_READL(src), FB_READL(dst), first), dst);
+			if (first)
+				last &= first;
+			FB_WRITEL( comp( FB_READL(src), FB_READL(dst), last), dst);
 		} else {
 			// Multiple destination words
 
 			// Leading bits
-			if (first != ~0UL) {
+			if (first) {
 				FB_WRITEL( comp( FB_READL(src), FB_READL(dst), first), dst);
 				dst--;
 				src--;
@@ -262,7 +272,7 @@ bitcpy_rev(struct fb_info *p, unsigned l
 				FB_WRITEL(FB_READL(src--), dst--);
 
 			// Trailing bits
-			if (last)
+			if (last != -1UL)
 				FB_WRITEL( comp( FB_READL(src), FB_READL(dst), last), dst);
 		}
 	} else {
@@ -270,29 +280,28 @@ bitcpy_rev(struct fb_info *p, unsigned l
 		unsigned long d0, d1;
 		int m;
 
-		int const left = -shift & (bits-1);
-		int const right = shift & (bits-1);
-		bswapmask &= shift;
+		int const left = shift & (bits-1);
+		int const right = -shift & (bits-1);
 
 		if ((unsigned long)dst_idx+1 >= n) {
 			// Single destination word
-			if (last)
-				first &= last;
+			if (first)
+				last &= first;
 			d0 = FB_READL(src);
 			if (shift < 0) {
 				// Single source word
-				d0 <<= left;
+				d0 >>= right;
 			} else if (1+(unsigned long)src_idx >= n) {
 				// Single source word
-				d0 >>= right;
+				d0 <<= left;
 			} else {
 				// 2 source words
 				d1 = FB_READL(src - 1);
 				d1 = fb_rev_pixels_in_long(d1, bswapmask);
-				d0 = d0>>right | d1<<left;
+				d0 = d0 << left | d1 >> right;
 			}
 			d0 = fb_rev_pixels_in_long(d0, bswapmask);
-			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
+			FB_WRITEL(comp(d0, FB_READL(dst), last), dst);
 		} else {
 			// Multiple destination words
 			/** We must always remember the last value read, because in case
@@ -307,12 +316,12 @@ bitcpy_rev(struct fb_info *p, unsigned l
 			if (shift < 0) {
 				// Single source word
 				d1 = d0;
-				d0 <<= left;
+				d0 >>= right;
 			} else {
 				// 2 source words
 				d1 = FB_READL(src--);
 				d1 = fb_rev_pixels_in_long(d1, bswapmask);
-				d0 = d0>>right | d1<<left;
+				d0 = d0 << left | d1 >> right;
 			}
 			d0 = fb_rev_pixels_in_long(d0, bswapmask);
 			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
@@ -325,39 +334,39 @@ bitcpy_rev(struct fb_info *p, unsigned l
 			n /= bits;
 			while ((n >= 4) && !bswapmask) {
 				d1 = FB_READL(src--);
-				FB_WRITEL(d0 >> right | d1 << left, dst--);
+				FB_WRITEL(d0 << left | d1 >> right, dst--);
 				d0 = d1;
 				d1 = FB_READL(src--);
-				FB_WRITEL(d0 >> right | d1 << left, dst--);
+				FB_WRITEL(d0 << left | d1 >> right, dst--);
 				d0 = d1;
 				d1 = FB_READL(src--);
-				FB_WRITEL(d0 >> right | d1 << left, dst--);
+				FB_WRITEL(d0 << left | d1 >> right, dst--);
 				d0 = d1;
 				d1 = FB_READL(src--);
-				FB_WRITEL(d0 >> right | d1 << left, dst--);
+				FB_WRITEL(d0 << left | d1 >> right, dst--);
 				d0 = d1;
 				n -= 4;
 			}
 			while (n--) {
 				d1 = FB_READL(src--);
 				d1 = fb_rev_pixels_in_long(d1, bswapmask);
-				d0 = d0 >> right | d1 << left;
+				d0 = d0 << left | d1 >> right;
 				d0 = fb_rev_pixels_in_long(d0, bswapmask);
 				FB_WRITEL(d0, dst--);
 				d0 = d1;
 			}
 
 			// Trailing bits
-			if (last) {
-				if (m <= left) {
+			if (m) {
+				if (m <= bits - left) {
 					// Single source word
-					d0 >>= right;
+					d0 <<= left;
 				} else {
 					// 2 source words
 					d1 = FB_READL(src);
 					d1 = fb_rev_pixels_in_long(d1,
 								bswapmask);
-					d0 = d0>>right | d1<<left;
+					d0 = d0 << left | d1 >> right;
 				}
 				d0 = fb_rev_pixels_in_long(d0, bswapmask);
 				FB_WRITEL(comp(d0, FB_READL(dst), last), dst);
@@ -371,9 +380,9 @@ void cfb_copyarea(struct fb_info *p, con
 	u32 dx = area->dx, dy = area->dy, sx = area->sx, sy = area->sy;
 	u32 height = area->height, width = area->width;
 	unsigned long const bits_per_line = p->fix.line_length*8u;
-	unsigned long __iomem *dst = NULL, *src = NULL;
+	unsigned long __iomem *base = NULL;
 	int bits = BITS_PER_LONG, bytes = bits >> 3;
-	int dst_idx = 0, src_idx = 0, rev_copy = 0;
+	unsigned dst_idx = 0, src_idx = 0, rev_copy = 0;
 	u32 bswapmask = fb_compute_bswapmask(p);
 
 	if (p->state != FBINFO_STATE_RUNNING)
@@ -389,7 +398,7 @@ void cfb_copyarea(struct fb_info *p, con
 
 	// split the base of the framebuffer into a long-aligned address and the
 	// index of the first bit
-	dst = src = (unsigned long __iomem *)((unsigned long)p->screen_base & ~(bytes-1));
+	base = (unsigned long __iomem *)((unsigned long)p->screen_base & ~(bytes-1));
 	dst_idx = src_idx = 8*((unsigned long)p->screen_base & (bytes-1));
 	// add offset of source and target area
 	dst_idx += dy*bits_per_line + dx*p->var.bits_per_pixel;
@@ -402,20 +411,14 @@ void cfb_copyarea(struct fb_info *p, con
 		while (height--) {
 			dst_idx -= bits_per_line;
 			src_idx -= bits_per_line;
-			dst += dst_idx >> (ffs(bits) - 1);
-			dst_idx &= (bytes - 1);
-			src += src_idx >> (ffs(bits) - 1);
-			src_idx &= (bytes - 1);
-			bitcpy_rev(p, dst, dst_idx, src, src_idx, bits,
+			bitcpy_rev(p, base + (dst_idx / bits), dst_idx % bits,
+				base + (src_idx / bits), src_idx % bits, bits,
 				width*p->var.bits_per_pixel, bswapmask);
 		}
 	} else {
 		while (height--) {
-			dst += dst_idx >> (ffs(bits) - 1);
-			dst_idx &= (bytes - 1);
-			src += src_idx >> (ffs(bits) - 1);
-			src_idx &= (bytes - 1);
-			bitcpy(p, dst, dst_idx, src, src_idx, bits,
+			bitcpy(p, base + (dst_idx / bits), dst_idx % bits,
+				base + (src_idx / bits), src_idx % bits, bits,
 				width*p->var.bits_per_pixel, bswapmask);
 			dst_idx += bits_per_line;
 			src_idx += bits_per_line;

