Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbaDPXzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:55:13 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:10925 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753294AbaDPXzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:55:11 -0400
X-IronPort-AV: E=Sophos;i="4.97,875,1389715200"; 
   d="scan'208";a="29365432"
Message-ID: <534F193F.2070600@cn.fujitsu.com>
Date: Thu, 17 Apr 2014 07:58:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: add __WQ_FREEZING and remove POOL_FREEZING
References: <20130421012925.GA19097@mtj.dyndns.org> <1395741364-19489-1-git-send-email-laijs@cn.fujitsu.com> <20140416195109.GD22569@htj.dyndns.org>
In-Reply-To: <20140416195109.GD22569@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 03:51 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Mar 25, 2014 at 05:56:04PM +0800, Lai Jiangshan wrote:
>> freezing is nothing related to pools, but POOL_FREEZING adds a connection,
>> and causes freeze_workqueues_begin() and thaw_workqueues() complicated.
>>
>> Since freezing is workqueue instance attribute, so we introduce __WQ_FREEZING
>> to wq->flags instead and remove POOL_FREEZING.
>>
>> we set __WQ_FREEZING only when freezable(to simplify pwq_adjust_max_active()),
>> make freeze_workqueues_begin() and thaw_workqueues() fast skip non-freezable wq.
> 
> Please wrap the description to 80 columns.
> 
>> @@ -3730,18 +3726,13 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
>>  static void pwq_adjust_max_active(struct pool_workqueue *pwq)
>>  {
>>  	struct workqueue_struct *wq = pwq->wq;
>> -	bool freezable = wq->flags & WQ_FREEZABLE;
>>  
>> -	/* for @wq->saved_max_active */
>> +	/* for @wq->saved_max_active and @wq->flags */
>>  	lockdep_assert_held(&wq->mutex);
>>  
>> -	/* fast exit for non-freezable wqs */
>> -	if (!freezable && pwq->max_active == wq->saved_max_active)
>> -		return;
>> -
> 
> Why are we removing the above?  Can't we still test __WQ_FREEZING as
> we're holding wq->mutex?  I don't really mind removing the
> optimization but the patch description at least has to explain what's
> going on.

This part was in other old patch: https://lkml.org/lkml/2013/4/3/756
I admit the changelogs(old patch&this) are bad.
But I still consider it would be better if we split it to two patches:
(https://lkml.org/lkml/2013/4/3/748 & https://lkml.org/lkml/2013/4/3/756)

There are different aims in the patches.

Any thinks? And sorry for I didn't keep to push the patches at that time.
Thanks
Lai

> 
> ...
>>  	list_for_each_entry(wq, &workqueues, list) {
>> +		if (!(wq->flags & WQ_FREEZABLE))
>> +			continue;
> 
> Ah, okay, you're not calling the function at all if WQ_FREEZABLE is
> not set.  I couldn't really understand what you were trying to say in
> the patch description.  Can you please try to refine the description
> more?  It's better to be verbose and clear than short and difficult to
> understand.
> 
> Thanks.
> 

