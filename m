Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbbAMJ0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:26:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbbAMJZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:25:36 -0500
Date: Tue, 13 Jan 2015 09:25:56 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Thomas Voegtle <tv@lio96.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [3.16.y-ckt stable] Linux 3.16.7-ckt4 stable review
Message-ID: <20150113092556.GA2304@charon>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
 <alpine.LSU.2.11.1501122121450.16281@er-systems.de>
 <20150112215941.GJ2455@charon>
 <alpine.LSU.2.11.1501130035110.20153@er-systems.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.11.1501130035110.20153@er-systems.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 12:35:58AM +0100, Thomas Voegtle wrote:
> On Mon, 12 Jan 2015, Luis Henriques wrote:
> 
> >On Mon, Jan 12, 2015 at 09:30:45PM +0100, Thomas Voegtle wrote:
> >>On Mon, 12 Jan 2015, Luis Henriques wrote:
> >>
> >>>This is the start of the review cycle for the Linux 3.16.7-ckt4 stable kernel.
> >>>
> >>>This version contains 216 new patches, summarized below.  The new patches are
> >>>posted as replies to this message and also available in this git branch:
> >>>
> >>>http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.16.y-review;a=shortlog
> >>>
> >>>git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.16.y-review
> >>>
> >>>The review period for version 3.16.7-ckt4 will be open for the next three days.
> >>>To report a problem, please reply to the relevant follow-up patch message.
> >>>
> >>>For more information about the Linux 3.16.y-ckt extended stable kernel version,
> >>>see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .
> >>
> >>
> >>Something is wrong with drm/i915 (I guess). I had a terrible memleak on Xorg
> >>when using mplayer using more and more RAM, and then the system is swapping
> >>itself to death.
> >>
> >>I'm using a openSUSE 13.1 (x86_64) on a Baytrail J1900 (this is Intel HD
> >>Gen7).
> >>
> >>
> >
> >Thank you for reporting, Thomas.  Can you please confirm that this is
> >actually a regression in 3.16.7-ckt4 (i.e., that you can't reproduce
> >it in 3.16.7-ckt3)?  If so, is it possible to bisecting it?
> 
> 
> 3.16.7-ckt3 was fine for me.
> 
> I tried to revert the drm/i915 patches in the review branch, and I got lucky
> with (only) reverting cb58c663d940a "drm/i915: Disallow pin ioctl completely
> for kms drivers".
> 
> No clue, why reverting these few lines helps, but then I have no memleak.
> 
> 
>      Thomas
> 

Thank a lot for narrowing this down, Thomas!  The text in that commit
(upstream commit d472fcc8379c) may actually provide an hint for this
issue.  It asks backporters to make sure they include both

commit b45305fce5bb1abec263fcff9d81ebecd6306ede
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon Dec 17 16:21:27 2012 +0100

    drm/i915: Implement workaround for broken CS tlb on i830/845

and

commit c4d69da167fa967749aeb70bc0e94a457e5d00c1
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Sep 8 14:25:41 2014 +0100

    drm/i915: Evict CS TLBs between batches

For some reason, this second commit (which was tagged for stable!)
isn't in 3.16, and I completely missed that.

Would you be able to verify that adding this commit (backport attached
bellow) fixes the issue?

Cheers,
--
Luís


>From e6407a03c0bd6a889997e365518863cdd96215bd Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 8 Sep 2014 14:25:41 +0100
Subject: drm/i915: Evict CS TLBs between batches
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit c4d69da167fa967749aeb70bc0e94a457e5d00c1 upstream.

Running igt, I was encountering the invalid TLB bug on my 845g, despite
that it was using the CS workaround. Examining the w/a buffer in the
error state, showed that the copy from the user batch into the
workaround itself was suffering from the invalid TLB bug (the first
cacheline was broken with the first two words reversed). Time to try a
fresh approach. This extends the workaround to write into each page of
our scratch buffer in order to overflow the TLB and evict the invalid
entries. This could be refined to only do so after we update the GTT,
but for simplicity, we do it before each batch.

