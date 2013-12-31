Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3LaDil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 22:38:41 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63985 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3LaDik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 22:38:40 -0500
Date: Tue, 31 Dec 2013 11:38:27 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, kmo@daterainc.com
Subject: [patch 1/2]percpu_ida: fix a live lock
Message-ID: <20131231033827.GA31994@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


steal_tags only happens when free tags is more than half of the total tags.
This is too restrict and can cause live lock. I found one cpu has free tags,
but other cpu can't steal (thread is bound to specific cpus), threads which
wants to allocate tags are always sleeping. I found this when I run next patch,
but this could happen without it I think.

I did performance test too with null_blk. Two cases (each cpu has enough percpu
tags, or total tags are limited) haven't performance changes.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 lib/percpu_ida.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux/lib/percpu_ida.c
===================================================================
--- linux.orig/lib/percpu_ida.c	2013-11-25 09:36:52.196626486 +0800
+++ linux/lib/percpu_ida.c	2013-12-31 11:20:03.205400612 +0800
@@ -54,9 +54,7 @@ static inline void move_tags(unsigned *d
 /*
  * Try to steal tags from a remote cpu's percpu freelist.
  *
- * We first check how many percpu freelists have tags - we don't steal tags
- * unless enough percpu freelists have tags on them that it's possible more than
- * half the total tags could be stuck on remote percpu freelists.
+ * We first check how many percpu freelists have tags
  *
  * Then we iterate through the cpus until we find some tags - we don't attempt
  * to find the "best" cpu to steal from, to keep cacheline bouncing to a
@@ -69,8 +67,7 @@ static inline void steal_tags(struct per
 	struct percpu_ida_cpu *remote;
 
 	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
-	     cpus_have_tags * pool->percpu_max_size > pool->nr_tags / 2;
-	     cpus_have_tags--) {
+	     cpus_have_tags; cpus_have_tags--) {
 		cpu = cpumask_next(cpu, &pool->cpus_have_tags);
 
 		if (cpu >= nr_cpu_ids) {
