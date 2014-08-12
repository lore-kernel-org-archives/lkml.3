Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaHLFey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:34:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbaHLFex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:34:53 -0400
Date: Tue, 12 Aug 2014 11:03:21 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140812053321.GK4184@grmbl.mre>
References: <20140808183424.GB13483@grmbl.mre>
 <20140808214347.GH5821@linux.vnet.ibm.com>
 <20140808214648.GA19058@linux.vnet.ibm.com>
 <20140811071308.GA4184@grmbl.mre>
 <20140811162807.GW5821@linux.vnet.ibm.com>
 <20140811194126.GF4184@grmbl.mre>
 <20140811201102.GD5821@linux.vnet.ibm.com>
 <20140811201845.GG4184@grmbl.mre>
 <20140811203421.GE5821@linux.vnet.ibm.com>
 <20140812034531.GA13801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812034531.GA13801@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 11 Aug 2014 [20:45:31], Paul E. McKenney wrote:
> On Mon, Aug 11, 2014 at 01:34:21PM -0700, Paul E. McKenney wrote:
> > On Tue, Aug 12, 2014 at 01:48:45AM +0530, Amit Shah wrote:
> > > On (Mon) 11 Aug 2014 [13:11:02], Paul E. McKenney wrote:
> > > > On Tue, Aug 12, 2014 at 01:11:26AM +0530, Amit Shah wrote:
> > > > > On (Mon) 11 Aug 2014 [09:28:07], Paul E. McKenney wrote:
> > > > > > On Mon, Aug 11, 2014 at 12:43:08PM +0530, Amit Shah wrote:
> > > > > > > On (Fri) 08 Aug 2014 [14:46:48], Paul E. McKenney wrote:
> > > > > > > > On Fri, Aug 08, 2014 at 02:43:47PM -0700, Paul E. McKenney wrote:
> > > > > > > > > On Sat, Aug 09, 2014 at 12:04:24AM +0530, Amit Shah wrote:
> > > > > > > > > > On (Fri) 08 Aug 2014 [11:18:35], Paul E. McKenney wrote:
> > > > > > > > > 
> > > > > > > > > [ . . . ]
> > > > > > > > > 
> > > > > > > > > > > Hmmm... What happens if you boot a7d7a143d0b4cb1914705884ca5c25e322dba693
> > > > > > > > > > > with the kernel parameter "acpi=off"?
> > > > > > > > > > 
> > > > > > > > > > That doesn't change anything - still hangs.
> > > > > > > > > > 
> > > > > > > > > > I intend to look at this more on Monday, though - turning in for
> > > > > > > > > > today.  In the meantime, if there's anything else you'd like me to
> > > > > > > > > > try, please let me know.
> > > > > > > > > 
> > > > > > > > > OK, given that I still cannot reproduce it, I do need your help with
> > > > > > > > > the diagnostics.  And so what sorts of diagnostics work for you in
> > > > > > > > > the hung state?  Are you able to dump ftrace buffers?
> > > > > > > > > 
> > > > > > > > > If you are able to dump ftrace buffers, please enable rcu:rcu_nocb_wake
> > > > > > > > > and send me the resulting trace.
> > > > > > > > 
> > > > > > > > And another random kernel boot parameter to try is rcu_nocb_poll.
> > > > > > > 
> > > > > > > Right, this gets the boot going again:
> > > > > > 
> > > > > > OK, that likely indicates a lost wakeup.  The event tracing enabled by
> > > > > > "rcu:rcu_nocb_wake" should help track those down.  Last time, it was qemu
> > > > > > losing the wakeups, but maybe it is RCU this time.  ;-)
> > > > > 
> > > > > The guest goes dead pretty early; is there a trick to enabling and
> > > > > getting these traces out of the guest that I don't know of that
> > > > > doesn't involve being booted into userspace?  I can perhaps try
> > > > > getting the trace output out from a virtio-serial channel; but even
> > > > > that driver isn't probed yet when the lockup happens.
> > > > 
> > > > First boot with the kernel parameter "trace_event=rcu:rcu_nocb_wake".
> > > > Then when the system hangs, do "sendkey alt-sysrq-z" at the "(qemu)"
> > > > prompt to dump the ftrace buffer.  This hopefully dumps the trace buffer
> > > > to dmesg.
> > > > 
> > > > In addition "sendkey alt-sysrq-t" at the "(qemu)" prompt dumps all tasks'
> > > > stacks, which would also likely be useful information.
> > > 
> > > Nah, this doesn't work -- the guest's totally locked up.  I need a way
> > > to continuously dump buffers till the lockup happens, I suppose.
> > 
> > That is a bit surprising.  Is it possible that the system is OOMing
> > quickly due to grace periods not proceeding?  If so, maybe giving the
> > VM more memory would help.
> 
> Oh, and it is necessary to build the kernel with CONFIG_RCU_TRACE=y
> for the rcu_nocb_wake trace events to be enabled in the first place.
> I am assuming that your kernel was built with CONFIG_MAGIC_SYSRQ=y.

Yes, it is :-)  I checked the rcu_nocb_poll cmdline option does indeed
dump all the ftrace buffers to dmesg.

> If all of that is in place and no joy, is it possible to extract the
> ftrace buffer from the running/hung guest?  It should be in there
> somewhere!  ;-)

I know of only virtio-console doing this (via userspace only,
though).

		Amit
