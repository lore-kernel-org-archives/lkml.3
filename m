Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaGRJ2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:28:21 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50157 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaGRJ2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:28:20 -0400
Message-ID: <53C8E8AE.5060309@arm.com>
Date: Fri, 18 Jul 2014 11:28:14 +0200
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bruno Wolff III <bruno@wolff.to>, Peter Zijlstra <peterz@infradead.org>
CC: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from caffcdd8d27ba78730d5540396ce72ad022aff2c
References: <20140716145546.GA6922@wolff.to> <20140716151748.GC2460@hansolo.jdub.homelinux.org> <53C6CFCC.2050300@arm.com> <20140716195414.GA16401@wolff.to> <53C7084C.7090104@arm.com> <20140717030947.GA17889@wolff.to> <53C79013.1020808@arm.com> <20140717090452.GH19379@twins.programming.kicks-ass.net> <53C7B247.2070309@arm.com> <20140717123502.GL19379@twins.programming.kicks-ass.net> <20140718053449.GA2039@wolff.to>
In-Reply-To: <20140718053449.GA2039@wolff.to>
X-OriginalArrivalTime: 18 Jul 2014 09:28:15.0895 (UTC) FILETIME=[9A79F270:01CFA26A]
X-MC-Unique: 114071810281800801
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/14 07:34, Bruno Wolff III wrote:
> On Thu, Jul 17, 2014 at 14:35:02 +0200,
>    Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> In any case, can someone who can trigger this run with the below; its
>> 'clean' for me, but supposedly you'll trigger a FAIL somewhere.
>
> I got a couple of fail messages.
>
> dmesg output is available in the bug as the following attachment:
> https://bugzilla.kernel.org/attachment.cgi?id=143361
>
> The part of interest is probably:
>
> [    0.253354] build_sched_groups: got group f255b020 with cpus:
> [    0.253436] build_sched_groups: got group f255b120 with cpus:
> [    0.253519] build_sched_groups: got group f255b1a0 with cpus:
> [    0.253600] build_sched_groups: got group f255b2a0 with cpus:
> [    0.253681] build_sched_groups: got group f255b2e0 with cpus:
> [    0.253762] build_sched_groups: got group f255b320 with cpus:
> [    0.253843] build_sched_groups: got group f255b360 with cpus:
> [    0.254004] build_sched_groups: got group f255b0e0 with cpus:
> [    0.254087] build_sched_groups: got group f255b160 with cpus:
> [    0.254170] build_sched_groups: got group f255b1e0 with cpus:
> [    0.254252] build_sched_groups: FAIL
> [    0.254331] build_sched_groups: got group f255b1a0 with cpus: 0
> [    0.255004] build_sched_groups: FAIL
> [    0.255084] build_sched_groups: got group f255b1e0 with cpus: 1

That (partly) explains it. f255b1a0 (5) and f255b1e0 (6) are reused 
here! This reuse doesn't happen on my machines.

But if they are used for a different cpu mask (not including cpu0 resp. 
cpu1 this would mess up their first usage?

I guess that the second time, cpu3 will be added to the cpumask of 
f255b1a0 and cpu4 to f255b1e0?

Maybe we can extend PeterZ patch to print out cpu and span as well us 
this printk also in free_sched_domain() to debug further if this is not 
enough evidence?

[    0.252059] __sdt_alloc: allocated f255b020 with cpus: (1)
[    0.252147] __sdt_alloc: allocated f255b0e0 with cpus: (2)
[    0.252229] __sdt_alloc: allocated f255b120 with cpus: (3)
[    0.252311] __sdt_alloc: allocated f255b160 with cpus: (4)
[    0.252395] __sdt_alloc: allocated f255b1a0 with cpus: (5)
[    0.252477] __sdt_alloc: allocated f255b1e0 with cpus: (6)
[    0.252559] __sdt_alloc: allocated f255b220 with cpus: (7) (not used)
[    0.252641] __sdt_alloc: allocated f255b260 with cpus: (8) (not used)
[    0.253013] __sdt_alloc: allocated f255b2a0 with cpus: (9)
[    0.253097] __sdt_alloc: allocated f255b2e0 with cpus: (10)
[    0.253184] __sdt_alloc: allocated f255b320 with cpus: (11)
[    0.253265] __sdt_alloc: allocated f255b360 with cpus: (12)

[    0.253354] build_sched_groups: got group f255b020 with cpus: (1)
[    0.253436] build_sched_groups: got group f255b120 with cpus: (3)
[    0.253519] build_sched_groups: got group f255b1a0 with cpus: (5)
[    0.253600] build_sched_groups: got group f255b2a0 with cpus: (9)
[    0.253681] build_sched_groups: got group f255b2e0 with cpus: (10)
[    0.253762] build_sched_groups: got group f255b320 with cpus: (11)
[    0.253843] build_sched_groups: got group f255b360 with cpus: (12)
[    0.254004] build_sched_groups: got group f255b0e0 with cpus: (2)
[    0.254087] build_sched_groups: got group f255b160 with cpus: (4)
[    0.254170] build_sched_groups: got group f255b1e0 with cpus: (6)
[    0.254252] build_sched_groups: FAIL
[    0.254331] build_sched_groups: got group f255b1a0 with cpus: 0 (5)
[    0.255004] build_sched_groups: FAIL
[    0.255084] build_sched_groups: got group f255b1e0 with cpus: 1 (6)
[    0.255365] devtmpfs: initialized

>
> I also booted with early printk=keepsched_debug as requested by
> Dietmar.
>

Didn't see what I was looking for in your dmesg output. Did you use
'earlyprintk=keep sched_debug'







