Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab3CYA2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 20:28:16 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48070 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3CYA2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 20:28:15 -0400
Date: Sun, 24 Mar 2013 17:28:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Russ Anderson <rja@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
In-Reply-To: <CAHGf_=qgsga4Juj8uNnfbmOZYtYhcQbqngbFDWg9=B-1nc1HSw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1303241727420.23613@chino.kir.corp.google.com>
References: <20130318155619.GA18828@sgi.com> <20130321105516.GC18484@gmail.com> <alpine.DEB.2.02.1303211139110.3775@chino.kir.corp.google.com> <20130322072532.GC10608@gmail.com> <20130323152948.GA3036@sgi.com>
 <CAHGf_=qgsga4Juj8uNnfbmOZYtYhcQbqngbFDWg9=B-1nc1HSw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Mar 2013, KOSAKI Motohiro wrote:

> > --- linux.orig/mm/page_alloc.c  2013-03-19 16:09:03.736450861 -0500
> > +++ linux/mm/page_alloc.c       2013-03-22 17:07:43.895405617 -0500
> > @@ -4161,10 +4161,23 @@ int __meminit __early_pfn_to_nid(unsigne
> >  {
> >         unsigned long start_pfn, end_pfn;
> >         int i, nid;
> > +       /*
> > +          NOTE: The following SMP-unsafe globals are only used early
> > +          in boot when the kernel is running single-threaded.
> > +        */
> > +       static unsigned long last_start_pfn, last_end_pfn;
> > +       static int last_nid;
> 
> Why don't you mark them __meminitdata? They seems freeable.
> 

Um, defining them in a __meminit function places them in .meminit.data 
already.
