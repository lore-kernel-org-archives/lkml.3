Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaKHGRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 01:17:20 -0500
Received: from ja.ssi.bg ([178.16.129.10]:55937 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750811AbaKHGRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 01:17:19 -0500
Date: Sat, 8 Nov 2014 08:16:58 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Calvin Owens <calvinowens@fb.com>
cc: Simon Horman <horms@verge.net.au>, Wensong Zhang <wensong@linux-vs.org>,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, agartrell@fb.com, kernel-team@fb.com
Subject: Re: [PATCH] ipvs: Keep skb->sk when allocating headroom on tunnel
 xmit
In-Reply-To: <545D43BD.8030203@fb.com>
Message-ID: <alpine.LFD.2.11.1411080814300.2081@ja.home.ssi.bg>
References: <1415147860-11389-1-git-send-email-calvinowens@fb.com> <alpine.LFD.2.11.1411051048540.1631@ja.home.ssi.bg> <545D43BD.8030203@fb.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Fri, 7 Nov 2014, Calvin Owens wrote:

> On 11/05/2014 01:21 AM, Julian Anastasov wrote:
> >
> >  Hello,
> >
> > On Tue, 4 Nov 2014, Calvin Owens wrote:
> >
> > > ip_vs_prepare_tunneled_skb() ignores ->sk when allocating a new
> > > skb, either unconditionally setting ->sk to NULL or allowing
> > > the uninitialized ->sk from a newly allocated skb to leak through
> > > to the caller.
> > >
> > > This patch properly copies ->sk and increments its reference count.
> > >
> > > Signed-off-by: Calvin Owens <calvinowens@fb.com>
> >
> > 	Good catch. Please, extend your patch to
> > fix also the second place that has such error,
> > ip_vs_tunnel_xmit_v6. This call is missing from long time,
> > it was not needed. But commits that allow skb->sk (local
> > clients) already need it, eg.
> 
> I'm not sure where exactly you mean: ip_vs_tunnel_xmit_v6() calls
> ip_vs_prepare_tunneled_skb() to do the allocation, so this patch covers that
> case.
> 
> In older versions of the kernel, ip_vs_tunnel_xmit_v6() does it directly,
> could that be what you're looking at?

	Sorry, it seems I was checking old branch.

	Simon, please apply.

Acked-by: Julian Anastasov <ja@ssi.bg>

> > - f2428ed5e7bc89c7 ("ipvs: load balance ipv6 connections from a local
> > process"), 2.6.28
> > - 4856c84c1358b798 ("ipvs: load balance IPv4 connections from a local
> > process"), 2.6.28
> >
> > > ---
> > >   net/netfilter/ipvs/ip_vs_xmit.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > >
> > > diff --git a/net/netfilter/ipvs/ip_vs_xmit.c
> > > b/net/netfilter/ipvs/ip_vs_xmit.c
> > > index 437a366..bd90bf8 100644
> > > --- a/net/netfilter/ipvs/ip_vs_xmit.c
> > > +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> > > @@ -846,6 +846,8 @@ ip_vs_prepare_tunneled_skb(struct sk_buff *skb, int
> > > skb_af,
> > >     new_skb = skb_realloc_headroom(skb, max_headroom);
> > >     if (!new_skb)
> > >   			goto error;
> > > +		if (skb->sk)
> > > +			skb_set_owner_w(new_skb, skb->sk);
> > >     consume_skb(skb);
> > >     skb = new_skb;
> > >    }

Regards

--
Julian Anastasov <ja@ssi.bg>
