Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbbAPQ5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:57:55 -0500
Received: from down.free-electrons.com ([37.187.137.238]:35785 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752640AbbAPQ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:57:29 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 1/2] clocksource: track usage
Date: Fri, 16 Jan 2015 17:57:18 +0100
Message-Id: <1421427439-11699-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421427439-11699-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421427439-11699-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Track whether the clocksource is enabled or disabled.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 include/linux/clocksource.h |  4 ++++
 kernel/time/clocksource.c   | 30 ++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c   |  8 +++-----
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index abcafaa20b86..7735902fc5f6 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -210,6 +210,8 @@ struct clocksource {
 #define CLOCK_SOURCE_SUSPEND_NONSTOP		0x80
 #define CLOCK_SOURCE_RESELECT			0x100
 
+#define CLOCK_SOURCE_USED			0x200
+
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
 
@@ -282,6 +284,8 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 
 extern int clocksource_register(struct clocksource*);
 extern int clocksource_unregister(struct clocksource*);
+extern int clocksource_enable(struct clocksource *);
+extern void clocksource_disable(struct clocksource *);
 extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index b79f39bda7e1..03cfc5a08e3b 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -889,6 +889,36 @@ int clocksource_unregister(struct clocksource *cs)
 }
 EXPORT_SYMBOL(clocksource_unregister);
 
+/**
+ * clocksource_enable - enable a registered clocksource
+ * @cs:	clocksource to enable
+ */
+int clocksource_enable(struct clocksource *cs)
+{
+	int ret = 0;
+
+	if (cs->enable)
+		ret = cs->enable(cs);
+
+	if (!ret)
+		cs->flags |= CLOCK_SOURCE_USED;
+
+	return ret;
+}
+EXPORT_SYMBOL(clocksource_enable);
+
+/**
+ * clocksource_disable - disable a registered clocksource
+ * @cs:	clocksource to disable
+ */
+void clocksource_disable(struct clocksource *cs)
+{
+	cs->flags &= ~CLOCK_SOURCE_USED;
+	if (cs->disable)
+		cs->disable(cs);
+}
+EXPORT_SYMBOL(clocksource_disable);
+
 #ifdef CONFIG_SYSFS
 /**
  * sysfs_show_current_clocksources - sysfs interface for current clocksource
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6a931852082f..82da6b94382c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -915,11 +915,10 @@ static int change_clocksource(void *data)
 	 * for built-in code (owner == NULL) as well.
 	 */
 	if (try_module_get(new->owner)) {
-		if (!new->enable || new->enable(new) == 0) {
+		if (clocksource_enable(new) == 0) {
 			old = tk->tkr.clock;
 			tk_setup_internals(tk, new);
-			if (old->disable)
-				old->disable(old);
+			clocksource_disable(old);
 			module_put(old->owner);
 		} else {
 			module_put(new->owner);
@@ -1080,8 +1079,7 @@ void __init timekeeping_init(void)
 	ntp_init();
 
 	clock = clocksource_default_clock();
-	if (clock->enable)
-		clock->enable(clock);
+	clocksource_enable(clock);
 	tk_setup_internals(tk, clock);
 
 	tk_set_xtime(tk, &now);
-- 
2.1.0

