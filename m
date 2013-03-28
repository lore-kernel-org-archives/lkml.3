Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab3C1Rig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:38:36 -0400
Received: from b232-131.smtp-out.amazonses.com ([199.127.232.131]:64513 "EHLO
	b232-131.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab3C1Rie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:38:34 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Mar 2013 13:38:34 EDT
Date: Thu, 28 Mar 2013 17:29:03 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
In-Reply-To: <20130327061351.GB17125@lge.com>
Message-ID: <0000013db20bb0bd-221640a3-e8f8-4140-a3d7-d8e129632ffe-000000@email.amazonses.com>
References: <1364010673.6345.156.camel@gandalf.local.home> <0000013da1f93be3-c3d42ae8-ff34-4c63-8094-77a83291ea19-000000@email.amazonses.com> <1364227073.6345.182.camel@gandalf.local.home> <1364228039.6345.183.camel@gandalf.local.home>
 <0000013da2ace21a-9e87fe8a-75c2-4b7c-b5e1-37ad196ce012-000000@email.amazonses.com> <1364234613.6345.184.camel@gandalf.local.home> <0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com> <1364236355.6345.185.camel@gandalf.local.home>
 <20130327025957.GA17125@lge.com> <1364355032.6345.200.camel@gandalf.local.home> <20130327061351.GB17125@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches against slub to enable deconfiguring cpu_partial support.

First one is a bug fix (Pekka please pick up this one or use Joonsoo's
earlier one).


Subject: slub: Fix object counts in acquire_slab

It seems that we were overallocating objects from the slab queues
since get_partial_node() assumed that page->inuse was undisturbed by
acquire_slab(). Save the # of objects in page->lru.next in acquire_slab()
and pass it to get_partial_node() that way.

I have a vague memory that Joonsoo also ran into this issue awhile back.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2013-03-28 12:14:26.958358688 -0500
+++ linux/mm/slub.c	2013-03-28 12:16:57.240785613 -0500
@@ -1498,6 +1498,7 @@ static inline void *acquire_slab(struct
 	void *freelist;
 	unsigned long counters;
 	struct page new;
+	unsigned long objects;

 	/*
 	 * Zap the freelist and set the frozen bit.
@@ -1507,6 +1508,7 @@ static inline void *acquire_slab(struct
 	freelist = page->freelist;
 	counters = page->counters;
 	new.counters = counters;
+	objects = page->objects;
 	if (mode) {
 		new.inuse = page->objects;
 		new.freelist = NULL;
@@ -1524,6 +1526,7 @@ static inline void *acquire_slab(struct
 		return NULL;

 	remove_partial(n, page);
+	page->lru.next = (void *)objects;
 	WARN_ON(!freelist);
 	return freelist;
 }
@@ -1565,7 +1568,7 @@ static void *get_partial_node(struct kme
 			c->page = page;
 			stat(s, ALLOC_FROM_PARTIAL);
 			object = t;
-			available =  page->objects - page->inuse;
+			available =  page->objects - (unsigned long)page->lru.next;
 		} else {
 			available = put_cpu_partial(s, page, 0);
 			stat(s, CPU_PARTIAL_NODE);
