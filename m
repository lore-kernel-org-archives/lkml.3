Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab3CYVeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:34:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665Ab3CYVeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:34:01 -0400
Date: Mon, 25 Mar 2013 14:34:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Russ Anderson <rja@sgi.com>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
Message-Id: <20130325143400.d226b1f7b64a209b86dd4151@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1303241727420.23613@chino.kir.corp.google.com>
References: <20130318155619.GA18828@sgi.com>
	<20130321105516.GC18484@gmail.com>
	<alpine.DEB.2.02.1303211139110.3775@chino.kir.corp.google.com>
	<20130322072532.GC10608@gmail.com>
	<20130323152948.GA3036@sgi.com>
	<CAHGf_=qgsga4Juj8uNnfbmOZYtYhcQbqngbFDWg9=B-1nc1HSw@mail.gmail.com>
	<alpine.DEB.2.02.1303241727420.23613@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Mar 2013 17:28:12 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Sat, 23 Mar 2013, KOSAKI Motohiro wrote:
> 
> > > --- linux.orig/mm/page_alloc.c  2013-03-19 16:09:03.736450861 -0500
> > > +++ linux/mm/page_alloc.c       2013-03-22 17:07:43.895405617 -0500
> > > @@ -4161,10 +4161,23 @@ int __meminit __early_pfn_to_nid(unsigne
> > >  {
> > >         unsigned long start_pfn, end_pfn;
> > >         int i, nid;
> > > +       /*
> > > +          NOTE: The following SMP-unsafe globals are only used early
> > > +          in boot when the kernel is running single-threaded.
> > > +        */
> > > +       static unsigned long last_start_pfn, last_end_pfn;
> > > +       static int last_nid;
> > 
> > Why don't you mark them __meminitdata? They seems freeable.
> > 
> 
> Um, defining them in a __meminit function places them in .meminit.data 
> already.

I wish it did, but it doesn't.
