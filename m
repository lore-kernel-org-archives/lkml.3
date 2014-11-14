Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaKNJTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:19:17 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:18608
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754660AbaKNJTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:19:16 -0500
X-IronPort-AV: E=Sophos;i="5.07,384,1413237600"; 
   d="scan'208";a="88110972"
Date: Fri, 14 Nov 2014 10:18:41 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Joe Perches <joe@perches.com>
cc: cocci <cocci@systeme.lip6.fr>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cocci] spatch for trivial pointer comparison style?
In-Reply-To: <1415945558.5912.10.camel@perches.com>
Message-ID: <alpine.DEB.2.10.1411140938400.2443@hadrien>
References: <1415908529.4223.11.camel@perches.com>  <alpine.DEB.2.02.1411140700010.2035@localhost6.localdomain6> <1415945558.5912.10.camel@perches.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Nov 2014, Joe Perches wrote:

> On Fri, 2014-11-14 at 07:06 +0100, Julia Lawall wrote:
> > On Thu, 13 Nov 2014, Joe Perches wrote:
> >
> > > I added a checkpatch entry for this.
> > > Maybe some cocci test like this would be useful?
> > >
> > > @@
> > > type t;
> > > t *p;
> > > @@
> > > -	p == NULL
> > > +	!p
> > >
> > > @@
> > > type t;
> > > t *p;
> > > @@
> > > -	p != NULL
> > > +	p
> > >
> > > @@
> > > type t;
> > > t *p;
> > > @@
> > > -	NULL == p
> > > +	!p
> > >
> > > @@
> > > type t;
> > > t *p;
> > > @@
> > > -	NULL != p
> > > +	p
> >
> > This was discussed many years ago.  I don't think that the change is
> > desirable in all cases.  There are functions like kmalloc where NULL means
> > failure and !p seems like the reasonable choice.  But there maybe other
> > cases where NULL is somehow a meaningful value.
> >
> > Here is a link to the part of the discussion:
> >
> > https://lkml.org/lkml/2007/7/27/103
>
> Yes, I agree with some of the things Al Viro said
> there, but isn't 'type t; t *p;' a subset of
> "expression *e"?

No.  How would you expect it to be different.  type t means that the type
is known.  expression *e means that there is a * in the type.  But there
is no way to know that there is a * in the type without knowing the full
type.

Maybe something like

e = f(...);
...
if (e == NULL) S1 else S2

would be acceptable?  But I was thinking that for some functions NULL
might be considered to be a meaningful result, rather than a sign of
failure.

The following semantic patch gives almost 3000 results:

@disable is_null@
expression e;
statement S1,S2;
@@

e = \(kmalloc\|kzalloc\|kcalloc\|devm_kmalloc\|devm_kzalloc\)(...);
... when != e
if (<+...
- e == NULL
+ !e
    ...+>) S1 else S2

julia
