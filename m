Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab3AQVvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:51:13 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:27218 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756319Ab3AQVvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:51:11 -0500
Date: Thu, 17 Jan 2013 21:51:09 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [RFC][PATCH] slub: Check for page NULL before doing the node_match
 check
In-Reply-To: <1358458996.23211.46.camel@gandalf.local.home>
Message-ID: <0000013c4a7e7fbf-c51fd42a-2455-4fec-bb37-915035956f05-000000@email.amazonses.com>
References: <1358446258.23211.32.camel@gandalf.local.home>  <1358447864.23211.34.camel@gandalf.local.home>  <0000013c4a69a2cf-1a19a6f6-e6a3-4f06-99a4-10fdd4b9aca2-000000@email.amazonses.com> <1358458996.23211.46.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Steven Rostedt wrote:

> >  	c->tid = next_tid(c->tid);
> > -	c->page = NULL;
> >  	c->freelist = NULL;
> > +	c->page = NULL;
>
> I'm assuming that this is to deal with the same CPU being able to touch
> the code?
>
> If so, it requires "barrier()". If this can affect other CPUs, then we
> need a smp_wmb() here, and smp_rmb() where it matters.

This is dealing with the same cpu being interrupted. Some of these
segments are in interrupt disable sections so they are not affected.

The above is a section where interrupts are enabled so it needs the
barriers.

> > @@ -2227,8 +2227,8 @@ redo:
> >  	if (unlikely(!node_match(page, node))) {
> >  		stat(s, ALLOC_NODE_MISMATCH);
> >  		deactivate_slab(s, page, c->freelist);
> > -		c->page = NULL;
> >  		c->freelist = NULL;
> > +		c->page = NULL;
> >  		goto new_slab;
> >  	}
> >

Interrupts are disabled so we do not need to change anything here.


> > @@ -2239,8 +2239,8 @@ redo:
> >  	 */
> >  	if (unlikely(!pfmemalloc_match(page, gfpflags))) {
> >  		deactivate_slab(s, page, c->freelist);
> > -		c->page = NULL;
> >  		c->freelist = NULL;
> > +		c->page = NULL;
> >  		goto new_slab;
> >  	}
> >

Ditto which leaves us with:

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2013-01-17 15:49:57.417491975 -0600
+++ linux/mm/slub.c	2013-01-17 15:50:49.010287150 -0600
@@ -1993,8 +1993,9 @@ static inline void flush_slab(struct kme
 	deactivate_slab(s, c->page, c->freelist);

 	c->tid = next_tid(c->tid);
-	c->page = NULL;
 	c->freelist = NULL;
+	barrier();
+	c->page = NULL;
 }

 /*
