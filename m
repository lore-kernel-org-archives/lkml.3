Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaIYIgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:36:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:45071 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbaIYIg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,595,1406617200"; 
   d="scan'208";a="605123668"
From: Lan Tianyu <tianyu.lan@intel.com>
To: peterz@infradead.org, mingo@kernel.org, rafael.j.wysocki@intel.com,
        toshi.kani@hp.com, akpm@linux-foundation.org, tianyu.lan@intel.com,
        ktkhai@parallels.com, fabf@skynet.be, laijs@cn.fujitsu.com,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        srivatsa@mit.edu, viresh.kumar@linaro.org
Cc: todd.e.brandt@linux.intel.com, tipbot@zytor.com,
        wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [RFC PATCH V3 3/3] Cpufreq: Hold cpu_add_remove_lock before change cpufreq_suspended flag
Date: Thu, 25 Sep 2014 16:32:05 +0800
Message-Id: <1411633925-9018-4-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411633925-9018-1-git-send-email-tianyu.lan@intel.com>
References: <1411633925-9018-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, enabling non-boot cpus will parallel with resuming devices.
Cpu online may take place after cpufreq resume. But all cpu should be up
before clearing cpufreq_suspended flag in the cpufreq_resume(). Cpufreq
core uses this flag to decide to do light-weight init or full init. Light
-weight init/tear down is dedicated for cpu hotplug during system pm. To
keep this rule, hold cpu_add_remove_lock during changing cpufreq_suspended
flag.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/cpufreq/cpufreq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 37951ec..b03f7dd 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1689,7 +1689,9 @@ void cpufreq_resume(void)
 	if (!cpufreq_driver)
 		return;
 
+	cpu_maps_update_begin();
 	cpufreq_suspended = false;
+	cpu_maps_update_done();
 
 	if (!has_target())
 		return;
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

