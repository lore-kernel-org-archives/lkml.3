Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbaBUBH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:07:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaBTXug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:50:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.4 22/25] time: Fix overflow when HZ is smaller than 60
Date: Thu, 20 Feb 2014 15:51:38 -0800
Message-Id: <20140220234843.105558201@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234842.483343851@linuxfoundation.org>
References: <20140220234842.483343851@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/jiffies.c |    6 ++++++
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


