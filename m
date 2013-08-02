Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab3HBKtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:49:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759514Ab3HBKJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 37/99] cpufreq / intel_pstate: Change to scale off of max P-state
Date: Fri,  2 Aug 2013 18:07:50 +0800
Message-Id: <20130802100231.246310097@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit 2134ed4d614349b2b4e8d7bb593baa9179b8dd1e upstream.

Change to using max P-state instead of max turbo P-state.  This
change resolves two issues.

On a quiet system intel_pstate can fail to respond to a load change.

On CPU SKUs that have a limited number of P-states and no turbo range
intel_pstate fails to select the highest available P-state.

This change is suitable for stable v3.9+

References: https://bugzilla.kernel.org/show_bug.cgi?id=59481
Reported-and-tested-by: Arjan van de Ven <arjan@linux.intel.com>
Reported-and-tested-by: dsmythies@telus.net
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -103,10 +103,10 @@ struct pstate_adjust_policy {
 static struct pstate_adjust_policy default_policy = {
 	.sample_rate_ms = 10,
 	.deadband = 0,
-	.setpoint = 109,
-	.p_gain_pct = 17,
+	.setpoint = 97,
+	.p_gain_pct = 20,
 	.d_gain_pct = 0,
-	.i_gain_pct = 4,
+	.i_gain_pct = 0,
 };
 
 struct perf_limits {
@@ -468,12 +468,12 @@ static inline void intel_pstate_set_samp
 static inline int intel_pstate_get_scaled_busy(struct cpudata *cpu)
 {
 	int32_t busy_scaled;
-	int32_t core_busy, turbo_pstate, current_pstate;
+	int32_t core_busy, max_pstate, current_pstate;
 
 	core_busy = int_tofp(cpu->samples[cpu->sample_ptr].core_pct_busy);
-	turbo_pstate = int_tofp(cpu->pstate.turbo_pstate);
+	max_pstate = int_tofp(cpu->pstate.max_pstate);
 	current_pstate = int_tofp(cpu->pstate.current_pstate);
-	busy_scaled = mul_fp(core_busy, div_fp(turbo_pstate, current_pstate));
+	busy_scaled = mul_fp(core_busy, div_fp(max_pstate, current_pstate));
 
 	return fp_toint(busy_scaled);
 }


