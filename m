Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab3DZGPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:15:40 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37233 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3DZGPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:15:38 -0400
Date: Fri, 26 Apr 2013 08:15:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Simon Horman <horms@verge.net.au>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ipvs: Use cond_resched_rcu_lock() helper when
 dumping connections
Message-ID: <20130426061534.GB25912@gmail.com>
References: <1366940708-10180-1-git-send-email-horms@verge.net.au>
 <1366940708-10180-3-git-send-email-horms@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366940708-10180-3-git-send-email-horms@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Horman <horms@verge.net.au> wrote:

> This avoids the situation where a dump of a large number of connections
> may prevent scheduling for a long time while also avoiding excessive
> calls to rcu_read_unlock() and rcu_read_lock().
> 
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: Simon Horman <horms@verge.net.au>
> ---
>  net/netfilter/ipvs/ip_vs_conn.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index a083bda..42a7b33 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -975,8 +975,7 @@ static void *ip_vs_conn_array(struct seq_file *seq, loff_t pos)
>  				return cp;
>  			}
>  		}
> -		rcu_read_unlock();
> -		rcu_read_lock();
> +		cond_resched_rcu_lock();
>  	}
>  
>  	return NULL;
> @@ -1015,8 +1014,7 @@ static void *ip_vs_conn_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>  			iter->l = &ip_vs_conn_tab[idx];
>  			return cp;
>  		}
> -		rcu_read_unlock();
> -		rcu_read_lock();
> +		cond_resched_rcu_lock();

Feel free to route this via the networking tree.

Note that this change isn't a pure clean-up but has functional effects as 
well: on !PREEMPT or PREEMPT_VOLUNTARY kernels it will add in a potential 
cond_resched() - while previously it would only rcu unlock and relock 
(which in itself isn't scheduling).

This should probably be pointed out in the changelog.

Thanks,

	Ingo
