Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab3IKWJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 18:09:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:49777 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab3IKWJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 18:09:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,887,1371106800"; 
   d="scan'208";a="400215595"
Subject: [RFC][PATCH] mm: percpu pages: up batch size to fix arithmetic?? errror
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux.com,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 11 Sep 2013 15:08:59 -0700
Message-Id: <20130911220859.EB8204BB@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I really don't know where the:

	batch /= 4;             /* We effectively *= 4 below */
	...
	batch = rounddown_pow_of_two(batch + batch/2) - 1;

came from.  The round down code at *MOST* does a *= 1.5, but
*averages* out to be just under 1.

On a system with 128GB in a zone, this means that we've got
(you can see in /proc/zoneinfo for yourself):

              high:  186 (744kB)
              batch: 31  (124kB)

That 124kB is almost precisely 1/4 of the "1/2 of a meg" that we
were shooting for.  We're under-sizing the batches by about 4x.
This patch kills the /=4.


---

 linux.git-davehans/mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_alloc.c~debug-pcp-sizes-1 mm/page_alloc.c
--- linux.git/mm/page_alloc.c~debug-pcp-sizes-1	2013-09-11 14:41:08.532445664 -0700
+++ linux.git-davehans/mm/page_alloc.c	2013-09-11 15:03:47.403912683 -0700
@@ -4103,7 +4103,6 @@ static int __meminit zone_batchsize(stru
 	batch = zone->managed_pages / 1024;
 	if (batch * PAGE_SIZE > 512 * 1024)
 		batch = (512 * 1024) / PAGE_SIZE;
-	batch /= 4;		/* We effectively *= 4 below */
 	if (batch < 1)
 		batch = 1;
 
_
