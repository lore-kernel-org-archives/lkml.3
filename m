Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab3LDAKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:10:22 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56612 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3LDAKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:10:15 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-03-529e72e44022
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 0/9] mm/rmap: unify rmap traversing functions through rmap_walk
Date: Wed,  4 Dec 2013 09:12:11 +0900
Message-Id: <1386115940-21425-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Changed from v1 *
recompute pgoff for both the huge page and normal page by compound_order().
change initialization way of rmap_walk_control variable.
add parameter's name to make prototype more readable.
change name of main function of rmap walk from main() to rmap_one().
add some comments on rmap_walk_control structure.
change name of function pointer.
add some comments to argument of try_ty_unmap_one().


Rmap traversing is used in five different cases, try_to_unmap(),
try_to_munlock(), page_referenced(), page_mkclean() and
remove_migration_ptes(). Each one implements its own traversing functions
for the cases, anon, file, ksm, respectively. These cause lots of duplications
and cause maintenance overhead. They also make codes being hard to understand
and error-prone. One example is hugepage handling. There is a code to compute
hugepage offset correctly in try_to_unmap_file(), but, there isn't a code
to compute hugepage offset in rmap_walk_file(). These are used pairwise
in migration context, but we missed to modify pairwise.

To overcome these drawbacks, we should unify these through one unified
function. I decide rmap_walk() as main function since it has no
unnecessity. And to control behavior of rmap_walk(), I introduce
struct rmap_walk_control having some function pointers. These makes
rmap_walk() working for their specific needs.

This patchset remove a lot of duplicated code as you can see in below
short-stat and kernel text size also decrease slightly.

   text    data     bss     dec     hex filename
  10640       1      16   10657    29a1 mm/rmap.o
  10047       1      16   10064    2750 mm/rmap.o

  13823     705    8288   22816    5920 mm/ksm.o
  13199     705    8288   22192    56b0 mm/ksm.o

Thanks.

Joonsoo Kim (9):
  mm/rmap: recompute pgoff for huge page
  mm/rmap: factor nonlinear handling out of try_to_unmap_file()
  mm/rmap: factor lock function out of rmap_walk_anon()
  mm/rmap: make rmap_walk to get the rmap_walk_control argument
  mm/rmap: extend rmap_walk_xxx() to cope with different cases
  mm/rmap: use rmap_walk() in try_to_unmap()
  mm/rmap: use rmap_walk() in try_to_munlock()
  mm/rmap: use rmap_walk() in page_referenced()
  mm/rmap: use rmap_walk() in page_mkclean()

 include/linux/ksm.h  |   15 +-
 include/linux/rmap.h |   27 ++-
 mm/ksm.c             |  116 +---------
 mm/migrate.c         |    7 +-
 mm/rmap.c            |  570 ++++++++++++++++++++++----------------------------
 5 files changed, 288 insertions(+), 447 deletions(-)

-- 
1.7.9.5

