Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab3ILGEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:04:12 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:55259 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab3ILGEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <5230C89D.7010801@linux.vnet.ibm.com>
References: <522E1FEF.6080803@wwwdotorg.org>
	<1775778.MeiRhuYy7o@vostro.rjw.lan>
	<522F86AD.6010603@wwwdotorg.org>
	<2521560.SfeNbV74nj@vostro.rjw.lan>
	<52304439.3030301@linux.vnet.ibm.com>
	<523094CD.3000506@wwwdotorg.org>
	<5230B078.3070306@linux.vnet.ibm.com>
	<5230B991.3040702@linux.vnet.ibm.com>
	<5230BE75.7040307@wwwdotorg.org>
	<5230C89D.7010801@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 11:34:08 +0530
Message-ID: <CAKohpondhWbzbedbvwfiBw+FbO+nanP9TjsV+53rQoMuVKUJqg@mail.gmail.com>
Subject: Re: cpufreq_stats NULL deref on second system suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 01:16, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] cpufreq: Restructure if/else block to avoid unintended behavior
>
> In __cpufreq_remove_dev_prepare(), the code which decides whether to remove
> the sysfs link or nominate a new policy cpu, is governed by an if/else block
> with a rather complex set of conditionals. Worse, they harbor a subtlety
> which leads to certain unintended behavior.
>
> The code looks like this:
>
>         if (cpu != policy->cpu && !frozen) {
>                 sysfs_remove_link(&dev->kobj, "cpufreq");
>         } else if (cpus > 1) {
>                 new_cpu = cpufreq_nominate_new_policy_cpu(...);
>                 ...
>                 update_policy_cpu(..., new_cpu);
>         }
>
> The original intention was:
> If the CPU going offline is not policy->cpu, just remove the link.
> On the other hand, if the CPU going offline is the policy->cpu itself,
> handover the policy->cpu job to some other surviving CPU in that policy.
>
> But because the 'if' condition also includes the 'frozen' check, now there
> are *two* possibilities by which we can enter the 'else' block:
>
> 1. cpu == policy->cpu (intended)
> 2. cpu != policy->cpu && frozen (unintended)
>
> Due to the second (unintended) scenario, we end up spuriously nominating
> a CPU as the policy->cpu, even when the existing policy->cpu is alive and
> well. This can cause problems further down the line, especially when we end
> up nominating the same policy->cpu as the new one (ie., old == new),
> because it totally confuses update_policy_cpu().
>
> To avoid this mess, restructure the if/else block to only do what was
> originally intended, and thus prevent any unwelcome surprises.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/cpufreq.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 62bdb95..247842b 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1193,8 +1193,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>                 cpumask_clear_cpu(cpu, policy->cpus);
>         unlock_policy_rwsem_write(cpu);
>
> -       if (cpu != policy->cpu && !frozen) {
> -               sysfs_remove_link(&dev->kobj, "cpufreq");
> +       if (cpu != policy->cpu) {
> +               if (!frozen)
> +                       sysfs_remove_link(&dev->kobj, "cpufreq");
>         } else if (cpus > 1) {
>
>                 new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);

Ahh, I wrote exactly the same crap.. Rafael please take Srivatsa's patch
here :)

> So can you see if patch 1 + this above fix solves your problem as well?
> Then we can retain the original patch 2 as a cleanup, after these 2 patches.

Why do we need 2 now? We should never hit that case I would say.. And If we
do, there is some other bug in our code which we have hidden :)
