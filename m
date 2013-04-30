Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab3D3PKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:10:34 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53407 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013Ab3D3PKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:10:31 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, js1304@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH for-3.10] workqueue: correct handling of the pool spin_lock
Date: Wed,  1 May 2013 00:07:00 +0900
Message-Id: <1367334420-4331-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we fail to mutex_trylock(), we release the pool spin_lock and do
mutex_lock(). After that, we should regrab the pool spin_lock, but,
regrabbing is missed in current code. So correct it.

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 154aa12..e02994f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2058,6 +2058,7 @@ static bool manage_workers(struct worker *worker)
 	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
 		spin_unlock_irq(&pool->lock);
 		mutex_lock(&pool->manager_mutex);
+		spin_lock_irq(&pool->lock);
 		ret = true;
 	}
 
-- 
1.7.9.5

