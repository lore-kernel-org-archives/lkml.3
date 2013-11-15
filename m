Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3KOIrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 03:47:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:30754 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266Ab3KOIrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 03:47:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="409237370"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/2] Cpufreq/gov: use tick_nohz_check() to check idle micro accouting support
Date: Fri, 15 Nov 2013 16:35:35 +0800
Message-Id: <1384504535-29987-2-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384504535-29987-1-git-send-email-tianyu.lan@intel.com>
References: <1383036537-30362-1-git-send-email-tianyu.lan@intel.com>
 <1384504535-29987-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current, od_init() uses get_cpu_idle_time_us() to check whether
idle micro accouting is supported. The get_cpu_idle_time_us()
returns -1 only when tick nohz is disabled. This patch is to use
tick_nohz_check() directly to check nohz enable status instead of
get_cpu_idle_time_us(). This can avoid unnecessary getting and
putting cpu.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/cpufreq/cpufreq_ondemand.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 18d4091..7db2468 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -475,8 +475,6 @@ static struct attribute_group od_attr_group_gov_pol = {
 static int od_init(struct dbs_data *dbs_data)
 {
 	struct od_dbs_tuners *tuners;
-	u64 idle_time;
-	int cpu;
 
 	tuners = kzalloc(sizeof(*tuners), GFP_KERNEL);
 	if (!tuners) {
@@ -484,10 +482,7 @@ static int od_init(struct dbs_data *dbs_data)
 		return -ENOMEM;
 	}
 
-	cpu = get_cpu();
-	idle_time = get_cpu_idle_time_us(cpu, NULL);
-	put_cpu();
-	if (idle_time != -1ULL) {
+	if (tick_nohz_check()) {
 		/* Idle micro accounting is supported. Use finer thresholds */
 		tuners->up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
 		/*
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

