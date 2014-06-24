Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaFXHQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:16:04 -0400
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:55773 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752166AbaFXHQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:16:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2899:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4362:5007:7652:7875:7903:7904:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12438:12517:12519:12679:12740:13019:13161:13229:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: kiss82_1748502398031
X-Filterd-Recvd-Size: 3327
Message-ID: <1403594158.29061.10.camel@joe-AO725>
Subject: Re: [PATCH 00/22] Add and use pci_zalloc_consistent
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Julian Calaby <julian.calaby@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jun 2014 00:15:58 -0700
In-Reply-To: <alpine.DEB.2.10.1406240714220.2659@hadrien>
References: <cover.1403530604.git.joe@perches.com>
	 <20140623172512.GA1390@garbanzo.do-not-panic.com>
	 <1403550809.15811.13.camel@joe-AO725>
	 <CAGRGNgVD2f0S-v8YZ-qABEhDJAwk5pp71FU9uLR8aSZ+DhABjg@mail.gmail.com>
	 <1403567322.20657.14.camel@joe-AO725>
	 <alpine.DEB.2.10.1406240714220.2659@hadrien>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 07:24 +0200, Julia Lawall wrote
> On Mon, 23 Jun 2014, Joe Perches wrote:
> > > > $ cat ./scripts/coccinelle/api/alloc/pci_zalloc_consistent.cocci
> > > > ///
> > > > /// Use pci_zalloc_consistent rather than
> > > > ///     pci_alloc_consistent followed by memset with 0
> > > > ///
> > > > /// This considers some simple cases that are common and easy to validate
> > > > /// Note in particular that there are no ...s in the rule, so all of the
> > > > /// matched code has to be contiguous
> > > > ///
> > > > /// Blatantly cribbed from: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> > > >
> > > > @@
> > > > type T, T2;
> > > > expression x;
> > > > expression E1,E2,E3;
> > > > statement S;
> > > > @@
> > > >
> > > > - x = (T)pci_alloc_consistent(E1,E2,E3);
> > > > + x = pci_zalloc_consistent(E1,E2,E3);
> > > >   if ((x==NULL) || ...) S
> > > > - memset((T2)x,0,E2);
> > >
> > > I don't know much about SmPL, but wouldn't having that if statement
> > > there reduce your matches?
> >
> > No, not really.
> >
> > Almost none of the pci_alloc_consistent calls
> > do not have a test for failure immediately after
> > them.

> Do not or do?

Sorry, English double negative.

As far as I know, almost every instance of pci_alloc_consistent
is followed by an if.

Exceptions exist in:

drivers/isdn/hardware/eicon/divasmain.c 
drivers/staging/slicoss/slicoss.c
drivers/tty/synclink_gt.c

There might be others, but I didn't look too hard.

> The advantage of the if is that you are sure that nothing strange happens
> to x between alloc and memset.  But a problem can be that sometimes people
> allocate two things, and then do error checking for both of them.  Then
> you rule would not match.  Or the set the return variable to an error code
> before doing the check rather than in the if branch.
> 
> You could put the following between the malloc and the memset in stead of
> the if.
> 
> ... when != ( f(...,x,...) | <+...x...+> = E3 )
>     when != ( while(...) S | for(...;...;...) S )
> 
> This has given reasonable results for kmalloc and memset.

Thanks for that.

It might be nice to add that to the kzalloc example
in scripts/coccinelle



