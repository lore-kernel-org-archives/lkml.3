Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965504AbaGRMIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:08:50 -0400
Received: from 8bytes.org ([81.169.241.247]:47500 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761405AbaGRMHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:07:16 -0400
From: Joerg Roedel <joro@8bytes.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 0/6] PM / Hibernate: Memory bitmap scalability improvements
Date: Fri, 18 Jul 2014 13:57:17 +0200
Message-Id: <1405684643-30234-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a patch set to improve the scalability of the memory
bitmap implementation used for hibernation. The current
implementation does not scale well to machines with several
TB of memory. A resume on those machines may cause soft
lockups to be reported.

These patches improve the data structure by adding a radix
tree to the linked list structure to improve random access
performance from O(n) to O(log_b(n)), where b depends on the
architecture (b=512 on amd64, 1024 in i386).

A test on a 12TB machine showed an improvement in resume
time from 76s with the old implementation to 2.4s with the
radix tree and the improved swsusp_free function. See below
for details of this test.

Patches 1-3 that add the radix tree while keeping the
existing memory bitmap implementation in place and add code
to compare the results between both implementations. This
was used during development to make sure both data
structures return the same results.

Patch 4 re-implements the swsusp_free() function to not
iterate over all pfns but only over the bits set in the
bitmaps. This showed to scale better on large memory
machines.

Patch 5 removes the old memory bitmap implementation now
that the radix tree is in place and working correctly.

The last patch adds touching the soft lockup watchdog in
rtree_next_node. This is necessary because the worst case
performance (all bits set in the forbidden_pages_map and
free_pages_map) is the same as with the old implementation
and may still cause soft lockups. Patch 6 avoids this.

The code was tested in 32 and 64 bit x86 and showed no
issues there.

Below is an example test that shows the performance
improvement on a 12TB machine. First the test with the old
memory bitmap:

# time perf record /usr/sbin/resume $sdev
resume: libgcrypt version: 1.5.0
[ perf record: Woken up 12 times to write data ]
[ perf record: Captured and wrote 2.882 MB perf.data (~125898 samples) ]

real    1m16.043s
user    0m0.016s
sys     0m0.312s
# perf report --stdio |head -50
# Events: 75K cycles
#
# Overhead  Command         Shared Object                                   
Symbol
# ........  .......  .................... 
........................................
#
    56.16%   resume  [kernel.kallsyms]     [k] memory_bm_test_bit
    19.35%   resume  [kernel.kallsyms]     [k] swsusp_free
    14.90%   resume  [kernel.kallsyms]     [k] memory_bm_find_bit
     7.28%   resume  [kernel.kallsyms]     [k] swsusp_page_is_forbidden

And here is the same test on the same machine with these
patches applied:

#  time perf record /usr/sbin/resume $sdev
resume: libgcrypt version: 1.5.0
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.039 MB perf.data (~1716 samples) ]

real    0m2.376s
user    0m0.020s
sys     0m0.408s

# perf report --stdio |head -50
# Events: 762  cycles
#
# Overhead  Command      Shared Object                     Symbol
# ........  .......  .................  .........................
#
    34.78%   resume  [kernel.kallsyms]  [k] find_next_bit
    27.03%   resume  [kernel.kallsyms]  [k] clear_page_c_e
     9.70%   resume  [kernel.kallsyms]  [k] mark_nosave_pages
     3.92%   resume  [kernel.kallsyms]  [k] alloc_rtree_node
     2.38%   resume  [kernel.kallsyms]  [k] get_image_page

As can be seen on these results these patches improve the
scalability significantly. Please review, any comments
appreciated.

Thanks,

	Joerg

Joerg Roedel (6):
  PM / Hibernate: Create a Radix-Tree to store memory bitmap
  PM / Hibernate: Add memory_rtree_find_bit function
  PM / Hibernate: Implement position keeping in radix tree
  PM / Hibernate: Iterate over set bits instead of PFNs in swsusp_free()
  PM / Hibernate: Remove the old memory-bitmap implementation
  PM / Hibernate: Touch Soft Lockup Watchdog in rtree_next_node

 kernel/power/snapshot.c | 510 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 368 insertions(+), 142 deletions(-)

-- 
1.9.1

