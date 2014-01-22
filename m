Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaAVGFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 01:05:16 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:53110 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaAVGFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 01:05:12 -0500
Date: Wed, 22 Jan 2014 14:05:06 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC] restore user defined min_free_kbytes when disabling thp
Message-ID: <20140122060506.GA2657@localhost.localdomain>
Mail-Followup-To: Mel Gorman <mgorman@suse.de>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
	Dave Hansen <dave.hansen@intel.com>,
	David Rientjes <rientjes@google.com>
References: <20140121093859.GA7546@localhost.localdomain>
 <20140121102351.GD4963@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121102351.GD4963@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012206-1344-0000-0000-0000051E9FD4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:23:51AM +0000, Mel Gorman wrote:
> On Tue, Jan 21, 2014 at 05:38:59PM +0800, Han Pingtian wrote:
> > The testcase 'thp04' of LTP will enable THP, do some testing, then
> > disable it if it wasn't enabled. But this will leave a different value
> > of min_free_kbytes if it has been set by admin. So I think it's better
> > to restore the user defined value after disabling THP.
> > 
> 
> Then have LTP record what min_free_kbytes was at the same time THP was
> enabled by the test and restore both settings. It leaves a window where
> an admin can set an alternative value during the test but that would also
> invalidate the test in same cases and gets filed under "don't do that".
> 

Because the value is changed in kernel, so it would be better to 
restore it in kernel, right? :)  I have a v2 patch which will restore
the value only if it isn't set again by user after THP's initialization.
This v2 patch is dependent on the patch 'mm: show message when updating
min_free_kbytes in thp' which has been added to -mm tree, can be found
here:

http://ozlabs.org/~akpm/mmotm/broken-out/mm-show-message-when-updating-min_free_kbytes-in-thp.patch

please have a look. Thanks.


>From 8b79586ff9a1d85cbe45102a86888268094ec0ae Mon Sep 17 00:00:00 2001
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
Date: Tue, 21 Jan 2014 17:24:43 +0800
Subject: [PATCH] mm: restore user defined min_free_kbytes when disabling thp

thp increases the value of min_free_kbytes in initialization. This will
change the user defined value of min_free_kbytes sometimes. So try to
restore the value when disabling thp if the value has been changed in
thp initialization and isn't changed by user afte that.

Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
---
 mm/huge_memory.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 94a824f..fcb8ce58 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -164,6 +164,16 @@ static int start_khugepaged(void)
 	} else if (khugepaged_thread) {
 		kthread_stop(khugepaged_thread);
 		khugepaged_thread = NULL;
+
+		if (user_min_free_kbytes >= 0 && 
+		    user_min_free_kbytes != min_free_kbytes) {
+			pr_info("restore min_free_kbytes from %d to user "
+				"defined %d when stopping khugepaged\n",
+				min_free_kbytes, user_min_free_kbytes);
+
+			min_free_kbytes = user_min_free_kbytes;
+			setup_per_zone_wmarks();
+		}
 	}
 
 	return err;
-- 
1.7.7.6

