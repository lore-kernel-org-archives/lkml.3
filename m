Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048AbaIFAvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:51:09 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:60458 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbaIFAvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:51:06 -0400
Date: Thu, 4 Sep 2014 10:04:17 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
In-Reply-To: <20140903181931.GB5001@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1409040944220.4565@gentwo.org>
References: <20140902203743.GL5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409021545370.32690@gentwo.org> <20140902211517.GO5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409021819500.5437@gentwo.org> <20140903021152.GA14069@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409030846310.9372@gentwo.org> <20140903144349.GT5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409031043540.24085@gentwo.org> <20140903171409.GZ5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409031226001.24691@gentwo.org>
 <20140903181931.GB5001@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Sep 2014, Paul E. McKenney wrote:

> As noted earlier, in theory, the atomic operations could be nonatomic,

Well as demonstrated by the patch earlier: The atomic operations are only
used on a the local cpu. There is no synchronization in that sense needed
between processors because there is never a remote atomic operation.

> > The code looks fragile and bound to have issues in the future given the
> > barriers/atomics etc. Its going to be cleaner without that.
>
> What exactly looks fragile about it, and exactly what issues do you
> anticipate?

I am concerned about creation of unecessary synchronization issues. In
this case we have already discovered that the atomic operations on per
cpu variables are only used to modify the contents from the local cpu.

This means at minimum we can give up on the use of atomics and keep the
barriers to enforce visibility.

> > And we are right now focusing on the simplest case. The atomics scheme is
> > used multiple times in the RCU subsystem. There is more weird looking code
> > there like atomic_add using zero etc.
>
> The atomic_add_return(0,...) reads the value out, forcing full ordering.
> Again, in theory, this could be a volatile read with explicit memory-barrier
> instructions on either side, but it is not clear which wins.  (Keep in
> mind that almost all of the atomic_add_return(0,...) calls for a given
> dynticks counter are executed from a single kthread.)
>
> If systems continue to add CPUs like they have over the past decade or
> so, I expect that you will be seeing more code like RCU's, not less.

We have other code like this in multiple subsystems but it does not have
the barrier issues, per cpu variables are updated always without the use
of atomics and the inspection of the per cpu state from remote cpus works
just fine also without them.

I'd like to simplify this as much as possible and make it consistent
throughout the kernel.



