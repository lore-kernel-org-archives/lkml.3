Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbaLBDJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 22:09:24 -0500
Received: from smtprelay0112.hostedemail.com ([216.40.44.112]:60546 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753557AbaLBDJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 22:09:23 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3871:3872:4321:4605:5007:6261:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12679:12740:13069:13071:13311:13357:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: knife67_6eced03ff5c0f
X-Filterd-Recvd-Size: 2271
Message-ID: <1417489760.4894.8.camel@perches.com>
Subject: Re: [PATCH net-next] udp: Neaten and reduce size of compute_score
 functions
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 01 Dec 2014 19:09:20 -0800
In-Reply-To: <1417489141.4442.24.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1417484341.4894.6.camel@perches.com>
	 <1417489141.4442.24.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 18:59 -0800, Eric Dumazet wrote:
> On Mon, 2014-12-01 at 17:39 -0800, Joe Perches wrote:
> > The compute_score functions are a bit difficult to read.
> > 
> > Neaten them a bit to reduce object sizes and make them a
> > bit more intelligible.
> > 
> > Return early to avoid indentation and avoid unnecessary
> > initializations.
[]
> > +	if (!(net_eq(sock_net(sk), net) &&
> > +	      udp_sk(sk)->udp_port_hash == hnum &&
> > +	      !ipv6_only_sock(sk)))
> > +		return -1
> 
> Or even better :
> 
> 
> 	if (!net_eq(sock_net(sk), net) ||
> 	    udp_sk(sk)->udp_port_hash != hnum ||
> 	    ipv6_only_sock(sk))
> 		return -1;

Hi Eric.

Yeah, I thought about it but thought it
simpler to not change the logic.

Either way is fine with me.

David?

btw: the same thing can be done for the v6 block too:

+       if (!(net_eq(sock_net(sk), net) && !ipv6_only_sock(sk)))
+               return -1;
 
-               if (inet->inet_rcv_saddr != daddr)
+       inet = inet_sk(sk);
+
+       if (inet->inet_rcv_saddr != daddr)
+               return -1;
+       if (inet->inet_num != hnum)
+               return -1;

to:

	if (!net_eq(sock_net(sk, net) ||
	    ipv6_only_sock(sk))
		return -1;

	inet = inet_sk(sk);

	if (inet->inet_rcv_saddr != daddr ||
	    inet->inet_num != hnum)
		return -1;


