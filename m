Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaEBGIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 02:08:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaEBGIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 02:08:39 -0400
Message-ID: <53633645.9090308@redhat.com>
Date: Fri, 02 May 2014 02:08:05 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: linux-kernel@vger.kernel.org, morten.rasmussen@arm.com, mingo@kernel.org,
        peterz@infradead.org, george.mccollister@gmail.com,
        ktkhai@parallels.com
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
References: <20140502004237.79dd3de6@annuminas.surriel.com>	 <1399008721.5233.35.camel@marge.simpson.net> <1399010337.5233.50.camel@marge.simpson.net>
In-Reply-To: <1399010337.5233.50.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 01:58 AM, Mike Galbraith wrote:
> On Fri, 2014-05-02 at 07:32 +0200, Mike Galbraith wrote: 
>> On Fri, 2014-05-02 at 00:42 -0400, Rik van Riel wrote: 
>>> Currently sync wakeups from the wake_affine code cannot work as
>>> designed, because the task doing the sync wakeup from the target
>>> cpu will block its wakee from selecting that cpu.
>>>
>>> This is despite the fact that whether or not the wakeup is sync
>>> determines whether or not we want to do an affine wakeup...
>>
>> If the sync hint really did mean we ARE going to schedule RSN, waking
>> local would be a good thing.  It is all too often a big fat lie.
> 
> One example of that is say pgbench.  The mother of all work (server
> thread) for that load wakes with sync hint.  Let the server wake the
> first of a small herd CPU affine, and that first wakee then preempt the
> server (mother of all work) that drives the entire load.
> 
> Byebye throughput.
> 
> When there's only one wakee, and there's really not enough overlap to at
> least break even, waking CPU affine is a great idea.  Even when your
> wakees only run for a short time, if you wake/get_preempted repeat, the
> load will serialize.

I see a similar issue with specjbb2013, with 4 backend and
4 frontend JVMs on a 4 node NUMA system.

The NUMA balancing code nicely places the memory of each JVM
on one NUMA node, but then the wake_affine code will happily
run all of the threads anywhere on the system, totally ruining
memory locality.

The front end and back end only exchange a few hundred messages
a second, over loopback tcp, so the switching rate between
threads is quite low...

I wonder if it would make sense for wake_affine to be off by
default, and only switch on when the right conditions are
detected, instead of having it on by default like we have now?

I have some ideas on that, but I should probably catch some
sleep before trying to code them up :)

Meanwhile, the test patch that I posted may help us figure out
whether the "sync" option in the current wake_affine code does
anything useful.

-- 
All rights reversed
