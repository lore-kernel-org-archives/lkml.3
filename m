Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbaFIJCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:02:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58533 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017AbaFIIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daeseok Youn <daeseok.youn@gmail.com>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 102/146] workqueue: fix bugs in wq_update_unbound_numa() failure path
Date: Mon,  9 Jun 2014 10:50:37 +0200
Message-Id: <e26e5199ebc5055b4f8ba6225bfe26cd05f4e0b6.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daeseok Youn <daeseok.youn@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/workqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 60fee69c37be..9ae0693ca520 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4090,7 +4090,8 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 	if (!pwq) {
 		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
 			   wq->name);
-		goto out_unlock;
+		mutex_lock(&wq->mutex);
+		goto use_dfl_pwq;
 	}
 
 	/*
-- 
1.9.3

