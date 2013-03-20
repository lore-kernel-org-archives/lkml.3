Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3CTRYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:24:53 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:61784 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3CTRYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:24:50 -0400
Date: Wed, 20 Mar 2013 10:24:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/21] workqueue: add missing POOL_FREEZING
Message-ID: <20130320172445.GB28968@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 12ee4fc67c00895b3d740297f7ca447239c1983b Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Wed, 20 Mar 2013 03:28:01 +0800

get_unbound_pool() forgot to set POOL_FREEZING if workqueue_freezing
is set and a new pool could go out of sync with the global freezing
state.

Fix it by adding POOL_FREEZING if workqueue_freezing.  wq_mutex is
already held so no further locking is necessary.  This also removes
the unused static variable warning when !CONFIG_FREEZER.

tj: Updated commit message.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 3 +++
 1 file changed, 3 insertions(+)

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
1.8.1.4

