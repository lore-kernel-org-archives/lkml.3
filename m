Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaFXFYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 01:24:53 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:37751 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbaFXFYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 01:24:52 -0400
X-IronPort-AV: E=Sophos;i="5.01,535,1400018400"; 
   d="scan'208";a="81731191"
Date: Tue, 24 Jun 2014 07:24:43 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Joe Perches <joe@perches.com>
cc: Julian Calaby <julian.calaby@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/22] Add and use pci_zalloc_consistent
In-Reply-To: <1403567322.20657.14.camel@joe-AO725>
Message-ID: <alpine.DEB.2.10.1406240714220.2659@hadrien>
References: <cover.1403530604.git.joe@perches.com>  <20140623172512.GA1390@garbanzo.do-not-panic.com>  <1403550809.15811.13.camel@joe-AO725>  <CAGRGNgVD2f0S-v8YZ-qABEhDJAwk5pp71FU9uLR8aSZ+DhABjg@mail.gmail.com> <1403567322.20657.14.camel@joe-AO725>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jun 2014, Joe Perches wrote:

> (Adding Julia Lawall and removing almost all other cc's)
>
> On Tue, 2014-06-24 at 09:27 +1000, Julian Calaby wrote:
> > Hi Joe,
>
> Hello Julian.
>
> > > $ cat ./scripts/coccinelle/api/alloc/pci_zalloc_consistent.cocci
> > > ///
> > > /// Use pci_zalloc_consistent rather than
> > > ///     pci_alloc_consistent followed by memset with 0
> > > ///
> > > /// This considers some simple cases that are common and easy to validate
> > > /// Note in particular that there are no ...s in the rule, so all of the
> > > /// matched code has to be contiguous
> > > ///
> > > /// Blatantly cribbed from: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> > >
> > > @@
> > > type T, T2;
> > > expression x;
> > > expression E1,E2,E3;
> > > statement S;
> > > @@
> > >
> > > - x = (T)pci_alloc_consistent(E1,E2,E3);
> > > + x = pci_zalloc_consistent(E1,E2,E3);
> > >   if ((x==NULL) || ...) S
> > > - memset((T2)x,0,E2);
> >
> > I don't know much about SmPL, but wouldn't having that if statement
> > there reduce your matches?
>
> No, not really.
>
> Almost none of the pci_alloc_consistent calls
> do not have a test for failure immediately after
> them.

Do not or do?

The advantage of the if is that you are sure that nothing strange happens
to x between alloc and memset.  But a problem can be that sometimes people
allocate two things, and then do error checking for both of them.  Then
you rule would not match.  Or the set the return variable to an error code
before doing the check rather than in the if branch.

You could put the following between the malloc and the memset in stead of
the if.

... when != ( f(...,x,...) | <+...x...+> = E3 )
    when != ( while(...) S | for(...;...;...) S )

This has given reasonable results for kmalloc and memset.

julia

> Coccinelle is a very cool code transformation tool,
> quite useful for these sorts of patch conversions.
>
> http://coccinelle.lip6.fr/documentation.php
>
>
>
