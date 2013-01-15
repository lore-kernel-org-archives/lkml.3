Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab3AOWd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:33:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:43218 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544Ab3AOWdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Paulson-Ellis <chris@edesix.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 166/221] drm/nouveau: fix blank LVDS screen regression on pre-nv50 cards
Date: Tue, 15 Jan 2013 10:51:33 -0800
Message-Id: <20130115185010.020649626@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nv04_dfp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nv04_dfp.c
+++ b/drivers/gpu/drm/nouveau/nv04_dfp.c
@@ -505,7 +505,7 @@ static void nv04_dfp_update_backlight(st
 
 static inline bool is_powersaving_dpms(int mode)
 {
-	return (mode != DRM_MODE_DPMS_ON);
+	return mode != DRM_MODE_DPMS_ON && mode != NV_DPMS_CLEARED;
 }
 
 static void nv04_lvds_dpms(struct drm_encoder *encoder, int mode)


