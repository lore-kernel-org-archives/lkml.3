Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaKEJbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:31:44 -0500
Received: from ja.ssi.bg ([178.16.129.10]:47210 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751198AbaKEJbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:31:40 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2014 04:31:40 EST
Date: Wed, 5 Nov 2014 11:21:13 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Calvin Owens <calvinowens@fb.com>
cc: Simon Horman <horms@verge.net.au>, Wensong Zhang <wensong@linux-vs.org>,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, agartrell@fb.com, kernel-team@fb.com
Subject: Re: [PATCH] ipvs: Keep skb->sk when allocating headroom on tunnel
 xmit
In-Reply-To: <1415147860-11389-1-git-send-email-calvinowens@fb.com>
Message-ID: <alpine.LFD.2.11.1411051048540.1631@ja.home.ssi.bg>
References: <1415147860-11389-1-git-send-email-calvinowens@fb.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Tue, 4 Nov 2014, Calvin Owens wrote:

> ip_vs_prepare_tunneled_skb() ignores ->sk when allocating a new
> skb, either unconditionally setting ->sk to NULL or allowing
> the uninitialized ->sk from a newly allocated skb to leak through
> to the caller.
> 
> This patch properly copies ->sk and increments its reference count.
> 
> Signed-off-by: Calvin Owens <calvinowens@fb.com>

	Good catch. Please, extend your patch to
fix also the second place that has such error,
ip_vs_tunnel_xmit_v6. This call is missing from long time,
it was not needed. But commits that allow skb->sk (local
clients) already need it, eg.

- f2428ed5e7bc89c7 ("ipvs: load balance ipv6 connections from a local
process"), 2.6.28
- 4856c84c1358b798 ("ipvs: load balance IPv4 connections from a local 
process"), 2.6.28

> ---
>  net/netfilter/ipvs/ip_vs_xmit.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index 437a366..bd90bf8 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -846,6 +846,8 @@ ip_vs_prepare_tunneled_skb(struct sk_buff *skb, int skb_af,
>  		new_skb = skb_realloc_headroom(skb, max_headroom);
>  		if (!new_skb)
>  			goto error;
> +		if (skb->sk)
> +			skb_set_owner_w(new_skb, skb->sk);
>  		consume_skb(skb);
>  		skb = new_skb;
>  	}

Regards

--
Julian Anastasov <ja@ssi.bg>
