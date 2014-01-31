Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbaAaVsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:48:40 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41425 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959AbaAaVsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:48:38 -0500
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Zoran Markovic <zoran.markovic@linaro.org>
Subject: [RFC PATCH] power: move pm_qos update timeout handler to power-efficient workqueue
Date: Fri, 31 Jan 2014 13:48:22 -0800
Message-Id: <1391204902-13389-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaibal Dutta <shaibal.dutta@broadcom.com>

To avoid waking up idle CPUs, allow the scheduler to select the best CPU
to handle pm_qos update timeouts. This extends idle residency times and
conserves power.

This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
[zoran.markovic@linaro.org: Rebased to latest kernel. Fixed code alignment.
Added commit message.]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 kernel/power/qos.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 8dff9b4..5e35a3a 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -405,7 +405,8 @@ void pm_qos_update_request_timeout(struct pm_qos_request *req, s32 new_value,
 			pm_qos_array[req->pm_qos_class]->constraints,
 			&req->node, PM_QOS_UPDATE_REQ, new_value);
 
-	schedule_delayed_work(&req->work, usecs_to_jiffies(timeout_us));
+	queue_delayed_work(system_power_efficient_wq,
+			   &req->work, usecs_to_jiffies(timeout_us));
 }
 
 /**
-- 
1.7.9.5

