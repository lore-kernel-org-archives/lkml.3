Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbaAHRbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:31:24 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43810 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034AbaAHRbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:31:21 -0500
Message-ID: <1389202287.26646.95.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] netfilter: nf_conntrack: fix RCU race in
 nf_conntrack_find_get
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Andrey Vagin <avagin@openvz.org>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, vvs@openvz.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Date: Wed, 08 Jan 2014 09:31:27 -0800
In-Reply-To: <20140108140444.GH9894@breakpoint.cc>
References: <1389090711-15843-1-git-send-email-avagin@openvz.org>
	 <1389107305.26646.20.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140107152520.GF9894@breakpoint.cc>
	 <1389188536.26646.84.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140108140444.GH9894@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-08 at 15:04 +0100, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > This will also set up a null-binding when no matching SNAT/DNAT/MASQERUADE
> > > rule existed.
> > > 
> > > The manipulations of the skb->nfct->ext nat area are performed without
> > > a lock.  Concurrent access is supposedly impossible as the conntrack
> > > should not (yet) be in the hash table.
> > > 
> > > The confirmed bit is set right before we insert the conntrack into
> > > the hash table (after we traversed rules, ct is ready to be
> > > 'published').
> > > 
> > > i.e. when the confirmed bit is NOT set we should not be 'seeing' the nf_conn
> > > struct when we perform the lookup, as it should still be sitting on the
> > > 'unconfirmed' list, being invisible to readers.
> > > 
> > > Does that explanation make sense to you?
> > > 
> > > Thanks for looking into this.
> > 
> > Still, this patch adds a loop. And maybe an infinite one if confirmed
> > bit is set from an context that was interrupted by this one.
> 
> Hmm.  There should be at most one retry.
> 
> The confirmed bit should always be set here.

So why are you testing it ?

> If it isn't then this conntrack shouldn't be in the hash table, i.e.
> when we re-try we should find the same conntrack again with the bit set.

Where is this guaranteed ? The invariant is the refcnt being taken.

> 
> Asuming the other cpu git interrupted after setting confirmed
> bit but before inserting it into the hash table, then our re-try
> should not be able find a matching entry.
> 
> Maybe I am missing something, but I don't see how we could (upon
> retry) find the very same entry again with the bit still not set.
> 
> > If you need to test the confirmed bit, then you also need to test it
> > before taking the refcount.
> 
> I don't think that would make sense, because it should always be
> set (inserting conntrack into hash table without confirmed set is
> illegal, and it is never unset again).
> 
> [ when allocating a new conntrack, ct->status is zeroed, which also
>   clears the flag.  This happens just before we set the new objects
>   refcount to 1 ]


I did this RCU conversion, so I think I know what I am talking about.

The entry should not be put into hash table (or refcnt set to 1),
if its not ready. It is that simple.

We need to address this problem without adding an extra test and
possible loop for the lookups.

Whole point of RCU is to make lookups fast, by possibly making the
writers doing all the needed logic.



