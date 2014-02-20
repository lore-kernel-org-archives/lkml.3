Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaBTB61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:58:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:30185 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbaBTB60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:58:26 -0500
X-IronPort-AV: E=Sophos;i="4.97,509,1389715200"; 
   d="scan'208";a="9563898"
Message-ID: <530561DF.90304@cn.fujitsu.com>
Date: Thu, 20 Feb 2014 10:01:03 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: Fix possible unexpectedly worker wakeup before
 started
References: <1392781678-31952-1-git-send-email-laijs@cn.fujitsu.com> <20140220001142.GV10134@htj.dyndns.org> <53055F6F.6060909@cn.fujitsu.com>
In-Reply-To: <53055F6F.6060909@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/20 09:56:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/20 09:56:14,
	Serialize complete at 2014/02/20 09:56:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 09:50 AM, Lai Jiangshan wrote:
> On 02/20/2014 08:11 AM, Tejun Heo wrote:
>> Hello, Lai.
>>
>> On Wed, Feb 19, 2014 at 11:47:58AM +0800, Lai Jiangshan wrote:
>>> If a worker is wokenup unexpectedly, it will start to work incorretly.
>>> Although it hardly happen, we should catch it and wait for being started
>>> if it does happen.
>>
>> Can this actually happen?  If so, how?
> 
> I don't think it can happen.
> It depends on the system outside of workqueue.
> 
> I'm afraid someone see the task and wake up it.
> workqueue protect itself.

I was extremely nervously, please drop the patch.
I also don't like too much protective code in workqueue.

> 
>>
>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>> ---
>>>  kernel/workqueue.c |    6 ++++++
>>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>>> index 82ef9f3..bee5fe1 100644
>>> --- a/kernel/workqueue.c
>>> +++ b/kernel/workqueue.c
>>> @@ -2284,6 +2284,12 @@ static int worker_thread(void *__worker)
>>>  	struct worker *worker = __worker;
>>>  	struct worker_pool *pool = worker->pool;
>>>  
>>> +	if (WARN_ON_ONCE(!(worker->flags & WORKER_STARTED))) {
>>
>> And if this is something which can legitimately happen, why are we
>> triggering WARN on it?
> 
> If it happens, it means there is something wrong in the system.
> 
>>
>>> +		/* The worker is wokenup unexpectedly before started */
>>> +		mutex_lock(&pool->manager_mutex);
>>> +		mutex_unlock(&pool->manager_mutex);
>>
>> And what does these mutex cycling achieve (they need comment)?
> 
> Synchronize the manager to finish.
> 
>>
>> Thanks.
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

