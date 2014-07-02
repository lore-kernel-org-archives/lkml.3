Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbaGBCFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 22:05:06 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55593 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaGBCFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 22:05:03 -0400
Date: Wed, 2 Jul 2014 10:04:54 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
Message-ID: <20140702020454.GA6961@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <53AAFDF7.2010607@oracle.com>
 <alpine.DEB.2.11.1406251228130.29216@gentwo.org>
 <alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com>
 <alpine.DEB.2.11.1407010956470.5353@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407010956470.5353@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070202-9264-0000-0000-0000066F79D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 09:58:52AM -0500, Christoph Lameter wrote:
>On Mon, 30 Jun 2014, David Rientjes wrote:
>
>> It's not at all clear to me that that patch is correct.  Wei?
>
>Looks ok to me. But I do not like the convoluted code in new_slab() which
>Wei's patch does not make easier to read. Makes it difficult for the
>reader to see whats going on.

My patch is somewhat convoluted since I wanted to preserve the original logic
and make minimal change. And yes, it looks not that nice to audience.

I feel a little hurt by this patch. What I found and worked is gone with this
patch.

>
>Lets drop the use of the variable named "last".
>
>
>Subject: slub: Only call setup_object once for each object
>
>Modify the logic for object initialization to be less convoluted
>and initialize an object only once.
>
>Signed-off-by: Christoph Lameter <cl@linux.com>
>
>Index: linux/mm/slub.c
>===================================================================
>--- linux.orig/mm/slub.c	2014-07-01 09:50:02.486846653 -0500
>+++ linux/mm/slub.c	2014-07-01 09:52:07.918802585 -0500
>@@ -1409,7 +1409,6 @@ static struct page *new_slab(struct kmem
> {
> 	struct page *page;
> 	void *start;
>-	void *last;
> 	void *p;
> 	int order;
>
>@@ -1432,15 +1431,11 @@ static struct page *new_slab(struct kmem
> 	if (unlikely(s->flags & SLAB_POISON))
> 		memset(start, POISON_INUSE, PAGE_SIZE << order);
>
>-	last = start;
> 	for_each_object(p, s, start, page->objects) {
>-		setup_object(s, page, last);
>-		set_freepointer(s, last, p);
>-		last = p;
>+		setup_object(s, page, p);
>+		set_freepointer(s, p, p + s->size);
> 	}
>-	setup_object(s, page, last);
>-	set_freepointer(s, last, NULL);
>-
>+	set_freepointer(s, start + (page->objects - 1) * s->size, NULL);
> 	page->freelist = start;
> 	page->inuse = page->objects;
> 	page->frozen = 1;

-- 
Richard Yang
Help you, Help me

