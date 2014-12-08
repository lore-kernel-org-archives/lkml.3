Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaLHMD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:03:59 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33645 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaLHMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:03:58 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 1/2] rtc/ab8500: set uie_unsupported flag
Date: Mon,  8 Dec 2014 20:03:06 +0800
Message-Id: <1418040187-5372-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, ab8500 doesn't set uie_unsupported of rtc_device, while
it doesn't support UIE, see ab8500_rtc_set_alarm().

Thus, when going through rtc_update_irq_enable()->rtc_timer_enqueue(),
there's a chance it has an alarm timer1 queued before which is going to
fired, so this update timer2 will be queued because it isn't the leftmost
one, which means rtc_timer_enqueue() will return 0.

This will result in two problems:
1) UIE EMUL will not be used.
2) When the alarm timer1 is fired, in rtc_timer_do_work() timer2 will
   fail to set the alarm time, so this rtc will disfunctional due to
   timer2 with the earliest expires in the timerqueue.

So, rtc drivers must set this flag if they don't support UIE.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-ab8500.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index 727e2f5..866e0ef 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -504,6 +504,8 @@ static int ab8500_rtc_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	rtc->uie_unsupported = 1;
+
 	return 0;
 }
 
-- 
1.9.1

