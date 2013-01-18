Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3AROxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:53:00 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:10255 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab3AROw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:52:58 -0500
Date: Fri, 18 Jan 2013 14:52:57 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [RFC][PATCH v2] slub: Keep page and object in sync in
 slab_alloc_node()
In-Reply-To: <20130118044242.GA18665@lge.com>
Message-ID: <0000013c4e25f885-c4f6e914-525b-4ffb-8272-f41ba9dd02d3-000000@email.amazonses.com>
References: <1358446258.23211.32.camel@gandalf.local.home> <1358447864.23211.34.camel@gandalf.local.home> <0000013c4a69a2cf-1a19a6f6-e6a3-4f06-99a4-10fdd4b9aca2-000000@email.amazonses.com> <1358458996.23211.46.camel@gandalf.local.home>
 <0000013c4a7e7fbf-c51fd42a-2455-4fec-bb37-915035956f05-000000@email.amazonses.com> <1358462763.23211.57.camel@gandalf.local.home> <1358464245.23211.62.camel@gandalf.local.home> <1358464837.23211.66.camel@gandalf.local.home> <1358468598.23211.67.camel@gandalf.local.home>
 <1358468924.23211.69.camel@gandalf.local.home> <20130118044242.GA18665@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013, Joonsoo Kim wrote:

> How about this?

The easiest fix is to just check for NULL in node_match since a similar
situation can occur in slab_free.

Subject: slub: Do not dereference NULL pointer in node_match

The variables accessed in slab_alloc are volatile and therefore
the page pointer passed to node_match can be NULL. The processing
of data in slab_alloc is tentative until either the cmpxchg
succeeds or the __slab_alloc slowpath is invoked. Both are
able to perform the same allocation from the freelist.

Check for the NULL pointer in node_match.

A false positive will lead to a retry of the loop in slab_alloc().

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2013-01-18 08:47:29.198954250 -0600
+++ linux/mm/slub.c	2013-01-18 08:47:40.579126371 -0600
@@ -2041,7 +2041,7 @@ static void flush_all(struct kmem_cache
 static inline int node_match(struct page *page, int node)
 {
 #ifdef CONFIG_NUMA
-	if (node != NUMA_NO_NODE && page_to_nid(page) != node)
+	if (page && (node != NUMA_NO_NODE && page_to_nid(page) != node))
 		return 0;
 #endif
 	return 1;
