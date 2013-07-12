Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab3GLHHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:07:02 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:33180 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3GLHHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:07:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130711221553.547.56787.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
	<20130711221553.547.56787.stgit@srivatsabhat.in.ibm.com>
Date: Fri, 12 Jul 2013 12:36:59 +0530
Message-ID: <CAKohpo=DNhKTGdectgyWLW3XkfDOAiEhJ=hi+zW=6G6fWShybg@mail.gmail.com>
Subject: Re: [PATCH 2/8] cpufreq: Fix misplaced call to cpufreq_update_policy()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, toralf.foerster@gmx.de, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 July 2013 03:45, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> The call to cpufreq_update_policy() is placed in the CPU hotplug callback
> of cpufreq_stats, which has a higher priority than the CPU hotplug callback
> of cpufreq-core. As a result, during CPU_ONLINE/CPU_ONLINE_FROZEN, we end up
> calling cpufreq_update_policy() *before* calling cpufreq_add_dev() !
> And for uninitialized CPUs, it just returns silently, not doing anything.

Hmm..

> To add to it, cpufreq_stats is not even the right place to call
> cpufreq_update_policy() to begin with. The cpufreq core ought to handle
> this in its own callback, from an elegance/relevance perspective.
>
> So move the invocation of cpufreq_update_policy() to cpufreq_cpu_callback,
> and place it *after* cpufreq_add_dev().
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/cpufreq.c       |    1 +
>  drivers/cpufreq/cpufreq_stats.c |    6 ------
>  2 files changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index ccc6eab..f8c3100 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1943,6 +1943,7 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
>                 case CPU_ONLINE:
>                 case CPU_ONLINE_FROZEN:
>                         cpufreq_add_dev(dev, NULL);
> +                       cpufreq_update_policy(cpu);

Do we need to call this for every hotplug of cpu? I am not
talking about suspend/resume here.
