Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaJCO3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:29:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbaJCO3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:29:17 -0400
Message-ID: <542EB29A.2050704@redhat.com>
Date: Fri, 03 Oct 2014 10:28:42 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH RFC] sched,idle: teach select_idle_sibling about idle
 states
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org> <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org> <542B277D.7050103@redhat.com> <alpine.LFD.2.11.1409301904150.5311@knanqh.ubzr> <20141002131548.6cd377d5@cuia.bos.redhat.com> <1412317384.5149.19.camel@marge.simpson.net> <20141003075012.GF10583@worktop.programming.kicks-ass.net>
In-Reply-To: <20141003075012.GF10583@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/03/2014 03:50 AM, Peter Zijlstra wrote:
> On Fri, Oct 03, 2014 at 08:23:04AM +0200, Mike Galbraith wrote:
>> On Thu, 2014-10-02 at 13:15 -0400, Rik van Riel wrote:
>> 
>>> Subject: sched,idle: teach select_idle_sibling about idle
>>> states
>>> 
>>> Change select_idle_sibling to take cpu idle exit latency into 
>>> account.  First preference is to select the cpu with the
>>> lowest exit latency from a completely idle sched_group inside
>>> the CPU; if that is not available, we pick the CPU with the
>>> lowest exit latency in any sched_group.
>>> 
>>> This increases the total search time of select_idle_sibling, we
>>> may want to look into propagating load info up the sched_group 
>>> tree in some way. That information would also be useful to
>>> prevent the wake_affine logic from causing a load imbalance
>>> between sched_groups.
>> 
>> A generic boo hiss aimed in the general direction of all of this
>> let's go look at every possibility on every wakeup stuff.  Less
>> is more.
> 
> I hear you, can you see actual slowdown with the patch? While the
> worst case doesn't change, it does make the average case equal to
> the worst case iteration -- where we previously would average out
> at inspecting half the CPUs before finding an idle one, we'd now
> always inspect all of them in order to compare all idle ones on
> their properties.
> 
> Also, with the latest generation of Haswell Xeons having 18 cores
> (36 threads) this is one massively painful loop for sure.

We have 3 different goals when selecting a runqueue for a task:
1) locality: get the task running close to where it has stuff cached
2) work preserving: get the task running ASAP, and preferably on a
   fully idle core
3) idle state latency: place the task on a CPU that can start running
   it ASAP

We may also consider the interplay of the above 3 to have an impact on
4) power use: pack tasks on some CPUs so other CPUs can go into deeper
   idle states

The current implementation is a "compromise" between (1) and (2),
with a strong preference for (2), falling back to (1) if no fully
idle core is found.

My ugly hack isn't any better, trading off (1) in order to be better
at (2) and (3). Whether it even affects (4) remains to be seen.

I know my patch is probably unacceptable, but I do think it is important
that we talk about the problem, and hopefully agree on exactly what the
problem is that we want to solve.

One big question in my mind is, when is locality more important, and
when is work preserving more important?  Do we have an answer to that
question?

The current code has the potential to be quite painful on systems with
a large number of cores per chip, so we will have to change things
anyway...

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJULrKaAAoJEM553pKExN6DVk4H/0d3vVXEezyIUgONluPwKwJC
6QFlaYkglMvfPM85aVLzj4JSQwGmgttXOZBcKvPxk76TbPEgee3lHsstqb0hmWKA
gJdNsR3q/56uUZz4nKTFZqHTXQ6JeXWhppCtd6dibfugo4gI6duvfNsugtOdggm7
1xfUamU6wNAa8VYl3XlHaAaXG4xApVgiNuAC/zRog4ckhfB/Rl2X+4A5Ki7F3eBa
6Gz1DvABd9UYXWvzmHZvB0B+cwSMUpApj5PlPIeo+ZceMCfw7vN20gdZdg/2trsn
weAQsc6ENGaadd5xPj3vsE5QS9oXUw14QM/RH74xy5A7iNyd5JToDRz67aKONiA=
=ZlKb
-----END PGP SIGNATURE-----
