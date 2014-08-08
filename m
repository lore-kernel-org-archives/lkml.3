Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaHHUvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:51:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40952 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbaHHUvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 071/259] intel_pstate: Fix setting VID
Date: Fri,  8 Aug 2014 13:38:14 -0700
Message-Id: <1407530482-4483-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit c16ed06024a6e699c332831dd50d8276744e3de8 upstream.

Commit 21855ff5 (intel_pstate: Set turbo VID for BayTrail) introduced
setting the turbo VID which is required to prevent a machine check on
some Baytrail SKUs under heavy graphics based workloads.  The
docmumentation update that brought the requirement to light also
changed the bit mask used for enumerating P state and VID values from
0x7f to 0x3f.

This change returns the mask value to 0x7f.

Tested with the Intel NUC DN2820FYK,
BIOS version FYBYT10H.86A.0034.2014.0513.1413 with v3.16-rc1 and
v3.14.8 kernel versions.

Fixes: 21855ff5 (intel_pstate: Set turbo VID for BayTrail)
Link: https://bugzilla.kernel.org/show_bug.cgi?id=77951
Reported-and-tested-by: Rune Reterson <rune@megahurts.dk>
Reported-and-tested-by: Eric Eickmeyer <erich@ericheickmeyer.com>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index bbfb81f..37ef477 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -361,21 +361,21 @@ static int byt_get_min_pstate(void)
 {
 	u64 value;
 	rdmsrl(BYT_RATIOS, value);
-	return (value >> 8) & 0x3F;
+	return (value >> 8) & 0x7F;
 }
 
 static int byt_get_max_pstate(void)
 {
 	u64 value;
 	rdmsrl(BYT_RATIOS, value);
-	return (value >> 16) & 0x3F;
+	return (value >> 16) & 0x7F;
 }
 
 static int byt_get_turbo_pstate(void)
 {
 	u64 value;
 	rdmsrl(BYT_TURBO_RATIOS, value);
-	return value & 0x3F;
+	return value & 0x7F;
 }
 
 static void byt_set_pstate(struct cpudata *cpudata, int pstate)
@@ -409,8 +409,8 @@ static void byt_get_vid(struct cpudata *cpudata)
 
 
 	rdmsrl(BYT_VIDS, value);
-	cpudata->vid.min = int_tofp((value >> 8) & 0x3f);
-	cpudata->vid.max = int_tofp((value >> 16) & 0x3f);
+	cpudata->vid.min = int_tofp((value >> 8) & 0x7f);
+	cpudata->vid.max = int_tofp((value >> 16) & 0x7f);
 	cpudata->vid.ratio = div_fp(
 		cpudata->vid.max - cpudata->vid.min,
 		int_tofp(cpudata->pstate.max_pstate -
-- 
1.9.1

