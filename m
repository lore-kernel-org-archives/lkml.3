Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab3HTBdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:33:09 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:39250 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3HTBdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:33:07 -0400
From: Furquan Shaikh <furquan@google.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Josh Triplett <josh.triplett@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc: Ronald Minnich <rminnich@google.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Furquan Shaikh <furquan@google.com>,
        furquan.m.shaikh@gmail.com
Subject: [PATCH 1/2] drm/i915: Fix bug while calculating the clock value using do_div in ironlake_crtc_clock_get
Date: Mon, 19 Aug 2013 18:33:01 -0700
Message-Id: <1376962382-29913-1-git-send-email-furquan@google.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to round up the values since the comparison in drm_mode_equal might fail if division
results in fractional part

Signed-off-by: Furquan Shaikh <furquan@google.com>
---
 drivers/gpu/drm/i915/intel_display.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 0f40f8e..e0069f4 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7190,7 +7190,11 @@ static void ironlake_crtc_clock_get(struct intel_crtc *crtc,
 		return;
 
 	clock = ((u64)link_m * (u64)link_freq * (u64)repeat);
-	do_div(clock, link_n);
+	/* This is required because the value comes out to be in fraction
+	   (eg. 70699.54). Need to round it up since values are compared in
+	   drm_mode_equal
+	*/
+	clock = DIV_ROUND_UP_ULL(clock, link_n);
 
 	pipe_config->adjusted_mode.clock = clock;
 }
-- 
1.8.3

