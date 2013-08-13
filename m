Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388Ab3HMWdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:33:10 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60523 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422Ab3HMWdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:33:08 -0400
Date: Tue, 13 Aug 2013 15:33:11 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] idr: Document ida tree sections
Message-ID: <20130813223311.GB12069@kmo-pixel>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-4-git-send-email-kmo@daterainc.com>
 <20130807202201.GA28039@mtj.dyndns.org>
 <20130807205117.GC11612@kmo-pixel>
 <20130809145756.GL20515@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809145756.GL20515@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 10:57:56AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 07, 2013 at 01:51:17PM -0700, Kent Overstreet wrote:
> > + * So if the max section size is 64k, that's ~4096 sections, with 8 byte
> > + * pointers that's a little over 32k for the pointers to sections.
> > + *
> > + * That means max size sections are order 4 page allocations.
> 
> Order 4 allocations for common data structure doesn't really sound
> like a good idea to me.  It's gonna work fine on relatively large
> machines but suck on mobile / small embedded devices, many of which
> are still struggling with 32bit address space and compaction may not
> be enabled.  It just doens't make sense to me to impose 64k
> allocations from low level library function like ida.

Would this be an acceptable solution?

>From 483cfa0c809b7dc3b0abad93407468f273416578 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kmo@daterainc.com>
Date: Tue, 13 Aug 2013 15:31:20 -0700
Subject: [PATCH] ida: Use order 2 allocations when COMPACTION=n

And fall back to vmalloc for the array of pointers to sections so we can
still allocate up to INT_MAX ids.

diff --git a/lib/idr.c b/lib/idr.c
index 02a221c..3bffb52 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -21,16 +21,20 @@
 #include <linux/export.h>
 #include <linux/idr.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/percpu.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/spinlock.h>
+#include <linux/vmalloc.h>
 
 static void kgfree(void *ptr, size_t size)
 {
-	if (size < PAGE_SIZE)
+	if (is_vmalloc_addr(ptr))
+		vfree(ptr);
+	else if (size < PAGE_SIZE)
 		kfree(ptr);
 	else
 		free_pages((unsigned long) ptr, get_order(size));
@@ -102,7 +106,14 @@ static void *kgalloc(size_t size, gfp_t gfp)
  */
 
 #define IDA_TREE_ARY		BITS_PER_LONG
-#define IDA_SECTION_SIZE	(64UL << 10)
+
+/* Max section size, in bytes */
+#ifdef CONFIG_COMPACTION
+#define IDA_SECTION_SIZE	(64UL << 10) /* order 4 page allocation */
+#else
+#define IDA_SECTION_SIZE	(16UL << 10) /* order 2 */
+#endif
+
 #define IDA_NODES_PER_SECTION	(IDA_SECTION_SIZE / sizeof(unsigned long))
 
 static inline unsigned long *ida_index_to_node(struct ida *ida, unsigned node)
@@ -251,8 +262,15 @@ again:
 
 	if (ida->nodes >= IDA_NODES_PER_SECTION &&
 	    is_power_of_2(cur_sections)) {
-		sections = kgalloc(cur_sections * 2 * sizeof(unsigned long *),
-				   __GFP_ZERO|gfp);
+		size_t bytes = cur_sections * 2 * sizeof(unsigned long *);
+
+		if (bytes <= IDA_SECTION_SIZE)
+			sections = kgalloc(bytes, __GFP_ZERO|gfp);
+		else if (gfp & GFP_KERNEL)
+			sections = vzalloc(bytes);
+		else
+			sections = NULL;
+
 		if (!sections)
 			goto err;
 	}
