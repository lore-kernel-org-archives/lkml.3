Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbaGHWMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:12:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54624 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbaGHWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:12:12 -0400
Date: Tue, 08 Jul 2014 15:12:10 -0700 (PDT)
Message-Id: <20140708.151210.1879376103263511218.davem@davemloft.net>
To: ixaphire@qrator.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip_tunnel: fix ip_tunnel_lookup
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140705022637.73152ff57309c468c1fdb563@qrator.net>
References: <20140705022637.73152ff57309c468c1fdb563@qrator.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 15:12:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <ixaphire@qrator.net>
Date: Sat, 5 Jul 2014 02:26:37 +0400

> @@ -205,6 +207,8 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
>  
>  	hlist_for_each_entry_rcu(t, head, hash_node) {
>  		if (t->parms.i_key != key ||
> +		    t->parms.iph.saddr != 0 ||
> +		    t->parms.iph.daddr != 0 ||
>  		    !(t->dev->flags & IFF_UP))
>  			continue;
>  

I don't really understand the logic of these tests.

Usually the canonical way to test these kinds of things is:

	if (parms->saddr && parms->saddr != saddr)
		goto no_match;

But you are signalling a non-match any time the address is not a
wildcard.

Why?
