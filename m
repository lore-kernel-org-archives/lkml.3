Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaAEAfK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 19:35:10 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:41798 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbaAEAfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 19:35:08 -0500
Date: Sun, 5 Jan 2014 08:35:01 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
Message-ID: <20140105003501.GC4106@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Michal Hocko <mhocko@suse.cz>
References: <20140101002935.GA15683@localhost.localdomain>
 <52C5AA61.8060701@intel.com>
 <20140103033303.GB4106@localhost.localdomain>
 <52C6FED2.7070700@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C6FED2.7070700@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010500-9332-0000-0000-000002AA7C37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 10:17:54AM -0800, Dave Hansen wrote:
> On 01/02/2014 07:33 PM, Han Pingtian wrote:
> > @@ -130,8 +130,11 @@ static int set_recommended_min_free_kbytes(void)
> >  			      (unsigned long) nr_free_buffer_pages() / 20);
> >  	recommended_min <<= (PAGE_SHIFT-10);
> >  
> > -	if (recommended_min > min_free_kbytes)
> > +	if (recommended_min > min_free_kbytes) {
> > +		pr_info("raising min_free_kbytes from %d to %d to help transparent hugepage allocations\n",
> > +			min_free_kbytes, recommended_min);
> >  		min_free_kbytes = recommended_min;
> > +	}
> >  	setup_per_zone_wmarks();
> >  	return 0;
> >  }
> 
> I know I gave you that big bloated string, but 108 columns is a _wee_
> bit over 80. :)
> 
> Otherwise, I do like the new message

Thanks. This is the new version:

>From f4d085a880dfae7638b33c242554efb0afc0852b Mon Sep 17 00:00:00 2001
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
 mm/huge_memory.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7de1bf8..7910360 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -130,8 +130,12 @@ static int set_recommended_min_free_kbytes(void)
 			      (unsigned long) nr_free_buffer_pages() / 20);
 	recommended_min <<= (PAGE_SHIFT-10);
 
-	if (recommended_min > min_free_kbytes)
+	if (recommended_min > min_free_kbytes) {
+		pr_info("raising min_free_kbytes from %d to %d "
+			"to help transparent hugepage allocations\n",
+			min_free_kbytes, recommended_min);
 		min_free_kbytes = recommended_min;
+	}
 	setup_per_zone_wmarks();
 	return 0;
 }
-- 
1.7.7.6

