Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaFKEMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:12:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36151 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaFKEMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:12:07 -0400
Date: Tue, 10 Jun 2014 21:12:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] kernel/rcu/tree.c: correct a check for grace
 period in progress
Message-ID: <20140611041202.GX4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402456819-30515-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402456819-30515-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061104-6688-0000-0000-0000027C302A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 11:20:19PM -0400, Pranith Kumar wrote:
> The comment above the code says that we are checking both the current node and
> the parent node to see if a grace period is in progress. Change the code
> accordingly.

Almost...  Please see below.

							Thanx, Paul

> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  kernel/rcu/tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index f1ba773..b632189 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1227,7 +1227,7 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
>  	 * need to explicitly start one.
>  	 */
>  	if (rnp->gpnum != rnp->completed ||
> -	    ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
> +	    ACCESS_ONCE(rnp_root->gpnum) != ACCESS_ONCE(rnp_root->completed)) {

At this point in the code, we are checking the current rcu_node structure,
which might or might not be the root.  If it is not the root, we absolutely
cannot compare against the root because we don't yet hold the root's lock.

So I cannot take this change.

That said, I do heartily encourage you to keep looking.  After all, there
are bound to be at least a few bugs in RCU somewhere.

>  		rnp->need_future_gp[c & 0x1]++;
>  		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleaf"));
>  		goto out;

