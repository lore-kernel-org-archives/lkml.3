Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaBQVkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:40:18 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33984 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaBQVkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:40:15 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 17 Feb 2014 13:39:30 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/6] documentation: Document call_rcu()
 safety mechanisms and limitations
Message-ID: <20140217213918.GA7941@thin>
References: <20140217212625.GA4083@linux.vnet.ibm.com>
 <1392672413-5114-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392672413-5114-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 01:26:48PM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The call_rcu() family of primitives will take action to accelerate
> grace periods when the number of callbacks pending on a given CPU
> becomes excessive.  Although this safety mechanism can be useful,
> it is no substitute for users of call_rcu() having rate-limit controls
> in place.  This commit adds this nuance to the documentation.
> 
> Reported-by: "Michael S. Tsirkin" <mst@redhat.com>
> Reported-by: Gleb Natapov <gleb@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Grammatical nit below; otherwise:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  Documentation/RCU/checklist.txt | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
> index 91266193b8f4..5733e31836b5 100644
> --- a/Documentation/RCU/checklist.txt
> +++ b/Documentation/RCU/checklist.txt
> @@ -256,10 +256,11 @@ over a rather long period of time, but improvements are always welcome!
>  		variations on this theme.
>  
>  	b.	Limiting update rate.  For example, if updates occur only
> -		once per hour, then no explicit rate limiting is required,
> -		unless your system is already badly broken.  The dcache
> -		subsystem takes this approach -- updates are guarded
> -		by a global lock, limiting their rate.
> +		once per hour, then no explicit rate limiting is
> +		required, unless your system is already badly broken.
> +		Older versions of the dcache subsystem takes this
> +		approach -- updates were guarded by a global lock,
> +		limiting their rate.

s/takes/take/ to match the change from the singular "The dcache
subsystem" to the plural "Older versions of the dcache subsystem"

(You might also change " -- updates are guarded by" to ", guarding
updates with".)

>  
>  	c.	Trusted update -- if updates can only be done manually by
>  		superuser or some other trusted user, then it might not
> @@ -268,7 +269,8 @@ over a rather long period of time, but improvements are always welcome!
>  		the machine.
>  
>  	d.	Use call_rcu_bh() rather than call_rcu(), in order to take
> -		advantage of call_rcu_bh()'s faster grace periods.
> +		advantage of call_rcu_bh()'s faster grace periods.  (This
> +		is only a partial solution, though.)
>  
>  	e.	Periodically invoke synchronize_rcu(), permitting a limited
>  		number of updates per grace period.
> @@ -276,6 +278,13 @@ over a rather long period of time, but improvements are always welcome!
>  	The same cautions apply to call_rcu_bh(), call_rcu_sched(),
>  	call_srcu(), and kfree_rcu().
>  
> +	Note that although these primitives do take action to avoid memory
> +	exhaustion when any given CPU has too many callbacks, a determined
> +	user could still exhaust memory.  This is especially the case
> +	if a system with a large number of CPUs has been configured to
> +	offload all of its RCU callbacks onto a single CPU, or if the
> +	system has relatively little free memory.
> +
>  9.	All RCU list-traversal primitives, which include
>  	rcu_dereference(), list_for_each_entry_rcu(), and
>  	list_for_each_safe_rcu(), must be either within an RCU read-side
> -- 
> 1.8.1.5
> 
