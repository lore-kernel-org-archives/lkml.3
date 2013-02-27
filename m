Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501Ab3B0AUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:20:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab3B0AJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: [ 44/86] drm/udl: make usage as a console safer
Date: Tue, 26 Feb 2013 16:07:52 -0800
Message-Id: <20130226235917.471054408@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit bcb39af4486be07e896fc374a2336bad3104ae0a upstream.

Okay you don't really want to use udl devices as your console, but if
you are unlucky enough to do so, you run into a lot of schedule while atomic
due to printk being called from all sorts of funky places. So check if we
are in an atomic context, and queue the damage for later, the next printk
should cause it to appear. This isn't ideal, but it is simple, and seems to
work okay in my testing here.

(dirty area idea came from xenfb)

fixes a bunch of sleeping while atomic issues running fbcon on udl devices.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/udl/udl_drv.h |    2 +
 drivers/gpu/drm/udl/udl_fb.c  |   44 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 42 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/udl/udl_drv.h
+++ b/drivers/gpu/drm/udl/udl_drv.h
@@ -74,6 +74,8 @@ struct udl_framebuffer {
 	struct drm_framebuffer base;
 	struct udl_gem_object *obj;
 	bool active_16; /* active on the 16-bit channel */
+	int x1, y1, x2, y2; /* dirty rect */
+	spinlock_t dirty_lock;
 };
 
 #define to_udl_fb(x) container_of(x, struct udl_framebuffer, base)
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -153,6 +153,9 @@ int udl_handle_damage(struct udl_framebu
 	struct urb *urb;
 	int aligned_x;
 	int bpp = (fb->base.bits_per_pixel / 8);
+	int x2, y2;
+	bool store_for_later = false;
+	unsigned long flags;
 
 	if (!fb->active_16)
 		return 0;
@@ -160,8 +163,6 @@ int udl_handle_damage(struct udl_framebu
 	if (!fb->obj->vmapping)
 		udl_gem_vmap(fb->obj);
 
-	start_cycles = get_cycles();
-
 	aligned_x = DL_ALIGN_DOWN(x, sizeof(unsigned long));
 	width = DL_ALIGN_UP(width + (x-aligned_x), sizeof(unsigned long));
 	x = aligned_x;
@@ -171,19 +172,53 @@ int udl_handle_damage(struct udl_framebu
 	    (y + height > fb->base.height))
 		return -EINVAL;
 
+	/* if we are in atomic just store the info
+	   can't test inside spin lock */
+	if (in_atomic())
+		store_for_later = true;
+
+	x2 = x + width - 1;
+	y2 = y + height - 1;
+
+	spin_lock_irqsave(&fb->dirty_lock, flags);
+
+	if (fb->y1 < y)
+		y = fb->y1;
+	if (fb->y2 > y2)
+		y2 = fb->y2;
+	if (fb->x1 < x)
+		x = fb->x1;
+	if (fb->x2 > x2)
+		x2 = fb->x2;
+
+	if (store_for_later) {
+		fb->x1 = x;
+		fb->x2 = x2;
+		fb->y1 = y;
+		fb->y2 = y2;
+		spin_unlock_irqrestore(&fb->dirty_lock, flags);
+		return 0;
+	}
+
+	fb->x1 = fb->y1 = INT_MAX;
+	fb->x2 = fb->y2 = 0;
+
+	spin_unlock_irqrestore(&fb->dirty_lock, flags);
+	start_cycles = get_cycles();
+
 	urb = udl_get_urb(dev);
 	if (!urb)
 		return 0;
 	cmd = urb->transfer_buffer;
 
-	for (i = y; i < y + height ; i++) {
+	for (i = y; i <= y2 ; i++) {
 		const int line_offset = fb->base.pitches[0] * i;
 		const int byte_offset = line_offset + (x * bpp);
 		const int dev_byte_offset = (fb->base.width * bpp * i) + (x * bpp);
 		if (udl_render_hline(dev, bpp, &urb,
 				     (char *) fb->obj->vmapping,
 				     &cmd, byte_offset, dev_byte_offset,
-				     width * bpp,
+				     (x2 - x + 1) * bpp,
 				     &bytes_identical, &bytes_sent))
 			goto error;
 	}
@@ -408,6 +443,7 @@ udl_framebuffer_init(struct drm_device *
 {
 	int ret;
 
+	spin_lock_init(&ufb->dirty_lock);
 	ufb->obj = obj;
 	ret = drm_framebuffer_init(dev, &ufb->base, &udlfb_funcs);
 	drm_helper_mode_fill_fb_struct(&ufb->base, mode_cmd);


