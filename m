Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaE2AgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 20:36:17 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42953 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaE2AgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 20:36:16 -0400
Date: Thu, 29 May 2014 02:36:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V5
Message-ID: <20140529003609.GG6507@localhost.localdomain>
References: <alpine.DEB.2.10.1405121317270.29911@gentwo.org>
 <20140528152107.GB6507@localhost.localdomain>
 <alpine.DEB.2.10.1405281110210.22514@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405281110210.22514@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 11:19:49AM -0500, Christoph Lameter wrote:
> On Wed, 28 May 2014, Frederic Weisbecker wrote:
> 
> > On Mon, May 12, 2014 at 01:18:10PM -0500, Christoph Lameter wrote:
> > >  #ifdef CONFIG_SMP
> > >  static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
> > >  int sysctl_stat_interval __read_mostly = HZ;
> > > +static DECLARE_BITMAP(cpu_stat_off_bits, CONFIG_NR_CPUS) __read_mostly;
> > > +const struct cpumask *const cpu_stat_off = to_cpumask(cpu_stat_off_bits);
> > > +EXPORT_SYMBOL(cpu_stat_off);
> >
> > Is there no way to make it a cpumask_var_t, and allocate it from
> > start_shepherd_timer()?
> >
> > This should really take less space overall.
> 
> This was taken from the way things work with the other cpumasks in
> linux/kernel/cpu.c. Its compatible with the way done there and allows
> also the write protection of the cpumask outside of vmstat.c

The cpumasks in cpu.c are special as they are the base of the cpumask_var_t
definition. They are necessary to define nr_cpu_bits which is the base of
cpumask_var_t allocations. As such they must stay lower level and defined
on top of NR_CPUS.

But most other cases don't need that huge static bitmap. I actually haven't
seen any other struct cpumask than isn't based on cpumask_var_t.

> 
> > > +	schedule_delayed_work(this_cpu_ptr(&vmstat_work),
> > > +		__round_jiffies_relative(sysctl_stat_interval,
> > > +		HOUSEKEEPING_CPU));
> >
> > Maybe you can just make the shepherd work unbound and let bind it from userspace
> > once we have the workqueue user affinity patchset in.
> 
> Yes that is what V5 should have done. Looks like the final version was not
> posted. Sigh. The correct patch follows this message and it no longer uses
> HOUSEKEEPING_CPU.

Ok.

> 
> 
> > OTOH, it means you need to have a vmstat_update work on the housekeeping CPU as well.
> 
> Well the vnstat_udpate may not be needed on the processor where the
> shepherd runs so it may save something.

Ok, thanks!

> 
> From cl@linux.com Thu Oct  3 12:41:21 2013
> Date: Thu, 3 Oct 2013 12:41:21 -0500 (CDT)
> From: Christoph Lameter <cl@linux.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Gilad Ben-Yossef <gilad@benyossef.com>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>, Minchan Kim <minchan.kim@gmail.com>, Hakan Akkan <hakanakkan@gmail.com>, Max Krasnyansky <maxk@qualcomm.com>, Frederic Weisbecker <fweisbec@gmail.com>, Paul E. McKenney <paulmck@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com, viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org
> Subject: vmstat: On demand vmstat workers V6

Please post it on a new thread so it gets noticed by others.

Thanks.
