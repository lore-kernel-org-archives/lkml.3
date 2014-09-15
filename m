Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbaIOUm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:42:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbaIOTgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mario Kleiner <mario.kleiner.de@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.16 153/158] drm/nouveau: Dis/Enable vblank irqs during suspend/resume.
Date: Mon, 15 Sep 2014 12:26:32 -0700
Message-Id: <20140915192547.460124656@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Kleiner <mario.kleiner.de@gmail.com>

commit 9cba5efab5a8145ae6c52ea273553f069c294482 upstream.

Vblank irqs don't get disabled during suspend or driver
unload, which causes irq delivery after "suspend" or
driver unload, at least until the gpu is powered off.
This could race with drm_vblank_cleanup() in the case
of nouveau and cause a use-after-free bug if the driver
is unloaded.

More annoyingly during everyday use, at least on nv50
display engine (likely also others), vblank irqs are
off after a resume from suspend, but the drm doesn't
know this, so all vblank related functionality is dead
after a resume. E.g., all windowed OpenGL clients will
hang at swapbuffers time, as well as many fullscreen
clients in many cases. This makes suspend/resume useless
if one wants to use any OpenGL apps after the resume.

In Linux 3.16, drm_vblank_on() was added, complementing
the older drm_vblank_off()  to solve these problems
elegantly, so use those calls in nouveaus suspend/resume
code.

For kernels 3.8 - 3.15, we need to cherry-pick the
drm_vblank_on() patch to support this patch.

Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_display.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -404,6 +404,11 @@ nouveau_display_fini(struct drm_device *
 {
 	struct nouveau_display *disp = nouveau_display(dev);
 	struct drm_connector *connector;
+	int head;
+
+	/* Make sure that drm and hw vblank irqs get properly disabled. */
+	for (head = 0; head < dev->mode_config.num_crtc; head++)
+		drm_vblank_off(dev, head);
 
 	/* disable hotplug interrupts */
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
@@ -620,6 +625,8 @@ void
 nouveau_display_resume(struct drm_device *dev)
 {
 	struct drm_crtc *crtc;
+	int head;
+
 	nouveau_display_init(dev);
 
 	/* Force CLUT to get re-loaded during modeset */
@@ -629,6 +636,10 @@ nouveau_display_resume(struct drm_device
 		nv_crtc->lut.depth = 0;
 	}
 
+	/* Make sure that drm and hw vblank irqs get resumed if needed. */
+	for (head = 0; head < dev->mode_config.num_crtc; head++)
+		drm_vblank_on(dev, head);
+
 	drm_helper_resume_force_mode(dev);
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {


