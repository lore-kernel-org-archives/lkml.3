Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaA2TV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:21:57 -0500
Received: from mail.us.es ([193.147.175.20]:44374 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbaA2TVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:21:54 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus3 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18412. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-99.8/7.5):. 
 Processed in 4.288744 secs); 29 Jan 2014 19:21:50 -0000
X-Spam-ASN: AS3209 94.216.0.0/13
X-Envelope-From: pneira@us.es
Date: Wed, 29 Jan 2014 20:21:37 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrey Vagin <avagin@openvz.org>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, vvs@openvz.org,
        Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] netfilter: nf_conntrack: fix RCU race in
 nf_conntrack_find_get (v3)
Message-ID: <20140129192136.GA7151@localhost>
References: <1389188841.26646.87.camel@edumazet-glaptop2.roam.corp.google.com>
 <1389549033-23523-1-git-send-email-avagin@openvz.org>
 <1389558074.31367.187.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389558074.31367.187.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 12:21:14PM -0800, Eric Dumazet wrote:
> On Sun, 2014-01-12 at 21:50 +0400, Andrey Vagin wrote:
> > Lets look at destroy_conntrack:
> > 
> > hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
> > ...
> > nf_conntrack_free(ct)
> > 	kmem_cache_free(net->ct.nf_conntrack_cachep, ct);
> > 
> > net->ct.nf_conntrack_cachep is created with SLAB_DESTROY_BY_RCU.
> > 
> > The hash is protected by rcu, so readers look up conntracks without
> > locks.
> > A conntrack is removed from the hash, but in this moment a few readers
> > still can use the conntrack. Then this conntrack is released and another
> > thread creates conntrack with the same address and the equal tuple.
> > After this a reader starts to validate the conntrack:
> > * It's not dying, because a new conntrack was created
> > * nf_ct_tuple_equal() returns true.
> ...
> 
> 
> > v2: move nf_ct_is_confirmed into the unlikely() annotation
> > v3: Eric suggested to fix refcnt, so that it becomes zero before adding
> >     in a hash, but we can't find a way how to do that. Another way is to
> >     interpret the confirm bit as part of a search key and check it in
> >     ____nf_conntrack_find() too.
> > 
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: Florian Westphal <fw@strlen.de>
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Cc: Patrick McHardy <kaber@trash.net>
> > Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> > Signed-off-by: Andrey Vagin <avagin@openvz.org>
> > ---
> 
> Acked-by: Eric Dumazet <edumazet@google.com>

Applied, thanks everyone!
