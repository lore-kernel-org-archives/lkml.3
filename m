Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaCQVtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaCQVta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:49:30 -0400
From: Mark Salter <msalter@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH] sched: use zalloc_cpumask_var for rootdomain cpumasks
Date: Mon, 17 Mar 2014 17:48:35 -0400
Message-Id: <1395092915-26526-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel/sched/core.c, there is:

static int init_rootdomain(struct root_domain *rd)
{
	memset(rd, 0, sizeof(*rd));

	if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
		goto out;
	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
		goto free_span;
	if (!alloc_cpumask_var(&rd->dlo_mask, GFP_KERNEL))
		goto free_online;
	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
		goto free_dlo_mask;

In the CONFIG_CPUMASK_OFFSTACK=y case, there doesn't appear to be anything
clearing the cpumasks. I think these should be zalloc_cpumask_var() calls.

I noticed this while debugging a memory corruptor in unrelated code which
cleared the span cpumask and triggered a BUG in the scheduler. I had turned
on CONFIG_PAGE_POISONING and looking at the span cpumask at various points
during early boot and saw that the mask was filled with POISON_FREE bytes
before the secondary cores started coming up and setting their cpu bits in
the mask.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 kernel/sched/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f5c6635..9843755 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5355,13 +5355,13 @@ static int init_rootdomain(struct root_domain *rd)
 {
 	memset(rd, 0, sizeof(*rd));
 
-	if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&rd->span, GFP_KERNEL))
 		goto out;
-	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&rd->online, GFP_KERNEL))
 		goto free_span;
-	if (!alloc_cpumask_var(&rd->dlo_mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&rd->dlo_mask, GFP_KERNEL))
 		goto free_online;
-	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
 		goto free_dlo_mask;
 
 	init_dl_bw(&rd->dl_bw);
-- 
1.8.5.3

