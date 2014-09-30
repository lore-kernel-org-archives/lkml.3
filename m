Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976AbaI3EDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:03:54 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59022 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaI3EDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:03:51 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rafael Wysocki <rjw@rjwysocki.net>, tianyu.lan@intel.com
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "3.15+" <stable@vger.kernel.org>
Subject: [PATCH] cpufreq: update 'cpufreq_suspended' after stopping governors
Date: Tue, 30 Sep 2014 09:33:17 +0530
Message-Id: <999a633cbd722157ab80611b98c26107ddc7bd9c.1412049692.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.3.693.g996b0fd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8e30444e1530 ("cpufreq: fix cpufreq suspend/resume for intel_pstate")
introduced a bug where the governors wouldn't be stopped anymore for
->target{_index}() drivers during suspend. This happens because
'cpufreq_suspended' is updated before stopping the governors during suspend and
due to this __cpufreq_governor() would return early due to this check:

	/* Don't start any governor operations if we are entering suspend */
	if (cpufreq_suspended)
		return 0;

This patch tries to fix this bug.

Fixes: 8e30444e1530 ("cpufreq: fix cpufreq suspend/resume for intel_pstate")
Cc: 3.15+ <stable@vger.kernel.org> # 3.15+
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6e93e7f..61190f6 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1658,10 +1658,8 @@ void cpufreq_suspend(void)
 	if (!cpufreq_driver)
 		return;
 
-	cpufreq_suspended = true;
-
 	if (!has_target())
-		return;
+		goto suspend;
 
 	pr_debug("%s: Suspending Governors\n", __func__);
 
@@ -1674,6 +1672,9 @@ void cpufreq_suspend(void)
 			pr_err("%s: Failed to suspend driver: %p\n", __func__,
 				policy);
 	}
+
+suspend:
+	cpufreq_suspended = true;
 }
 
 /**
-- 
2.0.3.693.g996b0fd

