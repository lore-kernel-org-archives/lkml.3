Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaFCLlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:41:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43421 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbaFCLlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daeseok Youn <daeseok.youn@gmail.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 044/138] workqueue: fix bugs in wq_update_unbound_numa() failure path
Date: Tue,  3 Jun 2014 12:38:10 +0100
Message-Id: <1401795584-22664-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeseok Youn <daeseok.youn@gmail.com>

commit 77f300b198f93328c26191b52655ce1b62e202cf upstream.

wq_update_unbound_numa() failure path has the following two bugs.

- alloc_unbound_pwq() is called without holding wq->mutex; however, if
  the allocation fails, it jumps to out_unlock which tries to unlock
  wq->mutex.

- The function should switch to dfl_pwq on failure but didn't do so
  after alloc_unbound_pwq() failure.

Fix it by regrabbing wq->mutex and jumping to use_dfl_pwq on
alloc_unbound_pwq() failure.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 4c16bd327c74 ("workqueue: implement NUMA affinity for unbound workqueues")
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/workqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d06e6e15ac02..a8b0147f3a89 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4061,7 +4061,8 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 	if (!pwq) {
 		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
 			   wq->name);
-		goto out_unlock;
+		mutex_lock(&wq->mutex);
+		goto use_dfl_pwq;
 	}
 
 	/*
-- 
1.9.1

