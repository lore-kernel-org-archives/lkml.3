Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaAaTSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:18:38 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46604 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:18:37 -0500
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Shaibal Dutta <shaibal.dutta@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Zoran Markovic <zoran.markovic@linaro.org>
Subject: [RFC PATCH] timekeeping: move clock sync work to power efficient workqueue
Date: Fri, 31 Jan 2014 11:18:24 -0800
Message-Id: <1391195904-12497-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaibal Dutta <shaibal.dutta@linaro.org>

For better use of CPU idle time, allow the scheduler to select the CPU
on which the CMOS clock sync work would be scheduled. This improves
idle residency time and conserver power.

This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
[zoran.markovic@linaro.org: Added commit message. Aligned code.]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 kernel/time/ntp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index af8d1d4..419a52c 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -514,12 +514,13 @@ static void sync_cmos_clock(struct work_struct *work)
 		next.tv_sec++;
 		next.tv_nsec -= NSEC_PER_SEC;
 	}
-	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
+	queue_delayed_work(system_power_efficient_wq,
+			   &sync_cmos_work, timespec_to_jiffies(&next));
 }
 
 void ntp_notify_cmos_timer(void)
 {
-	schedule_delayed_work(&sync_cmos_work, 0);
+	queue_delayed_work(system_power_efficient_wq, &sync_cmos_work, 0);
 }
 
 #else
-- 
1.7.9.5

