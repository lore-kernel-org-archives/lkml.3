Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbaFRFph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:45:37 -0400
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:58286 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753026AbaFRFpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:45:36 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:965:966:967:968:973:981:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2525:2538:2553:2560:2563:2682:2685:2692:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4385:4390:4395:5007:6119:7652:7875:7903:7904:8660:9025:9108:10004:10848:11026:11232:11658:11914:12043:12438:12517:12519:12663:12740:13095:13148:13230:14096:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toys39_30ad592999c15
X-Filterd-Recvd-Size: 5200
Message-ID: <1403070332.2649.10.camel@joe-AO725>
Subject: Re: [PATCH 1/1] scripts/coccinelle/free: add conditional kfree test
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Jesper Juhl <jj@chaosbits.net>, Fabian Frederick <fabf@skynet.be>,
        linux-kernel@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>
Date: Tue, 17 Jun 2014 22:45:32 -0700
In-Reply-To: <alpine.DEB.2.02.1406180711210.2059@localhost6.localdomain6>
References: <1403034199-9824-1-git-send-email-fabf@skynet.be>
	 <1403035539.2722.3.camel@joe-AO725>
	 <alpine.DEB.2.02.1406172331001.2055@localhost6.localdomain6>
	 <1403042299.2649.3.camel@joe-AO725>
	 <alpine.DEB.2.02.1406180711210.2059@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 07:25 +0200, Julia Lawall wrote:
> 
> On Tue, 17 Jun 2014, Joe Perches wrote:
> 
> > (adding Jesper Juhl)
> > 
> > On Tue, 2014-06-17 at 23:33 +0200, Julia Lawall wrote:
> > > On Tue, 17 Jun 2014, Joe Perches wrote:
> > > > On Tue, 2014-06-17 at 21:43 +0200, Fabian Frederick wrote:
> > > > > This patch adds a trivial script warning on
> > > > > 
> > > > > if(foo)
> > > > > 	kfree(foo)
> > > > > 
> > > > > (based on checkpatch)
> > > > []
> > > > > diff --git a/scripts/coccinelle/free/cond_kfree.cocci b/scripts/coccinelle/free/cond_kfree.cocci
> > > > []
> > > > > +* if (E)
> > > > > +*	kfree@p(E);
> > > > 
> > > > You should probably add all of the unnecessary
> > > > conditional tests that checkpatch uses:
> > > > 
> > > > kfree
> > > > usb_free_urb
> > > > debugfs_remove
> > > > debugfs_remove_recursive
> > > 
> > > Personally, I would prefer that the message encourage the user to consider 
> > > whether it is necessary to call these functions with NULL as an argument 
> > > in any case.
> > 
> > Jesper quite awhile ago wrote:
> > 
> > https://lkml.org/lkml/2005/10/13/81
> > 
> > - Since kfree always checks for a NULL argument there's no reason to have an
> > additional check prior to calling kfree. It's redundant.
> > - In many cases gcc produce significantly smaller code without the redundant
> > check before the call.
> > - It's been shown in the past (in discussions on LKML) that it's generally a
> > win performance wise to avoid the extra NULL check even though it might save
> > a function call. Only when the NULL check avoids the function call in the vast
> > majority of cases and the code is in a hot path does it make sense to have it.
> > - This patch removes quite a few more source lines than it adds, cutting down
> > on the overall number of source lines is generally a good thing.
> > - This patch reduces the indentation level, which is nice when the kfree call
> > is inside some deeply nested construct.
> 
> What I don't like is:
> 
> a = kmalloc(...);
> if (!a) goto out;
> b = kmalloc(...);
> if (!b) goto out;
> c = kmalloc(...);
> if (!c) goto out;
> ...
> out:
>   kfree(a);
>   kfree(b);
>   kfree(c);
> 
> With a little thought, one could reorganize the code to not call kfree on 
> a null value.

And I think most kernel malloc failures are written like:

	a = kmalloc(...);
	if (!a) goto out1;
	b = kmalloc(...);
	if (!b) goto out2;
	c = kmalloc(...)
	if (!c) goto out3;
...
out3:	kfree(b);
out2:	kfree(a);
out1:	...

>   Someone who is not familiar with Linux programming style 
> could interpret the feedback as that the above code is perfectly fine.  
> (And perhaps some people do consider that it is perfectly fine).

maybe so.

> On the other hand, in the case:
> 
> x = NULL;
> if (complicated_condition)
>   x = kmalloc(...);
>   if (!x) return;
> y = something(...);
> if (!y)
>   goto out1;
> ...
> out1: kfree(x);
> 
> I guess it's OK.  Mildly unpleasant, but probably the best option given 
> the various tradeoff.
> 
> In looking at Jesper's patch, I see that another case is:
> 
> a = kmalloc(...);
> b = kmalloc(...);
> if (!a || !b) {
>   kfree(a);
>   kfree(b);
> }
> 
> Personally, I would rather see each call have its own error handling code.  
> There is no point to make the second call if the first one fails.
> 
> When one tries to understand code, the main questions are why is this done 
> here, and why is this not done here.  Doing things that are unnecessary 
> introduces confusion in this regard.  Perhaps it doesn't matter for 
> kmalloc and kfree because everyone is familiar with them and they are 
> pretty innocuous.  But for the more obscure functions, like in my 
> recollection of Markus's patch, I'm not convinced that simply blindly 
> removing all unneeded tests without thinking whether the code could be 
> written in a better way is a good idea.

Blindly applying patches, even those produced by coccinelle,
let alone mine, is rarely good practice.


