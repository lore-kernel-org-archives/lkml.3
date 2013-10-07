Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3JGWGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:06:53 -0400
Received: from intranet.asianux.com ([58.214.24.6]:24058 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3JGWGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:06:51 -0400
X-Spam-Score: -100.9
Message-ID: <5253303E.8000907@asianux.com>
Date: Tue, 08 Oct 2013 06:05:50 +0800
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
References: <5212DD71.7070208@asianux.com>  <alpine.DEB.2.02.1309121627040.4089@ionos.tec.linutronix.de> <1379025421.1285.55.camel@dvhart-mobl4.amr.corp.intel.com> <alpine.DEB.2.02.1309130040140.4089@ionos.tec.linutronix.de> <52326FDE.5010303@asianux.com> <52524333.70107@asianux.com>
In-Reply-To: <52524333.70107@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In futex_lock_pi(), after rt_mutex_timed_lock() fails, the followed
fixup_owner() still may return 0 to express "success, lock not taken"
(may printk kernel error in it).

When it happens, 'res' is zero, 'ret' is still none-zero, and
"rt_mutex_owner(&q.pi_state->pi_mutex) == current", it will call
rt_mutex_unlock().

At least, they are conflict with the comment near above the related
checking statements. and one possible fix is below (only a demo for
discussion, not real patch for applying).


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c3a1a55..64e7100 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2071,7 +2071,7 @@ retry_private:
 	 * If fixup_owner() faulted and was unable to handle the fault, unlock
 	 * it and return the fault to userspace.
 	 */
-	if (ret && (rt_mutex_owner(&q.pi_state->pi_mutex) == current))
+	if (ret && res && (rt_mutex_owner(&q.pi_state->pi_mutex) == current))
 		rt_mutex_unlock(&q.pi_state->pi_mutex);
 
 	/* Unqueue and drop the lock */
-- 
1.7.7.6


On 10/07/2013 01:14 PM, Chen Gang wrote:
> 
> After read the code again, I have addtional opinion for discussing,
> please check thanks.
> 
> The related contents are at bottom.
> 
> On 09/13/2013 09:52 AM, Chen Gang wrote:
>> On 09/13/2013 07:36 AM, Thomas Gleixner wrote:
>>> That crusade does not involve any failure analysis or test cases. It's
>>> just driven by mechanically checking the code for inconsistencies. Now
>>> he tripped over a non obvious return value chain in the futex code. So
>>> instead of figuring out why it is coded this way, he just mechanically
>>> decided that there is a missing check. Though:
>>>
>>> The return value is checked and it needs deep understanding of the way
>>> how futexes work to grok why it's necessary to invoke fixup_owner()
>>> independent of the rt_mutex_finish_proxy_lock() return value.
>>>
>>> The code in question is:
>>>
>>> 	ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
>>>
>>> 	spin_lock(q.lock_ptr);
>>> 	/*
>>> 	 * Fixup the pi_state owner and possibly acquire the lock if we
>>> 	 * haven't already.
>>> 	 */
>>> 	res = fixup_owner(uaddr2, &q, !ret);
>>> 	/*
>>> 	 * If fixup_owner() returned an error, proprogate that.  If it
>>> 	 * acquired the lock, clear -ETIMEDOUT or -EINTR. 
>>> 	 */
>>> 	if (res)
>>> 		ret = (res < 0) ? res : 0;
>>>
>>> If you can understand the comments in the code and you are able to
>>> follow the implementation of fixup_owner() and the usage of "!ret" as
>>> an argument you really should be able to figure out, why this is
>>> correct.
>>>
>>> I'm well aware, as you are, that this code is hard to grok. BUT:
>>>
>>> If this code in futex_wait_requeue_pi() is wrong why did Chen's
>>> correctness checker not trigger on the following code in
>>> futex_lock_pi()?:
>>>
>>> 	if (!trylock)
>>> 		ret = rt_mutex_timed_lock(&q.pi_state->pi_mutex, to, 1);
>>> 	else {
>>> 		ret = rt_mutex_trylock(&q.pi_state->pi_mutex);
>>> 		/* Fixup the trylock return value: */
>>> 		ret = ret ? 0 : -EWOULDBLOCK;
>>> 	}
>>>
>>> 	spin_lock(q.lock_ptr);
>>> 	/*
>>> 	 * Fixup the pi_state owner and possibly acquire the lock if we
>>> 	 * haven't already.
>>> 	 */
>>> 	res = fixup_owner(uaddr, &q, !ret);
>>> 	/*
>>> 	 * If fixup_owner() returned an error, proprogate that.  If it acquired
>>> 	 * the lock, clear our -ETIMEDOUT or -EINTR.
>>> 	 */
>>> 	if (res)
>>> 		ret = (res < 0) ? res : 0;
>>>
>>> It's the very same pattern and according to Chen's logic broken as
>>> well.
>>>
>>> As I recommended to Chen to read the history of futex.c, I just can
>>> recommend the same thing to you to figure out why the heck this is the
>>> correct way to handle it.
>>>
>>> Hint: The relevant commit starts with: cdf
>>>
>>> The code has changed quite a bit since then, but the issue which is
>>> described quite well in the commit log is still the same.
>>>
>>> Just for the record:
>>>
>>>      Line 48 of futex.c says: "The futexes are also cursed."
>>>
> 
> fixup_owner() can return 0 for "success, lock not taken".
> 
> If rt_mutex_finish_proxy_lock() fail (ret !=0), fixup_owner() may also
> return 0 (and may printk error message in it), 'ret' will still hold the
> original error code, and continue.
> 
> Is that OK? (for the next checking statement "if (ret == -EFAULT)",
> according to its comments near above, "if fixup_pi_state_owner() faulted
> ...", it seems we need skip it in our case).
> 
> 
> Thanks.
> 
>>
>> Thank you for your explanation (especially spend you expensive time
>> resources on it).
>>
>> It is my fault:
>>
>>   the 'ret' which return from rt_mutex_finish_proxy_lock(), is used by the next fixup_owner().
>>
>>
>> Thanks.
>>
>>> Thanks,
>>>
>>> 	tglx
>>>
>>>
>>
> 
> 


-- 
Chen Gang
