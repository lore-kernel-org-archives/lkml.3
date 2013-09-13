Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab3IMBxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:53:36 -0400
Received: from intranet.asianux.com ([58.214.24.6]:32341 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab3IMBxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:53:35 -0400
X-Spam-Score: -100.8
Message-ID: <52326FDE.5010303@asianux.com>
Date: Fri, 13 Sep 2013 09:52:30 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Darren Hart <dvhart@linux.intel.com>, ccross@android.com,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] kernel/futex.c: notice the return value after rt_mutex_finish_proxy_lock()
 fails
References: <5212DD71.7070208@asianux.com>  <alpine.DEB.2.02.1309121627040.4089@ionos.tec.linutronix.de> <1379025421.1285.55.camel@dvhart-mobl4.amr.corp.intel.com> <alpine.DEB.2.02.1309130040140.4089@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1309130040140.4089@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Firstly, I am glad to see that you did not redirect all my mails to
"/dev/null".  ;-)


On 09/13/2013 07:36 AM, Thomas Gleixner wrote:
> On Thu, 12 Sep 2013, Darren Hart wrote:
>> On Thu, 2013-09-12 at 16:32 +0200, Thomas Gleixner wrote:
>>> On Tue, 20 Aug 2013, Chen Gang wrote:
>>>
>>>> rt_mutex_finish_proxy_lock() can return failure code (e.g. -EINTR,
>>>> -ETIMEDOUT).
>>>>
>>>> Original implementation has already noticed about it, but not check it
>>>> before next work.
>>>>
>>>> Also let coments within 80 columns to pass "./scripts/checkpatch.pl".
>>>>
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>> ---
>>>>  kernel/futex.c |   30 ++++++++++++++++--------------
>>>>  1 files changed, 16 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/kernel/futex.c b/kernel/futex.c
>>>> index c3a1a55..1a94e7d 100644
>>>> --- a/kernel/futex.c
>>>> +++ b/kernel/futex.c
>>>> @@ -2373,21 +2373,23 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
>>>>               ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
>>>>               debug_rt_mutex_free_waiter(&rt_waiter);
>>>>  
>>>> -             spin_lock(q.lock_ptr);
>>>> -             /*
>>>> -              * Fixup the pi_state owner and possibly acquire the lock if we
>>>> -              * haven't already.
>>>> -              */
>>>> -             res = fixup_owner(uaddr2, &q, !ret);
>>>> -             /*
>>>> -              * If fixup_owner() returned an error, proprogate that.  If it
>>>> -              * acquired the lock, clear -ETIMEDOUT or -EINTR.
>>>> -              */
>>>> -             if (res)
>>>> -                     ret = (res < 0) ? res : 0;
>>>> +             if (!ret) {
>>>
>>> Again. This is completely wrong!  
>>>

Yeah, really it is.


>>> We MUST call fixup_owner even if finish_proxy_lock() returned with an
>>> error code. Simply because finish_proxy_lock() is called outside of
>>> the spin_lock(q.lock_ptr) region and another thread might have
>>> modified the futex state. So we need to handle the corner cases
>>> otherwise we might leave the futex in some undefined state.
>>>
>>> You're reintroducing a hard to decode bug, which got analyzed and
>>> fixed in futex_lock_pi() years ago. See the history for the
>>> explanation.
>>>

Thank you for your details explanation.


>>> Sigh.
>>>
>>>         tglx
>>
>> Chen, perhaps you can let us know what the failure scenario is that you
>> are trying to address with this patch.
> 
> No failure scenario at all.
> 
> Chen is on a self defined agenda to fix random kernel bugs in random
> kernel subdirectories on a given rate by all means. (Google yourself
> for the details.)
> 

Hmm... what you said is partly correct -- it is part of my goal (at
least, I feel it is valuable to kernel).

Others which you did not mention, but still related with kernel:

  1. LTP (Linux Test Project), which I will start at q4 of 2013, which can let me provide more tests on kernel (also can find more kernel issues).

  2. gcc/binutils: which can find more issues both for kernel and gcc/binutils (I am also communicating with gcc folks too).

  3. Documents (or trivial patches): which I am trying, but seems I did not do quite well.


> That crusade does not involve any failure analysis or test cases. It's
> just driven by mechanically checking the code for inconsistencies. Now
> he tripped over a non obvious return value chain in the futex code. So
> instead of figuring out why it is coded this way, he just mechanically
> decided that there is a missing check. Though:
> 
> The return value is checked and it needs deep understanding of the way
> how futexes work to grok why it's necessary to invoke fixup_owner()
> independent of the rt_mutex_finish_proxy_lock() return value.
> 
> The code in question is:
> 
> 	ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
> 
> 	spin_lock(q.lock_ptr);
> 	/*
> 	 * Fixup the pi_state owner and possibly acquire the lock if we
> 	 * haven't already.
> 	 */
> 	res = fixup_owner(uaddr2, &q, !ret);
> 	/*
> 	 * If fixup_owner() returned an error, proprogate that.  If it
> 	 * acquired the lock, clear -ETIMEDOUT or -EINTR. 
> 	 */
> 	if (res)
> 		ret = (res < 0) ? res : 0;
> 
> If you can understand the comments in the code and you are able to
> follow the implementation of fixup_owner() and the usage of "!ret" as
> an argument you really should be able to figure out, why this is
> correct.
> 
> I'm well aware, as you are, that this code is hard to grok. BUT:
> 
> If this code in futex_wait_requeue_pi() is wrong why did Chen's
> correctness checker not trigger on the following code in
> futex_lock_pi()?:
> 
> 	if (!trylock)
> 		ret = rt_mutex_timed_lock(&q.pi_state->pi_mutex, to, 1);
> 	else {
> 		ret = rt_mutex_trylock(&q.pi_state->pi_mutex);
> 		/* Fixup the trylock return value: */
> 		ret = ret ? 0 : -EWOULDBLOCK;
> 	}
> 
> 	spin_lock(q.lock_ptr);
> 	/*
> 	 * Fixup the pi_state owner and possibly acquire the lock if we
> 	 * haven't already.
> 	 */
> 	res = fixup_owner(uaddr, &q, !ret);
> 	/*
> 	 * If fixup_owner() returned an error, proprogate that.  If it acquired
> 	 * the lock, clear our -ETIMEDOUT or -EINTR.
> 	 */
> 	if (res)
> 		ret = (res < 0) ? res : 0;
> 
> It's the very same pattern and according to Chen's logic broken as
> well.
> 
> As I recommended to Chen to read the history of futex.c, I just can
> recommend the same thing to you to figure out why the heck this is the
> correct way to handle it.
> 
> Hint: The relevant commit starts with: cdf
> 
> The code has changed quite a bit since then, but the issue which is
> described quite well in the commit log is still the same.
> 
> Just for the record:
> 
>      Line 48 of futex.c says: "The futexes are also cursed."
> 

Thank you for your explanation (especially spend you expensive time
resources on it).

It is my fault:

  the 'ret' which return from rt_mutex_finish_proxy_lock(), is used by the next fixup_owner().


Thanks.

> Thanks,
> 
> 	tglx
> 
> 

-- 
Chen Gang
