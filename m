Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3BEMPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:15:35 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:37073 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3BEMPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:15:34 -0500
Message-ID: <5110F7D6.8080203@gmail.com>
Date: Tue, 05 Feb 2013 20:15:18 +0800
From: Lai Jiangshan <eag0628@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/13] workqueue: add lock_pool_executing_work()
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com> <1359657696-2767-9-git-send-email-laijs@cn.fujitsu.com> <20130204213422.GD27963@mtj.dyndns.org>
In-Reply-To: <20130204213422.GD27963@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/2/5 5:34, Tejun Heo 写道:
> Hello,
>
> On Fri, Feb 01, 2013 at 02:41:31AM +0800, Lai Jiangshan wrote:
>> +static struct worker_pool *lock_pool_executing_work(struct work_struct *work,
>> +						    struct worker **worker)
>> +{
>> +	unsigned long pool_id = offq_work_pool_id(work);
>> +	struct worker_pool *pool;
>> +	struct worker *exec;
>> +
>> +	if (pool_id == WORK_OFFQ_POOL_NONE)
>> +		return NULL;
>> +
>> +	pool = worker_pool_by_id(pool_id);
>> +	if (!pool)
>> +		return NULL;
>> +
>> +	spin_lock(&pool->lock);
>> +	exec = find_worker_executing_work(pool, work);
>> +	if (exec) {
>> +		BUG_ON(pool != exec->pool);
>> +		*worker = exec;
>> +		return pool;
>> +	}
>> +	spin_unlock(&pool->lock);
>> +
>> +	return NULL;
>> +}
>
> So, if a work item is queued on the same CPU and it isn't being
> executed, it will lock, look up the hash, unlock and then lock again?
> If this is something improved by later patch, please explain so.
> There gotta be a better way to do this, right?
>

The caller can't call this function if the work is on queue.
the caller should call it only when CWQ bit is not set.

it is commentted "lock the pool a given offq work is running on",
sorry, comment is too short.

