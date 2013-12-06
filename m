Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161487Ab3LFWHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:07:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759452Ab3LFVxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pierre Ossman <pierre@ossman.eu>,
        Alex Deucher <alexander.deucher@amd.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.10 57/58] drm/radeon/audio: improve ACR calculation
Date: Fri,  6 Dec 2013 13:52:28 -0800
Message-Id: <20131206214850.164842686@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_hdmi.c |   68 +++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 22 deletions(-)

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
@@ -67,25 +68,47 @@ static const struct radeon_hdmi_acr r600
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
+	int n, cts;
+	unsigned long div, mul;
 
-	if (*CTS == 0) {
-		n = (u64)clock * (u64)N * 1000ULL;
-		d = 128 * freq;
-		do_div(n, d);
-		*CTS = n;
-	}
-	DRM_DEBUG("Using ACR timing N=%d CTS=%d for frequency %d\n",
-		  N, *CTS, freq);
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
@@ -93,15 +116,16 @@ struct radeon_hdmi_acr r600_hdmi_acr(uin
 	struct radeon_hdmi_acr res;
 	u8 i;
 
-	for (i = 0; r600_hdmi_predefined_acr[i].clock != clock &&
-	     r600_hdmi_predefined_acr[i].clock != 0; i++)
-		;
-	res = r600_hdmi_predefined_acr[i];
-
-	/* In case some CTS are missing */
-	r600_hdmi_calc_cts(clock, &res.cts_32khz, res.n_32khz, 32000);
-	r600_hdmi_calc_cts(clock, &res.cts_44_1khz, res.n_44_1khz, 44100);
-	r600_hdmi_calc_cts(clock, &res.cts_48khz, res.n_48khz, 48000);
+	/* Precalculated values for common clocks */
+	for (i = 0; i < ARRAY_SIZE(r600_hdmi_predefined_acr); i++) {
+		if (r600_hdmi_predefined_acr[i].clock == clock)
+			return r600_hdmi_predefined_acr[i];
+	}
+
+	/* And odd clocks get manually calculated */
+	r600_hdmi_calc_cts(clock, &res.cts_32khz, &res.n_32khz, 32000);
+	r600_hdmi_calc_cts(clock, &res.cts_44_1khz, &res.n_44_1khz, 44100);
+	r600_hdmi_calc_cts(clock, &res.cts_48khz, &res.n_48khz, 48000);
 
 	return res;
 }