I suspect this supersedes our current workaround, but for safety keep
doing both.

v2: The magic number shall be 2.

This doesn't conclusively prove that it is the mythical TLB bug we've
been trying to workaround for so long, that it requires touching a number
of pages to prevent the corruption indicates to me that it is TLB
related, but the corruption (the reversed cacheline) is more subtle than
a TLB bug, where we would expect it to read the wrong page entirely.

Oh well, it prevents a reliable hang for me and so probably for others
as well.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h         | 12 ++++--
 drivers/gpu/drm/i915/intel_ringbuffer.c | 66 +++++++++++++++++++--------------
 2 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 4fcff20cab98..37dacd14c208 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -330,16 +330,20 @@
 #define GFX_OP_DESTBUFFER_INFO	 ((0x3<<29)|(0x1d<<24)|(0x8e<<16)|1)
 #define GFX_OP_DRAWRECT_INFO     ((0x3<<29)|(0x1d<<24)|(0x80<<16)|(0x3))
 #define GFX_OP_DRAWRECT_INFO_I965  ((0x7900<<16)|0x2)
-#define SRC_COPY_BLT_CMD                ((2<<29)|(0x43<<22)|4)
+
+#define COLOR_BLT_CMD			(2<<29 | 0x40<<22 | (5-2))
+#define SRC_COPY_BLT_CMD		((2<<29)|(0x43<<22)|4)
 #define XY_SRC_COPY_BLT_CMD		((2<<29)|(0x53<<22)|6)
 #define XY_MONO_SRC_COPY_IMM_BLT	((2<<29)|(0x71<<22)|5)
-#define XY_SRC_COPY_BLT_WRITE_ALPHA	(1<<21)
-#define XY_SRC_COPY_BLT_WRITE_RGB	(1<<20)
+#define   BLT_WRITE_A			(2<<20)
+#define   BLT_WRITE_RGB			(1<<20)
+#define   BLT_WRITE_RGBA		(BLT_WRITE_RGB | BLT_WRITE_A)
 #define   BLT_DEPTH_8			(0<<24)
 #define   BLT_DEPTH_16_565		(1<<24)
 #define   BLT_DEPTH_16_1555		(2<<24)
 #define   BLT_DEPTH_32			(3<<24)
