Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaBUIfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:35:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59258 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbaBUIe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:34:58 -0500
Message-ID: <1392971691.5451.84.camel@marge.simpson.net>
Subject: Re: [PATCH v2] sched: keep quiescent cpu out of idle balance loop
From: Mike Galbraith <bitbucket@online.de>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Lei Wen <leiwen@marvell.com>, Peter Zijlstra <peterz@infradead.org>,
        mingo@redhat.com, preeti.lkml@gmail.com, daniel.lezcano@linaro.org,
        viresh.kumar@linaro.org, xjian@marvell.com,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Feb 2014 09:34:51 +0100
In-Reply-To: <CALZhoSTUZpL5th8HuN_pMe7UHt1PMVO7h9_DsChyz8eW3vctvw@mail.gmail.com>
References: <20140220122311.GO27965@twins.programming.kicks-ass.net>
	 <1392949390-9867-1-git-send-email-leiwen@marvell.com>
	 <1392961903.5451.58.camel@marge.simpson.net>
	 <CALZhoSTUZpL5th8HuN_pMe7UHt1PMVO7h9_DsChyz8eW3vctvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:vhZI7ckDNoi8d6YUoa7KHm8dfbual9iiEmaKMwP990u
 x6kRQ0YbPSwguymHiNdr4V76f476CE2G1U7OZiUH927u4fcrqr
 O02yfR5AWjCvMwMeuonm1HDnhk8JFx8Im9xSqAVef35ctW245P
 T/NwNaR0Hw58/QnOI4Ol0Om2xRmFkeZOWm6GZZ8A5UfJyI5ZQD
 LUjTKImoMoJ0mS5NJB2SYeKJKMi8MnAZ1tKyuO06kyurDw0VW7
 kGvX5iwSqNMH49qf7e5610BDoSh3w7NIqwB63dLOLNCFh237VV
 9TPchUi736MiAjesjunExXJAYKxr2/M1bMjYsIfR84NcYbX4Yx
 KwFHozCdkRza6qL2lx3VwKxoM47kmgtP4EqfxUGyhPlNoMkM9C
 5mfF6R0T8jFXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 15:28 +0800, Lei Wen wrote:

> Actually, what I have experiment is as:
> 1. set top cpuset as disable load balance
> 2. set 0-2 cpus to "system", and enable its load balance
> 3. set 3 cpu to "rt" and disable load balance.

Exactly as I do, pertinent part of my cheezy script being...

        # ...and fire up the shield
        cset shield --userset=rtcpus --cpu=${START_CPU}-${END_CPU} --kthread=on

        # If cpuset wasn't previously mounted (no obnoxious systemd),
        # we just mounted it.  Find the mount point.
        if [ -z $CPUSET_ROOT ]; then
                CPUSET_ROOT=$(grep cpuset /proc/mounts|cut -d ' ' -f2)
                if [ -z $CPUSET_ROOT ]; then
                        # If it's not mounted now, bail.
                        echo EEK, cupset is not mounted!
                        exit
                else
                        # ok, check for cgroup mount
                        if [ -f ${CPUSET_ROOT}/cpuset.cpus ]; then
                                CPUSET_PREFIX=cpuset.
                        fi
                fi
        fi

        echo 0 > ${CPUSET_ROOT}/${CPUSET_PREFIX}sched_load_balance
        echo 1 > ${CPUSET_ROOT}/system/${CPUSET_PREFIX}sched_load_balance
        echo 0 > ${CPUSET_ROOT}/rtcpus/${CPUSET_PREFIX}sched_load_balance
        echo 0 > ${CPUSET_ROOT}/rtcpus/${CPUSET_PREFIX}sched_relax_domain_level

> While by this way, root span always covering [0-2] which is seen
> by cpu 0-2, as you also mentioned.
> And it is true that if I disable load balance, I would see span mask
> get them merged.
> 
> So how about below change?
> +       if (!this_rq()->sd)
> +               return;
> Suppose isolated cpu would lose its sd, could you help
> confirm it from crash too?

Yeah, isolated CPUs have no sd connectivity.  I sent Peter a patchlet
offline showing what I do to keep nohz at bay.
> Or, you think it is wrong to do merge job when system group disable
> the load balance?

I think the construction stuff works fine, and !->sd is the perfect cue
to tell various things to keep their grubby mitts off of a CPU.

-Mike

