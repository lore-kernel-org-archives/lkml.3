Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab3JIV54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:57:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45386 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3JIV5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:57:54 -0400
Date: Wed, 9 Oct 2013 14:57:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 tip/core/rcu 07/13] ipv6/ip6_tunnel: Apply
 rcu_access_pointer() to avoid sparse false positive
Message-ID: <20131009215747.GA5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131009212920.GA15413@linux.vnet.ibm.com>
 <1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1381354186-16285-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <1381354949.4971.20.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381354949.4971.20.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100921-3532-0000-0000-0000020C773E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 02:42:29PM -0700, Eric Dumazet wrote:
> On Wed, 2013-10-09 at 14:29 -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The sparse checking for rcu_assign_pointer() was recently upgraded
> > to reject non-__kernel address spaces.  This also rejects __rcu,
> > which is almost always the right thing to do.  However, the use in
> > ip6_tnl_unlink() is legitimate: It is assigning a pointer to an element
> > from an RCU-protected list, and all elements of this list are already
> > visible to caller.
> > 
> > This commit therefore silences this false positive by laundering the
> > pointer using rcu_access_pointer() as suggested by Josh Triplett.
> > 
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> > Cc: James Morris <jmorris@namei.org>
> > Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> > Cc: Patrick McHardy <kaber@trash.net>
> > Cc: netdev@vger.kernel.org
> > ---
> >  net/ipv6/ip6_tunnel.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> > index 61355f7f4da5..ecc0166e1a9c 100644
> > --- a/net/ipv6/ip6_tunnel.c
> > +++ b/net/ipv6/ip6_tunnel.c
> > @@ -245,7 +245,7 @@ ip6_tnl_unlink(struct ip6_tnl_net *ip6n, struct ip6_tnl *t)
> >  	     (iter = rtnl_dereference(*tp)) != NULL;
> >  	     tp = &iter->next) {
> >  		if (t == iter) {
> > -			rcu_assign_pointer(*tp, t->next);
> > +			rcu_assign_pointer(*tp, rcu_access_pointer(t->next));
> >  			break;
> >  		}
> >  	}
> 
> Then it seems a mere "*tp = t->next;" would be enough  ?
> 
> We do not really need a barrier.

Hmmm...  I could use RCU_INIT_POINTER().  Something like the following?

	RCU_INIT_POINTER(ACCESS_ONCE(*tp), t->next);

The ACCESS_ONCE() to prevent the compiler from doing anything stupid.
Presumably the value of t->next cannot change, so a normal load suffices.

Or did you have something else in mind?

							Thanx, Paul

