Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3HRUhx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:37:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab3HRUfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Hailperin <max@gustavus.edu>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 07/45] sched: Ensure update_cfs_shares() is called for parents of continuously-running tasks
Date: Sun, 18 Aug 2013 13:35:56 -0700
Message-Id: <20130818203621.504406997@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit bf0bd948d1682e3996adc093b43021ed391983e6 upstream.

We typically update a task_group's shares within the dequeue/enqueue
path.  However, continuously running tasks sharing a CPU are not
subject to these updates as they are only put/picked.  Unfortunately,
when we reverted f269ae046 (in 17bc14b7), we lost the augmenting
periodic update that was supposed to account for this; resulting in a
potential loss of fairness.

To fix this, re-introduce the explicit update in
update_cfs_rq_blocked_load() [called via entity_tick()].

Reported-by: Max Hailperin <max@gustavus.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Paul Turner <pjt@google.com>
Link: http://lkml.kernel.org/n/tip-9545m3apw5d93ubyrotrj31y@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1984,6 +1984,7 @@ entity_tick(struct cfs_rq *cfs_rq, struc
 	 */
 	update_entity_load_avg(curr, 1);
 	update_cfs_rq_blocked_load(cfs_rq, 1);
+	update_cfs_shares(cfs_rq);
 
 #ifdef CONFIG_SCHED_HRTICK
 	/*


