Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab3BKTYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:24:16 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49022 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab3BKTYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:24:14 -0500
From: Artem Savkov <artem.savkov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH] cpufreq: 64bit divide in intel_pstate_calc_busy()
Date: Mon, 11 Feb 2013 23:24:08 +0400
Message-Id: <1360610648-6952-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_pstate.c won't compile on i686 because of a linking error:
drivers/cpufreq/intel_pstate.c:459: undefined reference to `__udivdi3'

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 drivers/cpufreq/intel_pstate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 86ad482..dc43208 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -456,7 +456,9 @@ static inline void intel_pstate_calc_busy(struct cpudata *cpu,
 	core_pct = div64_u64(sample->aperf * 100, sample->mperf);
 	sample->freq = cpu->pstate.turbo_pstate * core_pct * 1000;
 
-	sample->core_pct_busy = sample->pstate_pct_busy * core_pct / 100;
+	sample->core_pct_busy = div64_u64(
+					sample->pstate_pct_busy * core_pct,
+					100);
 }
 
 static inline void intel_pstate_sample(struct cpudata *cpu)
-- 
1.8.1.1

