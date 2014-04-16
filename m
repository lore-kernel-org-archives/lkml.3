Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaDPFcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:32:36 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41191 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbaDPFcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:32:35 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: tj@kernel.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] workqueue: fix bugs in wq_update_unbound_numa() failure path
Date: Wed, 16 Apr 2014 14:32:29 +0900
Message-ID: <58237829.Dxp0IlFuXc@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
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


