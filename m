Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaDXXEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:04:53 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61608 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaDXXEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:04:50 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 3/3] [RFC] timekeeping: Loop in the freqadjust logic to speed up convergence
Date: Thu, 24 Apr 2014 16:04:37 -0700
Message-Id: <1398380677-8684-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398380677-8684-1-git-send-email-john.stultz@linaro.org>
References: <1398380677-8684-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not convinced this is necessary, but this patch changes
the freqadjust logic so instead of approximating the correct
frequency adjustment making one logarithmic adjustment per tick,
we loop until the correct adjustment is found on the first call.

Thus, rather then splitting the correction up over a number of ticks
we do it all in the first tick. This is an increase of work, but
should avoid error accumulation which would slow convergence.

Again, I'm not sure the error accumulation is significant enough
to warrant the extra work here, but it improves simulator results
so I'm including this change for review and discussion.

Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index a130d00..6e715c3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1139,6 +1139,7 @@ static __always_inline void timekeeping_freqadjust(struct timekeeper *tk,
 	bool negative;
 	u32 adj;
 
+again:
 	tk->ntp_tick = ntp_tick_length();
 	/* Calculate current error per tick */
 	tick_error = ntp_tick_length() >> tk->ntp_error_shift;
@@ -1159,6 +1160,8 @@ static __always_inline void timekeeping_freqadjust(struct timekeeper *tk,
 
 	/* scale the corrections */
 	timekeeping_apply_adjustment(tk, offset, negative, adj);
+	if (adj)
+		goto again;
 }
 
 
-- 
1.8.3.2

