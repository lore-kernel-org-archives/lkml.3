Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3GFHvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 03:51:14 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47701 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3GFHvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 03:51:13 -0400
Message-ID: <51D7CBD7.2060902@linux.vnet.ibm.com>
Date: Sat, 06 Jul 2013 13:18:39 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
        deepthi@linux.vnet.ibm.com, peterz@infradead.org,
        rusty@rustcorp.com.au, heiko.carstens@de.ibm.com, rostedt@goodmis.org,
        miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        jens.axboe@oracle.com, tj@kernel.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, shli@kernel.org, tglx@linutronix.de,
        lig.fnst@cn.fujitsu.com, anton@samba.org
Subject: Re: [PATCH 2/3] smp/ipi:Clarify ambiguous comments around deadlock
 scenarios in smp_call_function variants.
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com> <20130705162711.16888.30274.stgit@preeti.in.ibm.com> <20130706061205.GA3518@udknight>
In-Reply-To: <20130706061205.GA3518@udknight>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070607-6102-0000-0000-000003D08AE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

On 07/06/2013 11:42 AM, Wang YanQing wrote:
> On Fri, Jul 05, 2013 at 09:57:11PM +0530, Preeti U Murthy wrote:
>> Elaborate on when deadlocks can occur when a call is made to
>> smp_call_function_single() and its friends. This avoids ambiguity about
>> when to use these calls.
>>
>> +	 * 2. wait = 0: This function could be called from an interrupt
>> +	 * context, and can get blocked on the csd_lock(csd) below in
>> +	 * "non wait cases".
>> +	 * This is because the percpu copy of csd of this_cpu is used
>> +	 * in non wait cases. Under such circumstances, if the previous caller
>> +	 * of this function who got preempted by this interrupt has already taken
>> +	 * the lock under non wait condition, it will result in deadlock.
>> +	 *
> 
> No, it will not cause deadlock, it is not mutex lock,  it is busy wait, so
> when the CSD_FLAG_LOCK be cleared, the code will go on running.

A deadlock might not result, but a potential long wait in an interrupt
context could result if the source cpu got preempted by an interrupt
between  csd_lock(csd) and generic_exec_single(), where it actually
sends an ipi to the target cpu.

Under such a scenario, if no other cpu has sent a smp_call_function ipi
to it, it will not check its queue till such an ipi is sent, as a result
of which the target will not release the csd on which the source cpu is
waiting.

Hence, on the source cpu,the interrupt handler will have to wait till
then. It would be good therefore to issue a warning under this circumstance.
Maybe we can modify the changelog to reflect this scenario.

> 
> After stare into the kernel/smp.c, I can't catch what the exactly meaning
> of the "DeadLock" in the original comment also.
> 
> I hope someone can clarify it.
> 
> Thanks.
> 

Regards
Preeti U Murthy

