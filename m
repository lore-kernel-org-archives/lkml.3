Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3GOL1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:27:43 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43357 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794Ab3GOL1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:27:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com,
        stern@rowland.harvard.edu, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] cpufreq: Fix misplaced call to cpufreq_update_policy()
Date: Mon, 15 Jul 2013 13:37:35 +0200
Message-ID: <2436314.Felxb6Mvh0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51E394A8.1030001@linux.vnet.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <CAKohpo=DNhKTGdectgyWLW3XkfDOAiEhJ=hi+zW=6G6fWShybg@mail.gmail.com> <51E394A8.1030001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 15, 2013 11:50:24 AM Srivatsa S. Bhat wrote:
> On 07/12/2013 12:36 PM, Viresh Kumar wrote:
> > On 12 July 2013 03:45, Srivatsa S. Bhat
> > <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> >> The call to cpufreq_update_policy() is placed in the CPU hotplug callback
> >> of cpufreq_stats, which has a higher priority than the CPU hotplug callback
> >> of cpufreq-core. As a result, during CPU_ONLINE/CPU_ONLINE_FROZEN, we end up
> >> calling cpufreq_update_policy() *before* calling cpufreq_add_dev() !
> >> And for uninitialized CPUs, it just returns silently, not doing anything.
> > 
> > Hmm..
> > 
> >> To add to it, cpufreq_stats is not even the right place to call
> >> cpufreq_update_policy() to begin with. The cpufreq core ought to handle
> >> this in its own callback, from an elegance/relevance perspective.
> >>
> >> So move the invocation of cpufreq_update_policy() to cpufreq_cpu_callback,
> >> and place it *after* cpufreq_add_dev().
> >>
> >> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> >> ---
> >>
> >>  drivers/cpufreq/cpufreq.c       |    1 +
> >>  drivers/cpufreq/cpufreq_stats.c |    6 ------
> >>  2 files changed, 1 insertion(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> >> index ccc6eab..f8c3100 100644
> >> --- a/drivers/cpufreq/cpufreq.c
> >> +++ b/drivers/cpufreq/cpufreq.c
> >> @@ -1943,6 +1943,7 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
> >>                 case CPU_ONLINE:
> >>                 case CPU_ONLINE_FROZEN:
> >>                         cpufreq_add_dev(dev, NULL);
> >> +                       cpufreq_update_policy(cpu);
> > 
> > Do we need to call this for every hotplug of cpu? I am not
> > talking about suspend/resume here.
> > 
> 
> I don't think we need to, but I think it would be better to postpone
> optimizations until all the cpufreq regressions get fixed. Later perhaps
> we could revisit these minor optimizations if desired.

Agreed.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
