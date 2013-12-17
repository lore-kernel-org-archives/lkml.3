Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab3LQT1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:27:48 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44745 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3LQT1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:27:46 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH 1/3] timekeeping: Fix lost updates to tai adjustment
Date: Tue, 17 Dec 2013 11:27:35 -0800
Message-Id: <1387308457-25364-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387308457-25364-1-git-send-email-john.stultz@linaro.org>
References: <1387308457-25364-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 48cdc135d4840 (Implement a shadow timekeeper), we have to
call timekeeping_update() after any adjustment to the timekeeping
structure in order to make sure that any adjustments to the structure
persist.

Unfortunately, the updates to the tai offset via adjtimex do not
trigger this update, causing adjustments to the tai offset to be
made and then over-written by the previous value at the next
update_wall_time() call.

This patch resovles the issue by calling timekeeping_update()
right after setting the tai offset.

Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable <stable@vger.kernel.org> #3.10+
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 87b4f00..6bad3d9 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -610,6 +610,7 @@ void timekeeping_set_tai_offset(s32 tai_offset)
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 	__timekeeping_set_tai_offset(tk, tai_offset);
+	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	clock_was_set();
@@ -1698,7 +1699,7 @@ int do_adjtimex(struct timex *txc)
 
 	if (tai != orig_tai) {
 		__timekeeping_set_tai_offset(tk, tai);
-		update_pvclock_gtod(tk, true);
+		timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 		clock_was_set_delayed();
 	}
 	write_seqcount_end(&timekeeper_seq);
-- 
1.8.3.2

