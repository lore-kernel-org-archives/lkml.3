Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965359AbaGOXiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:38:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933947AbaGOXOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.15 44/84] intel_pstate: Fix setting VID
Date: Tue, 15 Jul 2014 16:17:41 -0700
Message-Id: <20140715231714.524064836@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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
@@ -409,8 +409,8 @@ static void byt_get_vid(struct cpudata *
 
 
 	rdmsrl(BYT_VIDS, value);
-	cpudata->vid.min = int_tofp((value >> 8) & 0x3f);
-	cpudata->vid.max = int_tofp((value >> 16) & 0x3f);
+	cpudata->vid.min = int_tofp((value >> 8) & 0x7f);
+	cpudata->vid.max = int_tofp((value >> 16) & 0x7f);
 	cpudata->vid.ratio = div_fp(
 		cpudata->vid.max - cpudata->vid.min,
 		int_tofp(cpudata->pstate.max_pstate -


