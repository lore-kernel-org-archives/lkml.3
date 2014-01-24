Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaAXVls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 16:41:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbaAXVll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 16:41:41 -0500
Date: Fri, 24 Jan 2014 16:41:36 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] Fix overflow when HZ is smaller than 60
In-Reply-To: <alpine.LRH.2.02.1401241218470.16419@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1401241639100.23871@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401241218470.16419@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch that I sent before had wrong numbers in it, it could result in 
"Clocksource jiffies might overflow on 11% adjustment" message. This is 
the patch with correct numbers.

> +#if HZ < 30
> +#define JIFFIES_SHIFT	6
> +#elif HZ < 60
> +#define JIFFIES_SHIFT	7
> +#else
>  #define JIFFIES_SHIFT	8
> +#endif

From: Mikulas Patocka <mpatocka@redhat.com>

Fix overflow when HZ is 32

When compiling for the IA-64 ski emulator, HZ is set to 32 because the
emulation is slow and we don't want to waste too many cycles processing
timers. Alpha also has an option to set HZ to 32.

This causes integer underflow in
kernel/time/jiffies.c:
kernel/time/jiffies.c:66:2: warning: large integer implicitly truncated to unsigned type [-Woverflow]
  .mult  = NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
  ^

This patch reduces the JIFFIES_SHIFT value to avoid the overflow.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: stable@vger.kernel.org

---
 kernel/time/jiffies.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6-ia64/kernel/time/jiffies.c
===================================================================
--- linux-2.6-ia64.orig/kernel/time/jiffies.c	2014-01-24 22:34:17.000000000 +0100
+++ linux-2.6-ia64/kernel/time/jiffies.c	2014-01-24 22:36:56.000000000 +0100
@@ -51,7 +51,13 @@
  * HZ shrinks, so values greater than 8 overflow 32bits when
  * HZ=100.
  */
+#if HZ < 34
+#define JIFFIES_SHIFT	6
+#elif HZ < 67
+#define JIFFIES_SHIFT	7
+#else
 #define JIFFIES_SHIFT	8
+#endif
 
 static cycle_t jiffies_read(struct clocksource *cs)
 {
