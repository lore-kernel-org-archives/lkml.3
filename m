Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbaAaRhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:37:01 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37245 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570AbaAaRg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:36:58 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com
Cc: riel@redhat.com, mgorman@suse.de, mhocko@suse.cz,
        aneesh.kumar@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        hughd@google.com, david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com, dhillf@gmail.com,
        rientjes@google.com, davidlohr@hp.com, aswin@hp.com,
        scott.norton@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] mm, hugetlb: fixes and fault scalability
Date: Fri, 31 Jan 2014 09:36:40 -0800
Message-Id: <1391189806-13319-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1 (http://lkml.org/lkml/2014/1/26/219), based on feedback 
from Naoya Horiguchi:
- Dropped cleanup patches 6 & 7.

- Re did patch 3, fixing some potential use after free for new
  regions.

- Cleaned up patch 5.

- Added review tags.

This patchset resumes the work to improve the whole hugepage fault
scalability path. Previous efforts can be found here:

https://lkml.org/lkml/2013/7/26/299
https://lkml.org/lkml/2013/12/18/50

The latest attempt to address the big-fat hugetlb instantiation mutex by
removing the need for it altogether ended up having too much of an overhead
to consider and allow scalability. The discussion can be found at:
https://lkml.org/lkml/2014/1/3/244

This patchset is divided in three parts, where the first seven patches,
from Joonsoo, have been included and reviewed in previous patchsets. The 
last patch is the actual performance one.

Part 1. (1-3) Introduce new protection method for region tracking 
        data structure, instead of the hugetlb_instantiation_mutex. There
        is race condition when we map the hugetlbfs file to two different
        processes. To prevent it, we need to new protection method like
        as this patchset.

Part 2. (4-5) clean-up.

        These make code really simple, so these are worth to go into
        mainline separately.

Part 3 (6) Use a table of mutexes instead of a unique one, and allow
        faults to be handled in parallel. Benefits and caveats to this
        approach are in the patch.

All changes have passed the libhugetblfs test cases.
This patchset applies on top of Linus' current tree (3.13-e7651b81).

  mm, hugetlb: unify region structure handling
  mm, hugetlb: improve, cleanup resv_map parameters
  mm, hugetlb: fix race in region tracking
  mm, hugetlb: remove resv_map_put
  mm, hugetlb: use vma_resv_map() map types
  mm, hugetlb: improve page-fault scalability

 fs/hugetlbfs/inode.c    |  17 ++-
 include/linux/hugetlb.h |  10 ++
 mm/hugetlb.c            | 286 ++++++++++++++++++++++++++++++------------------
 3 files changed, 204 insertions(+), 109 deletions(-)

-- 
1.8.1.4

