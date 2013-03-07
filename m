Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab3CGT31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:29:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5074 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932765Ab3CGT30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:29:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 07 Mar 2013 11:23:16 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <john.stultz@linaro.org>, <toddpoynor@google.com>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] alarmtimer: add error prints when suspend failed
Date: Fri, 8 Mar 2013 00:57:37 +0530
Message-ID: <1362684457-32570-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The alramtimer suspend failed when nearest alarm wakeup time is
less than 2 sec or rtc timer can not start.

In suspend/resume stress testing, we found that sometimes alramtimer
failed to suspend and hence it cancel the suspend ops. Add error prints
in suspend failure to provide more info when failure occurs to help
debugging.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 kernel/time/alarmtimer.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index f11d83b..eed5646 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -249,6 +249,8 @@ static int alarmtimer_suspend(struct device *dev)
 
 	if (ktime_to_ns(min) < 2 * NSEC_PER_SEC) {
 		__pm_wakeup_event(ws, 2 * MSEC_PER_SEC);
+		dev_err(dev,
+			"Nearest alarm wakeup time < 2sec, avoiding suspend\n");
 		return -EBUSY;
 	}
 
@@ -260,8 +262,10 @@ static int alarmtimer_suspend(struct device *dev)
 
 	/* Set alarm, if in the past reject suspend briefly to handle */
 	ret = rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
-	if (ret < 0)
+	if (ret < 0) {
 		__pm_wakeup_event(ws, MSEC_PER_SEC);
+		dev_err(dev, "RTC timer start failed, %d\n", ret);
+	}
 	return ret;
 }
 #else
-- 
1.7.1.1

