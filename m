Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbaLJRiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:38:02 -0500
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:48618 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757620AbaLJRh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:37:58 -0500
Date: Wed, 10 Dec 2014 11:37:56 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: akpm <akpm@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
In-Reply-To: <CAOJsxLH4BGT9rGgg_4nxUMgW3sdEzLrmX2WtM8Ld3aytdR5e8g@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412101136520.6639@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141210163033.717707217@linux.com> <CAOJsxLFEN_w7q6NvbxkH2KTujB9auLkQgskLnGtN9iBQ4hV9sw@mail.gmail.com> <alpine.DEB.2.11.1412101107350.6291@gentwo.org>
 <CAOJsxLH4BGT9rGgg_4nxUMgW3sdEzLrmX2WtM8Ld3aytdR5e8g@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Pekka Enberg wrote:

> I'm fine with the optimization:
>
> Reviewed-by: Pekka Enberg <penberg@kernel.org>

There were some other issues so its now:


Subject: slub: Do not use c->page on free

Avoid using the page struct address on free by just doing an
address comparison. That is easily doable now that the page address
is available in the page struct and we already have the page struct
address of the object to be freed calculated.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2014-12-10 11:35:32.538563734 -0600
+++ linux/mm/slub.c	2014-12-10 11:36:39.032447807 -0600
@@ -2625,6 +2625,17 @@ slab_empty:
 	discard_slab(s, page);
 }

+static bool is_pointer_to_page(struct page *page, void *p)
+{
+	long d = p - page->address;
+
+	/*
+	 * Do a comparison for a MAX_ORDER page first before using
+	 * compound_order() to determine the actual page size.
+	 */
+	return d >= 0 && d < (1 << MAX_ORDER) && d < (compound_order(page) << PAGE_SHIFT);
+}
+
 /*
  * Fastpath with forced inlining to produce a kfree and kmem_cache_free that
  * can perform fastpath freeing without additional function calls.
@@ -2658,7 +2669,7 @@ redo:
 	tid = c->tid;
 	preempt_enable();

-	if (likely(page == c->page)) {
+	if (likely(is_pointer_to_page(page, c->freelist))) {
 		set_freepointer(s, object, c->freelist);

 		if (unlikely(!this_cpu_cmpxchg_double(
