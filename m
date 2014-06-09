Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784AbaFIW6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:58:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934072AbaFIWp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Doug Smythies <dsmythies@telus.net>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 65/78] intel_pstate: Correct rounding in busy calculation
Date: Mon,  9 Jun 2014 15:48:45 -0700
Message-Id: <20140609224815.430449553@linuxfoundation.org>
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

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit f0fe3cd7e12d8290c82284b5c8aee723cbd0371a upstream.

Changing to fixed point math throughout the busy calculation in
commit e66c1768 (Change busy calculation to use fixed point
math.) Introduced some inaccuracies by rounding the busy value at two
points in the calculation.  This change removes roundings and moves
the rounding to the output of the PID where the calculations are
complete and the value returned as an integer.

Fixes: e66c17683746 (intel_pstate: Change busy calculation to use fixed point math.)
Reported-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -40,10 +40,10 @@
 #define BYT_TURBO_VIDS		0x66d
 
 
-#define FRAC_BITS 6
+#define FRAC_BITS 8
 #define int_tofp(X) ((int64_t)(X) << FRAC_BITS)
 #define fp_toint(X) ((X) >> FRAC_BITS)
-#define FP_ROUNDUP(X) ((X) += 1 << FRAC_BITS)
+
 
 static inline int32_t mul_fp(int32_t x, int32_t y)
 {
@@ -198,7 +198,10 @@ static signed int pid_calc(struct _pid *
 	pid->last_err = fp_error;
 
 	result = pterm + mul_fp(pid->integral, pid->i_gain) + dterm;
-
+	if (result >= 0)
+		result = result + (1 << (FRAC_BITS-1));
+	else
+		result = result - (1 << (FRAC_BITS-1));
 	return (signed int)fp_toint(result);
 }
 
@@ -563,7 +566,6 @@ static inline void intel_pstate_calc_bus
 	core_pct = div_fp(int_tofp((sample->aperf)),
 			int_tofp((sample->mperf)));
 	core_pct = mul_fp(core_pct, int_tofp(100));
-	FP_ROUNDUP(core_pct);
 
 	sample->freq = fp_toint(
 		mul_fp(int_tofp(cpu->pstate.max_pstate * 1000), core_pct));
@@ -609,7 +611,7 @@ static inline int32_t intel_pstate_get_s
 	max_pstate = int_tofp(cpu->pstate.max_pstate);
 	current_pstate = int_tofp(cpu->pstate.current_pstate);
 	core_busy = mul_fp(core_busy, div_fp(max_pstate, current_pstate));
-	return FP_ROUNDUP(core_busy);
+	return core_busy;
 }
 
 static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)


