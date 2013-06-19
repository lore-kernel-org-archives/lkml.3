Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480Ab3FSIyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:54:45 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48020 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934435Ab3FSIyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:54:38 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 05/13] cpufreq: e_powersave: call CPUFREQ_POSTCHANGE notfier in error cases
Date: Wed, 19 Jun 2013 14:22:59 +0530
Message-Id: <859db6d3cfc0efbd5b96783967c10cfcb8b5a51a.1371630975.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1371630975.git.viresh.kumar@linaro.org>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1371630975.git.viresh.kumar@linaro.org>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PRECHANGE and POSTCHANGE notifiers must be called in groups, i.e either both
should be called or both shouldn't be.

In case we have started PRECHANGE notifier and found an error, we must call
POSTCHANGE notifier with freqs.new = freqs.old to guarantee that sequence of
calling notifiers is complete.

This driver was taking care of it but frequency isn't restored to freqs.old.

This patch fixes it.

Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/e_powersaver.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 37380fb..3d03626 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -161,6 +161,9 @@ postchange:
 		current_multiplier);
 	}
 #endif
+	if (err)
+		freqs.new = freqs.old;
+
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 	return err;
 }
-- 
1.7.12.rc2.18.g61b472e

