Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934980AbaFIXBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:01:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933940AbaFIWpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Doug Smythies <dsmythies@telus.net>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 67/78] intel_pstate: Improve initial busy calculation
Date: Mon,  9 Jun 2014 15:48:47 -0700
Message-Id: <20140609224815.487120037@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Smythies <dsmythies@telus.net>

commit bf8102228a8bf053051f311e5486042fe0542894 upstream.

This change makes the busy calculation using 64 bit math which prevents
overflow for large values of aperf/mperf.

Signed-off-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -563,16 +563,19 @@ static void intel_pstate_get_cpu_pstates
 static inline void intel_pstate_calc_busy(struct cpudata *cpu,
 					struct sample *sample)
 {
-	int32_t core_pct;
+	int64_t core_pct;
+	int32_t rem;
 
-	core_pct = div_fp(int_tofp((sample->aperf)),
-			int_tofp((sample->mperf)));
-	core_pct = mul_fp(core_pct, int_tofp(100));
+	core_pct = int_tofp(sample->aperf) * int_tofp(100);
+	core_pct = div_u64_rem(core_pct, int_tofp(sample->mperf), &rem);
+
+	if ((rem << 1) >= int_tofp(sample->mperf))
+		core_pct += 1;
 
 	sample->freq = fp_toint(
 		mul_fp(int_tofp(cpu->pstate.max_pstate * 1000), core_pct));
 
-	sample->core_pct_busy = core_pct;
+	sample->core_pct_busy = (int32_t)core_pct;
 }
 
 static inline void intel_pstate_sample(struct cpudata *cpu)


