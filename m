Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3ANJ0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:26:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4660 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab3ANJ0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:26:39 -0500
X-IronPort-AV: E=Sophos;i="4.84,466,1355068800"; 
   d="scan'208";a="6582926"
Subject: Re: [PATCH v3 05/22] sched: remove domain iterations in
 fork/exec/wake
From: li guang <lig.fnst@cn.fujitsu.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <50F02823.1070909@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
	 <1357375071-11793-6-git-send-email-alex.shi@intel.com>
	 <20130109182102.GC2046@e103034-lin>  <50EF9B69.3000201@linux.vnet.ibm.com>
	 <1357891316.2860.6.camel@liguang.fnst.cn.fujitsu.com>
	 <50F02823.1070909@intel.com>
Date: Mon, 14 Jan 2013 17:03:11 +0800
Message-ID: <1358154191.8818.15.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/14 17:04:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/14 17:04:32,
	Serialize complete at 2013/01/14 17:04:32
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-01-11五的 22:56 +0800，Alex Shi写道：
> On 01/11/2013 04:01 PM, li guang wrote:
> > 在 2013-01-11五的 10:26 +0530，Preeti U Murthy写道：
> >> Hi Morten,Alex
> >>
> >> On 01/09/2013 11:51 PM, Morten Rasmussen wrote:
> >>> On Sat, Jan 05, 2013 at 08:37:34AM +0000, Alex Shi wrote:
> >>>> Guess the search cpu from bottom to up in domain tree come from
> >>>> commit 3dbd5342074a1e sched: multilevel sbe sbf, the purpose is
> >>>> balancing over tasks on all level domains.
> >>>>
> >>>> This balancing cost much if there has many domain/groups in a large
> >>>> system. And force spreading task among different domains may cause
> >>>> performance issue due to bad locality.
> >>>>
> >>>> If we remove this code, we will get quick fork/exec/wake, plus better
> >>>> balancing among whole system, that also reduce migrations in future
> >>>> load balancing.
> >>>>
> >>>> This patch increases 10+% performance of hackbench on my 4 sockets
> >>>> NHM and SNB machines.
> >>>>
> >>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
> >>>> ---
> >>>>  kernel/sched/fair.c | 20 +-------------------
> >>>>  1 file changed, 1 insertion(+), 19 deletions(-)
> >>>>
> >>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >>>> index ecfbf8e..895a3f4 100644
> >>>> --- a/kernel/sched/fair.c
> >>>> +++ b/kernel/sched/fair.c
> >>>> @@ -3364,15 +3364,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
> >>>>  		goto unlock;
> >>>>  	}
> >>>>  
> >>>> -	while (sd) {
> >>>> +	if (sd) {
> >>>>  		int load_idx = sd->forkexec_idx;
> >>>>  		struct sched_group *group;
> >>>> -		int weight;
> >>>> -
> >>>> -		if (!(sd->flags & sd_flag)) {
> >>>> -			sd = sd->child;
> >>>> -			continue;
> >>>> -		}
> >>>>  
> >>>>  		if (sd_flag & SD_BALANCE_WAKE)
> >>>>  			load_idx = sd->wake_idx;
> >>>> @@ -3382,18 +3376,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
> >>>>  			goto unlock;
> >>>>  
> >>>>  		new_cpu = find_idlest_cpu(group, p, cpu);
> >>>> -
> >>>> -		/* Now try balancing at a lower domain level of new_cpu */
> >>>> -		cpu = new_cpu;
> >>>> -		weight = sd->span_weight;
> >>>> -		sd = NULL;
> >>>> -		for_each_domain(cpu, tmp) {
> >>>> -			if (weight <= tmp->span_weight)
> >>>> -				break;
> >>>> -			if (tmp->flags & sd_flag)
> >>>> -				sd = tmp;
> >>>> -		}
> >>>> -		/* while loop will break here if sd == NULL */
> >>>
> >>> I agree that this should be a major optimization. I just can't figure
> >>> out why the existing recursive search for an idle cpu switches to the
> >>> new cpu near the end and then starts a search for an idle cpu in the new
> >>> cpu's domain. Is this to handle some exotic sched domain configurations?
> >>> If so, they probably wouldn't work with your optimizations.
> >>
> >> Let me explain my understanding of why the recursive search is the way
> >> it is.
> >>
> >>  _________________________  sd0
> >> |                         |
> >> |  ___sd1__   ___sd2__    |
> >> | |        | |        |   |
> >> | | sgx    | |  sga   |   |
> >> | | sgy    | |  sgb   |   |
> >> | |________| |________|   |
> >> |_________________________|
> >>
> >> What the current recursive search is doing is (assuming we start with
> >> sd0-the top level sched domain whose flags are rightly set). we find
> >> that sd1 is the idlest group,and a cpux1 in sgx is the idlest cpu.
> >>
> >> We could have ideally stopped the search here.But the problem with this
> >> is that there is a possibility that sgx is more loaded than sgy; meaning
> >> the cpus in sgx are heavily imbalanced;say there are two cpus cpux1 and
> >> cpux2 in sgx,where cpux2 is heavily loaded and cpux1 has recently gotten
> >> idle and load balancing has not come to its rescue yet.According to the
> >> search above, cpux1 is idle,but is *not the right candidate for
> >> scheduling forked task,it is the right candidate for relieving the load
> >> from cpux2* due to cache locality etc.
> > 
> > This corner case may occur after "[PATCH v3 03/22] sched: fix
> > find_idlest_group mess logical" brought in the local sched_group bias,
> > and assume balancing runs on cpux2.
> > ideally,  find_idlest_group should find the real idlest(this case: sgy),
> > then, this patch is reasonable.
> > 
> 
> Sure. but seems it is a bit hard to go down the idlest group.
> 
> and the old logical is real cost too much, on my 2 socket NHM/SNB
> server, hackbench can increase 2~5% performance. and no clean
> performance on kbuild/aim7 etc.

what about remove local group bias?


-- 
regards!
li guang

