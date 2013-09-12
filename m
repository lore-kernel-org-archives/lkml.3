Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3ILGET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:04:19 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:41413 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab3ILGEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <5230B991.3040702@linux.vnet.ibm.com>
References: <522E1FEF.6080803@wwwdotorg.org>
	<1775778.MeiRhuYy7o@vostro.rjw.lan>
	<522F86AD.6010603@wwwdotorg.org>
	<2521560.SfeNbV74nj@vostro.rjw.lan>
	<52304439.3030301@linux.vnet.ibm.com>
	<523094CD.3000506@wwwdotorg.org>
	<5230B078.3070306@linux.vnet.ibm.com>
	<5230B991.3040702@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 11:28:58 +0530
Message-ID: <CAKohponn_TUVviNAdGH-SBoKTHg6E+_ExcZeKnjbSuONj_SnQQ@mail.gmail.com>
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

On 12 September 2013 00:12, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> OK, I took a second look at the code, and I suspect that applying the
> second patch might help. So can you try by applying both the patches
> please[1][2]?
>
> Basically here is my hunch: say CPUs 2 and 3 are part of a policy and
> 3 is the policy->cpu. During suspend, CPU 2 will be taken offline first,
> and we hit this code:
>
> 1199         if (cpu != policy->cpu && !frozen) {
> 1200                 sysfs_remove_link(&dev->kobj, "cpufreq");
> 1201         } else if (cpus > 1) {
> 1202
> 1203                 new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);
> 1204                 if (new_cpu >= 0) {
> 1205                         WARN_ON(lock_policy_rwsem_write(cpu));
> 1206                         update_policy_cpu(policy, new_cpu);
> 1207                         unlock_policy_rwsem_write(cpu);
> 1208
> 1209                         if (!frozen) {
> 1210                                 pr_debug("%s: policy Kobject moved to cpu: %d "
> 1211                                          "from: %d\n",__func__, new_cpu, cpu);
> 1212                         }
> 1213                 }
> 1214         }
>
> At this point, the first 'if' condition fails because frozen == true.
> So it enters the else part. But, policy->cpu is actually 3, not 2,
> and hence we invoke nominate_...() unnecessarily. That function returns
> 3 since that's the only CPU remaining in the mask, and so we call
> update_policy_cpu() with new_cpu = 3, and old_cpu was also 3! And that
> is the perfect recipe for disaster, with the current implementation of
> update_policy_cpu().

The problem here is not the wrong implementation of update_policy_cpu()
but

1199         if (cpu != policy->cpu && !frozen) {

Though I have fixed it before looking into your replies :)
