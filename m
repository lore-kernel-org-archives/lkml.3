Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965198Ab3GCTIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:08:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33334 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964993Ab3GCTA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:27 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=1g-gDb-BVPYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=hYBlYC7BFs0A:10 a=nAebDoNsAAAA:8 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8 a=FP58Ms26AAAA:8 a=pGLkceISAAAA:8 a=0y8SsgufyrqFZXVPfYcA:9 a=p7eRH5PH6dwA:10 a=wu_e27o_rKQA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=mvM_Y2QwmKl4CTBV:21 a=61s4nJnO7eW_lagJ:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184102.887714858@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Huacai Chen <chenhc@lemote.com>, Binbin Zhou <zhoubb@lemote.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Dave Airlie <airlied@gmail.com>
Subject: [098/141] drm: fix a use-after-free when GPU acceleration disabled
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0098-drm-fix-a-use-after-free-when-GPU-acceleration-disab.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhc@lemote.com>

[ Upstream commit b7ea85a4fed37835eec78a7be3039c8dc22b8178 ]

When GPU acceleration is disabled, drm_vblank_cleanup() will free the
vblank-related data, such as vblank_refcount, vblank_inmodeset, etc.
But we found that drm_vblank_post_modeset() may be called after the
cleanup, which use vblank_refcount and vblank_inmodeset. And this will
cause a kernel panic.

Fix this by return immediately if dev->num_crtcs is zero. This is the
same thing that drm_vblank_pre_modeset() does.

Call trace of a drm_vblank_post_modeset() after drm_vblank_cleanup():
[   62.628906] [<ffffffff804868d0>] drm_vblank_post_modeset+0x34/0xb4
[   62.628906] [<ffffffff804c7008>] atombios_crtc_dpms+0xb4/0x174
[   62.628906] [<ffffffff804c70e0>] atombios_crtc_commit+0x18/0x38
[   62.628906] [<ffffffff8047f038>] drm_crtc_helper_set_mode+0x304/0x3cc
[   62.628906] [<ffffffff8047f92c>] drm_crtc_helper_set_config+0x6d8/0x988
[   62.628906] [<ffffffff8047dd40>] drm_fb_helper_set_par+0x94/0x104
[   62.628906] [<ffffffff80439d14>] fbcon_init+0x424/0x57c
[   62.628906] [<ffffffff8046a638>] visual_init+0xb8/0x118
[   62.628906] [<ffffffff8046b9f8>] take_over_console+0x238/0x384
[   62.628906] [<ffffffff80436df8>] fbcon_takeover+0x7c/0xdc
[   62.628906] [<ffffffff8024fa20>] notifier_call_chain+0x44/0x94
[   62.628906] [<ffffffff8024fcbc>] __blocking_notifier_call_chain+0x48/0x68
[   62.628906] [<ffffffff8042d990>] register_framebuffer+0x228/0x260
[   62.628906] [<ffffffff8047e010>] drm_fb_helper_single_fb_probe+0x260/0x314
[   62.628906] [<ffffffff8047e2c4>] drm_fb_helper_initial_config+0x200/0x234
[   62.628906] [<ffffffff804e5560>] radeon_fbdev_init+0xd4/0xf4
[   62.628906] [<ffffffff804e0e08>] radeon_modeset_init+0x9bc/0xa18
[   62.628906] [<ffffffff804bfc14>] radeon_driver_load_kms+0xdc/0x12c
[   62.628906] [<ffffffff8048b548>] drm_get_pci_dev+0x148/0x238
[   62.628906] [<ffffffff80423564>] local_pci_probe+0x5c/0xd0
[   62.628906] [<ffffffff80241ac4>] work_for_cpu_fn+0x1c/0x30
[   62.628906] [<ffffffff802427c8>] process_one_work+0x274/0x3bc
[   62.628906] [<ffffffff80242934>] process_scheduled_works+0x24/0x44
[   62.628906] [<ffffffff8024515c>] worker_thread+0x31c/0x3f4
[   62.628906] [<ffffffff802497a8>] kthread+0x88/0x90
[   62.628906] [<ffffffff80206794>] kernel_thread_helper+0x10/0x18

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Binbin Zhou <zhoubb@lemote.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/drm_irq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 03f16f3..275bc82 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -980,7 +980,7 @@ EXPORT_SYMBOL(drm_vblank_off);
  */
 void drm_vblank_pre_modeset(struct drm_device *dev, int crtc)
 {
-	/* vblank is not initialized (IRQ not installed ?) */
+	/* vblank is not initialized (IRQ not installed ?), or has been freed */
 	if (!dev->num_crtcs)
 		return;
 	/*
@@ -1002,6 +1002,10 @@ void drm_vblank_post_modeset(struct drm_device *dev, int crtc)
 {
 	unsigned long irqflags;
 
+	/* vblank is not initialized (IRQ not installed ?), or has been freed */
+	if (!dev->num_crtcs)
+		return;
+
 	if (dev->vblank_inmodeset[crtc]) {
 		spin_lock_irqsave(&dev->vbl_lock, irqflags);
 		dev->vblank_disable_allowed = 1;
-- 
1.7.10.4


