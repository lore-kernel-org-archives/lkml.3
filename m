Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab3LBUcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:32:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab3LBTOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 164/173] drm/radeon: use 64-bit math to calculate CTS values for audio (v2)
Date: Mon,  2 Dec 2013 11:12:27 -0800
Message-Id: <20131202191201.954672369@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 062c2e4363451d49ef840232fe65e8bff0dde2a5 upstream.

Avoid losing precision.  See bug:
https://bugs.freedesktop.org/show_bug.cgi?id=69675

v2: fix math as per Anssi's comments.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_hdmi.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -75,8 +75,15 @@ static const struct radeon_hdmi_acr r600
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


