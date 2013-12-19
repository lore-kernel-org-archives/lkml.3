Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3LSMil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:38:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab3LSL5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pierre Ossman <pierre@ossman.eu>, Alex Deucher <alexander.deucher@amd.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 094/208] drm/radeon/audio: improve ACR calculation
Date: Thu, 19 Dec 2013 11:53:12 +0000
Message-Id: <1387454106-19326-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Ossman <pierre@ossman.eu>

commit a2098250fbda149cfad9e626afe80abe3b21e574 upstream.

In order to have any realistic chance of calculating proper
ACR values, we need to be able to calculate both N and CTS,
not just CTS. We still aim for the ideal N as specified in
the HDMI spec though.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=69675

Signed-off-by: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/r600_hdmi.c | 68 ++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index 4140fe8..01a2e1c 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -24,6 +24,7 @@
  * Authors: Christian König
  */
 #include <linux/hdmi.h>
+#include <linux/gcd.h>
 #include <drm/drmP.h>
 #include <drm/radeon_drm.h>
 #include "radeon.h"
@@ -67,25 +68,47 @@ static const struct radeon_hdmi_acr r600_hdmi_predefined_acr[] = {
     {  74250,  4096,  74250,  6272,  82500,  6144,  74250 }, /*  74.25       MHz */
     { 148352, 11648, 421875,  8918, 234375,  5824, 140625 }, /* 148.50/1.001 MHz */
     { 148500,  4096, 148500,  6272, 165000,  6144, 148500 }, /* 148.50       MHz */
-    {      0,  4096,      0,  6272,      0,  6144,      0 }  /* Other */
 };
 
+
 /*
- * calculate CTS value if it's not found in the table
+ * calculate CTS and N values if they are not found in the table
  */
-static void r600_hdmi_calc_cts(uint32_t clock, int *CTS, int N, int freq)
+static void r600_hdmi_calc_cts(uint32_t clock, int *CTS, int *N, int freq)
 {
-	u64 n;
-	u32 d;
-
-	if (*CTS == 0) {
-		n = (u64)clock * (u64)N * 1000ULL;
-		d = 128 * freq;
-		do_div(n, d);
-		*CTS = n;
-	}
-	DRM_DEBUG("Using ACR timing N=%d CTS=%d for frequency %d\n",
-		  N, *CTS, freq);
+	int n, cts;
+	unsigned long div, mul;
+
+	/* Safe, but overly large values */
+	n = 128 * freq;
+	cts = clock * 1000;
+
+	/* Smallest valid fraction */
+	div = gcd(n, cts);
+
+	n /= div;
+	cts /= div;
+
+	/*
+	 * The optimal N is 128*freq/1000. Calculate the closest larger
+	 * value that doesn't truncate any bits.
+	 */
+	mul = ((128*freq/1000) + (n-1))/n;
+
+	n *= mul;
+	cts *= mul;
+
+	/* Check that we are in spec (not always possible) */
+	if (n < (128*freq/1500))
+		printk(KERN_WARNING "Calculated ACR N value is too small. You may experience audio problems.\n");
+	if (n > (128*freq/300))
+		printk(KERN_WARNING "Calculated ACR N value is too large. You may experience audio problems.\n");
+
+	*N = n;
+	*CTS = cts;
+
+	DRM_DEBUG("Calculated ACR timing N=%d CTS=%d for frequency %d\n",
+		  *N, *CTS, freq);
 }
 
 struct radeon_hdmi_acr r600_hdmi_acr(uint32_t clock)
@@ -93,15 +116,16 @@ struct radeon_hdmi_acr r600_hdmi_acr(uint32_t clock)
 	struct radeon_hdmi_acr res;
 	u8 i;
 
-	for (i = 0; r600_hdmi_predefined_acr[i].clock != clock &&
-	     r600_hdmi_predefined_acr[i].clock != 0; i++)
-		;
-	res = r600_hdmi_predefined_acr[i];
+	/* Precalculated values for common clocks */
+	for (i = 0; i < ARRAY_SIZE(r600_hdmi_predefined_acr); i++) {
+		if (r600_hdmi_predefined_acr[i].clock == clock)
+			return r600_hdmi_predefined_acr[i];
+	}
 
-	/* In case some CTS are missing */
-	r600_hdmi_calc_cts(clock, &res.cts_32khz, res.n_32khz, 32000);
-	r600_hdmi_calc_cts(clock, &res.cts_44_1khz, res.n_44_1khz, 44100);
-	r600_hdmi_calc_cts(clock, &res.cts_48khz, res.n_48khz, 48000);
+	/* And odd clocks get manually calculated */
+	r600_hdmi_calc_cts(clock, &res.cts_32khz, &res.n_32khz, 32000);
+	r600_hdmi_calc_cts(clock, &res.cts_44_1khz, &res.n_44_1khz, 44100);
+	r600_hdmi_calc_cts(clock, &res.cts_48khz, &res.n_48khz, 48000);
 
 	return res;
 }
-- 
1.8.3.2

