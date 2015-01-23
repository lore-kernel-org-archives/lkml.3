Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbbAWEQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 23:16:52 -0500
Received: from nacho.alt.net ([208.90.169.18]:54014 "EHLO nacho.alt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbbAWEQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 23:16:50 -0500
Comment: DKIM? See http://www.dkim.org
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
	s=default; d=alt.net;
	h=Received:Received:Received:Date:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type:X-Delivery-Agent:From:Reply-To;
	b=k4S92Bn9AKQPL7SyRMXnEQM61ErduQueDKPprS6eV/FXj62mqPhRkEvoPMtvxN
	GI5e8QliRXdC3E9ASy5ihXQ/yedzT4V6i6byx0DQXBoWuHfWa6e9LsoBZhGEgdjf
	kY2EHgZQ4GGYlRR0r4mJ9AoTv9hL9chRNWgT4g7zX3X7A=;
Date: Fri, 23 Jan 2015 04:16:47 +0000 (UTC)
To: Julian Anastasov <ja@ssi.bg>
cc: Wensong Zhang <wensong@linux-vs.org>, Simon Horman <horms@verge.net.au>,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] IPVS: add wlib & wlip schedulers
In-Reply-To: <alpine.LFD.2.11.1501222308060.2572@ja.home.ssi.bg>
Message-ID: <Pine.LNX.4.64.1501230410450.8217@nacho.alt.net>
References: <Pine.LNX.4.44.0501260832210.17893-100000@nacho.alt.net>
	<Pine.LNX.4.61.0502010007060.1148@penguin.linux-vs.org>
	<Pine.LNX.4.64.1501172217420.8217@nacho.alt.net>
	<alpine.LFD.2.11.1501192342190.2687@ja.home.ssi.bg>
	<Pine.LNX.4.64.1501200137310.8217@nacho.alt.net>
	<alpine.LFD.2.11.1501222308060.2572@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Delivery-Agent: TMDA/1.1.12 (Macallan)
From: Chris Caputo <ccaputo@alt.net>
Reply-To: Chris Caputo <ccaputo-dated-1432354608.8cc3cb@alt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Julian Anastasov wrote:
> 	Hello,
> 
> On Tue, 20 Jan 2015, Chris Caputo wrote:
> > My application consists of incoming TCP streams being load balanced to 
> > servers which receive the feeds. These are long lived multi-gigabyte 
> > streams, and so I believe the estimator's 2-second timer is fine. As an 
> > example:
> > 
> > # cat /proc/net/ip_vs_stats
> >    Total Incoming Outgoing         Incoming         Outgoing
> >    Conns  Packets  Packets            Bytes            Bytes
> >      9AB  58B7C17        0      1237CA2C325                0
> > 
> >  Conns/s   Pkts/s   Pkts/s          Bytes/s          Bytes/s
> >        1     387C        0          B16C4AE                0
> 
> 	All other schedulers react and see different
> picture after every new connection. The worst example
> is WLC where slow-start mechanism is desired because
> idle server can be overloaded before the load is noticed
> properly. Even WRR accounts every connection in its state.
> 
> 	Your setup may expect low number of connections per
> second but for other kind of setups sending all connections
> to same server for 2 seconds looks scary. In fact, what
> changes is the position, so we rotate only among the
> least loaded servers that look equally loaded but it is
> one server in the common case. And as our stats are per
> CPU and designed for human reading, it is difficult to
> read them often for other purposes. We need a good idea
> to solve this problem, so that we can have faster feedback
> after every scheduling.

This is exactly why my wlib/wlip code is a hybrid of wlc and rr.  Last 
location is saved, and search is started after it.  Thus when traffic is 
zero, round-robin occurs.  When flows already exist, bursts of new 
connections do choose poorly based on repeated use of last estimation, but 
the complexity of working around that seems complex.

> > > 	May be not so useful idea: use sum of both directions
> > > or control it with svc->flags & IP_VS_SVC_F_SCHED_WLIB_xxx
> > > flags, see how "sh" scheduler supports flags. I.e.
> > > inbps + outbps.
> > 
> > I see a user-mode option as increasing complexity. For example, 
> > keepalived users would need to have keepalived patched to support the new 
> > algorithm, due to flags, rather than just configuring "wlib" or "wlip" and 
> > it just working.
> 
> 	That is also true.
> 
> > I think I'd rather see a wlob/wlop version for users that want to 
> > load-balance based on outgoing bytes/packets, and a wlb/wlp version for 
> > users that want them summed.
> 
> 	ok
> 
> > From: Chris Caputo <ccaputo@alt.net> 
> > 
> > IPVS: Change inbps and outbps to 64-bits so that estimator handles faster
> > flows. Also increases maximum viewable at user level from ~2.15Gbits/s to
> > ~34.35Gbits/s.
> 
> 	Yep, we are limited from u32 in user space structs.
> I have to think how to solve this problem.
> 
> 1gbit => ~1.5 million pps
> 10gbit => ~15 million pps
> 100gbit => ~150 million pps
> 
> > Signed-off-by: Chris Caputo <ccaputo@alt.net>
> > ---
> > diff -uprN linux-3.19-rc5-stock/include/net/ip_vs.h linux-3.19-rc5/include/net/ip_vs.h
> > --- linux-3.19-rc5-stock/include/net/ip_vs.h	2015-01-18 06:02:20.000000000 +0000
> > +++ linux-3.19-rc5/include/net/ip_vs.h	2015-01-20 08:01:15.548177969 +0000
> > @@ -390,8 +390,8 @@ struct ip_vs_estimator {
> >  	u32			cps;
> >  	u32			inpps;
> >  	u32			outpps;
> > -	u32			inbps;
> > -	u32			outbps;
> > +	u64			inbps;
> > +	u64			outbps;
> 
> 	Not sure, may be everything here should be u64 because
> we have shifted values. I'll need some days to investigate
> this issue...
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>

Sounds good and thanks!

Chris
