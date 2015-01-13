Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbbAMJgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:36:31 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42677 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbbAMJg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:36:29 -0500
Date: Tue, 13 Jan 2015 01:36:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rcu_tree: avoid touch rnp->completed when starts a new GP
Message-ID: <20150113093618.GI9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1421134234-3418-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421134234-3418-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011309-0005-0000-0000-000007FA4384
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 03:30:34PM +0800, Lai Jiangshan wrote:
> In rcu_gp_init(), rnp->completed equals to rsp->completed in THEORY,
> we don't need to touch it normally.  If something goes wrong,
> it will complain and fixup rnp->completed and avoid oops.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Queued for 3.21, thank you!

							Thanx, Paul

> ---
>  kernel/rcu/tree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 7680fc2..ea6dc28 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1639,8 +1639,8 @@ static int rcu_gp_init(struct rcu_state *rsp)
>  		rcu_preempt_check_blocked_tasks(rnp);
>  		rnp->qsmask = rnp->qsmaskinit;
>  		ACCESS_ONCE(rnp->gpnum) = rsp->gpnum;
> -		WARN_ON_ONCE(rnp->completed != rsp->completed);
> -		ACCESS_ONCE(rnp->completed) = rsp->completed;
> +		if (WARN_ON_ONCE(rnp->completed != rsp->completed))
> +			ACCESS_ONCE(rnp->completed) = rsp->completed;
>  		if (rnp == rdp->mynode)
>  			(void)__note_gp_changes(rsp, rnp, rdp);
>  		rcu_preempt_boost_start_gp(rnp);
> -- 
> 2.1.0
> 

