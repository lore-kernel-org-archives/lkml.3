Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483Ab3CZPfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:35:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54079 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965283Ab3CZPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Torsten Duwe <duwe@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 119/150] KMS: fix EDID detailed timing vsync parsing
Date: Tue, 26 Mar 2013 15:20:18 +0000
Message-Id: <1364311249-14454-120-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Duwe <torsten@lst.de>

commit 16dad1d743d31a104a849c8944e6b9eb479f6cd7 upstream.

EDID spreads some values across multiple bytes; bit-fiddling is needed
to retrieve these.  The current code to parse "detailed timings" has a
cut&paste error that results in a vsync offset of at most 15 lines
instead of 63.

See

   http://en.wikipedia.org/wiki/EDID

and in the "EDID Detailed Timing Descriptor" see bytes 10+11 show why
that needs to be a left shift.

Signed-off-by: Torsten Duwe <duwe@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_edid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 74f2421..f689958 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -876,7 +876,7 @@ static struct drm_display_mode *drm_mode_detailed(struct drm_device *dev,
 	unsigned vblank = (pt->vactive_vblank_hi & 0xf) << 8 | pt->vblank_lo;
 	unsigned hsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc0) << 2 | pt->hsync_offset_lo;
 	unsigned hsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0x30) << 4 | pt->hsync_pulse_width_lo;
-	unsigned vsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc) >> 2 | pt->vsync_offset_pulse_width_lo >> 4;
+	unsigned vsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc) << 2 | pt->vsync_offset_pulse_width_lo >> 4;
 	unsigned vsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0x3) << 4 | (pt->vsync_offset_pulse_width_lo & 0xf);
 
 	/* ignore tiny modes */
-- 
1.8.1.2