-#define   BLT_ROP_GXCOPY		(0xcc<<16)
+#define   BLT_ROP_SRC_COPY		(0xcc<<16)
+#define   BLT_ROP_COLOR_COPY		(0xf0<<16)
 #define XY_SRC_COPY_BLT_SRC_TILED	(1<<15) /* 965+ only */
 #define XY_SRC_COPY_BLT_DST_TILED	(1<<11) /* 965+ only */
 #define CMD_OP_DISPLAYBUFFER_INFO ((0x0<<29)|(0x14<<23)|2)
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index db8e92f27289..6a7a35acdfa7 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1247,54 +1247,66 @@ i965_dispatch_execbuffer(struct intel_engine_cs *ring,
 
 /* Just userspace ABI convention to limit the wa batch bo to a resonable size */
 #define I830_BATCH_LIMIT (256*1024)
+#define I830_TLB_ENTRIES (2)
+#define I830_WA_SIZE max(I830_TLB_ENTRIES*4096, I830_BATCH_LIMIT)
 static int
 i830_dispatch_execbuffer(struct intel_engine_cs *ring,
 				u64 offset, u32 len,
 				unsigned flags)
 {
+	u32 cs_offset = ring->scratch.gtt_offset;
 	int ret;
 
-	if (flags & I915_DISPATCH_PINNED) {
-		ret = intel_ring_begin(ring, 4);
-		if (ret)
-			return ret;
+	ret = intel_ring_begin(ring, 6);
+	if (ret)
+		return ret;
 
-		intel_ring_emit(ring, MI_BATCH_BUFFER);
-		intel_ring_emit(ring, offset | (flags & I915_DISPATCH_SECURE ? 0 : MI_BATCH_NON_SECURE));
-		intel_ring_emit(ring, offset + len - 8);
-		intel_ring_emit(ring, MI_NOOP);
-		intel_ring_advance(ring);
-	} else {
-		u32 cs_offset = ring->scratch.gtt_offset;
+	/* Evict the invalid PTE TLBs */
+	intel_ring_emit(ring, COLOR_BLT_CMD | BLT_WRITE_RGBA);
+	intel_ring_emit(ring, BLT_DEPTH_32 | BLT_ROP_COLOR_COPY | 4096);
+	intel_ring_emit(ring, I830_TLB_ENTRIES << 16 | 4); /* load each page */
+	intel_ring_emit(ring, cs_offset);
+	intel_ring_emit(ring, 0xdeadbeef);
+	intel_ring_emit(ring, MI_NOOP);
+	intel_ring_advance(ring);
 
+	if ((flags & I915_DISPATCH_PINNED) == 0) {
 		if (len > I830_BATCH_LIMIT)
 			return -ENOSPC;
 
-		ret = intel_ring_begin(ring, 9+3);
+		ret = intel_ring_begin(ring, 6 + 2);
 		if (ret)
 			return ret;
-		/* Blit the batch (which has now all relocs applied) to the stable batch
-		 * scratch bo area (so that the CS never stumbles over its tlb
-		 * invalidation bug) ... */
-		intel_ring_emit(ring, XY_SRC_COPY_BLT_CMD |
-				XY_SRC_COPY_BLT_WRITE_ALPHA |
-				XY_SRC_COPY_BLT_WRITE_RGB);
-		intel_ring_emit(ring, BLT_DEPTH_32 | BLT_ROP_GXCOPY | 4096);
-		intel_ring_emit(ring, 0);
-		intel_ring_emit(ring, (DIV_ROUND_UP(len, 4096) << 16) | 1024);
+
+		/* Blit the batch (which has now all relocs applied) to the
+		 * stable batch scratch bo area (so that the CS never
+		 * stumbles over its tlb invalidation bug) ...
+		 */
+		intel_ring_emit(ring, SRC_COPY_BLT_CMD | BLT_WRITE_RGBA);
+		intel_ring_emit(ring, BLT_DEPTH_32 | BLT_ROP_SRC_COPY | 4096);
+		intel_ring_emit(ring, DIV_ROUND_UP(len, 4096) << 16 | 1024);
 		intel_ring_emit(ring, cs_offset);
-		intel_ring_emit(ring, 0);
 		intel_ring_emit(ring, 4096);
 		intel_ring_emit(ring, offset);
+
 		intel_ring_emit(ring, MI_FLUSH);
+		intel_ring_emit(ring, MI_NOOP);
+		intel_ring_advance(ring);
 
 		/* ... and execute it. */
-		intel_ring_emit(ring, MI_BATCH_BUFFER);
-		intel_ring_emit(ring, cs_offset | (flags & I915_DISPATCH_SECURE ? 0 : MI_BATCH_NON_SECURE));
-		intel_ring_emit(ring, cs_offset + len - 8);
-		intel_ring_advance(ring);
+		offset = cs_offset;
 	}
 
+	ret = intel_ring_begin(ring, 4);
+	if (ret)
+		return ret;
+
+	intel_ring_emit(ring, MI_BATCH_BUFFER);
+	intel_ring_emit(ring, offset | (flags & I915_DISPATCH_SECURE ? 0 : MI_BATCH_NON_SECURE));
+	intel_ring_emit(ring, offset + len - 8);
+	intel_ring_emit(ring, MI_NOOP);
+	intel_ring_advance(ring);
+
 	return 0;
 }
 
@@ -2033,7 +2045,7 @@ int intel_init_render_ring_buffer(struct drm_device *dev)
 		struct drm_i915_gem_object *obj;
 		int ret;
 
-		obj = i915_gem_alloc_object(dev, I830_BATCH_LIMIT);
+		obj = i915_gem_alloc_object(dev, I830_WA_SIZE);
 		if (obj == NULL) {
 			DRM_ERROR("Failed to allocate batch bo\n");
 			return -ENOMEM;
-- 
2.1.4

