Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbaBUNCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:02:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47782 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbaBUNC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 42/60] time: Fix overflow when HZ is smaller than 60
Date: Fri, 21 Feb 2014 13:01:09 +0000
Message-Id: <1392987687-15367-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 80d767d770fd9c697e434fd080c2db7b5c60c6dd upstream.

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
Link: http://lkml.kernel.org/r/alpine.LRH.2.02.1401241639100.23871@file01.intranet.prod.int.rdu2.redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/jiffies.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index a470154..955560e 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
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
-- 
1.9.0

