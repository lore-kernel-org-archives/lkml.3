Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935498Ab3FTBeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:34:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:38139 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935469Ab3FTBeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:34:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,901,1363158000"; 
   d="scan'208";a="352653083"
Message-ID: <51C25BDE.6090104@intel.com>
Date: Thu, 20 Jun 2013 09:33:18 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [patch v8 9/9] sched/tg: remove blocked_load_avg in balance
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-10-git-send-email-alex.shi@intel.com> <CAPM31RJ_0xgymfN+5FzQCSrv-qgpT+42EOmWke1rOGy7GfHcYg@mail.gmail.com>
In-Reply-To: <CAPM31RJ_0xgymfN+5FzQCSrv-qgpT+42EOmWke1rOGy7GfHcYg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 08:20 PM, Paul Turner wrote:
> On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
>> > blocked_load_avg sometime is too heavy and far bigger than runnable load
>> > avg, that make balance make wrong decision. So remove it.
> Ok so this is  going to have terrible effects on the correctness of
> shares distribution; I'm fairly opposed to it in its present form.
> 
> So let's see, what could be happening..
> 
> In  "sched: compute runnable load avg in cpu_load and
> cpu_avg_load_per_task" you already update the load average weights
> solely based on current runnable load.  While this is generally poor
> for stability (and I suspect the benefit is coming largely from
> weighted_cpuload() where you do want to use runnable_load_avg and not
> get_rq_runnable_load() where I suspect including blocked_load_avg() is
> correct in the longer term).

If the 'poor stability' means your previous example of 2 40% busy task
and one 90% busy task. It occasionally happens. but at least in all
testing, kbuild, aim7, tbench, oltp, hackbench, ltp etc. involve
blocked_load_avg is just worse, guess due to above reason.
> 
> Ah so.. I have an inkling:
>   Inside weighted_cpuload() where you're trying to use only
> runnable_load_avg; this is in-fact still including blocked_load_avg
> for a cgroup since in the cgroup case a group entities' contribution
> is a function of both runnable and blocked load.

with this patch tg will not include blocked_load_avg.

Honestly, blocked_load_avg should has its meaning, like in your
scenario. but just now, we only can see it bring more harm without any
help on all we tested benchmarks.
I can't find a reason to enable sth that hurt performance.
> 
> Having weighted_cpuload() pull rq->load (possibly moderated by
> rq->avg) would reasonably avoid this since issued shares are
> calculated using instantaneous weights, without breaking the actual
> model for how much load overall that we believe the group has.
> 

I considered to use rq->avg in weighted_cpuload, but when we do
move_tasks to balance load between cpu, we just consider the cfs tasks
not rt task, consider rq->load/avg will involved a unnecessary rt
interference. So I changed to cfs load only.

-- 
Thanks
    Alex
