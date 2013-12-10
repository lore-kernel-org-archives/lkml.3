Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3LJFKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:10:21 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33433 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3LJFKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:10:17 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
Subject: [RFC][PATCH 2/3] timekeeping: Fix missing timekeeping_update in suspend path
Date: Mon,  9 Dec 2013 21:09:56 -0800
Message-Id: <1386652197-7035-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386652197-7035-1-git-send-email-john.stultz@linaro.org>
References: <1386652197-7035-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 48cdc135d4840 (Implement a shadow timekeeper), we have to
call timekeeping_update() after any adjustment to the timekeeping
structure in order to make sure that any adjustments to the structure
persist.

In the timekeeping suspend path, we udpate the timekeeper
structure, so we should be sure to update the shadow-timekeeper
before releasing the timekeeping locks. Currently this isn't done.

In most cases, the next time related code to run would be
timekeeping_resume, which does update the shadow-timekeeper, but
in an abundence of caution, this patch adds the call to
timekeeping_update() in the suspend path.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable <stable@vger.kernel.org> #3.10+
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6bad3d9..c615e9d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1024,6 +1024,8 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
+
+	timekeeping_update(tk, TK_MIRROR);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
-- 
1.8.3.2

