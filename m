Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3AXDby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:31:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44407 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab3AXDbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 58/74] drm/nouveau: fix blank LVDS screen regression on pre-nv50 cards
Date: Thu, 24 Jan 2013 01:27:10 -0200
Message-Id: <1358998046-613-59-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 92441b2263866c27ef48137be5aa6c8c692652fc upstream.

Commit 2a44e499 ("drm/nouveau/disp: introduce proper init/fini, separate
from create/destroy") started to call display init routines on pre-nv50
hardware on module load. But LVDS init code sets driver state in a way
which prevents modesetting code from operating properly.

nv04_display_init calls nv04_dfp_restore, which sets encoder->last_dpms to
NV_DPMS_CLEARED.

drm_crtc_helper_set_mode
  nv04_dfp_prepare
    nv04_lvds_dpms(DRM_MODE_DPMS_OFF)

nv04_lvds_dpms checks last_dpms mode (which is NV_DPMS_CLEARED) and wrongly
assumes it's a "powersaving mode", the new one (DRM_MODE_DPMS_OFF) is too,
so it skips calling some crucial lvds scripts.

Reported-by: Chris Paulson-Ellis <chris@edesix.com>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/nouveau/nv04_dfp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nv04_dfp.c b/drivers/gpu/drm/nouveau/nv04_dfp.c
index 11c9a1a..28c7a5a 100644
--- a/drivers/gpu/drm/nouveau/nv04_dfp.c
+++ b/drivers/gpu/drm/nouveau/nv04_dfp.c
@@ -504,7 +504,7 @@ static void nv04_dfp_update_backlight(struct drm_encoder *encoder, int mode)
 
 static inline bool is_powersaving_dpms(int mode)
 {
-	return (mode != DRM_MODE_DPMS_ON);
+	return mode != DRM_MODE_DPMS_ON && mode != NV_DPMS_CLEARED;
 }
 
 static void nv04_lvds_dpms(struct drm_encoder *encoder, int mode)
-- 
1.7.9.5

