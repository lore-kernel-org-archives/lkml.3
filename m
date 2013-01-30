Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3A3AKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 19:10:00 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36343 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3A3AJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 19:09:58 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] drm: avoid "mono_time_offset may be used uninitialized"
Date: Tue, 29 Jan 2013 17:09:50 -0700
Message-Id: <1359504590-23517-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Silence the following:
drivers/gpu/drm/drm_irq.c: In function 'drm_calc_vbltimestamp_from_scanoutpos':
drivers/gpu/drm/drm_irq.c:583:24: warning: 'mono_time_offset.tv64' may be used uninitialized in this function

... by always initializing mono_time_offset to zero. In practice, this
warning is false, since mono_time_offset is both set and used under the
condition if (!drm_timestamp_monotonic). However, at least my compiler
can't be coerced into realizing this; almost any code between the if
blocks that set and use the variable causes this warning.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
I'm not sure what the current thinking is re: silencing warnings like this;
IIRC some people may dislike this kind of change. Perhaps if this change
alone is problematic, one could additionally remove the if condition on the
use of mono_time_offset, thus always using the value?
---
 drivers/gpu/drm/drm_irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 19c01ca..b199818 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -580,7 +580,7 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 					  unsigned flags,
 					  struct drm_crtc *refcrtc)
 {
-	ktime_t stime, etime, mono_time_offset;
+	ktime_t stime, etime, mono_time_offset = {0};
 	struct timeval tv_etime;
 	struct drm_display_mode *mode;
 	int vbl_status, vtotal, vdisplay;
-- 
1.7.10.4

