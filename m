Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3JIWqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:46:14 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39211 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3JIWqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:46:12 -0400
Date: Wed, 9 Oct 2013 15:46:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "David S. Miller" <davem@davemloft.net>,
        Thomas Graf <tgraf@suug.ch>, Gao feng <gaofeng@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 tip/core/rcu 05/13] decnet: Apply rcu_access_pointer()
 to avoid sparse false positive
Message-ID: <20131009224604.GF5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131009212920.GA15413@linux.vnet.ibm.com>
 <1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1381354186-16285-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131009222842.GD11709@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009222842.GD11709@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100922-3532-0000-0000-0000020CA6C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 03:28:42PM -0700, Josh Triplett wrote:
> On Wed, Oct 09, 2013 at 02:29:38PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The sparse checking for rcu_assign_pointer() was recently upgraded
> > to reject non-__kernel address spaces.  This also rejects __rcu,
> > which is almost always the right thing to do.  However, the use in
> > dn_insert_route() is legitimate: It is assigning a pointer to an element
> 
> Nit: "uses ... are", not "use ... is". :)

Don't I already have "use ... is"?

							Thanx, Paul

> > from an RCU-protected list, and all elements of this list are already
> > visible to caller.
> > 
> > This commit therefore silences this false positive by laundering the
> > pointer using rcu_access_pointer() as suggested by Josh Triplett.
> > 
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Thomas Graf <tgraf@suug.ch>
> > Cc: Gao feng <gaofeng@cn.fujitsu.com>
> > Cc: Stephen Hemminger <shemminger@vyatta.com>
> > Cc: linux-decnet-user@lists.sourceforge.net
> > Cc: netdev@vger.kernel.org
> 
> With or without the above typo fix:
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > ---
> >  net/decnet/dn_route.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
> > index fe32388ea24f..3b1357bcfc92 100644
> > --- a/net/decnet/dn_route.c
> > +++ b/net/decnet/dn_route.c
> > @@ -345,7 +345,7 @@ static int dn_insert_route(struct dn_route *rt, unsigned int hash, struct dn_rou
> >  			/* Put it first */
> >  			*rthp = rth->dst.dn_next;
> >  			rcu_assign_pointer(rth->dst.dn_next,
> > -					   dn_rt_hash_table[hash].chain);
> > +					   rcu_access_pointer(dn_rt_hash_table[hash].chain));
> >  			rcu_assign_pointer(dn_rt_hash_table[hash].chain, rth);
> >  
> >  			dst_use(&rth->dst, now);
> > @@ -358,7 +358,8 @@ static int dn_insert_route(struct dn_route *rt, unsigned int hash, struct dn_rou
> >  		rthp = &rth->dst.dn_next;
> >  	}
> >  
> > -	rcu_assign_pointer(rt->dst.dn_next, dn_rt_hash_table[hash].chain);
> > +	rcu_assign_pointer(rt->dst.dn_next,
> > +			   rcu_access_pointer(dn_rt_hash_table[hash].chain));
> >  	rcu_assign_pointer(dn_rt_hash_table[hash].chain, rt);
> >  
> >  	dst_use(&rt->dst, now);
> > -- 
> > 1.8.1.5
> > 
> 

