Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935114Ab3DKIaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:30:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39309 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3DKIaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:30:21 -0400
Date: Thu, 11 Apr 2013 01:30:06 -0700
From: tip-bot for John Stultz <tipbot@zytor.com>
Message-ID: <tip-4e8f8b34b92b6514cc070aeb94d317cadd5071d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1365622909-953-1-git-send-email-john.stultz@linaro.org>
References: <1365622909-953-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timekeeping:
  Make sure to notify hrtimers when TAI offset changes
Git-Commit-ID: 4e8f8b34b92b6514cc070aeb94d317cadd5071d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 11 Apr 2013 01:30:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e8f8b34b92b6514cc070aeb94d317cadd5071d7
Gitweb:     http://git.kernel.org/tip/4e8f8b34b92b6514cc070aeb94d317cadd5071d7
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Wed, 10 Apr 2013 12:41:49 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 11 Apr 2013 10:19:44 +0200

timekeeping: Make sure to notify hrtimers when TAI offset changes

Now that we have CLOCK_TAI timers, make sure we notify hrtimer
code when TAI offset is changed.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/1365622909-953-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index c4d2a87..675f720 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -607,6 +607,7 @@ void timekeeping_set_tai_offset(s32 tai_offset)
 	__timekeeping_set_tai_offset(tk, tai_offset);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+	clock_was_set();
 }
 
 /**
@@ -1639,7 +1640,7 @@ int do_adjtimex(struct timex *txc)
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
 	struct timespec ts;
-	s32 tai;
+	s32 orig_tai, tai;
 	int ret;
 
 	/* Validate the data before disabling interrupts */
@@ -1663,10 +1664,13 @@ int do_adjtimex(struct timex *txc)
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 
-	tai = tk->tai_offset;
+	orig_tai = tai = tk->tai_offset;
 	ret = __do_adjtimex(txc, &ts, &tai);
 
-	__timekeeping_set_tai_offset(tk, tai);
+	if (tai != orig_tai) {
+		__timekeeping_set_tai_offset(tk, tai);
+		clock_was_set_delayed();
+	}
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
