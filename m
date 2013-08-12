Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab3HLCZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:25:39 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47217 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab3HLCZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:25:37 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-90-5208479fbba9
Date: Mon, 12 Aug 2013 11:25:35 +0900
From: Minchan Kim <minchan@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, guz.fnst@cn.fujitsu.com,
        bcrl@kvack.org
Subject: Re: [RFC PATCH v2 0/4] mm: reclaim zbud pages on migration and
 compaction
Message-ID: <20130812022535.GA18832@bbox>
References: <1376043740-10576-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376043740-10576-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 09, 2013 at 12:22:16PM +0200, Krzysztof Kozlowski wrote:
> Hi,
> 
> Currently zbud pages are not movable and they cannot be allocated from CMA
> region. These patches try to address the problem by:

The zcache, zram and GUP pages for memory-hotplug and/or CMA are
same situation.

> 1. Adding a new form of reclaim of zbud pages.
> 2. Reclaiming zbud pages during migration and compaction.
> 3. Allocating zbud pages with __GFP_RECLAIMABLE flag.

So I'd like to solve it with general approach.

Each subsystem or GUP caller who want to pin pages long time should
create own migration handler and register the page into pin-page
control subsystem like this.

driver/foo.c

int foo_migrate(struct page *page, void *private);

static struct pin_page_owner foo_migrate = {
        .migrate = foo_migrate;
};

int foo_allocate()
{
        struct page *newpage = alloc_pages();
        set_pinned_page(newpage, &foo_migrate);
}

And in compaction.c or somewhere where want to move/reclaim the page,
general VM can ask to owner if it founds it's pinned page.

mm/compaction.c

        if (PagePinned(page)) {
                struct pin_page_info *info = get_page_pin_info(page);
                info->migrate(page);
                
        }

Only hurdle for that is that we should introduce a new page flag and
I believe if we all agree this approch, we can find a solution at last.

What do you think?

>From 9a4f652006b7d0c750933d738e1bd6f53754bcf6 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Sun, 11 Aug 2013 00:31:57 +0900
Subject: [RFC] pin page control subsystem


Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/Makefile   |    2 +-
 mm/pin-page.c |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 1 deletion(-)
 create mode 100644 mm/pin-page.c

diff --git a/mm/Makefile b/mm/Makefile
index f008033..245c2f7 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -5,7 +5,7 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o pagewalk.o pgtable-generic.o
+			   vmalloc.o pagewalk.o pgtable-generic.o pin-page.o
 
 ifdef CONFIG_CROSS_MEMORY_ATTACH
 mmu-$(CONFIG_MMU)	+= process_vm_access.o
diff --git a/mm/pin-page.c b/mm/pin-page.c
new file mode 100644
index 0000000..74b07f8
--- /dev/null
+++ b/mm/pin-page.c
@@ -0,0 +1,101 @@
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/hashtable.h>
+
+#define PPAGE_HASH_BITS 10
+
+static DEFINE_SPINLOCK(hash_lock);
+/*
+ * Should consider what's data struct we should use.
+ * It would be better use radix tree if we try to pin contigous
+ * pages a lot but if we pin spread pages, it wouldn't be a good idea.
+ */
+static DEFINE_HASHTABLE(pin_page_hash, PPAGE_HASH_BITS);
+
+/*
+ * Each subsystems should provide own page migration handler
+ */
+struct pin_page_owner {
+	int (*migrate)(struct page *page, void *private);
+};
+
+struct pin_page_info {
+	struct pin_page_owner *owner;
+	struct hlist_node hlist;
+
+	unsigned long pfn;
+	void *private;
+};
+
+/* TODO : Introduce new page flags */
+void SetPinnedPage(struct page *page)
+{
+
+}
+
+int PinnedPage(struct page *page)
+{
+	return 0;
+}
+
+/*
+ * GUP caller or subsystems which pin the page should call this function
+ * to register @page in pin-page control subsystem so that VM can ask us
+ * when it want to migrate @page.
+ *  
+ * Each pinned page would have some private key to identify itself
+ * like custom-allocator-returned handle.
+ */
+int set_pinned_page(struct pin_page_owner *owner,
+			struct page *page, void *private)
+{
+	struct pin_page_info *pinfo = kmalloc(sizeof(pinfo), GFP_KERNEL);
+
+	INIT_HLIST_NODE(&pinfo->hlist);
+	pinfo->owner = owner;
+
+	pinfo->pfn = page_to_pfn(page);
+	pinfo->private = private;
+	
+	spin_lock(&hash_lock);
+	hash_add(pin_page_hash, &pinfo->hlist, pinfo->pfn);
+	spin_unlock(&hash_lock);
+
+	SetPinnedPage(page);
+	return 0;
+};
+
+struct pin_page_info *get_pin_page_info(struct page *page)
+{
+	struct pin_page_info *tmp;
+	unsigned long pfn = page_to_pfn(page);
+
+	spin_lock(&hash_lock);
+	hash_for_each_possible(pin_page_hash, tmp, hlist, pfn) {
+		if (tmp->pfn == pfn) {
+			spin_unlock(&hash_lock);
+			return tmp;
+		}
+	}
+	spin_unlock(&hash_lock);
+	return NULL;
+}
+
+/* Used in compaction.c */
+int migrate_pinned_page(struct page *page)
+{
+	int ret = 1;
+	struct pin_page_info *pinfo = NULL;
+
+	if (PinnedPage(page)) {
+		while ((pinfo = get_pin_page_info(page))) {
+			/* If one of owners failed, bail out */
+			if (pinfo->owner->migrate(page, pinfo->private))
+				break;
+		}
+
+		ret = 0;
+	}
+	return ret;
+}
-- 
1.7.9.5

-- 
Kind regards,
Minchan Kim
