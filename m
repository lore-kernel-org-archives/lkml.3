Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaAIHdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:33:09 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:38683 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaAIHdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:33:06 -0500
Date: Thu, 9 Jan 2014 15:32:59 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
Message-ID: <20140109073259.GK4106@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave.hansen@intel.com>,
	David Rientjes <rientjes@google.com>
References: <20140101002935.GA15683@localhost.localdomain>
 <52C5AA61.8060701@intel.com>
 <20140103033303.GB4106@localhost.localdomain>
 <52C6FED2.7070700@intel.com>
 <20140105003501.GC4106@localhost.localdomain>
 <20140106164604.GC27602@dhcp22.suse.cz>
 <20140108101611.GD27937@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108101611.GD27937@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010907-7164-0000-0000-000004F5C25C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 11:16:11AM +0100, Michal Hocko wrote:
> On Wed 08-01-14 16:20:01, Han Pingtian wrote:
> > On Mon, Jan 06, 2014 at 05:46:04PM +0100, Michal Hocko wrote:
> > > On Sun 05-01-14 08:35:01, Han Pingtian wrote:
> > > [...]
> > > > From f4d085a880dfae7638b33c242554efb0afc0852b Mon Sep 17 00:00:00 2001
> > > > From: Han Pingtian <hanpt@linux.vnet.ibm.com>
> > > > Date: Fri, 3 Jan 2014 11:10:49 +0800
> > > > Subject: [PATCH] mm: show message when raising min_free_kbytes in THP
> > > > 
> > > > min_free_kbytes may be raised during THP's initialization. Sometimes,
> > > > this will change the value being set by user. Showing message will
> > > > clarify this confusion.
> > > 
> > > I do not have anything against informing about changing value
> > > set by user but this will inform also when the default value is
> > > updated. Is this what you want? Don't you want to check against
> > > user_min_free_kbytes? (0 if not set by user)
> > > 
> > 
> > To use user_min_free_kbytes in mm/huge_memory.c, we need a 
> > 
> >     extern int user_min_free_kbytes;
> 
> The variable is not defined as static so you can use it outside of
> mm/page_alloc.c.
> 
> > in somewhere? Where should we put it? I guess it is mm/internal.h,
> > right?
> 
> I do not think this has to be globaly visible though. Why not just
> extern declaration in mm/huge_memory.c?
> 

This is the new patch, please review. Thanks.


>From b8db4f157a17d6d8652cc9cff024a192c3ee0779 Mon Sep 17 00:00:00 2001
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
 mm/huge_memory.c |    9 ++++++++-
 mm/page_alloc.c  |    2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7de1bf8..e0e4e29 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -100,6 +100,7 @@ static struct khugepaged_scan khugepaged_scan = {
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
+extern int user_min_free_kbytes;
 
 static int set_recommended_min_free_kbytes(void)
 {
@@ -130,8 +131,14 @@ static int set_recommended_min_free_kbytes(void)
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

