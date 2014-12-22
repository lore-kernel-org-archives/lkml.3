Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaLVSC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:02:58 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33296 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbaLVSC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:02:56 -0500
Date: Mon, 22 Dec 2014 18:02:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: System automatically wakes up because of Intel Rapid Start
 Technology
Message-ID: <20141222180254.GA13985@srcf.ucam.org>
References: <9927036.n7iZq92iLW@xps13>
 <20141222145949.GB11844@srcf.ucam.org>
 <3318216.XHaCQKkcW4@xps13>
 <3142141.XpVRfRv0Jy@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3142141.XpVRfRv0Jy@xps13>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting this right is a little bit annoying - if the timer would have 
expired during the time we were suspended, we don't want to re-enable 
it. I *think* this covers all cases, and does it in generic code rather 
than special-casing it. Any chance you can give it a test?

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 472a5ad..4e3a2a1 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -91,6 +91,8 @@ static int rtc_suspend(struct device *dev)
 		old_system = timespec64_sub(old_system, delta_delta);
 	}
 
+	rtc->valid_alarm = !rtc_read_alarm(rtc, &rtc->alarm);
+
 	return 0;
 }
 
@@ -145,6 +147,29 @@ static int rtc_resume(struct device *dev)
 	if (sleep_time.tv_sec >= 0)
 		timekeeping_inject_sleeptime64(&sleep_time);
 	rtc_hctosys_ret = 0;
+
+	/*
+	 * If there was an alarm set before suspend, make sure that the
+	 * platform hasn't overwritten it
+	 */
+	if (rtc->valid_alarm) {
+		struct rtc_time tm;
+		long now, scheduled;
+
+		rtc_read_time(rtc, &tm);
+		rtc_tm_to_time(&rtc->alarm.time, &scheduled);
+		rtc_tm_to_time(&tm, &now);
+
+		/* Clear the alarm if it went off during suspend */
+		if (scheduled <= now) {
+			rtc_time_to_tm(0, &rtc->alarm.time);
+			rtc->alarm.enabled = 0;
+		}
+
+		if (rtc->ops && rtc->ops->set_alarm)
+			rtc->ops->set_alarm(rtc->dev.parent, &rtc->alarm);
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 6d6be09..bc805ff 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -133,6 +133,10 @@ struct rtc_device
 	/* Some hardware can't support UIE mode */
 	int uie_unsupported;
 
+#ifdef CONFIG_PM_SLEEP
+	struct rtc_wkalrm alarm;
+	bool valid_alarm;
+#endif
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	struct work_struct uie_task;
 	struct timer_list uie_timer;


-- 
Matthew Garrett | mjg59@srcf.ucam.org
