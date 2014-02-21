Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbaBUNte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:49:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46903 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaBUMuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 038/121] timekeeping: Fix lost updates to tai adjustment
Date: Fri, 21 Feb 2014 12:47:42 +0000
Message-Id: <1392986945-9693-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit f55c07607a38f84b5c7e6066ee1cfe433fa5643c upstream.

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
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/timekeeping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5cf6c70..22f3ae2 100644
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
@@ -1697,7 +1698,7 @@ int do_adjtimex(struct timex *txc)
 
 	if (tai != orig_tai) {
 		__timekeeping_set_tai_offset(tk, tai);
-		update_pvclock_gtod(tk, true);
+		timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 		clock_was_set_delayed();
 	}
 	write_seqcount_end(&timekeeper_seq);
-- 
1.9.0

