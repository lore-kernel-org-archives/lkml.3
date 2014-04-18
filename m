Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaDRAIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:08:43 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57122 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDRAIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:08:40 -0400
Date: Fri, 18 Apr 2014 09:08:14 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: tj@kernel.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, daeseok.youn@gmail.com
Subject: [PATCH V2] workqueue: jumps to use_dfl_pwq if the target cpumask is
 equal wq's
Message-ID: <20140418000814.GA7622@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wq_update_unbound_numa(), when it's decided that the newly updated
cpumask equals the default, looks at whether the current pwq is
already the default one and skips setting pwq to the default one.
This extra step is unnecessary and we can always jump to use_dfl_pwq
instead. Simplify the code by removing the conditional.
This doesn't make any functional difference.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: update patch description and comment of code

 kernel/workqueue.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3150b21..e122d39 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4080,17 +4080,13 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 	 * Let's determine what needs to be done.  If the target cpumask is
 	 * different from wq's, we need to compare it to @pwq's and create
 	 * a new one if they don't match.  If the target cpumask equals
-	 * wq's, the default pwq should be used.  If @pwq is already the
-	 * default one, nothing to do; otherwise, install the default one.
+	 * wq's, the default pwq should be used.
 	 */
 	if (wq_calc_node_cpumask(wq->unbound_attrs, node, cpu_off, cpumask)) {
 		if (cpumask_equal(cpumask, pwq->pool->attrs->cpumask))
 			goto out_unlock;
 	} else {
-		if (pwq == wq->dfl_pwq)
-			goto out_unlock;
-		else
-			goto use_dfl_pwq;
+		goto use_dfl_pwq;
 	}
 
 	mutex_unlock(&wq->mutex);
-- 
1.7.4.4

