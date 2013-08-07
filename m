Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab3HGUvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:51:20 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56931 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3HGUvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:51:19 -0400
Date: Wed, 7 Aug 2013 13:51:17 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] idr: Document ida tree sections
Message-ID: <20130807205117.GC11612@kmo-pixel>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-4-git-send-email-kmo@daterainc.com>
 <20130807202201.GA28039@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807202201.GA28039@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 04:22:01PM -0400, Tejun Heo wrote:
> Hello, Kent.
> 
> On Wed, Aug 07, 2013 at 10:34:58AM -0700, Kent Overstreet wrote:
> > + * So for 1 mb of memory (and allocating more than that should be fine with
> > + * CONFIG_COMPACTION) you get slightly under 8 million IDs.
> 
> Nothing seems to explain the section thing.  This is broken up now,
> right?  Where's the documentation?

Whoops, yes. As usual with the documentation...

Here's a fixup patch for that:

>From c24de588c5f31fa77fb8fcbf4c457b32062fee0c Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kmo@daterainc.com>
Date: Wed, 7 Aug 2013 13:50:42 -0700
Subject: [PATCH] idr: Document ida tree sections


diff --git a/lib/idr.c b/lib/idr.c
index 320ffea..02a221c 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -72,18 +72,37 @@ static void *kgalloc(size_t size, gfp_t gfp)
  * the bit for id i is bit id % BITS_PER_LONG in ida->tree[ida->first_leaf + i /
  * BITS_PER_LONG].
  *
- * Note that the number of ids we can allocate is limited by the amount of
- * memory we can contiguously allocate. The amount of memory used for the bitmap
- * tree is only slightly more than a flat bitmap would use - about 1 / TREE_ARY
- * * (sizeof flat bitmap).
+ * That last line of code is a lie - logically, the data structure is one flat
+ * array - but to avoid giant contiguous allocations we use an array of arrays -
+ * ida_index_to_node() replaces the array lookup in the above example.
  *
- * So for 1 mb of memory (and allocating more than that should be fine with
- * CONFIG_COMPACTION) you get slightly under 8 million IDs.
+ * So ida->tree is an array of pointers to sections, where the sections are
+ * different segments of the array the bitmap tree lives in.
+ *
+ * If there's a single section, it's only as big as we need it to be, and we
+ * grow the bitmap tree by doubling the size of the allocation.
+ *
+ * Once the tree is big enough that we start using multiple sections, the
+ * sections are always the same size - the max section size - and we grow the
+ * tree by appending new sections.
+ *
+ * The maximum size of the bitmap tree is when we've allocated all the way up to
+ * INT_MAX ids; we need (INT_MAX / 8) bytes of memory for the leaves, plus a
+ * couple percent for the parent nodes (since TREE_ARY == BITS_PER_LONG the
+ * parent nodes only add around 2%).
+ *
+ * So that's ~256 mb of memory max; we pick the max section size such that the
+ * max size of the array of pointers to sections isn't any bigger than the max
+ * section size.
+ *
+ * So if the max section size is 64k, that's ~4096 sections, with 8 byte
+ * pointers that's a little over 32k for the pointers to sections.
+ *
+ * That means max size sections are order 4 page allocations.
  */
 
 #define IDA_TREE_ARY		BITS_PER_LONG
-#define IDA_ALLOC_ORDER_MAX	4
-#define IDA_SECTION_SIZE	(PAGE_SIZE << IDA_ALLOC_ORDER_MAX)
+#define IDA_SECTION_SIZE	(64UL << 10)
 #define IDA_NODES_PER_SECTION	(IDA_SECTION_SIZE / sizeof(unsigned long))
 
 static inline unsigned long *ida_index_to_node(struct ida *ida, unsigned node)
