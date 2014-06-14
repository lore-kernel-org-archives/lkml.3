Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaFNNFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 09:05:55 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63307 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbaFNNFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 09:05:53 -0400
Date: Sat, 14 Jun 2014 15:05:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rcu: Only pin GP kthread when full dynticks is actually
 used
Message-ID: <20140614130548.GC16504@localhost.localdomain>
References: <20140613161630.GQ4581@linux.vnet.ibm.com>
 <20140613162130.GP6635@localhost.localdomain>
 <20140613164441.GA14232@thin>
 <20140613204822.GT4581@linux.vnet.ibm.com>
 <20140613211034.GA10651@jtriplet-mobl1>
 <20140613224926.GW4581@linux.vnet.ibm.com>
 <20140613231033.GR6635@localhost.localdomain>
 <20140613232715.GB4581@linux.vnet.ibm.com>
 <20140613233933.GT6635@localhost.localdomain>
 <20140614050606.GD4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140614050606.GD4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 10:06:06PM -0700, Paul E. McKenney wrote:
> One complication...  So if the grace period has gone on for a long time,
> and you are returning to kernel mode, RCU will need the scheduling-clock
> tick.  However, in that very same situation, if you are returning to
> idle or to NO_HZ_FULL userspace execution, RCU does -not- need the
> scheduling-clock tick set.

Right.

> One way I could do this is to have rcu_needs_cpu() return three values:
> Zero for RCU doesn't need a scheduling-clock tick for any reason,
> one if RCU needs a scheduling-clock tick only if returning to kernel
> mode, and two if RCU unconditionally needs the scheduling-clock tick.
> Would that work, or is there a better approach?

For an interrupt, based on the context tracking state, I can check where we
return afterward if we are in an interrupt using context_tracking_in_user().

Now probably rcu_needs_cpu() should check that by itself and, depending
on where we return, only tell if we keep the tick or not.

What do you think?
