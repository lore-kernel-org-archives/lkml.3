Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966541AbaFQWj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:39:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53981 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966109AbaFQVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 106/212] intel_pstate: Set turbo VID for BayTrail
Date: Tue, 17 Jun 2014 14:43:20 -0700
Message-Id: <1403041506-13646-107-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit 21855ff5bcbdd075e1c99772827a84912ab083dd upstream.

A documentation update exposed that there is a separate set of VID
values that must be used in the turbo/boost P state range.  Add
enumerating and setting the correct VID for P states in the turbo
range.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index b687df8..bbfb81f 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -37,6 +37,7 @@
 #define BYT_RATIOS		0x66a
 #define BYT_VIDS		0x66b
 #define BYT_TURBO_RATIOS	0x66c
+#define BYT_TURBO_VIDS		0x66d
 
 
 #define FRAC_BITS 8
@@ -68,8 +69,9 @@ struct pstate_data {
 };
 
 struct vid_data {
-	int32_t min;
-	int32_t max;
+	int min;
+	int max;
+	int turbo;
 	int32_t ratio;
 };
 
@@ -359,14 +361,14 @@ static int byt_get_min_pstate(void)
 {
 	u64 value;
 	rdmsrl(BYT_RATIOS, value);
-	return (value >> 8) & 0xFF;
+	return (value >> 8) & 0x3F;
 }
 
 static int byt_get_max_pstate(void)
 {
 	u64 value;
 	rdmsrl(BYT_RATIOS, value);
-	return (value >> 16) & 0xFF;
+	return (value >> 16) & 0x3F;
 }
 
 static int byt_get_turbo_pstate(void)
@@ -393,6 +395,9 @@ static void byt_set_pstate(struct cpudata *cpudata, int pstate)
 	vid_fp = clamp_t(int32_t, vid_fp, cpudata->vid.min, cpudata->vid.max);
 	vid = fp_toint(vid_fp);
 
+	if (pstate > cpudata->pstate.max_pstate)
+		vid = cpudata->vid.turbo;
+
 	val |= vid;
 
 	wrmsrl(MSR_IA32_PERF_CTL, val);
@@ -402,13 +407,17 @@ static void byt_get_vid(struct cpudata *cpudata)
 {
 	u64 value;
 
+
 	rdmsrl(BYT_VIDS, value);
-	cpudata->vid.min = int_tofp((value >> 8) & 0x7f);
-	cpudata->vid.max = int_tofp((value >> 16) & 0x7f);
+	cpudata->vid.min = int_tofp((value >> 8) & 0x3f);
+	cpudata->vid.max = int_tofp((value >> 16) & 0x3f);
 	cpudata->vid.ratio = div_fp(
 		cpudata->vid.max - cpudata->vid.min,
 		int_tofp(cpudata->pstate.max_pstate -
 			cpudata->pstate.min_pstate));
+
+	rdmsrl(BYT_TURBO_VIDS, value);
+	cpudata->vid.turbo = value & 0x7f;
 }
 
 
-- 
1.9.1

