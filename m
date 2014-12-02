Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbaLBEoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:44:55 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33877 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaLBEox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:44:53 -0500
Message-ID: <1417495491.5303.11.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next] udp: Neaten and reduce size of compute_score
 functions
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 01 Dec 2014 20:44:51 -0800
In-Reply-To: <1417489760.4894.8.camel@perches.com>
References: <1417484341.4894.6.camel@perches.com>
	 <1417489141.4442.24.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1417489760.4894.8.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 19:09 -0800, Joe Perches wrote:
> On Mon, 2014-12-01 at 18:59 -0800, Eric Dumazet wrote:
> > On Mon, 2014-12-01 at 17:39 -0800, Joe Perches wrote:
> > > The compute_score functions are a bit difficult to read.
> > > 
> > > Neaten them a bit to reduce object sizes and make them a
> > > bit more intelligible.
> > > 
> > > Return early to avoid indentation and avoid unnecessary
> > > initializations.
> []
> > > +	if (!(net_eq(sock_net(sk), net) &&
> > > +	      udp_sk(sk)->udp_port_hash == hnum &&
> > > +	      !ipv6_only_sock(sk)))
> > > +		return -1
> > 
> > Or even better :
> > 
> > 
> > 	if (!net_eq(sock_net(sk), net) ||
> > 	    udp_sk(sk)->udp_port_hash != hnum ||
> > 	    ipv6_only_sock(sk))
> > 		return -1;
> 
> Hi Eric.
> 
> Yeah, I thought about it but thought it
> simpler to not change the logic.
> 
> Either way is fine with me.


Your patch does not change the logic at all.

My suggestion is about avoiding double negates which are really hard to
read. This is simple boolean logic rules.

Code was :

if (a && x == y && !ipv6_only_sock(sk))) {
    EXPR1;
} else {
    return -1;
}

So the 'logical' way of negating the condition is actually to not add
double negations and use :

if (!a || x != y || ipv6_only_sock(sk)))
    return -1;
EXPR1;

Instead of the less readable form :

if (!(a && x == y && !ipv6_only_sock(sk))))
    return -1;
EXPR1;

You do not have to ask David permission for this, really.



