Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaFKVZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:25:47 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51091 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaFKVZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:25:45 -0400
Date: Wed, 11 Jun 2014 14:25:40 -0700
From: josh@joshtriplett.org
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] kernel/rcu/tree.c:3435 fix a sparse warning
Message-ID: <20140611212540.GA16940@cloud>
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
 <1402519183-12752-5-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402519183-12752-5-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:39:42PM -0400, Pranith Kumar wrote:
> kernel/rcu/tree.c:3435:21: warning: incorrect type in argument 1 (different modifiers)
> kernel/rcu/tree.c:3435:21:    expected int ( *threadfn )( ... )
> kernel/rcu/tree.c:3435:21:    got int ( static [toplevel] [noreturn] *<noident> )( ... )
> 
> by removing __noreturn attribute and adding unreachable() as suggested on the
> mailing list: http://www.kernelhub.org/?p=2&msg=436683
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

No, we should not do this.  And the mailing list post you point to seems
to explicitly recommend using noreturn rather than unreachable.

If sparse doesn't understand this, that's a bug in sparse, not in the
kernel.  Sparse needs to understand that it's OK to drop noreturn from a
function pointer type, just not OK to add it.

Rationale: If you call a noreturn function through a non-noreturn
function pointer, you might end up with unnecessary cleanup code, but
the call will work.  If you call a non-noreturn function through a
noreturn function pointer, the caller will not expect a return, and may
crash; *that* should require a cast.

>  kernel/rcu/tree.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 9ab84d3..6029a2e 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1689,7 +1689,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
>  /*
>   * Body of kthread that handles grace periods.
>   */
> -static int __noreturn rcu_gp_kthread(void *arg)
> +static int rcu_gp_kthread(void *arg)
>  {
>  	int fqs_state;
>  	int gf;
> @@ -1777,6 +1777,9 @@ static int __noreturn rcu_gp_kthread(void *arg)
>  		/* Handle grace-period end. */
>  		rcu_gp_cleanup(rsp);
>  	}
> +
> +	unreachable();
> +	return 0;
>  }
>  
>  /*
> -- 
> 1.9.1
> 
