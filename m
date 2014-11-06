Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaKFWnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:43:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58977 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaKFWnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:19 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 094/162] intel_pstate: Correct BYT VID values.
Date: Thu,  6 Nov 2014 14:35:58 -0800
Message-Id: <1415313426-9622-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit d022a65ed2473fac4a600e3424503dc571160a3e upstream.

Using a VID value that is not high enough for the requested P state can
cause machine checks. Add a ceiling function to ensure calulated VIDs
with fractional values are set to the next highest integer VID value.

The algorythm for calculating the non-trubo VID from the BIOS writers
guide is:
 vid_ratio = (vid_max - vid_min) / (max_pstate - min_pstate)
 vid = ceiling(vid_min + (req_pstate - min_pstate) * vid_ratio)

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 2cb7028..4e8949d 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -54,6 +54,17 @@ static inline int32_t div_fp(int32_t x, int32_t y)
 	return div_s64((int64_t)x << FRAC_BITS, (int64_t)y);
 }
 
+static inline int ceiling_fp(int32_t x)
+{
+	int mask, ret;
+
+	ret = fp_toint(x);
+	mask = (1 << FRAC_BITS) - 1;
+	if (x & mask)
+		ret += 1;
+	return ret;
+}
+
 struct sample {
 	int32_t core_pct_busy;
 	u64 aperf;
@@ -428,7 +439,7 @@ static void byt_set_pstate(struct cpudata *cpudata, int pstate)
 		cpudata->vid.ratio);
 
 	vid_fp = clamp_t(int32_t, vid_fp, cpudata->vid.min, cpudata->vid.max);
-	vid = fp_toint(vid_fp);
+	vid = ceiling_fp(vid_fp);
 
 	if (pstate > cpudata->pstate.max_pstate)
 		vid = cpudata->vid.turbo;
-- 
1.9.1

