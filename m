Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab3IKL7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:59:11 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:41928 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3IKL7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <5230509D.6040205@linux.vnet.ibm.com>
References: <522E1FEF.6080803@wwwdotorg.org>
	<1775778.MeiRhuYy7o@vostro.rjw.lan>
	<522F86AD.6010603@wwwdotorg.org>
	<2521560.SfeNbV74nj@vostro.rjw.lan>
	<52304439.3030301@linux.vnet.ibm.com>
	<CAKohpokTVzikxunqSdUYmLjTOkfhWFJ=N4TTa4rdbj2euCFY-g@mail.gmail.com>
	<CAKohpomzQ8Yzk+OU0btQM6DGm4xsY1RR9uYFrZD3ZHO-bhrwKQ@mail.gmail.com>
	<5230509D.6040205@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 17:29:07 +0530
Message-ID: <CAKohpo=DfmNSMnyVRK0gfx7QGr=jOTbFo6uuGhEOaa2UMkeQAQ@mail.gmail.com>
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

On 11 September 2013 16:44, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Hmm? The problem is not about merely updating the policy->cpu field; the
> main issue is that the existing code was not letting the cpufreq-stats
> code know that we updated the policy->cpu under the hood. It is important
> for cpufreq-stats to know this because it maintains the reference to its
> stats structure by associating it with the policy->cpu. So if policy->cpu
> changes under the hood, it loses track of its reference. So we need to
> keep that code informed about changes to policy->cpu. Thus, we need to call
> update_policy_cpu() in the CPU online path (during resume). I don't see
> how we can skip that.

Okay.. There are two different ways in which cpufreq_add_dev() work
currently..

Boot cluster (i.e. policy with boot CPU)
---------------

Here cpufreq_remove_dev() is never called for boot cpu but all others.
And similarly cpufreq_add_dev() is never called for boot cpu but all others.

Now policy->cpu contains meaningful cpu at beginning of resume and
we don't need to modify that at all.. For all the remaining CPUs we
better call cpufreq_add_policy_cpu() rather..

Non-boot Cluster
---------------------

All CPUs here are removed and at the end policy->cpu contains the last
cpu removed.. So, for a cluster with cpu 2 and 3.... it will contain 3..

Not at resume we will add cpu2 first and so need to update policy->cpu
to 2.. But for all other CPUs in this cluster we return early from
cpufreq_add_dev() and call cpufreq_add_policy_cpu() as policy->cpus
was fixed by call to ->init() for the first cpu of this cluster..

And so we never reach the line: policy->cpu = cpu;

For the first cpu of non-boot cluster we need to call update_policy_cpu()
and not for others..


But for the boot cluster if we can call ->init() somehow at resume time,
then things would be fairly similar in both cases..

I am running of time now, as need to leave office now...
I hope I made the problem more clear or probably the way I see it :)

--
viresh
