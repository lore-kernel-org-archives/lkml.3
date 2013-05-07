Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab3EGNoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:44:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42653 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428Ab3EGNmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Derek Basehore <dbasehore@chromium.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 109/118] drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend
Date: Tue,  7 May 2013 14:39:15 +0100
Message-Id: <1367933964-1564-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek Basehore <dbasehore@chromium.org>

commit e005715efaf674660ae59af83b13822567e3a758 upstream.

There's a bug where rtc alarms are ignored after the rtc cmos suspends
but before the system finishes suspend.  Since hpet emulation is
disabled and it still handles the interrupts, a wake event is never
registered which is done from the rtc layer.

This patch reverts commit d1b2efa83fbf ("rtc: disable hpet emulation on
suspend") which disabled hpet emulation.  To fix the problem mentioned
in that commit, hpet_rtc_timer_init() is called directly on resume.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/rtc/rtc-cmos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 4267789..6a4adf7 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -805,9 +805,8 @@ static int cmos_suspend(struct device *dev)
 			mask = RTC_IRQMASK;
 		tmp &= ~mask;
 		CMOS_WRITE(tmp, RTC_CONTROL);
+		hpet_mask_rtc_irq_bit(mask);
 
-		/* shut down hpet emulation - we don't need it for alarm */
-		hpet_mask_rtc_irq_bit(RTC_PIE|RTC_AIE|RTC_UIE);
 		cmos_checkintr(cmos, tmp);
 	}
 	spin_unlock_irq(&rtc_lock);
@@ -872,6 +871,7 @@ static int cmos_resume(struct device *dev)
 			rtc_update_irq(cmos->rtc, 1, mask);
 			tmp &= ~RTC_AIE;
 			hpet_mask_rtc_irq_bit(RTC_AIE);
+			hpet_rtc_timer_init();
 		} while (mask & RTC_AIE);
 		spin_unlock_irq(&rtc_lock);
 	}
-- 
1.8.1.2

