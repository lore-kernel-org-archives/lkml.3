Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3LSMbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:31:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44960 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab3LSL6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 111/208] intel_pstate: fix no_turbo
Date: Thu, 19 Dec 2013 11:53:29 +0000
Message-Id: <1387454106-19326-112-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 1ccf7a1cdafadd02e33e8f3d74370685a0600ec6 upstream.

When sysfs for no_turbo is set, then also some p states in turbo regions
are observed. This patch will set IDA Engage bit when no_turbo is set to
explicitly disengage turbo.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index e8c3db8..f112f7d 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -394,7 +394,10 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 	trace_cpu_frequency(pstate * 100000, cpu->cpu);
 
 	cpu->pstate.current_pstate = pstate;
-	wrmsrl(MSR_IA32_PERF_CTL, pstate << 8);
+	if (limits.no_turbo)
+		wrmsrl(MSR_IA32_PERF_CTL, BIT(32) | (pstate << 8));
+	else
+		wrmsrl(MSR_IA32_PERF_CTL, pstate << 8);
 
 }
 
-- 
1.8.3.2

