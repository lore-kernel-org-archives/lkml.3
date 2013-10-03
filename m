Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3JCEVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:21:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab3JCEUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:20:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 54/57] drm/radeon: fix hdmi audio on DCE3.0/3.1 asics
Date: Wed,  2 Oct 2013 21:09:20 -0700
Message-Id: <20131003040640.288386813@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 58d327da9721f7a0f6e46c8dfa5cc5546fd7078a upstream.

These asics seem to use a mix of the DCE2.x and
DCE3.2 audio interfaces despite what the register spec
says.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=69729
https://bugs.freedesktop.org/show_bug.cgi?id=69671

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_hdmi.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -257,10 +257,7 @@ void r600_audio_set_dto(struct drm_encod
 	 * number (coefficient of two integer numbers.  DCCG_AUDIO_DTOx_PHASE
 	 * is the numerator, DCCG_AUDIO_DTOx_MODULE is the denominator
 	 */
-	if (ASIC_IS_DCE3(rdev)) {
-		/* according to the reg specs, this should DCE3.2 only, but in
-		 * practice it seems to cover DCE3.0 as well.
-		 */
+	if (ASIC_IS_DCE32(rdev)) {
 		if (dig->dig_encoder == 0) {
 			dto_cntl = RREG32(DCCG_AUDIO_DTO0_CNTL) & ~DCCG_AUDIO_DTO_WALLCLOCK_RATIO_MASK;
 			dto_cntl |= DCCG_AUDIO_DTO_WALLCLOCK_RATIO(wallclock_ratio);
@@ -276,8 +273,21 @@ void r600_audio_set_dto(struct drm_encod
 			WREG32(DCCG_AUDIO_DTO1_MODULE, dto_modulo);
 			WREG32(DCCG_AUDIO_DTO_SELECT, 1); /* select DTO1 */
 		}
+	} else if (ASIC_IS_DCE3(rdev)) {
+		/* according to the reg specs, this should DCE3.2 only, but in
+		 * practice it seems to cover DCE3.0/3.1 as well.
+		 */
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
-		/* according to the reg specs, this should be DCE2.0 and DCE3.0 */
+		/* according to the reg specs, this should be DCE2.0 and DCE3.0/3.1 */
 		WREG32(AUDIO_DTO, AUDIO_DTO_PHASE(base_rate / 10) |
 		       AUDIO_DTO_MODULE(clock / 10));
 	}


