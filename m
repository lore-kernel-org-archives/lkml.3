Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162608Ab3LFN2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:28:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44434 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161802Ab3LFNDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 186/272] drm/radeon: use 64-bit math to calculate CTS values for audio (v2)
Date: Fri,  6 Dec 2013 12:57:55 +0000
Message-Id: <1386334761-25517-187-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 062c2e4363451d49ef840232fe65e8bff0dde2a5 upstream.

Avoid losing precision.  See bug:
https://bugs.freedesktop.org/show_bug.cgi?id=69675

v2: fix math as per Anssi's comments.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/r600_hdmi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index a74c2aa..14e19aa 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -75,8 +75,15 @@ static const struct radeon_hdmi_acr r600_hdmi_predefined_acr[] = {
  */
 static void r600_hdmi_calc_cts(uint32_t clock, int *CTS, int N, int freq)
 {
-	if (*CTS == 0)
-		*CTS = clock * N / (128 * freq) * 1000;
+	u64 n;
+	u32 d;
+
+	if (*CTS == 0) {
+		n = (u64)clock * (u64)N * 1000ULL;
+		d = 128 * freq;
+		do_div(n, d);
+		*CTS = n;
+	}
 	DRM_DEBUG("Using ACR timing N=%d CTS=%d for frequency %d\n",
 		  N, *CTS, freq);
 }
-- 
1.8.3.2

