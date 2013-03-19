Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab3CSTeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:34:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43321 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757309Ab3CST2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:41 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904496"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 01/21] workqueue: add missing POOL_FREEZING
Date: Wed, 20 Mar 2013 03:28:01 +0800
Message-Id: <1363721306-2030-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:14,
	Serialize complete at 2013/03/20 03:27:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we create a new pool via get_unbound_pool() when freezing.
the pool->flags' POOL_FREEZING is incorrect.

Fix it by adding POOL_FREEZING if workqueue_freezing.
(wq_mutex is already held for accessing workqueue_freezing.)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e38d035..40f4017 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3503,6 +3503,9 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	if (!pool || init_worker_pool(pool) < 0)
 		goto fail;
 
+	if (workqueue_freezing)
+		pool->flags |= POOL_FREEZING;
+
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
-- 
1.7.7.6

