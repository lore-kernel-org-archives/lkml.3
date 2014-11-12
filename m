Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197AbaKLDiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:38:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbaKLBac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:30:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.17 180/319] intel_pstate: Correct BYT VID values.
Date: Wed, 12 Nov 2014 10:15:18 +0900
Message-Id: <20141112011022.510146798@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -52,6 +52,17 @@ static inline int32_t div_fp(int32_t x,
 	return div_s64((int64_t)x << FRAC_BITS, y);
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
@@ -425,7 +436,7 @@ static void byt_set_pstate(struct cpudat
 		cpudata->vid.ratio);
 
 	vid_fp = clamp_t(int32_t, vid_fp, cpudata->vid.min, cpudata->vid.max);
-	vid = fp_toint(vid_fp);
+	vid = ceiling_fp(vid_fp);
 
 	if (pstate > cpudata->pstate.max_pstate)
 		vid = cpudata->vid.turbo;


