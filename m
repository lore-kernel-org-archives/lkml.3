Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab3ILFwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:52:55 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:51923 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3ILFwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:52:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=DfmNSMnyVRK0gfx7QGr=jOTbFo6uuGhEOaa2UMkeQAQ@mail.gmail.com>
References: <522E1FEF.6080803@wwwdotorg.org>
	<1775778.MeiRhuYy7o@vostro.rjw.lan>
	<522F86AD.6010603@wwwdotorg.org>
	<2521560.SfeNbV74nj@vostro.rjw.lan>
	<52304439.3030301@linux.vnet.ibm.com>
	<CAKohpokTVzikxunqSdUYmLjTOkfhWFJ=N4TTa4rdbj2euCFY-g@mail.gmail.com>
	<CAKohpomzQ8Yzk+OU0btQM6DGm4xsY1RR9uYFrZD3ZHO-bhrwKQ@mail.gmail.com>
	<5230509D.6040205@linux.vnet.ibm.com>
	<CAKohpo=DfmNSMnyVRK0gfx7QGr=jOTbFo6uuGhEOaa2UMkeQAQ@mail.gmail.com>
Date: Thu, 12 Sep 2013 11:22:52 +0530
Message-ID: <CAKohpo=8mqRmmk17D52yiR9w1V4Z+2UzZ2kzABtrxHbYR+sQzw@mail.gmail.com>
Subject: Re: cpufreq_stats NULL deref on second system suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me fix my mail first.. I was running out of time yesterday and so couldn't
frame things correctly :)

On 11 September 2013 17:29, Viresh Kumar <viresh.kumar@linaro.org> wrote:
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

And this should be done without your patch. Or actually we will simply
return from this place. Atleast for systems with single cluster, like Tegra.

policy->related_cpus is still valid after resume and we haven't removed
policy from the cpufreq_policy_list (though there is a bug which I have
fixed separately and sent it to you..).. So no change required for a single
cluster system..

> Non-boot Cluster
> ---------------------
>
> All CPUs here are removed and at the end policy->cpu contains the last
> cpu removed.. So, for a cluster with cpu 2 and 3.... it will contain 3..
>
> Now at resume we will add cpu2 first and so need to update policy->cpu
> to 2..

> But for all other CPUs in this cluster we return early from
> cpufreq_add_dev() and call cpufreq_add_policy_cpu() as policy->cpus
> was fixed by call to ->init() for the first cpu of this cluster..

This was wrong, we need a valid policy->related_cpus field which is always
valid and so we return early here too, but not for the first cpu of cluster.

> And so we never reach the line: policy->cpu = cpu;
>
> For the first cpu of non-boot cluster we need to call update_policy_cpu()
> and not for others..

that's correct, thought I have one more idea.. :)

> But for the boot cluster if we can call ->init() somehow at resume time,
> then things would be fairly similar in both cases..

Not required.. its all working already.. and so Stephen shouldn't need your
patch for Tegra, but rather my patches that fix other cpufreq bugs..

Now coming back to the ideas I have...
Same code will work if hotplug sequence is fixed a bit. Why aren't we doing
exact opposite of suspend in resume?

We are removing CPUs (leaving the boot cpu) in ascending order and then
adding them back in same order.. Why?

Why not remove CPUs in descending order and add in ascending order? Or
remove in ascending order and add in descending order?

That way policy->cpu will be updated with the right cpu and your patch wouldn't
be required..

I am not saying that this can't be hacked/fixed in cpufreq but suspend/resume
may also be fixed and that looks logically more correct to me..
