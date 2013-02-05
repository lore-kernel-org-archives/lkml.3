Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3BEMHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:07:08 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:42430 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3BEMHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:07:04 -0500
Message-ID: <5110F5DE.6030407@gmail.com>
Date: Tue, 05 Feb 2013 20:06:54 +0800
From: Lai Jiangshan <eag0628@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/13] workqueue: fix work_busy()
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com> <1359657696-2767-3-git-send-email-laijs@cn.fujitsu.com> <20130204195458.GA27963@mtj.dyndns.org>
In-Reply-To: <20130204195458.GA27963@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/2/5 3:54, Tejun Heo 写道:
> Hello, Lai.
>
> On Fri, Feb 01, 2013 at 02:41:25AM +0800, Lai Jiangshan wrote:
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 973b290..d474a6c 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -3443,8 +3443,6 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
>>    * Test whether @work is currently pending or running.  There is no
>>    * synchronization around this function and the test result is
>>    * unreliable and only useful as advisory hints or for debugging.
>> - * Especially for reentrant wqs, the pending state might hide the
>> - * running state.
>
> Yeap, this is no longer true.
>
>>    *
>>    * RETURNS:
>>    * OR'd bitmask of WORK_BUSY_* bits.
>> @@ -3453,15 +3451,13 @@ unsigned int work_busy(struct work_struct *work)
>>   {
>>   	struct worker_pool *pool = get_work_pool(work);
>>   	unsigned long flags;
>> -	unsigned int ret = 0;
>> +	unsigned int ret = work_pending(work) ? WORK_BUSY_PENDING : 0;
>
> I'd prefer this as a if() statement.
>
>>   	if (!pool)
>> -		return 0;
>> +		return ret;
>
> I'm a bit confused.  When can we be pending w/o pool?
>

grab the pending bits <==time==> really queued
			^
		this patch considers the work is busy in this time

