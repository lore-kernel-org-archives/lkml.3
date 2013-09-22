Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3IVBW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:22:56 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57246 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3IVBWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:22:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 14/21] cpuidle: coupled: don't compare cpu masks unnecessarily
Date: Sun, 22 Sep 2013 06:51:06 +0530
Message-Id: <564c8b1f073dc396b54866a2220b09b7869289f4.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cpuidle_coupled_register_device() we do following:
	if (WARN_ON(!cpumask_equal(&dev->coupled_cpus, &coupled->coupled_cpus)))
		coupled->prevent++;

This is only required to be done when we are using 'coupled' from an existing
cpuidle_device and not when we have just done this:

	coupled->coupled_cpus = dev->coupled_cpus

So, move this compare statement to the right place.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/coupled.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index e952936..19a89eb 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -642,6 +642,10 @@ int cpuidle_coupled_register_device(struct cpuidle_device *dev)
 		other_dev = per_cpu(cpuidle_devices, cpu);
 		if (other_dev && other_dev->coupled) {
 			coupled = other_dev->coupled;
+
+			if (WARN_ON(!cpumask_equal(&dev->coupled_cpus,
+						&coupled->coupled_cpus)))
+				coupled->prevent++;
 			goto have_coupled;
 		}
 	}
@@ -655,9 +659,6 @@ int cpuidle_coupled_register_device(struct cpuidle_device *dev)
 
 have_coupled:
 	dev->coupled = coupled;
-	if (WARN_ON(!cpumask_equal(&dev->coupled_cpus, &coupled->coupled_cpus)))
-		coupled->prevent++;
-
 	cpuidle_coupled_update_online_cpus(coupled);
 
 	coupled->refcnt++;
-- 
1.7.12.rc2.18.g61b472e

