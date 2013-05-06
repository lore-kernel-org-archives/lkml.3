Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab3EFX7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:59:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab3EFW5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:57:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Derek Basehore <dbasehore@chromium.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 42/63] drivers/rtc/rtc-cmos.c: dont disable hpet emulation on suspend
Date: Mon,  6 May 2013 15:56:20 -0700
Message-Id: <20130506225325.090645533@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


