Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaDYLE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:04:56 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:35934 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbaDYLEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:04:52 -0400
From: Roman Gushchin <klamm@yandex-team.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "tkhai@yandex.ru" <tkhai@yandex.ru>
In-Reply-To: <20140424185858.GB26782@laptop.programming.kicks-ass.net>
References: <36851398363372@webcorp2g.yandex-team.ru> <20140424185858.GB26782@laptop.programming.kicks-ass.net>
Subject: Re: Real-time scheduling policies and hyper-threading
MIME-Version: 1.0
Message-Id: <17051398423889@webcorp2e.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 25 Apr 2014 15:04:49 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24.04.2014, 22:59, "Peter Zijlstra" <peterz@infradead.org>:
> On Thu, Apr 24, 2014 at 10:16:12PM +0400, Roman Gushchin wrote:
>
>> šAre there any known solutions of this problem except disabling
>> šhyper-threading and frequency scaling at all?
>
> This is what we generally tell people to do; disable HT in the BIOS,
> offline the siblings or similar approaches.

It's a good, but expensive approach, if you have many machines.


> Similarly we typically tell people to keep each rt workload to a single
> NUMA node, and in case the workload really is bigger and must cross into
> multiple, use memory interleave where possible.
>
>> šAre there any common plans to enhance the load balancing algorithm in
>> šthe rt-scheduler?
>
> Nope; at best the topology driven placement is going to be a heuristic,
> and the last thing you want for your realtime tasks is (non deterministic)
> placement heuristics.
>
> You, and only you, know your workload and can devise a correct placement
> policy. We have cpusets and cpu affinity available to carve up your
> system for this.

The problem here is that _all_ userspace tasks should care about cpu placement.
In reality, there is always a number of monitoring/administration/system tasks,
which execution increases latencies. Use of nice/SCHED_BATCH/... doesn't solve
the problem, because of hyper-threading.

Of course, it's possible to divide cpus statically via cpusets/partitioning,
but it's also not cheap in terms of overall performance utilization.


> That said, there might be something we could do for soft(er) realtime,
> but I don't think there's been much (if any) research on this.
>
>> šDoes anyone use rt-scheduler for runtime-like cpu-bound tasks?
>
> So in general cpu bound tasks in the RT classes (FIFO/RR/DEADLINE) are
> bad and can make the system go funny.
>
> For general system health it is important that various system tasks
> (kthreads usually) can run. Many of these kthreads run at !rt prios, and
> by having cpu bound tasks in rt prios they don't get to run.

I also had expected a number of problems here, but actually we caught only
a tricky race in timers code ( https://lkml.org/lkml/2014/3/17/323 ).
We haven't noticed any such problems on several hundreds of machines
working in runtime production for few weeks.

Probably, it's important, that CPU load in our case is never 100% for a period 
longer than few hundreds milliseconds.


Many thanks for you comments!

Regards,
Roman
