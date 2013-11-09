Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab3KIHDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:03:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab3KIGwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick Bartels <petzicus@googlemail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.11 11/94] cpufreq / intel_pstate: Fix max_perf_pct on resume
Date: Fri,  8 Nov 2013 22:51:17 -0800
Message-Id: <20131109065205.054002664@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit 52e0a509e5d6f902ec26bc2a8bb02b137dc453be upstream.

If the system is suspended while max_perf_pct is less than 100 percent
or no_turbo set policy->{min,max} will be set incorrectly with scaled
values which turn the scaled values into hard limits.

References: https://bugzilla.kernel.org/show_bug.cgi?id=61241
Reported-by: Patrick Bartels <petzicus@googlemail.com>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -629,8 +629,8 @@ static int intel_pstate_cpu_exit(struct
 
 static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
 {
-	int rc, min_pstate, max_pstate;
 	struct cpudata *cpu;
+	int rc;
 
 	rc = intel_pstate_init_cpu(policy->cpu);
 	if (rc)
@@ -644,9 +644,8 @@ static int intel_pstate_cpu_init(struct
 	else
 		policy->policy = CPUFREQ_POLICY_POWERSAVE;
 
-	intel_pstate_get_min_max(cpu, &min_pstate, &max_pstate);
-	policy->min = min_pstate * 100000;
-	policy->max = max_pstate * 100000;
+	policy->min = cpu->pstate.min_pstate * 100000;
+	policy->max = cpu->pstate.turbo_pstate * 100000;
 
 	/* cpuinfo and default policy values */
 	policy->cpuinfo.min_freq = cpu->pstate.min_pstate * 100000;


