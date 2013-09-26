Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab3IZFZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:25:29 -0400
Received: from ja.ssi.bg ([178.16.129.10]:48533 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750795Ab3IZFZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:25:27 -0400
Date: Thu, 26 Sep 2013 08:30:14 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Alexander Frolkin <avf@eldamar.org.uk>
cc: Simon Horman <horms@verge.net.au>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        lvs-devel@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: improved SH fallback strategy
In-Reply-To: <20130925092638.GD19768@eldamar.org.uk>
Message-ID: <alpine.LFD.2.00.1309260817290.1640@ja.ssi.bg>
References: <20130923115139.GA15034@eldamar.org.uk> <524099BA.5020303@cogentembedded.com> <20130924093238.GD18494@eldamar.org.uk> <20130925003033.GG26081@verge.net.au> <20130925092638.GD19768@eldamar.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Wed, 25 Sep 2013, Alexander Frolkin wrote:

> Improve the SH fallback realserver selection strategy.
> 
> With sh and sh-fallback, if a realserver is down, this attempts to
> distribute the traffic that would have gone to that server evenly
> among the remaining servers.
>  
> Signed-off-by: Alexander Frolkin <avf@eldamar.org.uk>
> 
> --
> diff --git a/net/netfilter/ipvs/ip_vs_sh.c b/net/netfilter/ipvs/ip_vs_sh.c
> index 3588fae..3d5ab7c 100644
> --- a/net/netfilter/ipvs/ip_vs_sh.c
> +++ b/net/netfilter/ipvs/ip_vs_sh.c
> @@ -115,27 +115,47 @@ ip_vs_sh_get(struct ip_vs_service *svc, struct ip_vs_sh_state *s,
>  }
>  
>  
> -/* As ip_vs_sh_get, but with fallback if selected server is unavailable */
> +/* As ip_vs_sh_get, but with fallback if selected server is unavailable
> + *
> + * The fallback strategy loops around the table starting from a "random"
> + * point (in fact, it is chosen to be the original hash value to make the
> + * algorithm deterministic) to find a new server.
> + */
>  static inline struct ip_vs_dest *
>  ip_vs_sh_get_fallback(struct ip_vs_service *svc, struct ip_vs_sh_state *s,
>  		      const union nf_inet_addr *addr, __be16 port)
>  {
> -	unsigned int offset;
> -	unsigned int hash;
> +	unsigned int offset, roffset;
> +	unsigned int hash, ihash;
>  	struct ip_vs_dest *dest;
>  
> -	for (offset = 0; offset < IP_VS_SH_TAB_SIZE; offset++) {
> -		hash = ip_vs_sh_hashkey(svc->af, addr, port, offset);
> -		dest = rcu_dereference(s->buckets[hash].dest);
> -		if (!dest)
> -			break;
> -		if (is_unavailable(dest))
> -			IP_VS_DBG_BUF(6, "SH: selected unavailable server "
> -				      "%s:%d (offset %d)",
> +	/* first try the dest it's supposed to go to */
> +	ihash = ip_vs_sh_hashkey(svc->af, addr, port, 0);
> +	dest = rcu_dereference(s->buckets[ihash].dest);
> +	if (!dest)
> +		return NULL;

	Can we reduce the indentation here, eg:

	if (!is_unavailable(dest))
		return dest;
	IP_VS_DBG_BUF(6, "SH: selected unavailable server "
	...
	for ()...
	...
	return NULL;

> +	if (is_unavailable(dest)) {
> +		IP_VS_DBG_BUF(6, "SH: selected unavailable server "
> +		      "%s:%d, reselecting",
> +		      IP_VS_DBG_ADDR(svc->af, &dest->addr),
> +		      ntohs(dest->port));
> +		/* if the original dest is unavailable, loop around the table
> +		 * starting from ihash to find a new dest
> +		 */
> +		for (offset = 0; offset < IP_VS_SH_TAB_SIZE; offset++) {
> +			roffset = (offset + ihash) % IP_VS_SH_TAB_SIZE;
> +			hash = ip_vs_sh_hashkey(svc->af, addr, port, roffset);
> +			dest = rcu_dereference(s->buckets[hash].dest);

	Every result of rcu_dereference should be checked
for NULL (no dests anymore):
			if (!dest)
				break;

	Then make sure there is correct indentation
for IP_VS_DBG_BUF parameters.

> +			if (is_unavailable(dest))
> +				IP_VS_DBG_BUF(6, "SH: selected unavailable "
> +				      "server %s:%d (offset %d), reselecting",
>  				      IP_VS_DBG_ADDR(svc->af, &dest->addr),
> -				      ntohs(dest->port), offset);
> -		else
> -			return dest;
> +				      ntohs(dest->port), roffset);
> +			else
> +				return dest;
> +		}
> +	} else {
> +		return dest;
>  	}
>  
>  	return NULL;

Regards

--
Julian Anastasov <ja@ssi.bg>
