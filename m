Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3ERDAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836Ab3ERDAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:34 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=FTY8uI-ngBYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Q4JcG_loK5wA:10 a=cm27Pg_UAAAA:8 a=pGLkceISAAAA:8 a=oGMlB6cnAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=C97uUp5i6XLLRc_JQigA:9 a=zv9_9hqRWm8A:10 a=MSl-tDqOz04A:10 a=CY6gl2JlH4YA:10 a=Zh68SRI7RUMA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021650.801338676@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Derek Basehore <dbasehore@chromium.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 056/136 ] drivers/rtc/rtc-cmos.c: dont disable hpet emulation on suspend
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0056-drivers-rtc-rtc-cmos.c-don-t-disable-hpet-emulation-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Derek Basehore <dbasehore@chromium.org>

[ Upstream commit e005715efaf674660ae59af83b13822567e3a758 ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/rtc/rtc-cmos.c |    4 ++--
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
1.7.10.4


