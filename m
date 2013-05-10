Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3EJOVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57160 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab3EJOVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Derek Basehore" <dbasehore@chromium.org>,
        "Maxim Levitsky" <maximlevitsky@gmail.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, "Ingo Molnar" <mingo@elte.hu>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.169955352@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [066/118] drivers/rtc/rtc-cmos.c: don't disable hpet emulation on
 suspend
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-cmos.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -805,9 +805,8 @@ static int cmos_suspend(struct device *d
 			mask = RTC_IRQMASK;
 		tmp &= ~mask;
 		CMOS_WRITE(tmp, RTC_CONTROL);
+		hpet_mask_rtc_irq_bit(mask);
 
-		/* shut down hpet emulation - we don't need it for alarm */
-		hpet_mask_rtc_irq_bit(RTC_PIE|RTC_AIE|RTC_UIE);
 		cmos_checkintr(cmos, tmp);
 	}
 	spin_unlock_irq(&rtc_lock);
@@ -872,6 +871,7 @@ static int cmos_resume(struct device *de
 			rtc_update_irq(cmos->rtc, 1, mask);
 			tmp &= ~RTC_AIE;
 			hpet_mask_rtc_irq_bit(RTC_AIE);
+			hpet_rtc_timer_init();
 		} while (mask & RTC_AIE);
 		spin_unlock_irq(&rtc_lock);
 	}

