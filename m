Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaEZDOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 23:14:44 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:49101 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751458AbaEZDOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 23:14:42 -0400
X-IronPort-AV: E=Sophos;i="4.98,909,1392134400"; 
   d="scan'208";a="30992420"
Message-ID: <5382B2A9.7030906@cn.fujitsu.com>
Date: Mon, 26 May 2014 11:19:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: remove the unneeded cpu_relax() in __queue_work()
References: <1400748257-14165-1-git-send-email-laijs@cn.fujitsu.com>	<20140522134758.GA5065@htj.dyndns.org> <CACvQF53Xs91KMdsYCsqM-NNJYtb+byajjc668aiM2vMFBv3JaA@mail.gmail.com>
In-Reply-To: <CACvQF53Xs91KMdsYCsqM-NNJYtb+byajjc668aiM2vMFBv3JaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 10:21 PM, Lai Jiangshan wrote:
> On Thu, May 22, 2014 at 9:47 PM, Tejun Heo <tj@kernel.org> wrote:
>> On Thu, May 22, 2014 at 04:44:16PM +0800, Lai Jiangshan wrote:
>>> When pwq->refcnt == 0, the retrying is guaranteed to make forward-progress.
>>> The comment above the code explains it well:
>>>
>>>       /*
>>>        * pwq is determined and locked.  For unbound pools, we could have
>>>        * raced with pwq release and it could already be dead.  If its
>>>        * refcnt is zero, repeat pwq selection.  Note that pwqs never die
>>>        * without another pwq replacing it in the numa_pwq_tbl or while
>>>        * work items are executing on it, so the retrying is guaranteed to
>>>        * make forward-progress.
>>>        */
>>>
>>> It means the cpu_relax() here is useless and sometimes misleading,
>>> it should retry directly and make some progress rather than waste time.
>>
>> cpu_relax() doesn't have much to do with guaranteeing forward
>> progress.  It's about giving a breather during busy wait so that the
> 
> This is not busy wait, the retry and numa_pwq_tbl() guarantee that
> the retry will get a new pwq (even without cpu_relax()) as the comments says,
> and the refcnt of this new pwq is very very likely non-zero and
> cpu_relax() can't
> increase the probability of non-zero-refcnt. cpu_relax() is useless here.
> 
> It is different from spin_lock() or some other spin code.
> 
> it is similar to the loop of __task_rq_lock() which also guarantees progress.
> 
> Thanks,
> Lai

Ping.

Any comments?

> 
>> waiting cpu doesn't busy loop claiming the same cache lines over and
>> over ultimately delaying the event being waited on.  If you're doing a
>> busy wait, you better use cpu_relax().
>>
>> Thanks.
>>
>> --
>> tejun
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

