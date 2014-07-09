Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaGIAsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 20:48:06 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43667 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaGIAsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 20:48:04 -0400
Date: Wed, 9 Jul 2014 04:47:59 +0400
From: Dmitry Popov <ixaphire@qrator.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip_tunnel: fix ip_tunnel_lookup
Message-Id: <20140709044759.009fdce94cf1fb2d872a4a4f@qrator.net>
In-Reply-To: <20140708.151210.1879376103263511218.davem@davemloft.net>
References: <20140705022637.73152ff57309c468c1fdb563@qrator.net>
	<20140708.151210.1879376103263511218.davem@davemloft.net>
X-Mailer: Sylpheed 3.4.2 (GTK+ 2.24.24; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jul 2014 15:12:10 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Dmitry Popov <ixaphire@qrator.net>
> Date: Sat, 5 Jul 2014 02:26:37 +0400
> 
> > @@ -205,6 +207,8 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
> >  
> >  	hlist_for_each_entry_rcu(t, head, hash_node) {
> >  		if (t->parms.i_key != key ||
> > +		    t->parms.iph.saddr != 0 ||
> > +		    t->parms.iph.daddr != 0 ||
> >  		    !(t->dev->flags & IFF_UP))
> >  			continue;
> >  
> 
> I don't really understand the logic of these tests.
> 
> Usually the canonical way to test these kinds of things is:
> 
> 	if (parms->saddr && parms->saddr != saddr)
> 		goto no_match;
> 
> But you are signalling a non-match any time the address is not a
> wildcard.
> 
> Why?

Because that's exactly what I want: to skip any non-wildcard tunnels.

How I see ip_tunnel_lookup logic:
1) try to find exact match (and if found return this tunnel):
tunnel.saddr == iph.daddr && tunnel.daddr == iph.saddr && key_matched()
2) try to find matched (local) wildcard tunnel:
tunnel.saddr == any && tunnel.daddr == iph.saddr && key_matched()
3) try to find matched (remote) wildcard tunnel:
tunnel.saddr == iph.daddr && tunnel.daddr == any && key_matched()
(there is also a test for multicast tunnel, but let's skip it for simplicity)
4) try to find matched (full) wildcard tunnel:
tunnel.saddr == any && tunnel.daddr == any && key_matched()
5) if nothing found return default tunnel.

According to this logic, in 4th loop (the one you quoted) we have to test that
tunnel.daddr == any && tunnel.saddr == any. In my opinion those two new lines
are the best way to achieve it.
