Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3DVK42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:56:28 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:25284
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755022Ab3DVK40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:56:26 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Mon, 22 Apr 2013 18:56:01 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <cpufreq@vger.kernel.org>
Subject: Re: [PATCH v2 06/15] powerpc/85xx: add support to JOG feature using
 cpufreq interface
Message-ID: <20130422105601.GA32331@localhost.localdomain>
References: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
 <1366368468-29143-6-git-send-email-chenhui.zhao@freescale.com>
 <CAOh2x=mQt-GJa8Hc-zybKOKJBhi5jWVy5-UN57pGJDdE1PPx_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOh2x=mQt-GJa8Hc-zybKOKJBhi5jWVy5-UN57pGJDdE1PPx_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 08:55:35AM +0530, Viresh Kumar wrote:
> On Fri, Apr 19, 2013 at 4:17 PM, Zhao Chenhui
> <chenhui.zhao@freescale.com> wrote:
> > diff --git a/drivers/cpufreq/mpc85xx-cpufreq.c b/drivers/cpufreq/mpc85xx-cpufreq.c
> 
> > +#include <linux/module.h>
> > +#include <linux/cpufreq.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/suspend.h>
> > +#include <linux/cpu.h>
> > +#include <linux/time.h>
> > +#include <linux/io.h>
> > +#include <linux/smp.h>
> 
> Would be better to keep them in alphabetical order, so that we don't add
> anything twice.

Good idea.

> 
> > +static int mpc85xx_cpufreq_cpu_init(struct cpufreq_policy *policy)
> > +{
> > +       unsigned int i, cur_pll;
> > +       int hw_cpu = get_hard_smp_processor_id(policy->cpu);
> > +
> > +       if (!cpu_present(policy->cpu))
> 
> This can't happen and so no need to check it.
> 
> > +               return -ENODEV;
> > +
> > +       /* the latency of a transition, the unit is ns */
> > +       policy->cpuinfo.transition_latency = 2000;
> > +
> > +       cur_pll = get_pll(hw_cpu);
> > +
> > +       /* initialize frequency table */
> > +       pr_debug("core%d frequency table:\n", hw_cpu);
> > +       for (i = 0; mpc85xx_freqs[i].frequency != CPUFREQ_TABLE_END; i++) {
> > +               if (mpc85xx_freqs[i].index <= max_pll[hw_cpu]) {
> > +                       /* The frequency unit is kHz. */
> > +                       mpc85xx_freqs[i].frequency =
> > +                               (sysfreq * mpc85xx_freqs[i].index / 2) / 1000;
> > +               } else {
> > +                       mpc85xx_freqs[i].frequency = CPUFREQ_ENTRY_INVALID;
> > +               }
> > +
> > +               pr_debug("%d: %dkHz\n", i, mpc85xx_freqs[i].frequency);
> > +
> > +               if (mpc85xx_freqs[i].index == cur_pll)
> > +                       policy->cur = mpc85xx_freqs[i].frequency;
> > +       }
> > +       pr_debug("current pll is at %d, and core freq is%d\n",
> > +                       cur_pll, policy->cur);
> > +
> > +       cpufreq_frequency_table_get_attr(mpc85xx_freqs, policy->cpu);
> > +
> > +       /*
> > +        * This ensures that policy->cpuinfo_min
> > +        * and policy->cpuinfo_max are set correctly.
> > +        */
> > +       return cpufreq_frequency_table_cpuinfo(policy, mpc85xx_freqs);
> 
> Call cpufreq_frequency_table_get_attr() at the end after above call is
> successful.
> 
> > +}
> 
> > +static int mpc85xx_cpufreq_target(struct cpufreq_policy *policy,
> > +                             unsigned int target_freq,
> > +                             unsigned int relation)
> 
> merge above two lines.
> 
> > +{
> > +       struct cpufreq_freqs freqs;
> > +       unsigned int new;
> > +       int ret = 0;
> > +
> > +       if (!set_pll)
> > +               return -ENODEV;
> > +
> > +       cpufreq_frequency_table_target(policy,
> > +                                      mpc85xx_freqs,
> > +                                      target_freq,
> > +                                      relation,
> > +                                      &new);
> 
> same.. merge all above to put it in a single line.
> 
> > +       freqs.old = policy->cur;
> > +       freqs.new = mpc85xx_freqs[new].frequency;
> > +       freqs.cpu = policy->cpu;
> 
> not required now.
> 
> > +       mutex_lock(&mpc85xx_switch_mutex);
> > +       cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
> 
> ditto. Rebase over latest code from linux-next. This call has changed.
> 
> > +       ret = set_pll(policy->cpu, mpc85xx_freqs[new].index);
> > +       if (!ret) {
> > +               pr_info("cpufreq: Setting core%d frequency to %d kHz and PLL ratio to %d:2\n",
> > +                        policy->cpu, mpc85xx_freqs[new].frequency,
> > +                        mpc85xx_freqs[new].index);
> > +
> > +               ppc_proc_freq = freqs.new * 1000ul;
> > +       }
> > +       cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
> > +       mutex_unlock(&mpc85xx_switch_mutex);
> > +
> > +       return ret;
> > +}
> 
> > +static int __init mpc85xx_jog_init(void)
> > +{
> > +       struct device_node *np;
> > +       unsigned int svr;
> > +
> > +       np = of_find_matching_node(NULL, mpc85xx_jog_ids);
> > +       if (!np)
> > +               return -ENODEV;
> > +
> > +       guts = of_iomap(np, 0);
> > +       if (!guts) {
> > +               of_node_put(np);
> > +               return -ENODEV;
> > +       }
> > +
> > +       sysfreq = fsl_get_sys_freq();
> > +
> > +       if (of_device_is_compatible(np, "fsl,mpc8536-guts")) {
> > +               svr = mfspr(SPRN_SVR);
> > +               if ((svr & 0x7fff) == 0x10) {
> > +                       pr_err("MPC8536 Rev 1.0 does not support cpufreq(JOG).\n");
> > +                       of_node_put(np);
> 
> unmap too??
> 
> > +                       return -ENODEV;
> > +               }
> > +               mpc85xx_freqs = mpc8536_freqs_table;
> > +               set_pll = mpc8536_set_pll;
> > +               max_pll[0] = get_pll(0);
> > +
> > +       } else if (of_device_is_compatible(np, "fsl,p1022-guts")) {
> > +               mpc85xx_freqs = p1022_freqs_table;
> > +               set_pll = p1022_set_pll;
> > +               max_pll[0] = get_pll(0);
> > +               max_pll[1] = get_pll(1);
> > +       }
> > +
> > +       pr_info("Freescale MPC85xx cpufreq(JOG) driver\n");
> > +
> > +       of_node_put(np);
> > +       return cpufreq_register_driver(&mpc85xx_cpufreq_driver);
> > +}
> > +
> > +device_initcall(mpc85xx_jog_init);
> 

Thanks. I will fix them.

-Chenhui

