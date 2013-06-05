Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab3FEEqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 00:46:31 -0400
Received: from ozlabs.org ([203.10.76.45]:60896 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab3FEEq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 00:46:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: 3.9.x:  Possible race related to stop_machine leads to lockup.
In-Reply-To: <51AE667F.6030702@candelatech.com>
References: <51AE5998.2060204@candelatech.com> <51AE667F.6030702@candelatech.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 05 Jun 2013 14:11:39 +0930
Message-ID: <87mwr5rwxo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear <greearb@candelatech.com> writes:
> On 06/04/2013 02:18 PM, Ben Greear wrote:
>> I've been trying to figure out why I see the migration/* processes
>> hang in a busy loop....
>>
>> While reading the stop_machine.c file, I think I might have an
>> answer.
>>
>> The set_state() method sets the thread_ack to the current number
>> of threads.  Each thread's state machine then decrements it down to
>> zero where it bumps the state to the next level.  This lets each
>> cpu stop in lock-step it seems.
>>
>> But, from what I can tell, the __stop_machine() method can
>> (re)set the state to STOPMACHINE_PREPARE while the migration
>> processes are in their loop.  That would explain why they sometimes
>> loop forever.
>>
>> Does this make sense?
>
> Err, no..that doesn't make sense.  'smdata' is on the stack.
>
> More printk debugging makes it look like one thread just
> never notices that smdata->state has been updated by another
> thread.
>
> There is this comment..maybe cpu_relax only does the chill out part
> and we need something else to make sure smdata->state is freshly
> read from the other CPU's cache?
>
> 		/* Chill out and ensure we re-read stopmachine_state. */
> 		cpu_relax();
> 		if (smdata->state != curstate) {
>
> Gah..way out of my league :P

What architecture?  Maybe someone didn't get the memo; cpu_relax()
should be a read barrier.

Cheers,
Rusty.
