Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3ITN5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab3ITN47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:56:59 -0400
Date: Fri, 20 Sep 2013 09:56:48 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: gma500: remove double free in psbfb_create
Message-ID: <20130920135648.GA19879@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code appears to be calling psb_gtt_free_range twice with the same args.
(The second call didn't appear in the diff output, it's right after the mutex_unlock)

Spotted with Coverity, not tested due to lack of hardware.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index 01dd7d2..d35ffc4 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -479,9 +479,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	mutex_unlock(&dev->struct_mutex);
 	return 0;
 out_unref:
-	if (backing->stolen)
-		psb_gtt_free_range(dev, backing);
-	else
+	if (!backing->stolen)
 		drm_gem_object_unreference(&backing->gem);
 out_err1:
 	mutex_unlock(&dev->struct_mutex);
