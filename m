Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3FEPOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:14:15 -0400
Received: from mail.candelatech.com ([208.74.158.172]:55244 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab3FEPOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:14:14 -0400
Message-ID: <51AF5509.1070706@candelatech.com>
Date: Wed, 05 Jun 2013 08:11:05 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: 3.9.x:  Possible race related to stop_machine leads to lockup.
References: <51AE5998.2060204@candelatech.com> <51AE667F.6030702@candelatech.com> <87mwr5rwxo.fsf@rustcorp.com.au>
In-Reply-To: <87mwr5rwxo.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 09:41 PM, Rusty Russell wrote:
> Ben Greear <greearb@candelatech.com> writes:
>> On 06/04/2013 02:18 PM, Ben Greear wrote:
>>> I've been trying to figure out why I see the migration/* processes
>>> hang in a busy loop....
>>>
>>> While reading the stop_machine.c file, I think I might have an
>>> answer.
>>>
>>> The set_state() method sets the thread_ack to the current number
>>> of threads.  Each thread's state machine then decrements it down to
>>> zero where it bumps the state to the next level.  This lets each
>>> cpu stop in lock-step it seems.
>>>
>>> But, from what I can tell, the __stop_machine() method can
>>> (re)set the state to STOPMACHINE_PREPARE while the migration
>>> processes are in their loop.  That would explain why they sometimes
>>> loop forever.
>>>
>>> Does this make sense?
>>
>> Err, no..that doesn't make sense.  'smdata' is on the stack.
>>
>> More printk debugging makes it look like one thread just
>> never notices that smdata->state has been updated by another
>> thread.
>>
>> There is this comment..maybe cpu_relax only does the chill out part
>> and we need something else to make sure smdata->state is freshly
>> read from the other CPU's cache?
>>
>> 		/* Chill out and ensure we re-read stopmachine_state. */
>> 		cpu_relax();
>> 		if (smdata->state != curstate) {
>>
>> Gah..way out of my league :P
>
> What architecture?  Maybe someone didn't get the memo; cpu_relax()
> should be a read barrier.

I tried making it and smp read barier, and tried using atomic_t for the state
object.  No big help.

Latest theory is that one thread gets stuck doing IRQs while rest of CPUs have
disabled IRQs and that one CPU/thread never gets back to the cpu shutdown state
machine.

I'll post a more complete debugging patch later today, and try to find
a better way to reproduce it.

Thanks,
Ben
>
> Cheers,
> Rusty.
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

