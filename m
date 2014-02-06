Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaBFPEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:04:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43798 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbaBFPEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:04:46 -0500
Date: Thu, 6 Feb 2014 07:04:16 -0800
From: tip-bot for Mikulas Patocka <tipbot@zytor.com>
Message-ID: <tip-80d767d770fd9c697e434fd080c2db7b5c60c6dd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mikulas@artax.karlin.mff.cuni.cz, tglx@linutronix.de,
        mpatocka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mikulas@artax.karlin.mff.cuni.cz, tglx@linutronix.de,
        mpatocka@redhat.com
In-Reply-To: <alpine.LRH.2.02.1401241639100.23871@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401241639100.23871@file01.intranet.prod.int.rdu2.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time: Fix overflow when HZ is smaller than 60
Git-Commit-ID: 80d767d770fd9c697e434fd080c2db7b5c60c6dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 06 Feb 2014 07:04:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80d767d770fd9c697e434fd080c2db7b5c60c6dd
Gitweb:     http://git.kernel.org/tip/80d767d770fd9c697e434fd080c2db7b5c60c6dd
Author:     Mikulas Patocka <mpatocka@redhat.com>
AuthorDate: Fri, 24 Jan 2014 16:41:36 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 6 Feb 2014 16:01:40 +0100

time: Fix overflow when HZ is smaller than 60

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
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/time/jiffies.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 7a925ba..a6a5bf5 100644
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
