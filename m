Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaANUHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:07:31 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33616 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbaANUH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:07:28 -0500
Date: Wed, 15 Jan 2014 04:07:20 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
Message-ID: <20140114200720.GM4106@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
	linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>
References: <52C5AA61.8060701@intel.com>
 <20140103033303.GB4106@localhost.localdomain>
 <52C6FED2.7070700@intel.com>
 <20140105003501.GC4106@localhost.localdomain>
 <20140106164604.GC27602@dhcp22.suse.cz>
 <20140108101611.GD27937@dhcp22.suse.cz>
 <20140110081744.GC9437@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110081744.GC9437@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011420-7182-0000-0000-0000098DE301
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 09:17:44AM +0100, Michal Hocko wrote:
> On Fri 10-01-14 00:13:44, Andrew Morton wrote:
> > On Fri, 10 Jan 2014 09:05:04 +0100 Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > > > --- a/mm/huge_memory.c
> > > > > +++ b/mm/huge_memory.c
> > > > > @@ -100,6 +100,7 @@ static struct khugepaged_scan khugepaged_scan = {
> > > > >  	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
> > > > >  };
> > > > >  
> > > > > +extern int user_min_free_kbytes;
> > > > >  
> > > > 
> > > > We don't add extern declarations to .c files.  How many other examples of 
> > > > this can you find in mm/?
> > > 
> > > I have suggested this because general visibility is not needed.
> > 
> > It's best to use a common declaration which is seen by the definition
> > site and all references, so everyone agrees on the variable's type. 
> > Otherwise we could have "long foo;" in one file and "extern char foo;"
> > in another and the compiler won't tell us.  I think the linker could
> > tell us, but it doesn't, afaik.  Perhaps there's an option...
> > 
> > > But if
> > > you think that it should then include/linux/mm.h sounds like a proper
> > > place.
> > 
> > mm/internal.h might suit.
> 
> min_free_kbytes is in mm.h so I thought having them together would be
> appropriate.
> 

This is the latest version which put user_min_free_kbytes in
mm/internal.h. Please have a look. Thanks.


>From 0d2583bea1f8ffa919e2cee3ee8ed08ec547284a Mon Sep 17 00:00:00 2001
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
Date: Thu, 9 Jan 2014 15:24:26 +0800
Subject: [PATCH] mm: show message when raising min_free_kbytes in THP

min_free_kbytes may be raised during THP's initialization. Sometimes,
this will change the value being set by user. Showing message will
clarify this confusion.

Only show this message when changing the value set by user according to
Michal Hocko's suggestion.

Showing the old value of min_free_kbytes according to Dave Hansen's
suggestion. This will give user the chance to restore old value of
min_free_kbytes.

Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
---
 mm/huge_memory.c |    8 +++++++-
 mm/internal.h    |    1 +
 mm/page_alloc.c  |    2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7de1bf8..2ca526b8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -130,8 +130,14 @@ static int set_recommended_min_free_kbytes(void)
 			      (unsigned long) nr_free_buffer_pages() / 20);
 	recommended_min <<= (PAGE_SHIFT-10);
 
-	if (recommended_min > min_free_kbytes)
+	if (recommended_min > min_free_kbytes) {
+		if (user_min_free_kbytes >= 0)
+			pr_info("raising min_free_kbytes from %d to %lu "
+				"to help transparent hugepage allocations\n",
+				min_free_kbytes, recommended_min);
+
 		min_free_kbytes = recommended_min;
+	}
 	setup_per_zone_wmarks();
 	return 0;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 684f7aa..110d8da 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -101,6 +101,7 @@ extern void prep_compound_page(struct page *page, unsigned long order);
 #ifdef CONFIG_MEMORY_FAILURE
 extern bool is_free_buddy_page(struct page *page);
 #endif
+extern int user_min_free_kbytes;
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9ea62b2..a9dcfd8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -205,7 +205,7 @@ static char * const zone_names[MAX_NR_ZONES] = {
 };
 
 int min_free_kbytes = 1024;
-int user_min_free_kbytes;
+int user_min_free_kbytes = -1;
 
 static unsigned long __meminitdata nr_kernel_pages;
 static unsigned long __meminitdata nr_all_pages;
-- 
1.7.7.6

