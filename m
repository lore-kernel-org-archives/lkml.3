Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaKKL7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:59:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57315 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaKKLJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 046/170] intel_pstate: Correct BYT VID values.
Date: Tue, 11 Nov 2014 11:06:45 +0000
Message-Id: <1415704129-12709-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 72c90a1ebb5f..4598b8731b55 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -53,6 +53,17 @@ static inline int32_t div_fp(int32_t x, int32_t y)
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
@@ -424,7 +435,7 @@ static void byt_set_pstate(struct cpudata *cpudata, int pstate)
 		cpudata->vid.ratio);
 
 	vid_fp = clamp_t(int32_t, vid_fp, cpudata->vid.min, cpudata->vid.max);
-	vid = fp_toint(vid_fp);
+	vid = ceiling_fp(vid_fp);
 
 	if (pstate > cpudata->pstate.max_pstate)
 		vid = cpudata->vid.turbo;
-- 
2.1.0

