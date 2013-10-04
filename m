Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3JDHE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 03:04:57 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34744 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3JDHE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 03:04:56 -0400
X-Originating-IP: 50.43.39.152
Date: Fri, 4 Oct 2013 00:04:49 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
Message-ID: <20131004070448.GA29335@leaf>
References: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
 <CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
 <20131003105130.GE13318@ZenIV.linux.org.uk>
 <CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
 <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com>
 <20131003232826.GA6604@jtriplet-mobl1>
 <20131004052959.GB5790@linux.vnet.ibm.com>
 <20131004060304.GA28411@leaf>
 <20131004061503.GC5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004061503.GC5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:15:03PM -0700, Paul E. McKenney wrote:
> On Thu, Oct 03, 2013 at 11:03:05PM -0700, Josh Triplett wrote:
> > On Thu, Oct 03, 2013 at 10:29:59PM -0700, Paul E. McKenney wrote:
> > > On Thu, Oct 03, 2013 at 04:28:27PM -0700, Josh Triplett wrote:
> > > > On Thu, Oct 03, 2013 at 01:52:45PM -0700, Linus Torvalds wrote:
> > > > > On Thu, Oct 3, 2013 at 1:41 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > > > >
> > > > > > The problem is this:
> > > > > > A = 1, B = 1
> > > > > > CPU1:
> > > > > > A = 0
> > > > > > <full barrier>
> > > > > > synchronize_rcu()
> > > > > > read B
> > > > > >
> > > > > > CPU2:
> > > > > > rcu_read_lock()
> > > > > > B = 0
> > > > > > read A
> > > 
> > > /me scratches his head...
> > > 
> > > OK, for CPU2 to see 1 from its read from A, the corresponding RCU
> > > read-side critical section must have started before CPU1 did A=0.  This
> > > means that this same RCU read-side critical section must have started
> > > before CPU1's synchronize_rcu(), which means that it must complete
> > > before that synchronize_rcu() returns.  Therefore, CPU2's B=0 must
> > > execute before CPU1's read of B, hence that read of B must return zero.
> > > 
> > > Conversely, if CPU1's read from B returns 1, we know that CPU2's
> > > RCU read-side critical section must not have completed until after
> > > CPU1's synchronize_rcu() returned, which means that the RCU read-side
> > > critical section must have started after that synchronize_rcu() started,
> > > so CPU1's assignment to A must also have already happened.  Therefore,
> > > CPU2's read from A must return zero.
> > 
> > Yeah, that makes sense.
> > 
> > I think too much time spent staring at the *implementation* of RCU and
> > the exciting assumptions it has to make about barriers or memory
> > operations leaking out of the implementations of the RCU primitives (for
> > instance, the fun needed to guarantee a memory barrier on all CPUs, or
> > to safely use non-atomic operations inside RCU itself) makes it entirely
> > too difficult to look at a perfectly ordinary *use* of RCU primitives
> > and see the obvious. :)
> 
> I must confess that my first thought upon seeing Al's example was "but
> of course CPU2's write to B and read from A can be reordered by either
> the compiler or the CPU!"  I had to look again myself.  ;-)

Exactly.

- Josh Triplett
