Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3HUDtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:49:14 -0400
Received: from intranet.asianux.com ([58.214.24.6]:44992 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab3HUDtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:49:13 -0400
X-Spam-Score: -101.0
Message-ID: <5214387A.6050702@asianux.com>
Date: Wed, 21 Aug 2013 11:48:10 +0800
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
References: <5212DD71.7070208@asianux.com> <1377015589.12131.110.camel@dvhart-mobl4.amr.corp.intel.com>
In-Reply-To: <1377015589.12131.110.camel@dvhart-mobl4.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 12:19 AM, Darren Hart wrote:
> HopingOn Tue, 2013-08-20 at 11:07 +0800, Chen Gang wrote:
> 
> 
> Hi Chen,
> 
>> rt_mutex_finish_proxy_lock() can return failure code (e.g. -EINTR,
>> -ETIMEDOUT).
>>
>> Original implementation has already noticed about it, but not check it
>> before next work.
>>
>> Also let coments within 80 columns to pass "./scripts/checkpatch.pl".
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  kernel/futex.c |   30 ++++++++++++++++--------------
>>  1 files changed, 16 insertions(+), 14 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index c3a1a55..1a94e7d 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -2373,21 +2373,23 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
>>  		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
>>  		debug_rt_mutex_free_waiter(&rt_waiter);
>>  
>> -		spin_lock(q.lock_ptr);
>> -		/*
>> -		 * Fixup the pi_state owner and possibly acquire the lock if we
>> -		 * haven't already.
>> -		 */
>> -		res = fixup_owner(uaddr2, &q, !ret);
> 
> 
> This call catches a corner case which appears to be skipped now. Or am I
> missing how you accounted for that?
> 
> 

Pardon ?

Hmm... this patch lets related code block in "if(!ret) {...}", should
not remove any code.

Please help check again for whether what I have done is correct or not.

Thanks.

>> -		/*
>> -		 * If fixup_owner() returned an error, proprogate that.  If it
>> -		 * acquired the lock, clear -ETIMEDOUT or -EINTR.
>> -		 */
>> -		if (res)
>> -			ret = (res < 0) ? res : 0;
>> +		if (!ret) {
>> +			spin_lock(q.lock_ptr);
>> +			/*
>> +			 * Fixup the pi_state owner and possibly acquire the
>> +			 * lock if we haven't already.
>> +			 */
>> +			res = fixup_owner(uaddr2, &q, !ret);
>> +			/*
>> +			 * If fixup_owner() returned an error, proprogate that.
>> +			 * If it acquired the lock, clear -ETIMEDOUT or -EINTR.
>> +			 */
>> +			if (res)
>> +				ret = (res < 0) ? res : 0;
>>  
>> -		/* Unqueue and drop the lock. */
>> -		unqueue_me_pi(&q);
>> +			/* Unqueue and drop the lock. */
>> +			unqueue_me_pi(&q);
>> +		}
>>  	}
>>  
>>  	/*
> 
> Thanks,
> 


-- 
Chen Gang
