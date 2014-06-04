Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaFDXzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:55:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaFDXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 210/228] intel_pstate: Set turbo VID for BayTrail
Date: Wed,  4 Jun 2014 16:23:59 -0700
Message-Id: <20140604232354.796278983@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit 21855ff5bcbdd075e1c99772827a84912ab083dd upstream.

A documentation update exposed that there is a separate set of VID
values that must be used in the turbo/boost P state range.  Add
enumerating and setting the correct VID for P states in the turbo
range.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -37,6 +37,7 @@
 #define BYT_RATIOS		0x66a
 #define BYT_VIDS		0x66b
 #define BYT_TURBO_RATIOS	0x66c
+#define BYT_TURBO_VIDS		0x66d
 
 
 #define FRAC_BITS 6
@@ -70,8 +71,9 @@ struct pstate_data {
 };
 
 struct vid_data {
-	int32_t min;
-	int32_t max;
+	int min;
+	int max;
+	int turbo;
 	int32_t ratio;
 };
 
@@ -360,14 +362,14 @@ static int byt_get_min_pstate(void)
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
@@ -394,6 +396,9 @@ static void byt_set_pstate(struct cpudat
 	vid_fp = clamp_t(int32_t, vid_fp, cpudata->vid.min, cpudata->vid.max);
 	vid = fp_toint(vid_fp);
 
+	if (pstate > cpudata->pstate.max_pstate)
+		vid = cpudata->vid.turbo;
+
 	val |= vid;
 
 	wrmsrl(MSR_IA32_PERF_CTL, val);
@@ -403,13 +408,17 @@ static void byt_get_vid(struct cpudata *
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
 
 


