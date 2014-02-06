Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbaBFUYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:24:35 -0500
Received: from smtprelay0168.hostedemail.com ([216.40.44.168]:47940 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751296AbaBFUYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:24:33 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:560:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2195:2198:2199:2200:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3874:4250:4321:5007:6119:7652:7903:8660:10004:10400:10848:11026:11232:11233:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13148:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: vest63_277830004af60
X-Filterd-Recvd-Size: 2515
Message-ID: <1391718270.15777.20.camel@joe-AO722>
Subject: Re: [PATCH] net: use __GFP_NORETRY for high order allocations
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 06 Feb 2014 12:24:30 -0800
In-Reply-To: <1391712162.10160.8.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1391712162.10160.8.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 10:42 -0800, Eric Dumazet wrote:
> sock_alloc_send_pskb() & sk_page_frag_refill()
> have a loop trying high order allocations to prepare
> skb with low number of fragments as this increases performance.
> 
> Problem is that under memory pressure/fragmentation, this can
> trigger OOM while the intent was only to try the high order
> allocations, then fallback to order-0 allocations.
[]
> Call Trace:
>  [<ffffffff8043766c>] dump_header+0xe1/0x23e
>  [<ffffffff80437a02>] oom_kill_process+0x6a/0x323
>  [<ffffffff80438443>] out_of_memory+0x4b3/0x50d
>  [<ffffffff8043a4a6>] __alloc_pages_may_oom+0xa2/0xc7
>  [<ffffffff80236f42>] __alloc_pages_nodemask+0x1002/0x17f0
>  [<ffffffff8024bd23>] alloc_pages_current+0x103/0x2b0
>  [<ffffffff8028567f>] sk_page_frag_refill+0x8f/0x160
[]
> diff --git a/net/core/sock.c b/net/core/sock.c
[]
> @@ -1775,7 +1775,9 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
>  			while (order) {
>  				if (npages >= 1 << order) {
>  					page = alloc_pages(sk->sk_allocation |
> -							   __GFP_COMP | __GFP_NOWARN,
> +							   __GFP_COMP |
> +							   __GFP_NOWARN |
> +							   __GFP_NORETRY,
>  							   order);
>  					if (page)
>  						goto fill_page;
> @@ -1845,7 +1847,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t prio)
>  		gfp_t gfp = prio;
>  
>  		if (order)
> -			gfp |= __GFP_COMP | __GFP_NOWARN;
> +			gfp |= __GFP_COMP | __GFP_NOWARN | __GFP_NORETRY;

Perhaps add __GFP_THISNODE too ?


