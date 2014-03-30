Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaC3XqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:46:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37354 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213AbaC3XoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:44:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thomas Gleixner" <tglx@linutronix.de>,
        "Mikulas Patocka" <mpatocka@redhat.com>,
        "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.326503504@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 087/200] time: Fix overflow when HZ is smaller than 60
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/jiffies.c | 6 ++++++
 1 file changed, 6 insertions(+)

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

