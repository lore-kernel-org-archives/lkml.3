Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbaE2QkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:40:25 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41265 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352AbaE2QkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:40:24 -0400
Date: Thu, 29 May 2014 09:40:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, hughd@google.com, viresh.kumar@linaro.org,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V5
Message-ID: <20140529164018.GM22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.10.1405121317270.29911@gentwo.org>
 <20140528152107.GB6507@localhost.localdomain>
 <alpine.DEB.2.10.1405281110210.22514@gentwo.org>
 <20140529003609.GG6507@localhost.localdomain>
 <alpine.DEB.2.10.1405290902180.11514@gentwo.org>
 <20140529142602.GA20258@localhost.localdomain>
 <alpine.DEB.2.10.1405291121400.12545@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405291121400.12545@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052916-9332-0000-0000-000000F020DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:24:15AM -0500, Christoph Lameter wrote:
> On Thu, 29 May 2014, Frederic Weisbecker wrote:
> 
> > > Well yes and I am tying directly into that scheme there in cpu.c to
> > > display the active vmstat threads in sysfs. so its the same.
> >
> > I don't think so. Or is there something in vmstat that cpumask_var_t
> > definition depends upon?
> 
> This patch definitely ties the vmstat cpumask into the scheme in cpu.c
> 
> > > I would like to have some way to display the activities on cpus in /sysfs
> > > like I have done here with the active vmstat workers.
> > >
> > > What I think we need is display cpumasks for
> > >
> > > 1. Cpus where the tick is currently off
> > > 2. Cpus that have dynticks enabled.
> > > 3. Cpus that are idle
> >
> > You should find all that in /proc/timer_list
> 
> True. I could actually drop the vmstat cpumask support.
> 
> > Now for CPUs that have full dynticks enabled, we probably need something
> > in sysfs. We could dump the nohz cpumask somewhere. For now you can only grep
> > the dmesg
> 
> There is a nohz mode in /proc/timer_list right?
> 
> > > 4. Cpus that are used for RCU.
> >
> > So, you mean those that aren't in extended grace period (between rcu_user_enter()/exit
> > or rcu_idle_enter/exit)?
> 
> No I mean cpus that have their RCU processing directed to another
> processor.

Ah, that is easier!

In kernel/rcu/tree_plugin.c under #ifdef CONFIG_RCU_NOCB_CPU:

cpumask_var_t get_rcu_nocb_mask(void)
{
	return rcu_nocb_mask;
}


In include/linux/rcupdate.h:

#if defined(CONFIG_TINY_RCU) || !defined(CONFIG_RCU_NOCB_CPU)
static inline cpumask_var_t get_rcu_nocb_mask(void)
{
	return NULL;
}
#else
cpumask_var_t get_rcu_nocb_mask(void);
#endif


Then display the mask however you prefer.  Modifying the mask is a very
bad idea, and will void your warranty, etc., etc.

							Thanx, Paul

