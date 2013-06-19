Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538Ab3FSIzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:55:53 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34174 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934450Ab3FSIzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:55:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 10/13] cpufreq: powernow-k8: call CPUFREQ_POSTCHANGE notfier in error cases
Date: Wed, 19 Jun 2013 14:23:04 +0530
Message-Id: <07d316c551e66b387254f0f544e18e415b9c181d.1371630975.git.viresh.kumar@linaro.org>
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

This patch fixes it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/powernow-k8.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index b828efe..c916320 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -967,9 +967,9 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 
 	res = transition_fid_vid(data, fid, vid);
 	if (res)
-		return res;
-
-	freqs.new = find_khz_freq_from_fid(data->currfid);
+		freqs.new = freqs.old;
+	else
+		freqs.new = find_khz_freq_from_fid(data->currfid);
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 	return res;
-- 
1.7.12.rc2.18.g61b472e

