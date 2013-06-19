Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470Ab3FSIyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:54:33 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:38656 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934435Ab3FSIyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:54:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH 03/13] cpufreq: davinci: call CPUFREQ_POSTCHANGE notfier in error cases
Date: Wed, 19 Jun 2013 14:22:57 +0530
Message-Id: <6e65891cd3e33c5db94563a387832ae648ef0d8c.1371630975.git.viresh.kumar@linaro.org>
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

Davinci driver was taking care of it but frequency isn't restored to freqs.old.

This patch fixes it.

Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/davinci-cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index c33c76c..551dd65 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -114,6 +114,9 @@ static int davinci_target(struct cpufreq_policy *policy,
 		pdata->set_voltage(idx);
 
 out:
+	if (ret)
+		freqs.new = freqs.old;
+
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	return ret;
-- 
1.7.12.rc2.18.g61b472e

