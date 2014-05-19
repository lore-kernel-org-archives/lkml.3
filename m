Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaESSCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:02:03 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63016 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaESSCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:02:00 -0400
Message-ID: <537A4714.1000009@colorfullife.com>
Date: Mon, 19 May 2014 20:01:56 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, akpm@linux-foundation.org
CC: aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ipc,msg: always respect MSG_NOERROR
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com> <1400012857-11733-4-git-send-email-davidlohr@hp.com> <53784ABD.8080209@colorfullife.com> <1400436100.9463.4.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1400436100.9463.4.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr, Hi Andrew,

On 05/18/2014 08:01 PM, Davidlohr Bueso wrote:
> On Sun, 2014-05-18 at 07:53 +0200, Manfred Spraul wrote:
>> On 05/13/2014 10:27 PM, Davidlohr Bueso wrote:
>>> When specifying the MSG_NOERROR flag, receivers can avoid returning
>>> error (E2BIG) and just truncate the message text, if it is too large.
>>>
>>> Currently, this logic is only respected when there are already pending
>>> messages in the queue.
>> Do you have a test case? The code should handle that
>> (See below)
Below you admit that the code works flawlessly.
I.e. The changelog misrepresents the patch as a bugfix, whereas it 
actually is a cleanup.

The code is more or less 15 years old, cleanups are a good thing, but 
NOT WITH A MISLEADING CHANGELOG!
(and unfortunately not the first time, you didn't mention that your 
patch to modify SHMMAX also disabled SHMMIN).


>>> @@ -901,6 +907,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
>>>    		list_add_tail(&msr_d.r_list, &msq->q_receivers);
>>>    		msr_d.r_tsk = current;
>>>    		msr_d.r_msgtype = msgtyp;
>>> +		msr_d.r_msgflg = msgflg;
>>>    		msr_d.r_mode = mode;
>>>    		if (msgflg & MSG_NOERROR)
>>>    			msr_d.r_maxsize = INT_MAX;
>>      ^^^^^^
>> This code should handle MSG_NOERROR:
>> If MSG_NOERROR is set, then maxsize is set to INT_MAX, therefore -E2BIG
>> should never be returned.
> Yeah, I noticed that, but I'd still prefer keeping the check, even if
> redundant. It's free and by keeping both scenarios where there are and
> aren't msg waiting in the queue the code becomes easier to read.
Why?
Preparation for porting to a noisy quantum computer, where we must check 
for conditions twice?

Either you can pass the flags, or you treat MSG_NOERROR as "accept 
messages up to size INT_MAX.
But not both.

A cleanup should *remove* code duplication and other complex parts, not 
add additional code duplication.

Andrew:
Could you please drop the patch?

- The change log must be updated.
- The introduction of r_msgflg is questionable. r_maxsize=INT_MAX is 
simpler than r_msgflg&MSG_NOERROR.
- The cleanup should be thoroughly tested, to verify that it doesn't 
break something that is not tested by LTP.

--
     Manfred

P.S.:
> +			wake_up_process(msr->r_tsk);
>   
> -				return 1;
> -			}
> +			/*
> +			 * Ensure that the wakeup is visible before
> +			 * setting r_msg, as the receiving end depends
> +			 * on it. See lockless receive part 1 and 2 in
> +			 * do_msgrcv().
> +			 */
> +			smp_mb();
> +			msr->r_msg = msg;
No, it's not about visibility.

The issue is use-after-free:
- immediately after msr->r_msg = msg, the other task can return to user 
space, call sys_exit() and then release the task struct
- wake_up_process(msr->r_tsk) then accesses already released memory.

On a virtualized hardware, this can happen (and did happen - either with 
ipc/sem.c or ipc/msg.c, with S390. It was documented, it seems it got lost).

So a hands-off is required:
Writing r_msg must be the last write operation.
