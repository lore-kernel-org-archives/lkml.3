Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053Ab3GWTSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:18:16 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:53707 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933793Ab3GWTSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:18:15 -0400
From: Artem Savkov <artem.savkov@gmail.com>
To: dchinner@redhat.com, glommer@openvz.org
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH] drm: i915_gem_inactive_scan: insufficient nr_to_scan size
Date: Tue, 23 Jul 2013 23:18:06 +0400
Message-Id: <1374607086-6761-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: git-send-email 1.8.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_to_scan needs to be (unsigned) long, not int, otherwise we get negative
values on 32bit systems during shrink resulting in lots of messages like one
below.

[ 4078.989603] shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to delete nr=-289580136

Introduced in "drivers: convert shrinkers to new count/scan API"
(383e4f4a4cdeb2dd552e90811089bcb4d41eb32e in linux-next.git)

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 4635354..b3b4891b 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4649,7 +4649,7 @@ i915_gem_inactive_scan(struct shrinker *shrinker, struct shrink_control *sc)
 			     struct drm_i915_private,
 			     mm.inactive_shrinker);
 	struct drm_device *dev = dev_priv->dev;
-	int nr_to_scan = sc->nr_to_scan;
+	unsigned long nr_to_scan = sc->nr_to_scan;
 	unsigned long freed;
 	bool unlock = true;
 
-- 
1.8.3.3

