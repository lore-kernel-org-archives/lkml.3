Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaFWBdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:33:00 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39774 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbaFWBcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:55 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "Christopher J. Morrone" <morrone2@llnl.gov>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 10/18] staging/lustre/ptlrpc: Add schedule point to ptlrpc_check_set()
Date: Sun, 22 Jun 2014 21:32:14 -0400
Message-Id: <1403487142-4880-11-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Christopher J. Morrone" <morrone2@llnl.gov>

Most ptlrpc sets are believed to be small and bounded in length.  However
at the very least the ptlrpcd reuses the ptlrpc sets at its primary work
queue.  This work queue can easily have work added faster than the ptlrpcd
thread can process the work.  The unbounded work can lead to the ptlrpcd
monopolizing a CPU for hundreds of seconds.  Obviously a well-behaved
kernel function should obey the scheduler and share the processor.

We address that problem by inserting a cond_resched() at the top of the
main loop of ptlrpc_check_set().

Some have suggested putting the cond_resched() lower in the loop.  However,
the only current way to bound the number of loops that we exceed our
allocated run time is to put the call at the top of the loop.  Putting it
lower would allow an unknown number (and since it is unknown, it might be
excessively large at times) of cycles through the loop before a
resched is allowed.

Signed-off-by: Christopher J. Morrone <morrone2@llnl.gov>
Reviewed-on: http://review.whamcloud.com/10358
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-5053
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index d806257..1890482 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -1496,6 +1496,8 @@ static inline int ptlrpc_set_producer(struct ptlrpc_request_set *set)
  * and no more replies are expected.
  * (it is possible to get less replies than requests sent e.g. due to timed out
  * requests or requests that we had trouble to send out)
+ *
+ * NOTE: This function contains a potential schedule point (cond_resched()).
  */
 int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 {
@@ -1513,6 +1515,14 @@ int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 		int unregistered = 0;
 		int rc = 0;
 
+		/* This schedule point is mainly for the ptlrpcd caller of this
+		 * function.  Most ptlrpc sets are not long-lived and unbounded
+		 * in length, but at the least the set used by the ptlrpcd is.
+		 * Since the processing time is unbounded, we need to insert an
+		 * explicit schedule point to make the thread well-behaved.
+		 */
+		cond_resched();
+
 		if (req->rq_phase == RQ_PHASE_NEW &&
 		    ptlrpc_send_new_req(req)) {
 			force_timer_recalc = 1;
-- 
1.9.0

