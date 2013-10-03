Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3JCP6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:58:19 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41206 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3JCP6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:58:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 11/16] cpuidle: call cpuidle_get_driver() from after taking cpuidle_driver_lock
Date: Thu,  3 Oct 2013 21:26:50 +0530
Message-Id: <f6ee471532bede99b5c568a3882365614919165b.1380815504.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuidle_driver_lock is taken correctly at most of the places but at few places
calls to cpuidle_get_driver() are done from outside of this lock.

Fix them by calling cpuidle_get_driver() after taking cpuidle_driver_lock.

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/driver.c | 3 ++-
 drivers/cpuidle/sysfs.c  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 58077a9..662d934 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -338,10 +338,11 @@ struct cpuidle_driver *cpuidle_driver_ref(void)
  */
 void cpuidle_driver_unref(void)
 {
-	struct cpuidle_driver *drv = cpuidle_get_driver();
+	struct cpuidle_driver *drv;
 
 	spin_lock(&cpuidle_driver_lock);
 
+	drv = cpuidle_get_driver();
 	if (drv && !WARN_ON(drv->refcnt <= 0))
 		drv->refcnt--;
 
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 8739cc0..a022393 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -52,9 +52,10 @@ static ssize_t show_current_driver(struct device *dev,
 				   char *buf)
 {
 	ssize_t ret;
-	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
+	struct cpuidle_driver *cpuidle_driver;
 
 	spin_lock(&cpuidle_driver_lock);
+	cpuidle_driver = cpuidle_get_driver();
 	if (cpuidle_driver)
 		ret = sprintf(buf, "%s\n", cpuidle_driver->name);
 	else
-- 
1.7.12.rc2.18.g61b472e

