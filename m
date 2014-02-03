Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaBCJ03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:26:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61743 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaBCJ01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:26:27 -0500
Message-ID: <1391419583.5357.241.camel@marge.simpson.net>
Subject: Re: [PATCH 1/2] irq_work: allow certain work in hard irq context
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
Date: Mon, 03 Feb 2014 10:26:23 +0100
In-Reply-To: <52EF53FE.8030004@linutronix.de>
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
	 <1391314950.5444.18.camel@marge.simpson.net>
	 <52EEA643.1010200@linutronix.de>
	 <1391400037.5357.62.camel@marge.simpson.net>
	 <52EF53FE.8030004@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:AaRNxpbcsDctCAx1znIRdU1rEzLRmT8bHA/1OWDyVjw
 4MLfoGXYlYUGV4tEHf9+NBGyqxV67hXBn89arncB2hJg75ueE7
 /rV5SB8locSJkfdWXBGzUJV45fpTWage/hLAHCN59Qe7BpgbaX
 ybamdhBvgbiYNkY6y3snhFlJVZNk5zj+n9Owh/7UdGTgkRbQTd
 7mtQq3OvSSXPiGP9zmwx90Z9V91TqeBUV4zjQBGP6dCrEjXImv
 kAmnfkq0awsJgpap3HzoYLIqp74xgkmEMtzKkDQT4hgCckfA5s
 W4dfIghkY8ArXfzN/nYzovCyq6IKDoOTYlAYYmx9by7BcqRZG/
 RUewepwtfuIMC0BmQvzZUGPezDucYlG9fx7ni2KybiY2zCqRar
 4K74pzzARYCkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 09:31 +0100, Sebastian Andrzej Siewior wrote: 
> On 02/03/2014 05:00 AM, Mike Galbraith wrote:
> > On Sun, 2014-02-02 at 21:10 +0100, Sebastian Andrzej Siewior wrote:
> > 
> >> According to the backtrace both of them are trying to access the
> >> per-cpu hrtimer (sched_timer) in order to cancel but they seem to fail
> >> to get the timer lock here. They shouldn't spin there for minutes, I
> >> have no idea why they did so…
> > 
> > Hm. per-cpu...
> > 
> > I've been chasing an rt hotplug heisenbug that is pointing to per-cpu
> > oddness.  During sched domain re-construction while running Steven's
> > stress script on 64 core box, we hit a freshly constructed domain with
> > _no span_, build_sched_groups()->get_group() explodes when we meeting
> > it.  But if you try to watch the thing appear... it just doesn't.
> > 
> > static int build_sched_domains(const struct cpumask *cpu_map,
> >                                struct sched_domain_attr *attr)
> > {
> >         enum s_alloc alloc_state;
> >         struct sched_domain *sd;
> >         struct s_data d;
> >         int i, ret = -ENOMEM;
> > 
> >         alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
> >         if (alloc_state != sa_rootdomain)
> >                 goto error;
> > 
> >         /* Set up domains for cpus specified by the cpu_map. */
> >         for_each_cpu(i, cpu_map) {
> >                 struct sched_domain_topology_level *tl;
> > 
> >                 sd = NULL;
> >                 for_each_sd_topology(tl) {
> >                         sd = build_sched_domain(tl, cpu_map, attr, sd, i);
> > BUG_ON(sd == spanless-alien) here..
> 
> spanless-alien is?

An sd spanning zero CPUs, cpumask is empty.

> BUG_ON() is actually _very_ cheap. It shouldn't even create any kind of
> compiler barrier which would reload variables / registers. It should
> evaluate sd and "spanless-alien", do the compare and then go on.

Nonetheless, the bad thing then refuses to happen.

> >                         if (tl == sched_domain_topology)
> >                                 *per_cpu_ptr(d.sd, i) = sd;
> >                         if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
> >                                 sd->flags |= SD_OVERLAP;
> >                         if (cpumask_equal(cpu_map, sched_domain_span(sd)))
> >                                 break;
> >                 }
> >         }
> > 
> >         /* Build the groups for the domains */
> >         for_each_cpu(i, cpu_map) {
> >                 for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
> >                         sd->span_weight = cpumask_weight(sched_domain_span(sd));
> >                         if (sd->flags & SD_OVERLAP) {
> >                                 if (build_overlap_sched_groups(sd, i))
> >                                         goto error;
> >                         } else {
> >                                 if (build_sched_groups(sd, i))
> > ..prevents meeting that alien here.. while hotplug locked.
> 
> my copy of build_sched_groups() always returns 0 so it never goes to
> the error marker.

It explodes before return, in the call to get_group(), trying to write
to lala land.

> Did you consider a compiler bug? I could try to
> rebuild your source + config on two different compilers just to see if
> it makes a difference.

Possible, but seems very unlikely.  I suspect it's something to do with
the rather unusual topology of this box.  8 sockets, but 1 NUMA node
with a whole 8GB ram.  Lots of CPU, no way to use it well.  I suppose I
should try beating up a less crippled big box, see if its reproducible
elsewhere.  It takes a while to explode on this box, and may not ever
explode in a box that doesn't have 64 CPUs all poking the same couple
sticks of ram.

-Mike

