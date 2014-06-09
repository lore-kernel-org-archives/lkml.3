Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824AbaFIXMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:12:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaFIWp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.14 35/78] sched/deadline: Restrict user params max value to 2^63 ns
Date: Mon,  9 Jun 2014 15:48:15 -0700
Message-Id: <20140609224814.471852470@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juri Lelli <juri.lelli@gmail.com>

commit b0827819b0da4acfbc1df1e05edcf50efd07cbd1 upstream.

Michael Kerrisk noticed that creating SCHED_DEADLINE reservations
with certain parameters (e.g, a runtime of something near 2^64 ns)
can cause a system freeze for some amount of time.

The problem is that in the interface we have

 u64 sched_runtime;

while internally we need to have a signed runtime (to cope with
budget overruns)

 s64 runtime;

At the time we setup a new dl_entity we copy the first value in
the second. The cast turns out with negative values when
sched_runtime is too big, and this causes the scheduler to go crazy
right from the start.

Moreover, considering how we deal with deadlines wraparound

 (s64)(a - b) < 0

we also have to restrict acceptable values for sched_{deadline,period}.

This patch fixes the thing checking that user parameters are always
below 2^63 ns (still large enough for everyone).

It also rewrites other conditions that we check, since in
__checkparam_dl we don't have to deal with deadline wraparounds
and what we have now erroneously fails when the difference between
values is too big.

Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Dario Faggioli<raistlin@linux.it>
Cc: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140513141131.20d944f81633ee937f256385@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3242,17 +3242,40 @@ __getparam_dl(struct task_struct *p, str
  * We ask for the deadline not being zero, and greater or equal
  * than the runtime, as well as the period of being zero or
  * greater than deadline. Furthermore, we have to be sure that
- * user parameters are above the internal resolution (1us); we
- * check sched_runtime only since it is always the smaller one.
+ * user parameters are above the internal resolution of 1us (we
+ * check sched_runtime only since it is always the smaller one) and
+ * below 2^63 ns (we have to check both sched_deadline and
+ * sched_period, as the latter can be zero).
  */
 static bool
 __checkparam_dl(const struct sched_attr *attr)
 {
-	return attr && attr->sched_deadline != 0 &&
-		(attr->sched_period == 0 ||
-		(s64)(attr->sched_period   - attr->sched_deadline) >= 0) &&
-		(s64)(attr->sched_deadline - attr->sched_runtime ) >= 0  &&
-		attr->sched_runtime >= (2 << (DL_SCALE - 1));
+	/* deadline != 0 */
+	if (attr->sched_deadline == 0)
+		return false;
+
+	/*
+	 * Since we truncate DL_SCALE bits, make sure we're at least
+	 * that big.
+	 */
+	if (attr->sched_runtime < (1ULL << DL_SCALE))
+		return false;
+
+	/*
+	 * Since we use the MSB for wrap-around and sign issues, make
+	 * sure it's not set (mind that period can be equal to zero).
+	 */
+	if (attr->sched_deadline & (1ULL << 63) ||
+	    attr->sched_period & (1ULL << 63))
+		return false;
+
+	/* runtime <= deadline <= period (if period != 0) */
+	if ((attr->sched_period != 0 &&
+	     attr->sched_period < attr->sched_deadline) ||
+	    attr->sched_deadline < attr->sched_runtime)
+		return false;
+
+	return true;
 }
 
 /*


