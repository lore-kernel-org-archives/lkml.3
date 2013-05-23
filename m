Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3EWBL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 21:11:28 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:48369 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab3EWBL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 21:11:27 -0400
From: Derek Basehore <dbasehore@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        akpm@linux-foundation.org, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH] rtc: cmos: Fix accidentally enabling rtc channel
Date: Wed, 22 May 2013 18:04:05 -0700
Message-Id: <1369271045-17410-1-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During resume, we call hpet_rtc_timer_init after masking an irq bit in hpet.
This will cause the call to hpet_disable_rtc_channel to be undone if RTC_AIE is
the only bit not masked.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
---
 drivers/rtc/rtc-cmos.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index cc5bea9..ee0bc69 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -854,6 +854,10 @@ static int cmos_resume(struct device *dev)
 		}
 
 		spin_lock_irq(&rtc_lock);
+		if (device_may_wakeup(dev)) {
+			hpet_rtc_timer_init();
+		}
+
 		do {
 			CMOS_WRITE(tmp, RTC_CONTROL);
 			hpet_set_rtc_irq_bit(tmp & RTC_IRQMASK);
@@ -869,7 +873,6 @@ static int cmos_resume(struct device *dev)
 			rtc_update_irq(cmos->rtc, 1, mask);
 			tmp &= ~RTC_AIE;
 			hpet_mask_rtc_irq_bit(RTC_AIE);
-			hpet_rtc_timer_init();
 		} while (mask & RTC_AIE);
 		spin_unlock_irq(&rtc_lock);
 	}
-- 
1.8.2.1

