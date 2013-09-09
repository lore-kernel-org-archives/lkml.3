Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab3IIT0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:26:20 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:49681 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3IIT0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:26:18 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Thorsten Glaser <tg@mirbsd.de>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] m68k: Add infrastructure for machine-specific get_cycles()
Date: Mon,  9 Sep 2013 21:26:13 +0200
Message-Id: <1378754774-25804-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently get_cycles() always returns zero.  As get_cycles() is called to
add entropy to the random number generator pool, security can be increased
by adding a hook where platforms can provide their own implementation.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/machdep.h |    1 +
 arch/m68k/include/asm/timex.h   |    5 +----
 arch/m68k/kernel/time.c         |   13 +++++++++++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/include/asm/machdep.h b/arch/m68k/include/asm/machdep.h
index 953ca21..334f751 100644
--- a/arch/m68k/include/asm/machdep.h
+++ b/arch/m68k/include/asm/machdep.h
@@ -22,6 +22,7 @@ extern unsigned int (*mach_get_ss)(void);
 extern int (*mach_get_rtc_pll)(struct rtc_pll_info *);
 extern int (*mach_set_rtc_pll)(struct rtc_pll_info *);
 extern int (*mach_set_clock_mmss)(unsigned long);
+extern cycles_t (*mach_get_cycles)(void);
 extern void (*mach_reset)( void );
 extern void (*mach_halt)( void );
 extern void (*mach_power_off)( void );
diff --git a/arch/m68k/include/asm/timex.h b/arch/m68k/include/asm/timex.h
index 6759dad..0fdc5d2 100644
--- a/arch/m68k/include/asm/timex.h
+++ b/arch/m68k/include/asm/timex.h
@@ -23,9 +23,6 @@
 
 typedef unsigned long cycles_t;
 
-static inline cycles_t get_cycles(void)
-{
-	return 0;
-}
+extern cycles_t get_cycles(void);
 
 #endif
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 7eb9792..65b1663 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -28,6 +28,19 @@
 #include <linux/timex.h>
 #include <linux/profile.h>
 
+
+cycles_t (*mach_get_cycles)(void);
+
+cycles_t get_cycles(void)
+{
+	if (mach_get_cycles)
+		return mach_get_cycles();
+
+	return 0;
+}
+EXPORT_SYMBOL(get_cycles);
+
+
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "xtime_update()" routine every clocktick
-- 
1.7.9.5

