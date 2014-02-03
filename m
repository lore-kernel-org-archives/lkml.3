Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaBCIcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:32:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:37499 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCIcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:32:00 -0500
Message-ID: <52EF53FE.8030004@linutronix.de>
Date: Mon, 03 Feb 2014 09:31:58 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
Subject: Re: [PATCH 1/2] irq_work: allow certain work in hard irq context
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>	 <1391314950.5444.18.camel@marge.simpson.net>	 <52EEA643.1010200@linutronix.de> <1391400037.5357.62.camel@marge.simpson.net>
In-Reply-To: <1391400037.5357.62.camel@marge.simpson.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 05:00 AM, Mike Galbraith wrote:
> On Sun, 2014-02-02 at 21:10 +0100, Sebastian Andrzej Siewior wrote:
> 
>> According to the backtrace both of them are trying to access the
>> per-cpu hrtimer (sched_timer) in order to cancel but they seem to fail
>> to get the timer lock here. They shouldn't spin there for minutes, I
>> have no idea why they did so…
> 
> Hm. per-cpu...
> 
> I've been chasing an rt hotplug heisenbug that is pointing to per-cpu
> oddness.  During sched domain re-construction while running Steven's
> stress script on 64 core box, we hit a freshly constructed domain with
> _no span_, build_sched_groups()->get_group() explodes when we meeting
> it.  But if you try to watch the thing appear... it just doesn't.
> 
> static int build_sched_domains(const struct cpumask *cpu_map,
>                                struct sched_domain_attr *attr)
> {
>         enum s_alloc alloc_state;
>         struct sched_domain *sd;
>         struct s_data d;
>         int i, ret = -ENOMEM;
> 
>         alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
>         if (alloc_state != sa_rootdomain)
>                 goto error;
> 
>         /* Set up domains for cpus specified by the cpu_map. */
>         for_each_cpu(i, cpu_map) {
>                 struct sched_domain_topology_level *tl;
> 
>                 sd = NULL;
>                 for_each_sd_topology(tl) {
>                         sd = build_sched_domain(tl, cpu_map, attr, sd, i);
> BUG_ON(sd == spanless-alien) here..

spanless-alien is?
BUG_ON() is actually _very_ cheap. It shouldn't even create any kind of
compiler barrier which would reload variables / registers. It should
evaluate sd and "spanless-alien", do the compare and then go on.

>                         if (tl == sched_domain_topology)
>                                 *per_cpu_ptr(d.sd, i) = sd;
>                         if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
>                                 sd->flags |= SD_OVERLAP;
>                         if (cpumask_equal(cpu_map, sched_domain_span(sd)))
>                                 break;
>                 }
>         }
> 
>         /* Build the groups for the domains */
>         for_each_cpu(i, cpu_map) {
>                 for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
>                         sd->span_weight = cpumask_weight(sched_domain_span(sd));
>                         if (sd->flags & SD_OVERLAP) {
>                                 if (build_overlap_sched_groups(sd, i))
>                                         goto error;
>                         } else {
>                                 if (build_sched_groups(sd, i))
> ..prevents meeting that alien here.. while hotplug locked.

my copy of build_sched_groups() always returns 0 so it never goes to
the error marker. Did you consider a compiler bug? I could try to
rebuild your source + config on two different compilers just to see if
it makes a difference.

Sebastian
