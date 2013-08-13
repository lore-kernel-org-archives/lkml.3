Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab3HMGs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:48:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab3HMGdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 43/60] drm/radeon: select audio dto based on encoder id for DCE3
Date: Mon, 12 Aug 2013 23:34:10 -0700
Message-Id: <20130813063337.790358710@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e1accbf0543eecfdb161131208c3dfefee22d61f upstream.

There are two audio dtos on radeon asics that you can
select between.  Normally, dto0 is used for hdmi and
dto1 for DP, but it seems that the dto is somehow
tied to the encoders on DCE3 asics.

fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=67435

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_hdmi.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -242,9 +242,15 @@ void r600_audio_set_dto(struct drm_encod
 		/* according to the reg specs, this should DCE3.2 only, but in
 		 * practice it seems to cover DCE3.0 as well.
 		 */
-		WREG32(DCCG_AUDIO_DTO0_PHASE, base_rate * 100);
-		WREG32(DCCG_AUDIO_DTO0_MODULE, clock * 100);
-		WREG32(DCCG_AUDIO_DTO_SELECT, 0); /* select DTO0 */
+		if (dig->dig_encoder == 0) {
+			WREG32(DCCG_AUDIO_DTO0_PHASE, base_rate * 100);
+			WREG32(DCCG_AUDIO_DTO0_MODULE, clock * 100);
+			WREG32(DCCG_AUDIO_DTO_SELECT, 0); /* select DTO0 */
+		} else {
+			WREG32(DCCG_AUDIO_DTO1_PHASE, base_rate * 100);
+			WREG32(DCCG_AUDIO_DTO1_MODULE, clock * 100);
+			WREG32(DCCG_AUDIO_DTO_SELECT, 1); /* select DTO1 */
+		}
 	} else {
 		/* according to the reg specs, this should be DCE2.0 and DCE3.0 */
 		WREG32(AUDIO_DTO, AUDIO_DTO_PHASE(base_rate / 10) |


