Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab3IAF0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 01:26:13 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:43131 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3IAF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 01:26:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, sboyd@codeaurora.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: don't allow governor limits to be changed when it is disabled
Date: Sun,  1 Sep 2013 10:56:01 +0530
Message-Id: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpufreq_governor() returns with -EBUSY when governor is already stopped and we
try to stop it again, but when it is stopped we must not allow calls to
CPUFREQ_GOV_LIMITS event as well.

This patch adds this check in __cpufreq_governor().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Rafael,

Its better if we can get these in for 3.11, otherwise we need to get them in the
stable tree..

Anyway, we will get these in 3.10 stable tree but that requires us to identify
few more patches that will go with these. I will do that later.

This must fix the issues reported by Stephen.

Tested on my thinkpad over your linux-next branch.

 drivers/cpufreq/cpufreq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5c75e31..f320a20 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1692,8 +1692,9 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 						policy->cpu, event);
 
 	mutex_lock(&cpufreq_governor_lock);
-	if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
-	    (policy->governor_enabled && (event == CPUFREQ_GOV_START))) {
+	if ((policy->governor_enabled && (event == CPUFREQ_GOV_START)) ||
+		(!policy->governor_enabled && ((event == CPUFREQ_GOV_LIMITS) ||
+					       (event == CPUFREQ_GOV_STOP)))) {
 		mutex_unlock(&cpufreq_governor_lock);
 		return -EBUSY;
 	}
-- 
1.7.12.rc2.18.g61b472e

