Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaHFNUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:20:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaHFNTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:19:25 -0400
From: Mel Gorman <mgorman@suse.de>
To: Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Nicolas Pitre <nico@linaro.org>
Cc: Mike Galbraith <mgalbraith@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/4] cpuidle: menu: Use ktime_to_us instead of reinventing the wheel
Date: Wed,  6 Aug 2014 14:19:19 +0100
Message-Id: <1407331161-4642-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1407331161-4642-1-git-send-email-mgorman@suse.de>
References: <1407331161-4642-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ktime_to_us implementation is slightly better than the one implemented
in menu.c. Use it

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 drivers/cpuidle/governors/menu.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 801b2ee..373278a 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -297,7 +297,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	unsigned int interactivity_req;
-	struct timespec t;
 
 	if (data->needs_update) {
 		menu_update(drv, dev);
@@ -311,9 +310,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		return 0;
 
 	/* determine the expected residency time, round up */
-	t = ktime_to_timespec(tick_nohz_get_sleep_length());
-	data->next_timer_us =
-		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
+	data->next_timer_us = ktime_to_us(tick_nohz_get_sleep_length());
 
 
 	data->bucket = which_bucket(data->next_timer_us);
-- 
1.8.4.5

