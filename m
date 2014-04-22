Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaDVBoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:44:04 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:4366 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751117AbaDVBoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:44:01 -0400
X-IronPort-AV: E=Sophos;i="4.97,899,1389715200"; 
   d="scan'208";a="29544870"
Message-ID: <5355CA43.5040608@cn.fujitsu.com>
Date: Tue, 22 Apr 2014 09:47:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 V3] workqueue: substitute POOL_FREEZING with __WQ_FREEZING
References: <1398081561-12618-1-git-send-email-laijs@cn.fujitsu.com> <20140421222035.GA22730@htj.dyndns.org>
In-Reply-To: <20140421222035.GA22730@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 06:20 AM, Tejun Heo wrote:
> On Mon, Apr 21, 2014 at 07:59:20PM +0800, Lai Jiangshan wrote:
>> Only workqueues have freezable or freezing attribution/state, not worker pools.
>> But POOL_FREEZING adds a suspicious state and makes reviewers confused.
>>
>> And it causes freeze_workqueues_begin() and thaw_workqueues() much complicated,
>> they need to travel all the pools besides wqs.
>>
>> Since freezable is workqueue instance's attribution, and freezing
>> is workqueue instance's state, so we introduce __WQ_FREEZING
>> to wq->flags instead and remove POOL_FREEZING.
>>
>> It is different from POOL_FREEZING, POOL_FREEZING is simply set
>> all over the world(all pools), while __WQ_FREEZING is only set for freezable wq.
>> freeze_workqueues_begin()/thaw_workqueues() skip to handle non-freezable wqs
>> and don't touch the non-freezable wqs' flags.
> 
> I was about to apply the patch and have updated the patch description.
> 
>   While freezing takes place globally, its execution is per-workqueue;
>   however, the current implementation makes use of the per-worker_pool
>   POOL_FREEZING flag.  While it's not broken, the flag makes the code
>   more confusing and complicates freeze_workqueues_begin() and
>   thaw_workqueues() by requiring them to walk through all pools.
> 
>   Since freezable is a workqueue's attribute, and freezing is a
>   workqueue's state, let's introduce __WQ_FREEZING to wq->flags instead
>   and remove POOL_FREEZING.
> 
>   It is different from POOL_FREEZING in that __WQ_FREEZING is only set
>   for freezable workqueues while POOL_FREEZING is set globally over all
>   pools.  freeze_workqueues_begin() and thaw_workqueues() now skip
>   non-freezable workqueues.
> 
> But looking at the patch, why do we need __WQ_FREEZING at all?  We
> should be able to test workqueue_freezing in pwq_adjust_max_active(),
> right?  The only requirement there would be that

Testing workqueue_freezing requires wq_pool_mutex held.
Although almost-all pwq_adjust_max_active() are called with wq_pool_mutex held,
except workqueue_set_max_active(). But I hope pwq_adjust_max_active()
don't require the heavy wq_pool_mutex.

> pwq_adjust_max_active() is invoked at least once after
> workqueue_freezing is changed, which is already guaranteed.
> 
> Thanks.
> 

