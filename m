Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422714AbaGROQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:16:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48432 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761881AbaGROQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:16:51 -0400
Message-ID: <53C92C4F.2010704@arm.com>
Date: Fri, 18 Jul 2014 16:16:47 +0200
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bruno Wolff III <bruno@wolff.to>, Peter Zijlstra <peterz@infradead.org>
CC: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from caffcdd8d27ba78730d5540396ce72ad022aff2c
References: <53C6CFCC.2050300@arm.com> <20140716195414.GA16401@wolff.to> <53C7084C.7090104@arm.com> <20140717030947.GA17889@wolff.to> <53C79013.1020808@arm.com> <20140717090452.GH19379@twins.programming.kicks-ass.net> <53C7B247.2070309@arm.com> <20140717123502.GL19379@twins.programming.kicks-ass.net> <20140718053449.GA2039@wolff.to> <20140718101633.GP9918@twins.programming.kicks-ass.net> <20140718130126.GA2401@wolff.to>
In-Reply-To: <20140718130126.GA2401@wolff.to>
X-OriginalArrivalTime: 18 Jul 2014 14:16:49.0142 (UTC) FILETIME=[E9F9C960:01CFA292]
X-MC-Unique: 114071815164902001
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/14 15:01, Bruno Wolff III wrote:
> On Fri, Jul 18, 2014 at 12:16:33 +0200,
>    Peter Zijlstra <peterz@infradead.org> wrote:
>> So it looks like the actual domain tree is broken, and not what we
>> assumed it was.
>>
>> Could I bother you to run with the below instead? It should also print
>> out the sched domain masks so we don't need to guess about them.
>
> The full dmesg output is at:
> https://bugzilla.kernel.org/attachment.cgi?id=143381
>
>> (make sure you have CONFIG_SCHED_DEBUG=y otherwise it will not build)
>>
>>> I also booted with early printk=keepsched_debug as requested by Dietmar.
>>
>> can you make that: sched_debug ?
>
> I think I've fixed that.
>
> I think the part you are most interested in contains the following:
> [    0.252280] smpboot: Total of 4 processors activated (21438.11 BogoMIPS)
> [    0.253058] __sdt_alloc: allocated f255b020 with cpus:
> [    0.253146] __sdt_alloc: allocated f255b0e0 with cpus:
> [    0.253227] __sdt_alloc: allocated f255b120 with cpus:
> [    0.253308] __sdt_alloc: allocated f255b160 with cpus:
> [    0.253390] __sdt_alloc: allocated f255b1a0 with cpus:
> [    0.253471] __sdt_alloc: allocated f255b1e0 with cpus:
> [    0.253551] __sdt_alloc: allocated f255b220 with cpus:
> [    0.253632] __sdt_alloc: allocated f255b260 with cpus:
> [    0.254009] __sdt_alloc: allocated f255b2a0 with cpus:
> [    0.254092] __sdt_alloc: allocated f255b2e0 with cpus:
> [    0.254181] __sdt_alloc: allocated f255b320 with cpus:
> [    0.254262] __sdt_alloc: allocated f255b360 with cpus:
> [    0.254350] build_sched_domain: cpu: 0 level: SMT cpu_map: 0-3 tl->mask: 0,2
> [    0.254433] build_sched_domain: cpu: 0 level: MC cpu_map: 0-3 tl->mask: 0

So the MC level cpu mask function is wrong on this machine. Should be 
0,2 here, right?

The cpu_capacity values look strange too (probably a subsequent error).

[    0.257260] CPU0 attaching sched-domain:
[    0.257264]  domain 0: span 0,2 level SMT
[    0.257268]   groups: 0 (cpu_capacity = 586) 2 (cpu_capacity = 587)
[    0.257275]   domain 1: span 0-3 level DIE
[    0.257278]    groups: 0 (cpu_capacity = 587) 1 (cpu_capacity = 588) 
2 (cpu_capacity = 587) 3 (cpu_capacity = 588)

> [    0.254516] build_sched_domain: cpu: 0 level: DIE cpu_map: 0-3 tl->mask: 0-3
> [    0.254600] build_sched_domain: cpu: 1 level: SMT cpu_map: 0-3 tl->mask: 1,3
> [    0.254683] build_sched_domain: cpu: 1 level: MC cpu_map: 0-3 tl->mask: 1
> [    0.254766] build_sched_domain: cpu: 1 level: DIE cpu_map: 0-3 tl->mask: 0-3
> [    0.254850] build_sched_domain: cpu: 2 level: SMT cpu_map: 0-3 tl->mask: 0,2
> [    0.254932] build_sched_domain: cpu: 2 level: MC cpu_map: 0-3 tl->mask: 2
> [    0.255005] build_sched_domain: cpu: 2 level: DIE cpu_map: 0-3 tl->mask: 0-3
> [    0.255091] build_sched_domain: cpu: 3 level: SMT cpu_map: 0-3 tl->mask: 1,3
> [    0.255176] build_sched_domain: cpu: 3 level: MC cpu_map: 0-3 tl->mask: 3
> [    0.255260] build_sched_domain: cpu: 3 level: DIE cpu_map: 0-3 tl->mask: 0-3
> [    0.256006] build_sched_groups: got group f255b020 with cpus:
> [    0.256089] build_sched_groups: got group f255b120 with cpus:
> [    0.256171] build_sched_groups: got group f255b1a0 with cpus:
> [    0.256252] build_sched_groups: got group f255b2a0 with cpus:
> [    0.256333] build_sched_groups: got group f255b2e0 with cpus:
> [    0.256414] build_sched_groups: got group f255b320 with cpus:
> [    0.256495] build_sched_groups: got group f255b360 with cpus:
> [    0.256576] build_sched_groups: got group f255b0e0 with cpus:
> [    0.256657] build_sched_groups: got group f255b160 with cpus:
> [    0.256740] build_sched_groups: got group f255b1e0 with cpus:
> [    0.256821] build_sched_groups: FAIL
> [    0.257004] build_sched_groups: got group f255b1a0 with cpus: 0
> [    0.257087] build_sched_groups: FAIL
> [    0.257167] build_sched_groups: got group f255b1e0 with cpus: 1
>
>


