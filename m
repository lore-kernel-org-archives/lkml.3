Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab3FGO6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:58:09 -0400
Received: from kanga.kvack.org ([205.233.56.17]:55203 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab3FGO6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:58:07 -0400
Date: Fri, 7 Jun 2013 10:58:06 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Timo =?iso-8859-1?Q?Ter=E4s?= <timo.teras@iki.fi>
Subject: Re: [ 150/184] ipv4: check rt_genid in dst_check
Message-ID: <20130607145806.GR15183@kvack.org>
References: <20130604172136.519104713@1wt.eu> <1370585253.4021.93.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370585253.4021.93.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 07:07:33AM +0100, Ben Hutchings wrote:
> > This commit is based on the above, with the addition of verifying blackhole
> > routes in the same manner.
> 
> That addition doesn't seem to correspond to anything in mainline.  Why
> should 2.6.32 differ?

Fixing the issue with blackhole routes as it was accomplished in mainline 
would require pulling in a lot more code, and people were not interested 
in pulling in all of the dependencies given the much higher risk of trying 
to select the right subset of changes to include.  The addition of the 
single line of "dst->obsolete = -1;" in ipv4_dst_blackhole() was much 
easier to verify, and is in the spirit of the patch in question.  This is 
the minimal set of changes to fix the bug in question.

		-ben

> Ben.
> 
> > Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
> > Signed-off-by: Willy Tarreau <w@1wt.eu>
> > ---
> >  net/ipv4/route.c | 17 ++++++++++++-----
> >  1 file changed, 12 insertions(+), 5 deletions(-)
> > 
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index 58f141b..f16d19b 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -1412,7 +1412,7 @@ void ip_rt_redirect(__be32 old_gw, __be32 daddr, __be32 new_gw,
> >  					dev_hold(rt->u.dst.dev);
> >  				if (rt->idev)
> >  					in_dev_hold(rt->idev);
> > -				rt->u.dst.obsolete	= 0;
> > +				rt->u.dst.obsolete	= -1;
> >  				rt->u.dst.lastuse	= jiffies;
> >  				rt->u.dst.path		= &rt->u.dst;
> >  				rt->u.dst.neighbour	= NULL;
> > @@ -1477,7 +1477,7 @@ static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst)
> >  	struct dst_entry *ret = dst;
> >  
> >  	if (rt) {
> > -		if (dst->obsolete) {
> > +		if (dst->obsolete > 0) {
> >  			ip_rt_put(rt);
> >  			ret = NULL;
> >  		} else if ((rt->rt_flags & RTCF_REDIRECTED) ||
> > @@ -1700,7 +1700,9 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, u32 mtu)
> >  
> >  static struct dst_entry *ipv4_dst_check(struct dst_entry *dst, u32 cookie)
> >  {
> > -	return NULL;
> > +	if (rt_is_expired((struct rtable *)dst))
> > +		return NULL;
> > +	return dst;
> >  }
> >  
> >  static void ipv4_dst_destroy(struct dst_entry *dst)
> > @@ -1862,7 +1864,8 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
> >  	if (!rth)
> >  		goto e_nobufs;
> >  
> > -	rth->u.dst.output= ip_rt_bug;
> > +	rth->u.dst.output = ip_rt_bug;
> > +	rth->u.dst.obsolete = -1;
> >  
> >  	atomic_set(&rth->u.dst.__refcnt, 1);
> >  	rth->u.dst.flags= DST_HOST;
> > @@ -2023,6 +2026,7 @@ static int __mkroute_input(struct sk_buff *skb,
> >  	rth->fl.oif 	= 0;
> >  	rth->rt_spec_dst= spec_dst;
> >  
> > +	rth->u.dst.obsolete = -1;
> >  	rth->u.dst.input = ip_forward;
> >  	rth->u.dst.output = ip_output;
> >  	rth->rt_genid = rt_genid(dev_net(rth->u.dst.dev));
> > @@ -2187,6 +2191,7 @@ local_input:
> >  		goto e_nobufs;
> >  
> >  	rth->u.dst.output= ip_rt_bug;
> > +	rth->u.dst.obsolete = -1;
> >  	rth->rt_genid = rt_genid(net);
> >  
> >  	atomic_set(&rth->u.dst.__refcnt, 1);
> > @@ -2411,7 +2416,8 @@ static int __mkroute_output(struct rtable **result,
> >  	rth->rt_gateway = fl->fl4_dst;
> >  	rth->rt_spec_dst= fl->fl4_src;
> >  
> > -	rth->u.dst.output=ip_output;
> > +	rth->u.dst.output = ip_output;
> > +	rth->u.dst.obsolete = -1;
> >  	rth->rt_genid = rt_genid(dev_net(dev_out));
> >  
> >  	RT_CACHE_STAT_INC(out_slow_tot);
> > @@ -2741,6 +2747,7 @@ static int ipv4_dst_blackhole(struct net *net, struct rtable **rp, struct flowi
> >  	if (rt) {
> >  		struct dst_entry *new = &rt->u.dst;
> >  
> > +		new->obsolete = -1;
> >  		atomic_set(&new->__refcnt, 1);
> >  		new->__use = 1;
> >  		new->input = dst_discard;
> 
> -- 
> Ben Hutchings
> Theory and practice are closer in theory than in practice.
>                                 - John Levine, moderator of comp.compilers



-- 
"Thought is the essence of where you are now."
