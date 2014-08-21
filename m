Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaHUA1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 20:27:42 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60740 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaHUA0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 20:26:50 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Dan Streetman <ddstreet@ieee.org>, ds2horner@gmail.com,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v3 0/4] zram memory control enhance
Date: Thu, 21 Aug 2014 09:27:14 +0900
Message-Id: <1408580838-29236-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, zram has no feature to limit memory so theoretically
zram can deplete system memory.
Users have asked for a limit several times as even without exhaustion
zram makes it hard to control memory usage of the platform.
This patchset adds the feature.

Patch 1 makes zs_get_total_size_bytes faster because it would be
used frequently in later patches for the new feature.

Patch 2 changes zs_get_total_size_bytes's return unit from bytes
to page so that zsmalloc doesn't need unnecessary operation(ie,
<< PAGE_SHIFT).

Patch 3 adds new feature. I added the feature into zram layer,
not zsmalloc because limiation is zram's requirement, not zsmalloc
so any other user using zsmalloc(ie, zpool) shouldn't affected
by unnecessary branch of zsmalloc. In future, if every users
of zsmalloc want the feature, then, we could move the feature
from client side to zsmalloc easily but vice versa would be
painful.

Patch 4 adds news facility to report maximum memory usage of zram
so that user can get how many of peak memory zram used easily
without extremely short inverval polling via
/sys/block/zram0/mem_used_total.

* From v2
 * Introduce helper funcntion to update max_used_pages
   for readability - David
 * Avoid unncessary zs_get_total_size call in updating loop
   for max_used_pages - David

* From v1
 * rebased on next-20140815
 * fix up race problem - David, Dan
 * reset mem_used_max as current total_bytes, rather than 0 - David
 * resetting works with only "0" write for extensiblilty - David, Dan

Minchan Kim (4):
  zsmalloc: move pages_allocated to zs_pool
  zsmalloc: change return value unit of zs_get_total_size_bytes
  zram: zram memory size limitation
  zram: report maximum used memory

 Documentation/ABI/testing/sysfs-block-zram | 19 ++++++
 Documentation/blockdev/zram.txt            | 21 +++++--
 drivers/block/zram/zram_drv.c              | 98 +++++++++++++++++++++++++++++-
 drivers/block/zram/zram_drv.h              |  6 ++
 include/linux/zsmalloc.h                   |  2 +-
 mm/zsmalloc.c                              | 38 ++++++------
 6 files changed, 159 insertions(+), 25 deletions(-)

-- 
2.0.0

