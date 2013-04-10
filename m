Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964949Ab3DJAg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:36:29 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:64811 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab3DJAg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:36:27 -0400
From: Derek Basehore <dbasehore@chromium.org>
To: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH] Don't disable hpet emulation on suspend
Date: Tue,  9 Apr 2013 17:36:13 -0700
Message-Id: <1365554173-24475-1-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a bug where rtc alarms are ignored after the rtc cmos suspends but
before the system finishes suspend. Since hpet emulation is disabled and it
still handles the interrupts, a wake event is never registered which is done
from the rtc layer. This reverts an earlier commit which disables hpet
emulation. To fix the problem mentioned in that commit, the hpet_rtc_timer_init
function is called directly on resume.

This reverts commit d1b2efa83fbf7b33919238fa29ef6ab935820103.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
---
 drivers/rtc/rtc-cmos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index af97c94..cc5bea9 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -804,9 +804,8 @@ static int cmos_suspend(struct device *dev)
 			mask = RTC_IRQMASK;
 		tmp &= ~mask;
 		CMOS_WRITE(tmp, RTC_CONTROL);
+		hpet_mask_rtc_irq_bit(mask);
 
-		/* shut down hpet emulation - we don't need it for alarm */
-		hpet_mask_rtc_irq_bit(RTC_PIE|RTC_AIE|RTC_UIE);
 		cmos_checkintr(cmos, tmp);
 	}
 	spin_unlock_irq(&rtc_lock);
@@ -870,6 +869,7 @@ static int cmos_resume(struct device *dev)
 			rtc_update_irq(cmos->rtc, 1, mask);
 			tmp &= ~RTC_AIE;
 			hpet_mask_rtc_irq_bit(RTC_AIE);
+			hpet_rtc_timer_init();
 		} while (mask & RTC_AIE);
 		spin_unlock_irq(&rtc_lock);
 	}
-- 
1.8.1.3

