Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaDPFMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:12:13 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61618 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaDPFMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:12:10 -0400
Date: Wed, 16 Apr 2014 14:11:32 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: tj@kernel.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] workqueue: fix bugs in wq_update_unbound_numa() failure
 path
Message-ID: <20140416051126.GA12288@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wq_update_unbound_numa() failure path has the following two bugs.
 - alloc_unbound_pwq() is called without holding wq->mutex;
 however, if the allocation fails, it jumps to out_unlock
 which tries to unlock wq->mutex.

 - The function should switch to dfl_pwq on failure
 but didn't do so after alloc_unbound_pwq() failure.

Fix it by regrabbing wq->mutex and jumping to use_dfl_pwq on
alloc_unbound_pwq() failure.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 kernel/workqueue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0ee63af..3150b21 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4100,7 +4100,8 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 	if (!pwq) {
 		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
 			   wq->name);
-		goto out_unlock;
+		mutex_lock(&wq->mutex);
+		goto use_dfl_pwq;
 	}
 
 	/*
-- 
1.7.4.4

