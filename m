Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3BUSsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:48:45 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:35454 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab3BUSsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:48:40 -0500
From: Ian Abbott <abbotti@mev.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH] timers: Add jsleep() and jsleep_interruptible()
Date: Thu, 21 Feb 2013 18:48:11 +0000
Message-Id: <1361472491-10848-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes you want the waitqueue wake-up ignoring effect of msleep() or
msleep_interruptible(), but happen to know the desired timeout in
jiffies rather than milliseconds.  In this case you'd do something like
this:

	msleep(jiffies_to_msecs(timeout_in_jiffies));

The first thing that msleep() and msleep_interruptible() do is convert
the parameter to jiffies (and msleep_interruptible() converts its return
value back to milliseconds).

The new functions jsleep() and jsleep_interruptible() behave like
msleep() and msleep_interruptible() except that the desired timeout (and
return value of jsleep_interruptible()) is specified in jiffies.  So the
above call could be simplified to:

	jsleep(timeout_in_jiffies);

I'm not sure how useful this would be, but there are a couple of places
in "serial_core.c" that could usefully call jsleep_interruptible()
instead of msleep_interruptible().

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 Documentation/timers/timers-howto.txt | 11 +++++++++--
 include/linux/delay.h                 |  2 ++
 kernel/timer.c                        | 32 +++++++++++++++++++++++++++-----
 3 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/Documentation/timers/timers-howto.txt b/Documentation/timers/timers-howto.txt
index 038f8c7..2911600 100644
--- a/Documentation/timers/timers-howto.txt
+++ b/Documentation/timers/timers-howto.txt
@@ -46,8 +46,11 @@ NON-ATOMIC CONTEXT:
 	-- Backed by hrtimers:
 		usleep_range(unsigned long min, unsigned long max)
 	-- Backed by jiffies / legacy_timers
-		msleep(unsigned long msecs)
-		msleep_interruptible(unsigned long msecs)
+		jsleep(unsigned long timeout)
+		jsleep_interruptible(unsigned long timeout)
+		msleep(unsigned int msecs)
+		msleep_interruptible(unsigned int msecs)
+		ssleep(unsigned int secs)
 
 	Unlike the *delay family, the underlying mechanism
 	driving each of these calls varies, thus there are
@@ -103,3 +106,7 @@ NON-ATOMIC CONTEXT:
 			short, the difference is whether the sleep can be ended
 			early by a signal. In general, just use msleep unless
 			you know you have a need for the interruptible variant.
+
+			If the required delay is in jiffies, jsleep and
+			jsleep_interruptible are good alternatives to msleep
+			and msleep_interruptible, respectively.
diff --git a/include/linux/delay.h b/include/linux/delay.h
index a6ecb34..dffa295 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -43,6 +43,8 @@ static inline void ndelay(unsigned long x)
 
 extern unsigned long lpj_fine;
 void calibrate_delay(void);
+void jsleep(unsigned long timeout);
+unsigned long jsleep_interruptible(unsigned long timeout);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
 void usleep_range(unsigned long min, unsigned long max);
diff --git a/kernel/timer.c b/kernel/timer.c
index dbf7a78..ebb3733 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1794,6 +1794,31 @@ void __init init_timers(void)
 }
 
 /**
+ * jsleep - sleep safely even with waitqueue interruptions
+ * @timeout: Time in jiffies to sleep for
+ */
+void jsleep(unsigned long timeout)
+{
+	while (timeout)
+		timeout = schedule_timeout_uninterruptible(timeout);
+}
+
+EXPORT_SYMBOL_GPL(jsleep);
+
+/**
+ * jsleep_interruptible - sleep waiting for signals
+ * @timeout: Time in jiffies to sleep for
+ */
+unsigned long jsleep_interruptible(unsigned long timeout)
+{
+	while (timeout && !signal_pending(current))
+		timeout = schedule_timeout_interruptible(timeout);
+	return timeout;
+}
+
+EXPORT_SYMBOL(jsleep_interruptible);
+
+/**
  * msleep - sleep safely even with waitqueue interruptions
  * @msecs: Time in milliseconds to sleep for
  */
@@ -1801,8 +1826,7 @@ void msleep(unsigned int msecs)
 {
 	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
 
-	while (timeout)
-		timeout = schedule_timeout_uninterruptible(timeout);
+	jsleep(timeout);
 }
 
 EXPORT_SYMBOL(msleep);
@@ -1815,9 +1839,7 @@ unsigned long msleep_interruptible(unsigned int msecs)
 {
 	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
 
-	while (timeout && !signal_pending(current))
-		timeout = schedule_timeout_interruptible(timeout);
-	return jiffies_to_msecs(timeout);
+	return jiffies_to_msecs(jsleep_interruptible(timeout));
 }
 
 EXPORT_SYMBOL(msleep_interruptible);
-- 
1.8.1.2

