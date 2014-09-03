Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaICRnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:43:19 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:60170 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301AbaICRnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:43:18 -0400
Date: Wed, 3 Sep 2014 12:43:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
In-Reply-To: <20140903171409.GZ5001@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1409031226001.24691@gentwo.org>
References: <alpine.DEB.2.11.1409021513490.26284@gentwo.org> <20140902203743.GL5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409021545370.32690@gentwo.org> <20140902211517.GO5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409021819500.5437@gentwo.org>
 <20140903021152.GA14069@linux.vnet.ibm.com> <alpine.DEB.2.11.1409030846310.9372@gentwo.org> <20140903144349.GT5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409031043540.24085@gentwo.org> <20140903171409.GZ5001@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2014, Paul E. McKenney wrote:

> > Well, a shared data structure would be cleaner in general but there are
> > certainly other approaches.
>
> Per-CPU variables -are- a shared data structure.

No the intent is for them to be for the particular cpu and therefore
there is limited support for sharing. Its not a shared data structure in
the classic sense.

The code in the rcu subsystem operates like other percpu code: There is a
modification of local variables by the current processor and other
processors inspect the state once in awhile. The other percpu code does
not need atomics and barriers. RCU for some reason (that is not clear to
me) does.

> > But lets focus on the dynticks_idle case we are discussing here rather
> > than tackle the more difficult other atomics. What is checked in the loop
> > over the remote cpus is the dynticks_idle value plus
> > dynticks_idle_jiffies. So it seems that memory ordering is only used to
> > ensure that the jiffies are seen correctly.
> >
> > In that case both the dynticks_idle and dynticks_idle_jiffies could be
> > placed in one 64 bit value. If this is stored and retrieved as one then
> > there is no issue with ordering anymore and the barriers would no longer
> > be needed.
>
> If there was an upper bound on the propagation of values through a system,
> I could buy this.

What is different in propagation speeds? The atomic read on the function
that checks for the quiescent period having passed is a regular read
anyways. The atomic_inc makes the cacheline propagate faster through the
system? I understand that it evicts the cachelines from other processors
caches (containing other percpu data by the way). That is the desired
effect?

> But Mike Galbraith checked the overhead of ->dynticks_idle and found
> it to be too small to measure.  So doesn't seem to be a problem worth
> extraordinary efforts, especially given that many systems can avoid
> it simply by leaving CONFIG_NO_HZ_SYSIDLE=n.

The code looks fragile and bound to have issues in the future given the
barriers/atomics etc. Its going to be cleaner without that.

And we are right now focusing on the simplest case. The atomics scheme is
used multiple times in the RCU subsystem. There is more weird looking code
there like atomic_add using zero etc.




