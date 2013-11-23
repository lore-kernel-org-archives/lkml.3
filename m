Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3KWWlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 17:41:19 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:33566 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab3KWWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 17:41:17 -0500
Date: Sat, 23 Nov 2013 23:41:16 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Kamala R <kamala@aristanetworks.com>
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] IPv6: Fixed support for blackhole and prohibit routes
Message-ID: <20131123224116.GH15822@order.stressinduktion.org>
Mail-Followup-To: Kamala R <kamala@aristanetworks.com>,
	netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
References: <1385108488-32163-1-git-send-email-kamala@aristanetwors.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385108488-32163-1-git-send-email-kamala@aristanetwors.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 01:51:28PM +0530, Kamala R wrote:
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index f54e3a1..d90b9ab 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -1564,21 +1564,24 @@ int ip6_route_add(struct fib6_config *cfg)
>  				goto out;
>  			}
>  		}
> -		rt->dst.output = ip6_pkt_discard_out;
> -		rt->dst.input = ip6_pkt_discard;
>  		rt->rt6i_flags = RTF_REJECT|RTF_NONEXTHOP;
> +		rt->dst.error = -ENETUNREACH;
>  		switch (cfg->fc_type) {
>  		case RTN_BLACKHOLE:
>  			rt->dst.error = -EINVAL;
> +			rt->dst.output = dst_discard;
> +			rt->dst.input = dst_discard;
>  			break;
>  		case RTN_PROHIBIT:
>  			rt->dst.error = -EACCES;
> +			rt->dst.output = ip6_pkt_prohibit_out;
> +			rt->dst.input = ip6_pkt_prohibit;
>  			break;
>  		case RTN_THROW:
>  			rt->dst.error = -EAGAIN;
> -			break;
>  		default:
> -			rt->dst.error = -ENETUNREACH;
> +			rt->dst.output = ip6_pkt_discard_out;
> +			rt->dst.input = ip6_pkt_discard;
>  			break;
>  		}
>  		goto install_route;

I like it more if a variable is only assigned once. Otherwise it is fine by
me. 

