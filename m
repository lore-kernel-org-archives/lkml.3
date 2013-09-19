Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab3ISEFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 00:05:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20658 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab3ISEFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 00:05:38 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] cpufreq: return EEXIST instead of EBUSY for second registering
Date: Wed, 18 Sep 2013 21:05:20 -0700
Message-Id: <1379563520-7221-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System that cpu support intel_pstate, acpi_cpufreq fail to
load, and udev keep trying until trace get filled up and
kernel crash.

The root cause is driver return ret from cpufreq_register_driver
and when some other driver take over before, it would return
EBUSY, then udev will keep trying...

cpufreq_register_driver should return EEXIST instead.
then system could boot without appending intel_pstate=disable
and still use intel_pstate.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/cpufreq/cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-2.6.orig/drivers/cpufreq/cpufreq.c
+++ linux-2.6/drivers/cpufreq/cpufreq.c
@@ -2104,7 +2104,7 @@ int cpufreq_register_driver(struct cpufr
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	if (cpufreq_driver) {
 		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
-		return -EBUSY;
+		return -EEXIST;
 	}
 	cpufreq_driver = driver_data;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
