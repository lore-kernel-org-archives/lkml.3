Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaHORlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:41:37 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:46580 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaHORlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:41:36 -0400
X-Greylist: delayed 87236 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Aug 2014 13:41:36 EDT
Message-ID: <53EE464D.7060803@hp.com>
Date: Fri, 15 Aug 2014 13:41:33 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: peterz@infradead.org, mingo@kernel.org, jason.low2@hp.com,
        scott.norton@hp.com, aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] locking/mutexes: Avoid bogus wakeups after lock
 stealing
References: <1407995870-4268-1-git-send-email-davidlohr@hp.com>  <53ECEF32.6010706@hp.com> <1408037423.12776.6.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1408037423.12776.6.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 01:30 PM, Davidlohr Bueso wrote:
> On Thu, 2014-08-14 at 13:17 -0400, Waiman Long wrote:
>>
>> I still think it is better to do that after spin_lock_mutex().
> As mentioned, this causes all sorts of hung tasks when the another task
> enters the slowpath when locking. There's a big fat comment above.
>
>> In
>> addition, the atomic_set() is racy. It is better to something like
> Why is it racy? Atomically setting the lock to -1 given that the lock
> was stolen should be safe. The alternative we discussed with Jason was
> to set the counter to -1 in the spinning path. But given that we need to
> serialize the counter check with the list_empty() check that would
> require the wait_lock. This is very messy and unnecessarily complicates
> things.
>
Let's consider the following scenario:

   Task 1                                  Task 2
   ------                                  ------
                                         steal the lock
if (mutex_has_owner) {                       :
         : <---- a long interrupt        mutex_unlock() [cnt = 1]
     atomic_set(cnt, -1);
     return;
}

Now the lock is no longer available and all the tasks that are trying
to get it will hang. IOW, you cannot set the count to -1 unless you
are sure it is 0 to begin with.

>>     if (atomic_cmpxchg(&lock->count, 0, -1)<= 0)
>>       return;
> Not really because some archs leave the lock at 1 after the unlock
> fastpath.

Yes, I know that. I am saying x86 won't get any benefit from this patch.

-Longman
