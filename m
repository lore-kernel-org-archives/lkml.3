Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab3IMB3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:29:03 -0400
Received: from intranet.asianux.com ([58.214.24.6]:57889 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab3IMB3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:29:00 -0400
X-Spam-Score: -100.8
Message-ID: <52326A1A.8010209@asianux.com>
Date: Fri, 13 Sep 2013 09:27:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, ccross@android.com,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/futex.c: notice the return value after rt_mutex_finish_proxy_lock()
 fails
References: <5212DD71.7070208@asianux.com>  <alpine.DEB.2.02.1309121627040.4089@ionos.tec.linutronix.de> <1379025421.1285.55.camel@dvhart-mobl4.amr.corp.intel.com>
In-Reply-To: <1379025421.1285.55.camel@dvhart-mobl4.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 06:37 AM, Darren Hart wrote:
> On Thu, 2013-09-12 at 16:32 +0200, Thomas Gleixner wrote:
>> On Tue, 20 Aug 2013, Chen Gang wrote:
>>
>>> rt_mutex_finish_proxy_lock() can return failure code (e.g. -EINTR,
>>> -ETIMEDOUT).
>>>
>>> Original implementation has already noticed about it, but not check it
>>> before next work.
>>>
>>> Also let coments within 80 columns to pass "./scripts/checkpatch.pl".
>>>
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> ---
>>>  kernel/futex.c |   30 ++++++++++++++++--------------
>>>  1 files changed, 16 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/kernel/futex.c b/kernel/futex.c
>>> index c3a1a55..1a94e7d 100644
>>> --- a/kernel/futex.c
>>> +++ b/kernel/futex.c
>>> @@ -2373,21 +2373,23 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
>>>               ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
>>>               debug_rt_mutex_free_waiter(&rt_waiter);
>>>  
>>> -             spin_lock(q.lock_ptr);
>>> -             /*
>>> -              * Fixup the pi_state owner and possibly acquire the lock if we
>>> -              * haven't already.
>>> -              */
>>> -             res = fixup_owner(uaddr2, &q, !ret);
>>> -             /*
>>> -              * If fixup_owner() returned an error, proprogate that.  If it
>>> -              * acquired the lock, clear -ETIMEDOUT or -EINTR.
>>> -              */
>>> -             if (res)
>>> -                     ret = (res < 0) ? res : 0;
>>> +             if (!ret) {
>>
>> Again. This is completely wrong!  
>>
>> We MUST call fixup_owner even if finish_proxy_lock() returned with an
>> error code. Simply because finish_proxy_lock() is called outside of
>> the spin_lock(q.lock_ptr) region and another thread might have
>> modified the futex state. So we need to handle the corner cases
>> otherwise we might leave the futex in some undefined state.
>>
>> You're reintroducing a hard to decode bug, which got analyzed and
>> fixed in futex_lock_pi() years ago. See the history for the
>> explanation.
>>
>> Sigh.
>>
>>         tglx
> 
> Chen, perhaps you can let us know what the failure scenario is that you
> are trying to address with this patch. I only replied the once as I
> pointed out the corner-case and expected you to follow up with that.
> This region of code is very fragile to modifications as it has become
> more corner-cases than core logic in some places :-)
> 

Oh, thanks, it is my fault:

  the 'ret' which return from rt_mutex_finish_proxy_lock(), is used by
the next fixup_owner().

Hmm... excuse me, my English is not quite well, it seems you already
know about it, but not say straightly and directly?

next, when find/feel something wrong, can say directly, I can/should
understand it (and I need/should thank you, too), that will be more
efficient (can save both of us time resources).

:-)

> For starters, I'm not following your second sentence in the commit log.
> Can you elaborate on the following?
> 
> "Original implementation has already noticed about it, but not check it
> before next work."
> 
> Do you have a test-case that demonstrates a failure mode?
> 

No, I just 'found' it, and give a simply 'fix' to let related experts
check (and now, we know it is just a spam).

Hmm... for 'test', it is really an 'important thing' to me (not 'urgent
thing'), I have plan to start to use LTP (Linux Test Project) in q4 of
2013 (start at 2013-10-01).


Thanks.
-- 
Chen Gang
