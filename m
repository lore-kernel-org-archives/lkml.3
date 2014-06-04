Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaFDXcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:32:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaFDXYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:24:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.10 073/103] workqueue: fix bugs in wq_update_unbound_numa() failure path
Date: Wed,  4 Jun 2014 16:25:36 -0700
Message-Id: <20140604232549.172488228@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4043,7 +4043,8 @@ static void wq_update_unbound_numa(struc
 	if (!pwq) {
 		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
 			   wq->name);
-		goto out_unlock;
+		mutex_lock(&wq->mutex);
+		goto use_dfl_pwq;
 	}
 
 	/*


