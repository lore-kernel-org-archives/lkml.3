Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaIHGlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:41:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51517 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaIHGlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:41:08 -0400
Date: Sun, 7 Sep 2014 23:40:12 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-eb1b4af0a64ac7bb0ee36f579c1c7cefcbc3ac2c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1408133138-22048-4-git-send-email-riel@redhat.com>
References: <1408133138-22048-4-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, time: Atomically increment stime & utime
Git-Commit-ID: eb1b4af0a64ac7bb0ee36f579c1c7cefcbc3ac2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb1b4af0a64ac7bb0ee36f579c1c7cefcbc3ac2c
Gitweb:     http://git.kernel.org/tip/eb1b4af0a64ac7bb0ee36f579c1c7cefcbc3ac2c
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 15 Aug 2014 16:05:38 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Sep 2014 08:17:02 +0200

sched, time: Atomically increment stime & utime

The functions task_cputime_adjusted and thread_group_cputime_adjusted()
can be called locklessly, as well as concurrently on many different CPUs.

This can occasionally lead to the utime and stime reported by times(), and
other syscalls like it, going backward. The cause for this appears to be
multiple threads racing in cputime_adjust(), both with values for utime or
stime that is larger than the original, but each with a different value.

Sometimes the larger value gets saved first, only to be immediately
overwritten with a smaller value by another thread.

Using atomic exchange prevents that problem, and ensures time
progresses monotonically.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: umgwanakikbuti@gmail.com
Cc: fweisbec@gmail.com
Cc: akpm@linux-foundation.org
Cc: srao@redhat.com
Cc: lwoodman@redhat.com
Cc: atheurer@redhat.com
Cc: oleg@redhat.com
Link: http://lkml.kernel.org/r/1408133138-22048-4-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cputime.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 49b7cfe..2b57031 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -602,9 +602,12 @@ static void cputime_adjust(struct task_cputime *curr,
 	 * If the tick based count grows faster than the scheduler one,
 	 * the result of the scaling may go backward.
 	 * Let's enforce monotonicity.
+	 * Atomic exchange protects against concurrent cputime_adjust().
 	 */
-	prev->stime = max(prev->stime, stime);
-	prev->utime = max(prev->utime, utime);
+	while (stime > (rtime = ACCESS_ONCE(prev->stime)))
+		cmpxchg(&prev->stime, rtime, stime);
+	while (utime > (rtime = ACCESS_ONCE(prev->utime)))
+		cmpxchg(&prev->utime, rtime, utime);
 
 out:
 	*ut = prev->utime;
