Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaIDBi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:38:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42016 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaIDBi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:38:26 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, Nitin Gupta <ngupta@vflare.org>,
        Luigi Semenzato <semenzato@google.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 0/3] make vm aware of zram-swap
Date: Thu,  4 Sep 2014 10:39:43 +0900
Message-Id: <1409794786-10951-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VM uses nr_swap_pages as one of information when it reclaims
anonymous page because nr_swap_pages means how many freeable
space in swap so VM is able to throttle swap out if it found
there is no more space in swap.

But for zram-swap, there is size gap between virtual disksize
and physical memory to be able to store compressed memory so
nr_swap_pages is not correct parameter to throttle swap.

It causes endless anonymous reclaim(ie, swapout) even if there
is no free space in zram-swap so it makes system unresponsive.

This patch adds new hint SWAP_GET_FREE so zram can return how
many of freeable space to VM. With using that, VM can know whether
zram is full and substract remained freeable space from
nr_swap_pages to make it less than 0. IOW, from now on, VM sees
there is no more space of zram so that it will stop anonymous
reclaiming until swap_entry_free free a page which increases
nr_swap_pages again.

With this patch, user will see OOM when zram-swap is full
instead of hang with no response.

Minchan Kim (3):
  zram: generalize swap_slot_free_notify
  mm: add swap_get_free hint for zram
  zram: add swap_get_free hint

 Documentation/filesystems/Locking |  7 ++----
 drivers/block/zram/zram_drv.c     | 36 +++++++++++++++++++++++++--
 include/linux/blkdev.h            |  8 ++++--
 mm/page_io.c                      |  7 +++---
 mm/swapfile.c                     | 52 +++++++++++++++++++++++++++++++++++----
 5 files changed, 93 insertions(+), 17 deletions(-)

-- 
2.0.0

