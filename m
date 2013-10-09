Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3JIW2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:28:55 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52556 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3JIW2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:28:54 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 9 Oct 2013 15:28:42 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Message-ID: <20131009222842.GD11709@jtriplet-mobl1>
References: <20131009212920.GA15413@linux.vnet.ibm.com>
 <1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1381354186-16285-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381354186-16285-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 02:29:38PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The sparse checking for rcu_assign_pointer() was recently upgraded
> to reject non-__kernel address spaces.  This also rejects __rcu,
> which is almost always the right thing to do.  However, the use in
> dn_insert_route() is legitimate: It is assigning a pointer to an element

Nit: "uses ... are", not "use ... is". :)

> from an RCU-protected list, and all elements of this list are already
> visible to caller.
> 
> This commit therefore silences this false positive by laundering the
> pointer using rcu_access_pointer() as suggested by Josh Triplett.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Thomas Graf <tgraf@suug.ch>
> Cc: Gao feng <gaofeng@cn.fujitsu.com>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: linux-decnet-user@lists.sourceforge.net
> Cc: netdev@vger.kernel.org

With or without the above typo fix:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  net/decnet/dn_route.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
> index fe32388ea24f..3b1357bcfc92 100644
> --- a/net/decnet/dn_route.c
> +++ b/net/decnet/dn_route.c
> @@ -345,7 +345,7 @@ static int dn_insert_route(struct dn_route *rt, unsigned int hash, struct dn_rou
>  			/* Put it first */
>  			*rthp = rth->dst.dn_next;
>  			rcu_assign_pointer(rth->dst.dn_next,
> -					   dn_rt_hash_table[hash].chain);
> +					   rcu_access_pointer(dn_rt_hash_table[hash].chain));
>  			rcu_assign_pointer(dn_rt_hash_table[hash].chain, rth);
>  
>  			dst_use(&rth->dst, now);
> @@ -358,7 +358,8 @@ static int dn_insert_route(struct dn_route *rt, unsigned int hash, struct dn_rou
>  		rthp = &rth->dst.dn_next;
>  	}
>  
> -	rcu_assign_pointer(rt->dst.dn_next, dn_rt_hash_table[hash].chain);
> +	rcu_assign_pointer(rt->dst.dn_next,
> +			   rcu_access_pointer(dn_rt_hash_table[hash].chain));
>  	rcu_assign_pointer(dn_rt_hash_table[hash].chain, rt);
>  
>  	dst_use(&rt->dst, now);
> -- 
> 1.8.1.5
> 
