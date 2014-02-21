Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaBUH2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:28:50 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:36806 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbaBUH2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:28:49 -0500
MIME-Version: 1.0
In-Reply-To: <1392961903.5451.58.camel@marge.simpson.net>
References: <20140220122311.GO27965@twins.programming.kicks-ass.net>
	<1392949390-9867-1-git-send-email-leiwen@marvell.com>
	<1392961903.5451.58.camel@marge.simpson.net>
Date: Fri, 21 Feb 2014 15:28:48 +0800
Message-ID: <CALZhoSTUZpL5th8HuN_pMe7UHt1PMVO7h9_DsChyz8eW3vctvw@mail.gmail.com>
Subject: Re: [PATCH v2] sched: keep quiescent cpu out of idle balance loop
From: Lei Wen <adrian.wenl@gmail.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Lei Wen <leiwen@marvell.com>, Peter Zijlstra <peterz@infradead.org>,
        mingo@redhat.com, preeti.lkml@gmail.com, daniel.lezcano@linaro.org,
        viresh.kumar@linaro.org, xjian@marvell.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On Fri, Feb 21, 2014 at 1:51 PM, Mike Galbraith <bitbucket@online.de> wrote:
> On Fri, 2014-02-21 at 10:23 +0800, Lei Wen wrote:
>> Cpu which is put into quiescent mode, would remove itself
>> from kernel's sched_domain, and want others not disturb its
>> task running. But current scheduler would not checking whether
>> that cpu is setting in such mode, and still insist the quiescent
>> cpu to response the nohz load balance.
>
> Let's isolate some CPUs.
>
> Setup:
> /-----"system" CPU0
> \
>   \---"rtcpus" CPUs1-3
>
> crash> runqueues
> PER-CPU DATA TYPE:
>   struct rq runqueues;
> PER-CPU ADDRESSES:
>   [0]: ffff88022fc12c00
>   [1]: ffff88022fc92c00
>   [2]: ffff88022fd12c00
>   [3]: ffff88022fd92c00
> crash> struct rq ffff88022fd92c00 | grep sd
>   sd = 0x0,  <== yup, CPU3 is isolated bit of silicon
> crash> struct rq ffff88022fd92c00 | grep rd
>   rd = 0xffffffff81bffe60 <def_root_domain>,
> crash> struct -x root_domain 0xffffffff81bffe60
> ...
>   span = {{
>       bits = {0xe} <== "rtcpus"
>     }},
> crash> struct rq ffff88022fc12c00 | grep rd
>   rd = 0xffff8802242c5800,
> crash> struct -x root_domain 0xffff8802242c5800
> ...
>   span = {{
>       bits = {0x1} <== "system"
>     }},
>
> Turn off load balancing in "system" as well now, CPU0 loses its 'sd',
> and becomes an isolated island identical to "rtcpus" CPUs, and thus..
>
>   span = {{
>       bits = {0xf} <== oh darn
>     }},
>
> .."system" and "rtcpus" merge, all CPUs having NULL sd, as they are now
> all remote silicon islands, but they now also share rd again, as if you
> had never diddled domains in the first place.

Great catch for it!
Actually, what I have experiment is as:
1. set top cpuset as disable load balance
2. set 0-2 cpus to "system", and enable its load balance
3. set 3 cpu to "rt" and disable load balance.

While by this way, root span always covering [0-2] which is seen
by cpu 0-2, as you also mentioned.
And it is true that if I disable load balance, I would see span mask
get them merged.

So how about below change?
+       if (!this_rq()->sd)
+               return;
Suppose isolated cpu would lose its sd, could you help
confirm it from crash too?

Or, you think it is wrong to do merge job when system group disable
the load balance?

Thanks,
Lei
