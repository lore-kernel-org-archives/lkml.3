Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbbA0Fxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 00:53:37 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:33199 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbbA0Fxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 00:53:34 -0500
Message-ID: <54C727DA.4040601@gmail.com>
Date: Tue, 27 Jan 2015 03:53:30 -0200
From: Gustavo Bittencourt <gbitten@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH -rt] rtmutex: enable deadlock detection in the ww_mutex_lock
 functions
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According the ww-mutex-design.txt documentation,  the ww_mutex_lock_interruptible and ww_mutex_lock functions should return -EDEADLK when faced with a deadlock. To do so, the flag detect_deadlock in the rt_mutex_slowlock calls should be enabled. This patch corrects potential deadlocks when running PREEMPT_RT with nouveau driver.

Kernel v3.14-rt

Signed-off-by: Gustavo Bittencourt<gbitten@gmail.com>
---
  kernel/locking/rtmutex.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 6c40660..3f6ef91 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1965,7 +1965,7 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ww_c
  	might_sleep();
  
  	mutex_acquire(&lock->base.dep_map, 0, 0,_RET_IP_);
-	ret = rt_mutex_slowlock(&lock->base.lock, TASK_INTERRUPTIBLE, NULL, 0, ww_ctx);
+	ret = rt_mutex_slowlock(&lock->base.lock, TASK_INTERRUPTIBLE, NULL, 1, ww_ctx);
  	if (ret)
  		mutex_release(&lock->base.dep_map, 1,_RET_IP_);
  	else if (!ret && ww_ctx->acquired > 1)
@@ -1984,7 +1984,7 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ww_ctx)
  
  	mutex_acquire_nest(&lock->base.dep_map, 0, 0, &ww_ctx->dep_map,
  			_RET_IP_);
-	ret = rt_mutex_slowlock(&lock->base.lock, TASK_UNINTERRUPTIBLE, NULL, 0, ww_ctx);
+	ret = rt_mutex_slowlock(&lock->base.lock, TASK_UNINTERRUPTIBLE, NULL, 1, ww_ctx);
  	if (ret)
  		mutex_release(&lock->base.dep_map, 1,_RET_IP_);
  	else if (!ret && ww_ctx->acquired > 1)
-- 1.9.1

