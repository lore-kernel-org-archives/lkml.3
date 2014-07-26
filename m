Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863AbaGZEDK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 00:03:10 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:35684 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750705AbaGZEDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 00:03:07 -0400
X-IronPort-AV: E=Sophos;i="5.00,965,1396972800"; 
   d="scan'208";a="33803135"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: [PATCH] kthread_work: wake up worker only when the worker is idle
Date: Sat, 26 Jul 2014 12:03:59 +0800
Message-ID: <1406347444-4045-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the worker task is not idle, it may sleep on some conditions by the request
of the work.  Our unfriendly wakeup in the insert_kthread_work() may confuse
the worker.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/kthread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index c2390f4..ef48322 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -591,7 +591,7 @@ static void insert_kthread_work(struct kthread_worker *worker,
 
 	list_add_tail(&work->node, pos);
 	work->worker = worker;
-	if (likely(worker->task))
+	if (!worker->current_work && likely(worker->task))
 		wake_up_process(worker->task);
 }
 
-- 
1.7.4.4

