Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaFMPwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:52:40 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43110 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaFMPwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:52:38 -0400
Date: Fri, 13 Jun 2014 08:52:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rcu: Only pin GP kthread when full dynticks is actually
 used
Message-ID: <20140613155233.GM4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402618619-32630-1-git-send-email-fweisbec@gmail.com>
 <20140613012432.GH4581@linux.vnet.ibm.com>
 <20140613013515.GA9589@linux.vnet.ibm.com>
 <20140613124714.GC6635@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613124714.GC6635@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061315-1344-0000-0000-00000230F9BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 02:47:16PM +0200, Frederic Weisbecker wrote:
> On Thu, Jun 12, 2014 at 06:35:15PM -0700, Paul E. McKenney wrote:
> > On Thu, Jun 12, 2014 at 06:24:32PM -0700, Paul E. McKenney wrote:
> > > On Fri, Jun 13, 2014 at 02:16:59AM +0200, Frederic Weisbecker wrote:
> > > > CONFIG_NO_HZ_FULL may be enabled widely on distros nowadays but actual
> > > > users should be a tiny minority, if actually any.
> > > > 
> > > > Also there is a risk that affining the GP kthread to a single CPU could
> > > > end up noticeably reducing RCU performances and increasing energy
> > > > consumption.
> > > > 
> > > > So lets affine the GP kthread only when nohz full is actually used
> > > > (ie: when the nohz_full= parameter is filled or CONFIG_NO_HZ_FULL_ALL=y)
> > 
> > Which reminds me...  Kernel-heavy workloads running NO_HZ_FULL_ALL=y
> > can see long RCU grace periods, as in about two seconds each.  It is
> > not hard for me to detect this situation.
> 
> Ah yeah sounds quite long.
> 
> > Is there some way I can
> > call for a given CPU's scheduling-clock interrupt to be turned on?
> 
> Yeah, once the nohz kick patchset (https://lwn.net/Articles/601214/) is merged,
> a simple call to tick_nohz_full_kick_cpu() should do the trick. Although the
> right condition must be there on the IPI side. Maybe with rcu_needs_cpu() or such.

I could record the offending GP, and make rcu_needs_cpu() return true
if the current GP matches the offending one.

> But it would be interesting to identify the sources of these extended grace periods.
> If we only restart the tick, we may ignore some deeper oustanding issue.

Some of them have been fixable by other means, but they will probably
come back as system sizes grow.  And I really have put preemption points
into kernel code in response to RCU CPU stall warnings, and the current
state of NO_HZ_FULL effectively ignores these preemption points.  :-/

							Thanx, Paul

> Thanks.
> 
> > 
> > I believe that the nsproxy guys were seeing something like this as well.
> > 
> > 							Thanx, Paul
> 

