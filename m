Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaDSPxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 11:53:21 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:43357 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaDSPxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 11:53:18 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Seth Jennings <sjennings@variantweb.net>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] mm: zpool: add common api for zswap to use zbud/zsmalloc
Date: Sat, 19 Apr 2014 11:52:40 -0400
Message-Id: <1397922764-1512-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow zswap users to choose between zbud and zsmalloc for
the compressed storage pool, this patch set adds a new api "zpool" that
provides an interface to both zbud and zsmalloc.  Only a minor change
to zbud's interface was needed, as detailed in the first patch;
zsmalloc required shrinking to be added and a minor interface change,
as detailed in the second patch.

I believe Seth originally was using zsmalloc for swap, but there were
concerns about how significant the impact of shrinking zsmalloc would
be when zswap had to start reclaiming pages.  That still may be an
issue, but this at least allows users to choose themselves whether
they want a lower-density or higher-density compressed storage medium.
At least for situations where zswap reclaim is never or rarely reached,
it probably makes sense to use the higher density of zsmalloc.

Note this patch series does not change zram to use zpool, although that
change should be possible as well.


Dan Streetman (4):
  mm: zpool: zbud_alloc() minor param change
  mm: zpool: implement zsmalloc shrinking
  mm: zpool: implement common zpool api to zbud/zsmalloc
  mm: zpool: update zswap to use zpool

 drivers/block/zram/zram_drv.c |   2 +-
 include/linux/zbud.h          |   3 +-
 include/linux/zpool.h         | 166 ++++++++++++++++++
 include/linux/zsmalloc.h      |   7 +-
 mm/Kconfig                    |  43 +++--
 mm/Makefile                   |   1 +
 mm/zbud.c                     |  28 ++--
 mm/zpool.c                    | 380 ++++++++++++++++++++++++++++++++++++++++++
 mm/zsmalloc.c                 | 168 +++++++++++++++++--
 mm/zswap.c                    |  70 ++++----
 10 files changed, 787 insertions(+), 81 deletions(-)
 create mode 100644 include/linux/zpool.h
 create mode 100644 mm/zpool.c

-- 
1.8.3.1

