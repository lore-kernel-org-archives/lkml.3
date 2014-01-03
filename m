Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaACDdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:33:13 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34340 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaACDdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:33:11 -0500
Date: Fri, 3 Jan 2014 11:33:03 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
Message-ID: <20140103033303.GB4106@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Michal Hocko <mhocko@suse.cz>
References: <20140101002935.GA15683@localhost.localdomain>
 <52C5AA61.8060701@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C5AA61.8060701@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010303-0320-0000-0000-00000218A44E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 10:05:21AM -0800, Dave Hansen wrote:
> On 12/31/2013 04:29 PM, Han Pingtian wrote:
> > min_free_kbytes may be updated during thp's initialization. Sometimes,
> > this will change the value being set by user. Showing message will
> > clarify this confusion.
> ...
> > -	if (recommended_min > min_free_kbytes)
> > +	if (recommended_min > min_free_kbytes) {
> >  		min_free_kbytes = recommended_min;
> > +		pr_info("min_free_kbytes is updated to %d by enabling transparent hugepage.\n",
> > +			min_free_kbytes);
> > +	}
> 
> "updated" doesn't tell us much.  It's also kinda nasty that if we enable
> then disable THP, we end up with an elevated min_free_kbytes.  Maybe we
> should at least put something in that tells the user how to get back
> where they were if they care:
> 
> "raising min_free_kbytes from %d to %d to help transparent hugepage
> allocations"
> 
Thanks. I have updated it according to your suggestion.


>From f9902b16ff0c326349e72eca9facef2c98f8595d Mon Sep 17 00:00:00 2001
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
Date: Fri, 3 Jan 2014 11:10:49 +0800
Subject: [PATCH] mm: show message when raising min_free_kbytes in THP

min_free_kbytes may be raised during THP's initialization. Sometimes,
this will change the value being set by user. Showing message will
clarify this confusion.

Showing the old value of min_free_kbytes according to Dave Hansen's
suggestion. This will give user the chance to restore old value of
min_free_kbytes.

Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
---
 mm/huge_memory.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7de1bf8..1f0356d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -130,8 +130,11 @@ static int set_recommended_min_free_kbytes(void)
 			      (unsigned long) nr_free_buffer_pages() / 20);
 	recommended_min <<= (PAGE_SHIFT-10);
 
-	if (recommended_min > min_free_kbytes)
+	if (recommended_min > min_free_kbytes) {
+		pr_info("raising min_free_kbytes from %d to %d to help transparent hugepage allocations\n",
+			min_free_kbytes, recommended_min);
 		min_free_kbytes = recommended_min;
+	}
 	setup_per_zone_wmarks();
 	return 0;
 }
-- 
1.7.7.6

