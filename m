Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965660AbaFRJCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:02:09 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4644 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964781AbaFRJCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:02:01 -0400
X-IronPort-AV: E=Sophos;i="5.01,499,1400018400"; 
   d="scan'208";a="80704616"
Date: Wed, 18 Jun 2014 11:02:48 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Joe Perches <joe@perches.com>
cc: Jesper Juhl <jj@chaosbits.net>, Fabian Frederick <fabf@skynet.be>,
        linux-kernel@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>
Subject: Re: [PATCH 1/1] scripts/coccinelle/free: add conditional kfree
 test
In-Reply-To: <1403070332.2649.10.camel@joe-AO725>
Message-ID: <alpine.DEB.2.10.1406181100520.2059@hadrien>
References: <1403034199-9824-1-git-send-email-fabf@skynet.be>  <1403035539.2722.3.camel@joe-AO725>  <alpine.DEB.2.02.1406172331001.2055@localhost6.localdomain6>  <1403042299.2649.3.camel@joe-AO725>  <alpine.DEB.2.02.1406180711210.2059@localhost6.localdomain6>
 <1403070332.2649.10.camel@joe-AO725>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2014, Joe Perches wrote:

> On Wed, 2014-06-18 at 07:25 +0200, Julia Lawall wrote:
> >
> > On Tue, 17 Jun 2014, Joe Perches wrote:
> >
> > > (adding Jesper Juhl)
> > >
> > > On Tue, 2014-06-17 at 23:33 +0200, Julia Lawall wrote:
> > > > On Tue, 17 Jun 2014, Joe Perches wrote:
> > > > > On Tue, 2014-06-17 at 21:43 +0200, Fabian Frederick wrote:
> > > > > > This patch adds a trivial script warning on
> > > > > >
> > > > > > if(foo)
> > > > > > 	kfree(foo)
> > > > > >
> > > > > > (based on checkpatch)
> > > > > []
> > > > > > diff --git a/scripts/coccinelle/free/cond_kfree.cocci b/scripts/coccinelle/free/cond_kfree.cocci
> > > > > []
> > > > > > +* if (E)
> > > > > > +*	kfree@p(E);
> > > > >
> > > > > You should probably add all of the unnecessary
> > > > > conditional tests that checkpatch uses:
> > > > >
> > > > > kfree
> > > > > usb_free_urb
> > > > > debugfs_remove
> > > > > debugfs_remove_recursive
> > > >
> > > > Personally, I would prefer that the message encourage the user to consider
> > > > whether it is necessary to call these functions with NULL as an argument
> > > > in any case.
> > >
> > > Jesper quite awhile ago wrote:
> > >
> > > https://lkml.org/lkml/2005/10/13/81
> > >
> > > - Since kfree always checks for a NULL argument there's no reason to have an
> > > additional check prior to calling kfree. It's redundant.
> > > - In many cases gcc produce significantly smaller code without the redundant
> > > check before the call.
> > > - It's been shown in the past (in discussions on LKML) that it's generally a
> > > win performance wise to avoid the extra NULL check even though it might save
> > > a function call. Only when the NULL check avoids the function call in the vast
> > > majority of cases and the code is in a hot path does it make sense to have it.
> > > - This patch removes quite a few more source lines than it adds, cutting down
> > > on the overall number of source lines is generally a good thing.
> > > - This patch reduces the indentation level, which is nice when the kfree call
> > > is inside some deeply nested construct.
> >
> > What I don't like is:
> >
> > a = kmalloc(...);
> > if (!a) goto out;
> > b = kmalloc(...);
> > if (!b) goto out;
> > c = kmalloc(...);
> > if (!c) goto out;
> > ...
> > out:
> >   kfree(a);
> >   kfree(b);
> >   kfree(c);
> >
> > With a little thought, one could reorganize the code to not call kfree on
> > a null value.
>
> And I think most kernel malloc failures are written like:
>
> 	a = kmalloc(...);
> 	if (!a) goto out1;
> 	b = kmalloc(...);
> 	if (!b) goto out2;
> 	c = kmalloc(...)
> 	if (!c) goto out3;
> ...
> out3:	kfree(b);
> out2:	kfree(a);
> out1:	...

This is the case for the good code.  But not necessarily in staging.

> >   Someone who is not familiar with Linux programming style
> > could interpret the feedback as that the above code is perfectly fine.
> > (And perhaps some people do consider that it is perfectly fine).
>
> maybe so.
>
> > On the other hand, in the case:
> >
> > x = NULL;
> > if (complicated_condition)
> >   x = kmalloc(...);
> >   if (!x) return;
> > y = something(...);
> > if (!y)
> >   goto out1;
> > ...
> > out1: kfree(x);
> >
> > I guess it's OK.  Mildly unpleasant, but probably the best option given
> > the various tradeoff.
> >
> > In looking at Jesper's patch, I see that another case is:
> >
> > a = kmalloc(...);
> > b = kmalloc(...);
> > if (!a || !b) {
> >   kfree(a);
> >   kfree(b);
> > }
> >
> > Personally, I would rather see each call have its own error handling code.
> > There is no point to make the second call if the first one fails.
> >
> > When one tries to understand code, the main questions are why is this done
> > here, and why is this not done here.  Doing things that are unnecessary
> > introduces confusion in this regard.  Perhaps it doesn't matter for
> > kmalloc and kfree because everyone is familiar with them and they are
> > pretty innocuous.  But for the more obscure functions, like in my
> > recollection of Markus's patch, I'm not convinced that simply blindly
> > removing all unneeded tests without thinking whether the code could be
> > written in a better way is a good idea.
>
> Blindly applying patches, even those produced by coccinelle,
> let alone mine, is rarely good practice.

Sure.  I would just argue for changing the text associated with the
semantic patch a little bit, to suggest considering whether the code can
be reorganized to eliminate the possibility of passing NULL to these
functions in the first place.

julia
