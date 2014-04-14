Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaDNKlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:41:47 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:41495 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbaDNKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:41:45 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: tj@kernel.org, laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V2] workqueue: fix double unlock bug
Date: Mon, 14 Apr 2014 19:41:41 +0900
Message-ID: <3760742.KPOjd8C4i8@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mutex_unlock() and put_pwq_unlocked() do not need to be called
when alloc_unbound_pwq() is failed.

And remove "if" condition for whether "pwq" is same as "wq->dfl_pwq"
when wq_calc_node_cpumask() returns false and just use "goto use_dfl_pwq"

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: replace "if condition" with "goto" as Lai's comment.

 kernel/workqueue.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0ee63af..9853067 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4087,10 +4087,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
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
@@ -4100,7 +4097,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 	if (!pwq) {
 		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
 			   wq->name);
-		goto out_unlock;
+		return;
 	}
 
 	/*
-- 
1.7.4.4


