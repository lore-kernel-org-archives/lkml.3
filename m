Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3IKOA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:00:58 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:43961 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3IKOA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:00:56 -0400
Message-ID: <523076A0.3020308@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 19:26:48 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan>	<522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan>	<52304439.3030301@linux.vnet.ibm.com> <CAKohpokTVzikxunqSdUYmLjTOkfhWFJ=N4TTa4rdbj2euCFY-g@mail.gmail.com> <CAKohpomzQ8Yzk+OU0btQM6DGm4xsY1RR9uYFrZD3ZHO-bhrwKQ@mail.gmail.com> <5230509D.6040205@linux.vnet.ibm.com> <CAKohpo=DfmNSMnyVRK0gfx7QGr=jOTbFo6uuGhEOaa2UMkeQAQ@mail.gmail.com>
In-Reply-To: <CAKohpo=DfmNSMnyVRK0gfx7QGr=jOTbFo6uuGhEOaa2UMkeQAQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091113-7014-0000-0000-00000398690A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 05:29 PM, Viresh Kumar wrote:
> On 11 September 2013 16:44, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> Hmm? The problem is not about merely updating the policy->cpu field; the
>> main issue is that the existing code was not letting the cpufreq-stats
>> code know that we updated the policy->cpu under the hood. It is important
>> for cpufreq-stats to know this because it maintains the reference to its
>> stats structure by associating it with the policy->cpu. So if policy->cpu
>> changes under the hood, it loses track of its reference. So we need to
>> keep that code informed about changes to policy->cpu. Thus, we need to call
>> update_policy_cpu() in the CPU online path (during resume). I don't see
>> how we can skip that.
> 
> Okay.. There are two different ways in which cpufreq_add_dev() work
> currently..
> 
> Boot cluster (i.e. policy with boot CPU)
> ---------------
> 
> Here cpufreq_remove_dev() is never called for boot cpu but all others.
> And similarly cpufreq_add_dev() is never called for boot cpu but all others.
> 
> Now policy->cpu contains meaningful cpu at beginning of resume and
> we don't need to modify that at all.. For all the remaining CPUs we
> better call cpufreq_add_policy_cpu() rather..
>

Yes, and the existing code already does that. And if you observe the placement
of the call to update_policy_cpu() in my patch, you'll find that it won't
be called in cases where we call cpufreq_add_policy_cpu(). Which is exactly
what you want, IIUC.

> Non-boot Cluster
> ---------------------
> 
> All CPUs here are removed and at the end policy->cpu contains the last
> cpu removed.. So, for a cluster with cpu 2 and 3.... it will contain 3..
> 
> Not at resume we will add cpu2 first and so need to update policy->cpu
> to 2.. But for all other CPUs in this cluster we return early from
> cpufreq_add_dev() and call cpufreq_add_policy_cpu() as policy->cpus
> was fixed by call to ->init() for the first cpu of this cluster..
> 
> And so we never reach the line: policy->cpu = cpu;
> 
> For the first cpu of non-boot cluster we need to call update_policy_cpu()
> and not for others..
> 

Yes, and that's precisely why I added the call to update_policy_cpu() only
near the statement 'policy->cpu = cpu'. All other cases don't need to call
that function, and in my patch, they indeed don't call that function.

A simple way to look at this is:
If policy->cpu is updated anywhere in the resume (cpu online) path, we need
to call update_policy_cpu(). Otherwise, we don't need to call that function.
This will cover both the scenarios you described above.

> 
> But for the boot cluster if we can call ->init() somehow at resume time,
> then things would be fairly similar in both cases..
> 
> I am running of time now, as need to leave office now...
> I hope I made the problem more clear or probably the way I see it :)
> 

Well, your explanation matches my understanding of the scenarios, and
I had written the patch keeping those scenarios in mind; so I believe the
patch is correct as it is. So what I didn't get is this: are you suggesting
that something is wrong in my patch, or are you just reiterating the different
scenarios involved so that I can recheck whether my patch is right?

If it is the former, please point me to the exact problem you found in
my patch. If it is the latter, I'm pretty sure my patch is right, I've
already checked it :-)

Regards,
Srivatsa S. Bhat

