Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaJHDvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:51:36 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:26137 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753521AbaJHDvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:51:01 -0400
X-IronPort-AV: E=Sophos;i="5.04,674,1406563200"; 
   d="scan'208";a="36937205"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/3] workqueue: extend wq_pool_mutex to also protect pwq-installation
Date: Wed, 8 Oct 2014 11:53:32 +0800
Message-ID: <1412740423-20782-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
References: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Athough pwq-installation without wq_pool_mutex held is not bug,
but it is not good design, it is better to make the pwq-allocation and installation
are in the (same) wq_pool_mutex.

And since the pwq-allocation and installation are in the same wq_pool_mutex,
get_online_cpus() will not be needed for this reason, and it will be remove
in later patch.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7a217f0..9bc3a87 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3805,8 +3805,6 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 		}
 	}
 
-	mutex_unlock(&wq_pool_mutex);
-
 	/* all pwqs have been created successfully, let's install'em */
 	mutex_lock(&wq->mutex);
 
@@ -3827,6 +3825,8 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 		put_pwq_unlocked(pwq_tbl[node]);
 	put_pwq_unlocked(dfl_pwq);
 
+	mutex_unlock(&wq_pool_mutex);
+
 	put_online_cpus();
 	ret = 0;
 	/* fall through */
-- 
1.7.4.4

