Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3BND0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:26:39 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:50127 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3BND0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:26:38 -0500
Date: Wed, 13 Feb 2013 19:26:33 -0800
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2 wq/for-3.9] workqueue: fix is_chained_work() regression
Message-ID: <20130214032633.GF9057@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c9e7cf273f ("workqueue: move busy_hash from global_cwq to
worker_pool") incorrectly converted is_chained_work() to use
get_gcwq() inside for_each_gcwq_cpu() while removing get_gcwq().

As cwq might not exist for all possible workqueue CPUs, @cwq can be
NULL and the following cwq deferences can lead to oops.

Fix it by using for_each_cwq_cpu() instead, which is the better one to
use anyway as we only need to check pools that the wq is associated
with.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1167,7 +1167,7 @@ static bool is_chained_work(struct workq
 	unsigned long flags;
 	unsigned int cpu;
 
-	for_each_wq_cpu(cpu) {
+	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		struct worker_pool *pool = cwq->pool;
 		struct worker *worker;
