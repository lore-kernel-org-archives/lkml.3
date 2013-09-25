Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab3IYAan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:30:43 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60806 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab3IYAai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:30:38 -0400
Date: Wed, 25 Sep 2013 09:30:33 +0900
From: Simon Horman <horms@verge.net.au>
To: Alexander Frolkin <avf@eldamar.org.uk>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: improved SH fallback strategy
Message-ID: <20130925003033.GG26081@verge.net.au>
References: <20130923115139.GA15034@eldamar.org.uk>
 <524099BA.5020303@cogentembedded.com>
 <20130924093238.GD18494@eldamar.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924093238.GD18494@eldamar.org.uk>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 10:32:38AM +0100, Alexander Frolkin wrote:
> Improve the SH fallback realserver selection strategy.
>  
> With sh and sh-fallback, if a realserver is down, this attempts to
> distribute the traffic that would have gone to that server evenly
> among the remaining servers.
>  
> Signed-off-by: Alexander Frolkin <avf@eldamar.org.uk>

Hi Alexander,

could you add some comments to the code or at least a description of the
algorithm to the above the function.  The intent of original code may not
have been obvious to the eye but this version certainly isn't obvious to
mine.

> --
> diff --git a/net/netfilter/ipvs/ip_vs_sh.c b/net/netfilter/ipvs/ip_vs_sh.c
> index 3588fae..0db7d01 100644
> --- a/net/netfilter/ipvs/ip_vs_sh.c
> +++ b/net/netfilter/ipvs/ip_vs_sh.c
> @@ -120,22 +120,33 @@ static inline struct ip_vs_dest *
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
> +	ihash = ip_vs_sh_hashkey(svc->af, addr, port, 0);
> +	dest = rcu_dereference(s->buckets[ihash].dest);
> +	if (!dest)
> +		return NULL;
> +	if (is_unavailable(dest)) {
> +		IP_VS_DBG_BUF(6, "SH: selected unavailable server "
> +		      "%s:%d, reselecting",
> +		      IP_VS_DBG_ADDR(svc->af, &dest->addr),
> +		      ntohs(dest->port));
> +		for (offset = 0; offset < IP_VS_SH_TAB_SIZE; offset++) {
> +			roffset = (offset + ihash) % IP_VS_SH_TAB_SIZE;
> +			hash = ip_vs_sh_hashkey(svc->af, addr, port, roffset);
> +			dest = rcu_dereference(s->buckets[hash].dest);
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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe lvs-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
