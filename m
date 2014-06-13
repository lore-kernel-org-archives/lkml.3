Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaFMXNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 19:13:35 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53089 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaFMXNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 19:13:33 -0400
Date: Sat, 14 Jun 2014 01:13:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rcu: Only pin GP kthread when full dynticks is actually
 used
Message-ID: <20140613231323.GS6635@localhost.localdomain>
References: <1402618619-32630-1-git-send-email-fweisbec@gmail.com>
 <20140613012432.GH4581@linux.vnet.ibm.com>
 <20140613013515.GA9589@linux.vnet.ibm.com>
 <20140613124714.GC6635@localhost.localdomain>
 <20140613155233.GM4581@linux.vnet.ibm.com>
 <20140613160002.GL6635@localhost.localdomain>
 <20140613161630.GQ4581@linux.vnet.ibm.com>
 <20140613162130.GP6635@localhost.localdomain>
 <20140613204903.GU4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613204903.GU4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 01:49:03PM -0700, Paul E. McKenney wrote:
> On Fri, Jun 13, 2014 at 06:21:32PM +0200, Frederic Weisbecker wrote:
> > On Fri, Jun 13, 2014 at 09:16:30AM -0700, Paul E. McKenney wrote:
> > > > Is it because we have dynticks CPUs staying too long in the kernel without
> > > > taking any quiescent states? Are we perhaps missing some rcu_user_enter() or
> > > > things?
> > > 
> > > Sort of the former, but combined with the fact that in-kernel CPUs still
> > > need scheduling-clock interrupts for RCU to make progress.  I could
> > > move this to RCU's context-switch hook, but that could be very bad for
> > > workloads that do lots of context switching.
> > 
> > Or I can restart the tick if the CPU stays in the kernel for too long without
> > a tick. I think that's what we were doing before but we removed that because
> > we never implemented it correctly (we sent scheduler IPI that did nothing...)
> 
> That would work for me!
> 
> Just out of curiosity, what would you use to determine that the CPU
> had been in the kernel too long?

I'd rather deduce that when grace periods completion go past some delay.
I think that's the requirement for calling rcu_kick_nohz_cpu()?
