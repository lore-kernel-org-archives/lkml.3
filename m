Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbaEGHGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:06:14 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60023 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbaEGHGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:06:13 -0400
X-IronPort-AV: E=Sophos;i="4.97,1001,1389715200"; 
   d="scan'208";a="30181628"
Message-ID: <5369DC5C.20001@cn.fujitsu.com>
Date: Wed, 7 May 2014 15:10:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] workqueue: destroy worker directly in the idle
 timeout handler
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com> <1398571754-12443-5-git-send-email-laijs@cn.fujitsu.com> <20140505143613.GD11231@htj.dyndns.org>
In-Reply-To: <20140505143613.GD11231@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 10:36 PM, Tejun Heo wrote:
> On Sun, Apr 27, 2014 at 12:08:59PM +0800, Lai Jiangshan wrote:
>> Since kthread_stop() is removed from destroy_worker(),
>> destroy_worker() doesn't need to sleep.
>> Since "unbind the worker" is moved out from destroy_worker(),
>> destroy_worker() doesn't require manager_mutex.
>>
>> So destroy_worker() can be directly called in the idle timeout
>> handler, it helps us remove POOL_MANAGE_WORKERS and
>> maybe_destroy_worker() and simplify the manage_workers()
>>
>> After POOL_MANAGE_WORKERS is removed, worker_thread() doesn't
>> need to test whether it needs to manage after processed works.
>> So we can remove this test branch.
> 
> Ah, so, you can take out workers directly from idle timer.  Yeah,
> that's nice.  I'm not a big fan of the wait_queue usage in the
> previous patch tho.  Can we use a completion instead?
> 
> Thanks.
> 

1) complete() can't be called inside attach_mutex due to the worker
   shouldn't access to the pool after complete().
2) put_unbound_pool() may called from get_unbound_pool(), we need to add
   an additional check and avoid the wait_for_completion() if so.

+static void worker_detach_from_pool(struct worker *worker, struct worker_pool *pool)
+{
+	bool is_last;
+
+	mutex_lock(&pool->bind_mutex);
+	list_del(&worker->bind_entry);
+	is_last = list_empty(&worker->bind_entry);
+	mutex_unlock(&pool->bind_mutex);
+
+	/* need some comments here */
+	if (is_last)
+		complete(&pool->workers_detached);
+}


@@ -3588,6 +3587,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 	mutex_lock(&pool->manager_mutex);
 	spin_lock_irq(&pool->lock);
 	
+	need_to_wait = pool->nr_workers != 0; /* it may be called from get_unbound_pool() */
 	while ((worker = first_worker(pool)))
 		destroy_worker(worker);
 	WARN_ON(pool->nr_workers || pool->nr_idle);
@@ -3596,6 +3596,8 @@ static void put_unbound_pool(struct worker_pool *pool)
 	mutex_unlock(&pool->manager_mutex);
 	mutex_unlock(&pool->manager_arb);
 
+	if (need_to_wait)
+		wait_for_completion(&pool->workers_detached);

 	/* shut down the timers */
 	del_timer_sync(&pool->idle_timer);
 	del_timer_sync(&pool->mayday_timer);


So I think wait_queue is more grace.

Thanks,
Lai

