Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbaHVQxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:53:31 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:42584 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaHVQxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:30 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Subject: [PATCHSET REPOST percpu/for-3.18] percpu: implement atomic allocation support
Date: Fri, 22 Aug 2014 12:53:04 -0400
Message-Id: <1408726399-4436-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(the initial posting was missing cc's, reposting)

Due to the use of vmalloc area allocations and page table populations,
preparing percpu areas require GFP_KERNEL and all the allocator users
are expected to be able to perform GFP_KERNEL allocations.  This is
mostly okay but there are cases where atomic percpu allocations are
necessary usually in the IO path.

Currently, blk-throttle is implementing its own ad-hoc async
allocation and there are some more planned similar usages.  I posted
[1] percpu_pool which generalizes the percpu atomic allocation a bit
but this was a bit too cumbersome especially to use with other library
data structures which make use of percpu memory as a part of it.

This patchset implements proper atomic allocation support in the
percpu allocator.  It's largely composed of two parts.  The first is
updates to the area allocator so that it can skip non-populated areas.
The second is async filling mechanisms which try to maintain a certain
level of empty populated areas.  The allocator currently tries to keep
the number of empty populated pages between 2 and 4.  Even with fairly
aggressive back-to-back allocations, this seems enough to satisfy most
allocations as long as the allocation size is under a page.

This patchset contains the following 13 patches.

 0001-percpu-remove-the-usage-of-separate-populated-bitmap.patch
 0002-percpu-remove-may_alloc-from-pcpu_get_pages.patch
 0003-percpu-move-common-parts-out-of-pcpu_-de-populate_ch.patch
 0004-percpu-move-region-iterations-out-of-pcpu_-de-popula.patch
 0005-percpu-make-percpu-km-set-chunk-populated-bitmap-pro.patch
 0006-percpu-restructure-locking.patch
 0007-percpu-make-pcpu_alloc_area-capable-of-allocating-on.patch
 0008-percpu-indent-the-population-block-in-pcpu_alloc.patch
 0009-percpu-implement-__-alloc_percpu_gfp.patch
 0010-percpu-make-sure-chunk-map-array-has-available-space.patch
 0011-percpu-implmeent-pcpu_nr_empty_pop_pages-and-chunk-n.patch
 0012-percpu-rename-pcpu_reclaim_work-to-pcpu_balance_work.patch
 0013-percpu-implement-asynchronous-chunk-population.patch

0001-0005 are prep patches.

0006 restructures locking so that populated areas can be given out w/o
grabbing the mutex.

0007-0009 implement alloc_percpu_gfp() which supports atomic
allocations.

0010-0013 implement async filling mechanisms.

This patchset is on top of percpu/for-3.17-fixes 849f5169097e
("percpu: perform tlb flush after pcpu_map_pages() failure") and is
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review-atomic-alloc

 include/linux/percpu.h |   13 -
 mm/percpu-km.c         |   16 -
 mm/percpu-vm.c         |  162 +++------------
 mm/percpu.c            |  523 +++++++++++++++++++++++++++++++++++++++----------
 4 files changed, 479 insertions(+), 235 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/20140718200804.GG13012@htj.dyndns.org
