Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaBQJZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:25:41 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35448 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaBQJZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:25:36 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V6 2/7] cpufreq: suspend governors from dpm_{suspend|resume}()
Date: Mon, 17 Feb 2014 14:55:08 +0530
Message-Id: <5b79cd9aa706d988d242d80d73cfe67c0e6c5b3d.1392629003.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1392629003.git.viresh.kumar@linaro.org>
References: <cover.1392629003.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1392629003.git.viresh.kumar@linaro.org>
References: <cover.1392629003.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patch added support for suspending governors, with callbacks being
called from dpm_{suspend|resume}_noirq(). The problem here is that most of the
devices (i.e. devices with ->suspend() callbacks) have already been suspended by
now and so if drivers want to change frequency before suspending, then it might
not be possible for many platforms (which depend on other peripherals like i2c,
regulators, etc).

So, we actually need to do this from dpm_{suspend|resume}() instead. This patch
does it.

Tested-by: Lan Tianyu <tianyu.lan@intel.com>
Tested-by: Nishanth Menon <nm@ti.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/base/power/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index da49882..0f82012 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -582,7 +582,6 @@ static void dpm_resume_noirq(pm_message_t state)
 	dpm_show_time(starttime, state, "noirq");
 	resume_device_irqs();
 	cpuidle_resume();
-	cpufreq_resume();
 }
 
 /**
@@ -858,6 +857,8 @@ void dpm_resume(pm_message_t state)
 	mutex_unlock(&dpm_list_mtx);
 	async_synchronize_full();
 	dpm_show_time(starttime, state, NULL);
+
+	cpufreq_resume();
 }
 
 /**
@@ -1063,7 +1064,6 @@ static int dpm_suspend_noirq(pm_message_t state)
 	ktime_t starttime = ktime_get();
 	int error = 0;
 
-	cpufreq_suspend();
 	cpuidle_pause();
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
@@ -1415,6 +1415,8 @@ int dpm_suspend(pm_message_t state)
 
 	might_sleep();
 
+	cpufreq_suspend();
+
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
 	async_error = 0;
-- 
1.7.12.rc2.18.g61b472e

