Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937092Ab3DJSYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:24:20 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42387 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934446Ab3DJSYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:24:15 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v3 00/11] mm: fixup changers of per cpu pageset's ->high and ->batch
Date: Wed, 10 Apr 2013 11:23:28 -0700
Message-Id: <1365618219-17154-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041018-5806-0000-0000-000020ACC17E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Problems" with the current code:
 1. there is a lack of synchronization in setting ->high and ->batch in
    percpu_pagelist_fraction_sysctl_handler()
 2. stop_machine() in zone_pcp_update() is unnecissary.
 3. zone_pcp_update() does not consider the case where percpu_pagelist_fraction is non-zero

To fix:
 1. add memory barriers, a safe ->batch value, an update side mutex when
    updating ->high and ->batch, and use ACCESS_ONCE() for ->batch users that
    expect a stable value.
 2. avoid draining pages in zone_pcp_update(), rely upon the memory barriers added to fix #1
 3. factor out quite a few functions, and then call the appropriate one.

Note that it results in a change to the behavior of zone_pcp_update(), which is
used by memory_hotplug. I'm rather certain that I've diserned (and preserved)
the essential behavior (changing ->high and ->batch), and only eliminated
unneeded actions (draining the per cpu pages), but this may not be the case.

Further note that the draining of pages that previously took place in
zone_pcp_update() occured after repeated draining when attempting to offline a
page, and after the offline has "succeeded". It appears that the draining was
added to zone_pcp_update() to avoid refactoring setup_pageset() into 2
funtions.

--

Since v2: https://lkml.org/lkml/2013/4/9/718

 - note ACCESS_ONCE() in fix #1 above.
 - consolidate ->batch & ->high update protocol into a single funtion (Gilad).
 - add missing ACCESS_ONCE() on ->batch

Since v1: https://lkml.org/lkml/2013/4/5/444

 - instead of using on_each_cpu(), use memory barriers (Gilad) and an update side mutex.
 - add "Problem" #3 above, and fix.
 - rename function to match naming style of similar function
 - move unrelated comment

--

Cody P Schafer (11):
  mm/page_alloc: factor out setting of pcp->high and pcp->batch.
  mm/page_alloc: prevent concurrent updaters of pcp ->batch and ->high
  mm/page_alloc: insert memory barriers to allow async update of pcp
    batch and high
  mm/page_alloc: protect pcp->batch accesses with ACCESS_ONCE
  mm/page_alloc: convert zone_pcp_update() to rely on memory barriers
    instead of stop_machine()
  mm/page_alloc: when handling percpu_pagelist_fraction, don't unneedly
    recalulate high
  mm/page_alloc: factor setup_pageset() into pageset_init() and
    pageset_set_batch()
  mm/page_alloc: relocate comment to be directly above code it refers
    to.
  mm/page_alloc: factor zone_pageset_init() out of setup_zone_pageset()
  mm/page_alloc: in zone_pcp_update(), uze zone_pageset_init()
  mm/page_alloc: rename setup_pagelist_highmark() to match naming of
    pageset_set_batch()

 mm/page_alloc.c | 151 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 90 insertions(+), 61 deletions(-)

-- 
1.8.2.1

