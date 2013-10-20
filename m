Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3JTLKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 07:10:09 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35991 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3JTLKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 07:10:08 -0400
Date: Sun, 20 Oct 2013 13:10:06 +0200
From: Andreas Mohr <andi@lisas.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4/5] sched: Refactor iowait accounting
Message-ID: <20131020111006.GA26671@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382195841-6558-5-git-send-email-fweisbec@gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


+u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
+{
+	ktime_t iowait, delta = { .tv64 = 0 };
+	struct rq *rq = cpu_rq(cpu);
+	ktime_t now = ktime_get();
+	unsigned int seq;
+
+	do {
+		seq = read_seqbegin(&rq->iowait_lock);
+		if (rq->nr_iowait)
+			delta = ktime_sub(now, rq->iowait_start);
+		iowait = ktime_add(rq->iowait_time, delta);
+	} while (read_seqretry(&rq->iowait_lock, seq));


AFAICS that's slightly buggy, in light of:


+static void cpu_iowait_end(struct rq *rq)
+{
+	ktime_t delta;
+	write_seqlock(&rq->iowait_lock);
+	if (!--rq->nr_iowait) {
+		delta = ktime_sub(ktime_get(), rq->iowait_start);
+		rq->iowait_time = ktime_add(rq->iowait_time, delta);
+	}
+	write_sequnlock(&rq->iowait_lock);
+}

get_cpu_iowait_time_us() loops until update is consistent,
yet its "delta" will have been assigned previously
(*and potentially not updated*),
yet then a subsequent cpu_iowait_end() does provide a final consistent
update (by updating that very iowait_time base value taking the current delta
[destructively] into account!!)
and the other get_cpu_iowait_time_us's delta value remained stale
(iff nr_iowait now back to zero!).

IOW, newly updated iowait_time base value already (and re-evaluated),
yet *old* delta still being added to this *new* base value.



Further thoughts:

Janitorial: cpu_iowait_end(): might be useful to move ktime_t delta
into local scope.

Would be nice to move inner handling of get_cpu_iowait_time_us()
into an rq-focussed properly named helper function (to reflect the fact that
while this is stored in rq it's merely being used to derive CPU-side status
values from it), but it seems "ktime_t now" would then have to be
grabbed multiple times, which would be a complication.

In case of high update traffic of parts guarded by rq->iowait_lock
(is that a relevant case?),
it might be useful to merely grab all relevant values into helper vars
(i.e., establish a consistent "view" on things), now, start, nr_iowait etc. -
this would enable us to do ktime_sub(), ktime_add() calculations
*once*, after the fact. Drawback would be that this reduces seqlock
guard scope (would not be active any more during runtime spent for calculations,
i.e. another update may happen during that calculation time),
but then that function's purpose merely is to provide a *consistent
one-time probe* of a continually updated value anyway, so it does not
matter if we happen to return values of one update less
than is already available.


Thank you very much for working on improving this important infrastructure code!

Andreas Mohr
