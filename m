Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab3ERDQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:16:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634Ab3ERDAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:13 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=P1zr_Y95ImkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Xds5NudUzSAA:10 a=zd2uoN0lAAAA:8 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=Ke31fmEPYgc436yewl4A:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021701.178656068@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 122/136 ] drm/radeon: disable the crtcs in mc_stop (evergreen+) (v2)
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0122-drm-radeon-disable-the-crtcs-in-mc_stop-evergreen-v2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit abf1457bbbe4c62066bd03c6d31837dea28644dc ]

Just disabling the mem requests should be enough, but
that doesn't seem to work correctly on efi systems.

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=57567
https://bugs.freedesktop.org/show_bug.cgi?id=43655
https://bugzilla.kernel.org/show_bug.cgi?id=56441

v2: blank displays first, then disable.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/evergreen.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 6cb958b..cbbaaf6 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1286,6 +1286,7 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 				tmp = RREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i]);
 				if (!(tmp & EVERGREEN_CRTC_BLANK_DATA_EN)) {
 					radeon_wait_for_vblank(rdev, i);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
 					WREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i], tmp);
 				}
@@ -1293,8 +1294,10 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 				if (!(tmp & EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE)) {
 					radeon_wait_for_vblank(rdev, i);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					tmp |= EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
 					WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			}
 			/* wait for the next frame */
@@ -1304,6 +1307,15 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 					break;
 				udelay(1);
 			}
+
+			/* XXX this is a hack to avoid strange behavior with EFI on certain systems */
+			WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
+			tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
+			tmp &= ~EVERGREEN_CRTC_MASTER_EN;
+			WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+			WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
+			save->crtc_enabled[i] = false;
+			/* ***** */
 		} else {
 			save->crtc_enabled[i] = false;
 		}
-- 
1.7.10.4


