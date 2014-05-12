Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaELJao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:30:44 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35619 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbaELJah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:30:37 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        arvind.chauhan@arm.com, daniel.lezcano@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC 2/2] clockevents: add ->set_dev_mode() to struct clock_event_device
Date: Mon, 12 May 2014 15:00:06 +0530
Message-Id: <0e036bbf00178049b542c450eabc246b8a88f687.1399886467.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1399886467.git.viresh.kumar@linaro.org>
References: <cover.1399886467.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1399886467.git.viresh.kumar@linaro.org>
References: <cover.1399886467.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a requirement to add another mode: CLOCK_EVT_MODE_ONESHOT_STOPPED
(lkml.org/lkml/2014/5/9/508) to clockevent devices and clockevent-drivers may or
maynot support it. And so can return failure codes on a call to ->set_mode(),
which has a return type of 'void' as of now.

To fix that, add another callback ->set_dev_mode(), with return type 'int'. All
clockevent drivers will be migrated to use this new interface later. Also mark
->set_mode() deprecated.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/clockchips.h |  5 ++++-
 kernel/time/clockevents.c  | 26 ++++++++++++++++++++------
 kernel/time/timer_list.c   |  9 +++++++--
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 4e7a4d3..e15836f 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -81,7 +81,8 @@ enum clock_event_mode {
  * @mode:		operating mode assigned by the management code
  * @features:		features
  * @retries:		number of forced programming retries
- * @set_mode:		set mode function
+ * @set_dev_mode:	set state function
+ * @set_mode:		set mode function (deprecated, use set_dev_mode instead)
  * @broadcast:		function to broadcast events
  * @min_delta_ticks:	minimum delta value in ticks stored for reconfiguration
  * @max_delta_ticks:	maximum delta value in ticks stored for reconfiguration
@@ -109,6 +110,8 @@ struct clock_event_device {
 	unsigned long		retries;
 
 	void			(*broadcast)(const struct cpumask *mask);
+	int			(*set_dev_mode)(enum clock_event_mode mode,
+					    struct clock_event_device *);
 	void			(*set_mode)(enum clock_event_mode mode,
 					    struct clock_event_device *);
 	void			(*suspend)(struct clock_event_device *);
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 8665660..3ef5997 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -104,8 +104,17 @@ EXPORT_SYMBOL_GPL(clockevent_delta2ns);
 int clockevents_set_mode(struct clock_event_device *dev,
 				 enum clock_event_mode mode)
 {
+	int ret = 0;
+
 	if (dev->mode != mode) {
-		dev->set_mode(mode, dev);
+		if (dev->set_dev_mode)
+			ret = dev->set_dev_mode(mode, dev);
+		else
+			dev->set_mode(mode, dev);
+
+		if (unlikely(ret))
+			return ret;
+
 		dev->mode = mode;
 
 		/*
@@ -443,15 +452,20 @@ EXPORT_SYMBOL_GPL(clockevents_config_and_register);
 
 int __clockevents_update_freq(struct clock_event_device *dev, u32 freq)
 {
+	int ret = 0;
+
 	clockevents_config(dev, freq);
 
 	if (dev->mode == CLOCK_EVT_MODE_ONESHOT)
-		return clockevents_program_event(dev, dev->next_event, false);
-
-	if (dev->mode == CLOCK_EVT_MODE_PERIODIC)
-		dev->set_mode(CLOCK_EVT_MODE_PERIODIC, dev);
+		ret = clockevents_program_event(dev, dev->next_event, false);
+	else if (dev->mode == CLOCK_EVT_MODE_PERIODIC) {
+		if (dev->set_dev_mode)
+			ret = dev->set_dev_mode(CLOCK_EVT_MODE_PERIODIC, dev);
+		else
+			dev->set_mode(CLOCK_EVT_MODE_PERIODIC, dev);
+	}
 
-	return 0;
+	return ret;
 }
 
 /**
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 61ed862..3d854aa 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -228,8 +228,13 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 	print_name_offset(m, dev->set_next_event);
 	SEQ_printf(m, "\n");
 
-	SEQ_printf(m, " set_mode:       ");
-	print_name_offset(m, dev->set_mode);
+	if (dev->set_dev_mode) {
+		SEQ_printf(m, " set_dev_mode:       ");
+		print_name_offset(m, dev->set_dev_mode);
+	} else {
+		SEQ_printf(m, " set_mode:       ");
+		print_name_offset(m, dev->set_mode);
+	}
 	SEQ_printf(m, "\n");
 
 	SEQ_printf(m, " event_handler:  ");
-- 
2.0.0.rc2

