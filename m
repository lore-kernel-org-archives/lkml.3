Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbaEIIlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:41:07 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:53978 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbaEIIlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:41:03 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] tick: SHUTDOWN event-dev if no events are required for KTIME_MAX
Date: Fri,  9 May 2014 14:10:23 +0530
Message-Id: <0fe81b08a8aa32912ce7b4a015fdc09b6e3830e3.1399623699.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1399623699.git.viresh.kumar@linaro.org>
References: <cover.1399623699.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1399623699.git.viresh.kumar@linaro.org>
References: <cover.1399623699.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When expires is set to KTIME_MAX in tick_program_event(), we are sure that there
are no events enqueued for a very long time and so there is no point keeping
event device running. We will get interrupted without any work to do many a
times, for example when timer's counter overflows.

So, its better to SHUTDOWN the event device then and restart it ones we get a
request for next event. For implementing this a new field 'last_mode' is added
to 'struct clock_event_device' to keep track of last mode used.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/clockchips.h |  1 +
 kernel/time/tick-oneshot.c | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 2e4cb67..36a4ca6 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -105,6 +105,7 @@ struct clock_event_device {
 	u32			mult;
 	u32			shift;
 	enum clock_event_mode	mode;
+	enum clock_event_mode	last_mode;
 	unsigned int		features;
 	unsigned long		retries;
 
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 8241090..9543815 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -27,8 +27,20 @@
 int tick_program_event(ktime_t expires, int force)
 {
 	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
+	int ret = 0;
 
-	return clockevents_program_event(dev, expires, force);
+	/* Shut down event device if it is not required for long */
+	if (unlikely(expires.tv64 == KTIME_MAX)) {
+		dev->last_mode = dev->mode;
+		clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
+	} else {
+		/* restore mode when restarting event dev */
+		if (unlikely(dev->mode == CLOCK_EVT_MODE_SHUTDOWN))
+			clockevents_set_mode(dev, dev->last_mode);
+		ret = clockevents_program_event(dev, expires, force);
+	}
+
+	return ret;
 }
 
 /**
-- 
2.0.0.rc2

