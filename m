Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab3DYUeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:34:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:45978 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773Ab3DYUbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:46 -0400
Message-Id: <20130425143435.762417789@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 04/15] clocksource: Add module refcount
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline; filename=clocksource-add-module-refcount.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a module refcount, so the current clocksource cannot be removed
unconditionally.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clocksource.h |    3 +++
 kernel/time/timekeeping.c   |   15 ++++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

Index: tip/include/linux/clocksource.h
===================================================================
--- tip.orig/include/linux/clocksource.h
+++ tip/include/linux/clocksource.h
@@ -21,6 +21,7 @@
 /* clocksource cycle base type */
 typedef u64 cycle_t;
 struct clocksource;
+struct module;
 
 #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
 #include <asm/clocksource.h>
@@ -162,6 +163,7 @@ extern u64 timecounter_cyc2time(struct t
  * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
  * @cycle_last:		most recent cycle counter value seen by ::read()
+ * @owner:		module reference
  */
 struct clocksource {
 	/*
@@ -195,6 +197,7 @@ struct clocksource {
 	cycle_t cs_last;
 	cycle_t wd_last;
 #endif
+	struct module *owner;
 } ____cacheline_aligned;
 
 /*
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -627,11 +627,16 @@ static int change_clocksource(void *data
 	write_seqcount_begin(&timekeeper_seq);
 
 	timekeeping_forward_now(tk);
-	if (!new->enable || new->enable(new) == 0) {
-		old = tk->clock;
-		tk_setup_internals(tk, new);
-		if (old->disable)
-			old->disable(old);
+	if (try_module_get(new->owner)) {
+		if (!new->enable || new->enable(new) == 0) {
+			old = tk->clock;
+			tk_setup_internals(tk, new);
+			if (old->disable)
+				old->disable(old);
+			module_put(old->owner);
+		} else {
+			module_put(new->owner);
+		}
 	}
 	timekeeping_update(tk, true, true);
 


