Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3KPPVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 10:21:37 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:36239 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3KPPV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 10:21:28 -0500
Date: Sat, 16 Nov 2013 07:21:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ding Tianhong <dthxman@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 11/14] bonding/bond_main: Apply
 ACCESS_ONCE() to avoid sparse false positive
Message-ID: <20131116152119.GB4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131116003946.GA316@linux.vnet.ibm.com>
 <1384562417-817-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1384562417-817-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <5286F550.10900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5286F550.10900@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111615-8236-0000-0000-000003DB7B9A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 12:32:16PM +0800, Ding Tianhong wrote:
> 于 2013/11/16 8:40, Paul E. McKenney 写道:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >
> > The sparse checking for rcu_assign_pointer() was recently upgraded
> > to reject non-__kernel address spaces.  This also rejects __rcu,
> > which is almost always the right thing to do.  However, the uses in
> > bond_change_active_slave() and __bond_release_one() are legitimate:
> > They are assigning a pointer to an element from an RCU-protected list
> > (or a NULL pointer), and all elements of this list are already visible
> > to caller.
> >
> > This commit therefore silences these false positives either by laundering
> > the pointers using ACCESS_ONCE() as suggested by Eric Dumazet and Josh
> > Triplett, or by using RCU_INIT_POINTER() for NULL pointer assignments.
> 
> I think it is fit for net-next.

Thank you!

If this is queued there, I would be happy to drop it from my tree.
There are no dependencies on anything in my tree.

							Thanx, Paul

> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Stephen Hemminger <stephen@networkplumber.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: bridge@lists.linux-foundation.org
> > Cc: netdev@vger.kernel.org
> > ---
> >  drivers/net/bonding/bond_main.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index 72df399c4ab3..bbd7fd3e46fe 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -890,7 +890,8 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
> >  		if (new_active)
> >  			bond_set_slave_active_flags(new_active);
> >  	} else {
> > -		rcu_assign_pointer(bond->curr_active_slave, new_active);
> > +		/* Both --rcu and visible, so ACCESS_ONCE() is OK. */
> > +		ACCESS_ONCE(bond->curr_active_slave) = new_active;
> >  	}
> >  
> >  	if (bond->params.mode == BOND_MODE_ACTIVEBACKUP) {
> > @@ -1801,7 +1802,7 @@ static int __bond_release_one(struct net_device *bond_dev,
> >  	}
> >  
> >  	if (all) {
> > -		rcu_assign_pointer(bond->curr_active_slave, NULL);
> > +		RCU_INIT_POINTER(bond->curr_active_slave, NULL);
> >  	} else if (oldcurrent == slave) {
> >  		/*
> >  		 * Note that we hold RTNL over this sequence, so there
> 

