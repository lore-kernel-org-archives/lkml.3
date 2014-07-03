Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742AbaGCWn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:43:26 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:64167 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759693AbaGCWnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:24 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 00/18] lib: bitmap: Various improvements
Date: Fri,  4 Jul 2014 00:42:46 +0200
Message-Id: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many functions in lib/bitmap.c start with an expression such as lim =
bits/BITS_PER_LONG. Since bits has type (signed) int, and since gcc
cannot know that it is in fact non-negative, it generates worse code
than it could. These patches, mostly consisting of changing various
parameters to unsigned, gives a slight overall code reduction:

add/remove: 1/1 grow/shrink: 8/16 up/down: 251/-414 (-163)
function                                     old     new   delta
tick_device_uses_broadcast                   335     425     +90
__irq_alloc_descs                            498     554     +56
__bitmap_andnot                               73     115     +42
__bitmap_and                                  70     101     +31
bitmap_weight                                  -      11     +11
copy_hugetlb_page_range                      752     762     +10
follow_hugetlb_page                          846     854      +8
hugetlb_init                                1415    1417      +2
hugetlb_nrpages_setup                        130     131      +1
hugetlb_add_hstate                           377     376      -1
bitmap_allocate_region                        82      80      -2
select_task_rq_fair                         2202    2191     -11
hweight_long                                  66      55     -11
__reg_op                                     230     219     -11
dm_stats_message                            2849    2833     -16
bitmap_parselist                              92      74     -18
__bitmap_weight                              115      97     -18
__bitmap_subset                              153     129     -24
__bitmap_full                                128     104     -24
__bitmap_empty                               120      96     -24
bitmap_set                                   179     149     -30
bitmap_clear                                 185     155     -30
__bitmap_equal                               136     105     -31
__bitmap_intersects                          148     108     -40
__bitmap_complement                          109      67     -42
tick_device_setup_broadcast_func.isra         81       -     -81

[The increases in __bitmap_and{,not} are due to bug fixes 17/18,18/18.
No idea why bitmap_weight suddenly appears.] While 163 bytes treewide
is insignificant, I believe the bitmap functions are often called with
locks held, so saving even a few cycles might be worth it.

While making these changes, I found a few other things that might be
worth including. 16,17,18 are actual bug fixes. The rest shouldn't
change the behaviour of any of the functions, provided no-one passed
negative nbits values. If something should come up, it should be
fairly bisectable.

A few issues I thought about, but didn't know what to do with:

* Many of the functions misbehave if nbits is compile-time 0; the
  out-of-line functions generally handle 0 correctly. bitmap_fill() is
  particularly bad, whether the 0 is known at compile time or not. It
  would probably be nice to add detection of at least compile-time 0
  and handle that appropriately.

* I didn't change __bitmap_shift_{left,right} to use unsigned because
  I want to fully understand why the algorithm works before making
  that change. However, AFAICT, they behave correctly for all
  (positive) shift amounts. This is not the case for the
  small_const_nbits versions. If for example nbits = n =
  BITS_PER_LONG, the shift operators turn into no-ops (at least on
  x86), so one get *dst = *src, whereas one would expect to get
  *dst=0. That difference in behaviour is somewhat annoying.

Rasmus Villemoes (18):
  lib: bitmap: Make nbits parameter of bitmap_empty unsigned
  lib: bitmap: Make nbits parameter of bitmap_full unsigned
  lib: bitmap: Make nbits parameter of bitmap_equal unsigned
  lib: bitmap: Make nbits parameter of bitmap_complement unsigned
  lib: bitmap: Remove unnecessary mask from bitmap_complement
  lib: bitmap: Make nbits parameter of bitmap_{and,or,xor,andnot}
    unsigned
  lib: bitmap: Make nbits parameter of bitmap_intersects unsigned
  lib: bitmap: Make nbits parameter of bitmap_subset unsigned
  lib: bitmap: Make nbits parameter of bitmap_weight unsigned
  lib: bitmap: Make the start index of bitmap_set unsigned
  lib: bitmap: Make the start index of bitmap_clear unsigned
  lib: bitmap: Simplify bitmap_parselist
  lib: bitmap: Fix typo in kerneldoc for bitmap_pos_to_ord
  lib: bitmap: Change parameter of bitmap_*_region to unsigned
  lib: bitmap: Micro-optimize bitmap_allocate_region
  lib: bitmap: Add missing mask in bitmap_shift_right
  lib: bitmap: Add missing mask in bitmap_and
  lib: bitmap: Add missing mask in bitmap_andnot

 include/linux/bitmap.h |  62 +++++++++++++--------------
 lib/bitmap.c           | 111 +++++++++++++++++++++++++------------------------
 2 files changed, 87 insertions(+), 86 deletions(-)

-- 
1.9.2
