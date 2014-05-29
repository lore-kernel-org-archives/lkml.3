Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998AbaE2JJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:09:35 -0400
Received: from spostino.sms.unimo.it ([155.185.44.3]:41522 "EHLO
	spostino.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934258AbaE2JGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:06:52 -0400
From: Paolo Valente <paolo.valente@unimore.it>
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Cc: Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Paolo Valente <paolo.valente@unimore.it>
Subject: [PATCH RFC - TAKE TWO - 04/12] block, bfq: modify the peak-rate estimator
Date: Thu, 29 May 2014 11:05:35 +0200
Message-Id: <1401354343-5527-5-git-send-email-paolo.valente@unimore.it>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
UNIMORE-X-SA-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless the maximum budget B_max that BFQ can assign to a queue is set
explicitly by the user, BFQ automatically updates B_max. In
particular, BFQ dynamically sets B_max to the number of sectors that
can be read, at the current estimated peak rate, during the maximum
time, T_max, allowed before a budget timeout occurs. In formulas, if
we denote as R_est the estimated peak rate, then B_max = T_max ∗
R_est. Hence, the higher R_est is with respect to the actual disk peak
rate, the higher the probability that processes incur budget timeouts
unjustly is. Besides, a too high value of B_max unnecessarily
increases the deviation from an ideal, smooth service.

To filter out spikes, the estimated peak rate is updated only on the
expiration of queues that have been served for a long-enough time.  As
a first step, the estimator computes the device rate, R_meas, during
the service of the queue. After that, if R_est < R_meas, then R_est is
set to R_meas.

Unfortunately, our experiments highlighted the following two
problems. First, because of ZBR, depending on the locality of the
workload, the estimator may easily converge to a value that is
appropriate only for part of a disk. Second, R_est may jump (and
remain forever equal) to a much higher value than the actual device
peak rate, in case of hits in the drive cache, which may let sectors
be transferred in practice at bus rate.

To try to converge to the actual average peak rate over the disk
surface (in case of rotational devices), and to smooth the spikes
caused by the drive cache, this patch changes the estimator as
follows. In the description of the changes, we refer to a queue
containing random requests as 'seeky', according to the terminology
used in the code, and inherited from CFQ.

- First, now R_est may be updated also in case the just-expired queue,
  despite not being detected as seeky, has not been however able to
  consume all of its budget within the maximum time slice T_max. In
  fact, this is an indication that B_max is too large. Since B_max =
  T_max ∗ R_est, R_est is then probably too large, and should be
  reduced.

- Second, to filter the spikes in R_meas, a discrete low-pass filter
  is now used to update R_est instead of just keeping the highest rate
  sampled. The rationale is that the average peak rate of a disk over
  its surface is a relatively stable quantity, hence a low-pass filter
  should converge more or less quickly to the right value.

With the current values of the constants used in the filter, the
latter seems to effectively smooth fluctuations and allow the
estimator to converge to the actual peak rate with all the devices we
tested.

Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 block/bfq-iosched.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 49ff1da..2a4e03d 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -818,7 +818,7 @@ static unsigned long bfq_calc_max_budget(u64 peak_rate, u64 timeout)
  * throughput. See the code for more details.
  */
 static int bfq_update_peak_rate(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-				int compensate)
+				int compensate, enum bfqq_expiration reason)
 {
 	u64 bw, usecs, expected, timeout;
 	ktime_t delta;
@@ -854,10 +854,23 @@ static int bfq_update_peak_rate(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	 * the peak rate estimation.
 	 */
 	if (usecs > 20000) {
-		if (bw > bfqd->peak_rate) {
-			bfqd->peak_rate = bw;
+		if (bw > bfqd->peak_rate ||
+		   (!BFQQ_SEEKY(bfqq) &&
+		    reason == BFQ_BFQQ_BUDGET_TIMEOUT)) {
+			bfq_log(bfqd, "measured bw =%llu", bw);
+			/*
+			 * To smooth oscillations use a low-pass filter with
+			 * alpha=7/8, i.e.,
+			 * new_rate = (7/8) * old_rate + (1/8) * bw
+			 */
+			do_div(bw, 8);
+			if (bw == 0)
+				return 0;
+			bfqd->peak_rate *= 7;
+			do_div(bfqd->peak_rate, 8);
+			bfqd->peak_rate += bw;
 			update = 1;
-			bfq_log(bfqd, "new peak_rate=%llu", bw);
+			bfq_log(bfqd, "new peak_rate=%llu", bfqd->peak_rate);
 		}
 
 		update |= bfqd->peak_rate_samples == BFQ_PEAK_RATE_SAMPLES - 1;
@@ -936,7 +949,7 @@ static void bfq_bfqq_expire(struct bfq_data *bfqd,
 	/* Update disk peak rate for autotuning and check whether the
 	 * process is slow (see bfq_update_peak_rate).
 	 */
-	slow = bfq_update_peak_rate(bfqd, bfqq, compensate);
+	slow = bfq_update_peak_rate(bfqd, bfqq, compensate, reason);
 
 	/*
 	 * As above explained, 'punish' slow (i.e., seeky), timed-out
-- 
1.9.2

