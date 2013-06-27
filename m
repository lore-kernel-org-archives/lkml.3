Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3F0Ian (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:30:43 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:32859 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3F0Iag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:30:36 -0400
Message-ID: <1372321835.3301.221.camel@edumazet-glaptop>
Subject: Re: [netlink] WARNING: at mm/vmalloc.c:1487 __vunmap()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Date: Thu, 27 Jun 2013 01:30:35 -0700
In-Reply-To: <20130627082238.GA6346@localhost>
References: <20130614220119.GA12954@localhost>
	 <20130617200938.GA14567@localhost>
	 <1372250558.3301.194.camel@edumazet-glaptop>
	 <20130627082238.GA6346@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 10:22 +0200, Pablo Neira Ayuso wrote:
> Hi Eric,
> 
> Thanks for looking into this.
> 
> On Wed, Jun 26, 2013 at 05:42:38AM -0700, Eric Dumazet wrote:
> [...]
> > Nope there are several issues :
> > 
> > 1) bug in netlink_alloc_large_skb() because it doesn't account
> > for sizeof(struct skb_shared_info) overhead and initialization.
> 
> Indeed, I can send a fix for this.
> 
> > 2) Also, skb_clone() on such skb should be forbidden.
> > 
> >    Example, nl_fib_input() does a nskb = skb_clone(skb)
> >
> > If skb is freed before nskb, then nskb wont know skb->head must be freed
> > by vfree()
> > 
> > I don't know...
> > 
> > 3) Do we really need this vmalloc stuff, because it sounds like we are
> > going to add yet another test in fast path (in skb_free_head())
> 
> We want to send atomic rule-set updates via netlink in one single
> batch message to kernel space. Without vmalloc, I can send up to
> ~20000 rule updates in one single batch.
> 
> We considered splitting the updates in smaller batches to make netlink
> happy, but then a process has to own the rule-set base until it has
> finished the update to avoid any interference. However, a broken
> user-space program may (ab)use such ownership to prevents others from
> updating the rule-set.
> 
> > 4) Or we must track all skb_clone() netlink calls to attach a destructor
> > to properly to the vfree()
> 
> Perhaps we can add a new specific function for this, netlink_skb_clone?
> 

You have also to track the kfree_skb() calls done before
you set skb->destructor.

Or set skb->destructor right after netlink_alloc_large_skb()

> I'll be fine to track skb_clone in existing netlink families and
> replace it by such call in case you don't find this solution too
> hackish.

Let see if you can do that, I'll test and review the patches.

I suggest you use build_skb() as in :

static struct sk_buff *netlink_alloc_large_skb(unsigned int size, bool broadcast)
{
        struct sk_buff *skb;
        void *data;

        if (size <= NLMSG_GOODSIZE || broadcast)
                return alloc_skb(size, GFP_KERNEL);

        size = SKB_DATA_ALIGN(size) +
               SKB_DATA_ALIGN(sizeof(struct skb_shared_info));

        data = vmalloc(size);
        if (!data)
                return NULL;
        skb = build_skb(data, size);
        if (!skb)
                vfree(data);
        else
                skb->head_frag = 0;
        return skb;
}


