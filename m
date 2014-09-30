Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaI3Mnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:43:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37061 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaI3Mnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:43:50 -0400
Message-ID: <542AA587.7060407@arm.com>
Date: Tue, 30 Sep 2014 13:43:51 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Arnd Bergmann <arnd@arndb.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "umgwanakikbuti@gmail.com" <umgwanakikbuti@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "srao@redhat.com" <srao@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "atheurer@redhat.com" <atheurer@redhat.com>,
        "oleg@redhat.com" <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] sched, time: cmpxchg does not work on 64-bit variable
References: <2547036.UshV4pXvhf@wuerfel> <542AA33E.2050008@redhat.com>
In-Reply-To: <542AA33E.2050008@redhat.com>
X-OriginalArrivalTime: 30 Sep 2014 12:43:46.0649 (UTC) FILETIME=[2D1E7490:01CFDCAC]
X-MC-Unique: 114093013434702301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 30/09/14 13:34, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 09/30/2014 07:56 AM, Arnd Bergmann wrote:
>> A recent change to update the stime/utime members of task_struct 
>> using atomic cmpxchg broke configurations on 32-bit machines with 
>> CONFIG_VIRT_CPU_ACCOUNTING_GEN set, because that uses 64-bit 
>> nanoseconds, leading to a link-time error:
>>
>> kernel/built-in.o: In function `cputime_adjust': :(.text+0x25234):
>> undefined reference to `__bad_cmpxchg'
>>
>> This reverts the change that caused the problem, I suspect the real
>> fix is to conditionally use cmpxchg64 instead, but I have not
>> checked if that will work on all architectures.
> 
> I see that kernel/sched/clock.c uses cmpxchg64 in a non
> architecture, non 64 bit specific piece of code, and
> nobody complained about that file not building, so I have
> to assume cmpxchg64 works :)
> 
> The revert seems like a bad idea, since it will reintroduce
> a race condition with sys_times().
> 
> One problem is that include/asm-generic/cputime_nsecs.h
> defines cputime_t as u64, while cputime_jiffies.h defines
> cputime_t as a long...
> 
> Will anybody barf at a cmpxchg_cputime, or is the solution
> to fix cmpxchg on architectures where it does not accept a
> 64 bit type?  Not quite sure how to do the latter...
> 
> Arnd, on which architecture are you seeing a build failure?
> Is it just 32 bit arm?

I'm seeing it on ARMv7 build too in case I enable 'Full dynticks CPU
time accounting'.

-- Dietmar

> 
[...]

