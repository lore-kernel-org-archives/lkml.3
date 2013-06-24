Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3FXTb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:31:56 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54087 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3FXTbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:53 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 32/32] block: delete __cpuinit usage from all block files
Date: Mon, 24 Jun 2013 15:30:37 -0400
Message-ID: <1372102237-8757-33-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

This removes all the drivers/block uses of the __cpuinit macros
from all C files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 block/blk-iopoll.c  | 6 +++---
 block/blk-softirq.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-iopoll.c b/block/blk-iopoll.c
index 58916af..4b8d9b54 100644
--- a/block/blk-iopoll.c
+++ b/block/blk-iopoll.c
@@ -189,8 +189,8 @@ void blk_iopoll_init(struct blk_iopoll *iop, int weight, blk_iopoll_fn *poll_fn)
 }
 EXPORT_SYMBOL(blk_iopoll_init);
 
-static int __cpuinit blk_iopoll_cpu_notify(struct notifier_block *self,
-					  unsigned long action, void *hcpu)
+static int blk_iopoll_cpu_notify(struct notifier_block *self,
+				 unsigned long action, void *hcpu)
 {
 	/*
 	 * If a CPU goes away, splice its entries to the current CPU
@@ -209,7 +209,7 @@ static int __cpuinit blk_iopoll_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata blk_iopoll_cpu_notifier = {
+static struct notifier_block blk_iopoll_cpu_notifier = {
 	.notifier_call	= blk_iopoll_cpu_notify,
 };
 
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 467c8de..ec9e606 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -78,8 +78,8 @@ static int raise_blk_irq(int cpu, struct request *rq)
 }
 #endif
 
-static int __cpuinit blk_cpu_notify(struct notifier_block *self,
-				    unsigned long action, void *hcpu)
+static int blk_cpu_notify(struct notifier_block *self, unsigned long action,
+			  void *hcpu)
 {
 	/*
 	 * If a CPU goes away, splice its entries to the current CPU
@@ -98,7 +98,7 @@ static int __cpuinit blk_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata blk_cpu_notifier = {
+static struct notifier_block blk_cpu_notifier = {
 	.notifier_call	= blk_cpu_notify,
 };
 
-- 
1.8.1.2

