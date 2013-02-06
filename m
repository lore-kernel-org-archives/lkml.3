Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab3BFCue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:50:34 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53431 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3BFCub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:50:31 -0500
X-AuditID: 9c93016f-b7b1fae000006419-0b-5111c4f49f06
Date: Wed, 6 Feb 2013 11:50:28 +0900
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH v2] zsmalloc: Add Kconfig for enabling PTE method
Message-ID: <20130206025028.GH11197@blaptop>
References: <1360117028-5625-1-git-send-email-minchan@kernel.org>
 <20130206022854.GA1681@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206022854.GA1681@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 06:28:54PM -0800, Greg Kroah-Hartman wrote:
> On Wed, Feb 06, 2013 at 11:17:08AM +0900, Minchan Kim wrote:
> > diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
> > index 9084565..232b3b6 100644
> > --- a/drivers/staging/zsmalloc/Kconfig
> > +++ b/drivers/staging/zsmalloc/Kconfig
> > @@ -8,3 +8,15 @@ config ZSMALLOC
> >  	  non-standard allocator interface where a handle, not a pointer, is
> >  	  returned by an alloc().  This handle must be mapped in order to
> >  	  access the allocated space.
> > +
> > +config PGTABLE_MAPPING
> > +        bool "Use page table mapping to access allocations that span two pages"
> 
> No tabs?
> 
> Please also put "ZSmalloc somewhere in the text here, otherwise it
> really doesn't make much sense when seeing it in a menu.
> 
> > +        depends on ZSMALLOC
> > +        default n
> 
> That's the default, so it can be dropped.
> 
> > +        help
> > +	  By default, zsmalloc uses a copy-based object mapping method to access
> > +	  allocations that span two pages. However, if a particular architecture
> > +	  performs VM mapping faster than copying, then you should select this.
> > +	  This causes zsmalloc to use page table mapping rather than copying
> > +	  for object mapping. You can check speed with zsmalloc benchmark[1].
> > +	  [1] https://github.com/spartacus06/zsmalloc
> 
> Care to specify exactly _what_ architectures this should be set for or
> not?  That will help the distros out a lot in determining if this should
> be enabled or not.
> 
> > diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> > index 06f73a9..2c1805c 100644
> > --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> > +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> > @@ -207,6 +207,7 @@ struct zs_pool {
> >  	struct size_class size_class[ZS_SIZE_CLASSES];
> >  
> >  	gfp_t flags;	/* allocation flags used when growing pool */
> > +
> >  };
> >  
> >  /*
> 
> Why add this extra line?
> 
> thanks,
> 
> greg k-h

Sorry for bothering you.
I fixed all you pointed out.
Thanks for the review, Greg!

Here it goes.

------------------- 8< -------------------

>From 506acea72916c9a12cf80290bc5cd87f4af1914d Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Wed, 6 Feb 2013 11:10:59 +0900
Subject: [PATCH v3] zsmalloc: Add Kconfig for enabling PTE method

Zsmalloc has two methods 1) copy-based and 2) pte-based to access
allocations that span two pages. You can see history why we supported
two approach from [1].

In summary, copy-based method is 3 times fater in x86 while pte-based
is 6 times faster in ARM.

But it was bad choice that adding hard coding to select architecture
which want to use pte based method. This patch removed it and adds
new Kconfig to select the approach.

This patch is based on next-20130205.

[1] https://lkml.org/lkml/2012/7/11/58

* Changelog from v2
  * Add tab and drop "default n" - Greg
  * Modify description - Greg
  * Drop unnecessary extra line - Greg

* Changelog from v1
  * Fix CONFIG_PGTABLE_MAPPING in zsmalloc-main.c - Greg

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zsmalloc/Kconfig         | 13 +++++++++++++
 drivers/staging/zsmalloc/zsmalloc-main.c | 19 ++++---------------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
index 9084565..83f9cec 100644
--- a/drivers/staging/zsmalloc/Kconfig
+++ b/drivers/staging/zsmalloc/Kconfig
@@ -8,3 +8,16 @@ config ZSMALLOC
 	  non-standard allocator interface where a handle, not a pointer, is
 	  returned by an alloc().  This handle must be mapped in order to
 	  access the allocated space.
+
+config PGTABLE_MAPPING
+	bool "Use page table mapping to access object in zsmalloc"
+	depends on ZSMALLOC
+	help
+	  By default, zsmalloc uses a copy-based object mapping method to
+	  access allocations that span two pages. However, if a particular
+	  architecture (ex, ARM) performs VM mapping faster than copying,
+	  then you should select this. This causes zsmalloc to use page table
+	  mapping rather than copying for object mapping.
+
+	  You can check speed with zsmalloc benchmark[1].
+	  [1] https://github.com/spartacus06/zsmalloc
diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 06f73a9..aa6aac4 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -218,19 +218,8 @@ struct zs_pool {
 #define CLASS_IDX_MASK	((1 << CLASS_IDX_BITS) - 1)
 #define FULLNESS_MASK	((1 << FULLNESS_BITS) - 1)
 
-/*
- * By default, zsmalloc uses a copy-based object mapping method to access
- * allocations that span two pages. However, if a particular architecture
- * performs VM mapping faster than copying, then it should be added here
- * so that USE_PGTABLE_MAPPING is defined. This causes zsmalloc to use
- * page table mapping rather than copying for object mapping.
-*/
-#if defined(CONFIG_ARM)
-#define USE_PGTABLE_MAPPING
-#endif
-
 struct mapping_area {
-#ifdef USE_PGTABLE_MAPPING
+#ifdef CONFIG_PGTABLE_MAPPING
 	struct vm_struct *vm; /* vm area for mapping object that span pages */
 #else
 	char *vm_buf; /* copy buffer for objects that span pages */
@@ -622,7 +611,7 @@ static struct page *find_get_zspage(struct size_class *class)
 	return page;
 }
 
-#ifdef USE_PGTABLE_MAPPING
+#ifdef CONFIG_PGTABLE_MAPPING
 static inline int __zs_cpu_up(struct mapping_area *area)
 {
 	/*
@@ -663,7 +652,7 @@ static inline void __zs_unmap_object(struct mapping_area *area,
 	flush_tlb_kernel_range(addr, end);
 }
 
-#else /* USE_PGTABLE_MAPPING */
+#else /* CONFIG_PGTABLE_MAPPING*/
 
 static inline int __zs_cpu_up(struct mapping_area *area)
 {
@@ -741,7 +730,7 @@ out:
 	pagefault_enable();
 }
 
-#endif /* USE_PGTABLE_MAPPING */
+#endif /* CONFIG_PGTABLE_MAPPING */
 
 static int zs_cpu_notifier(struct notifier_block *nb, unsigned long action,
 				void *pcpu)
-- 
1.8.1.1

-- 
Kind regards,
Minchan Kim
