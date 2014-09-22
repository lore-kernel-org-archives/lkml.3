Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaIVACo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 20:02:44 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:42447 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaIVACl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 20:02:41 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, Nitin Gupta <ngupta@vflare.org>,
        Luigi Semenzato <semenzato@google.com>, juno.choi@lge.com,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v1 0/5] stop anon reclaim when zram is full
Date: Mon, 22 Sep 2014 09:03:06 +0900
Message-Id: <1411344191-2842-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For zram-swap, there is size gap between virtual disksize
and available physical memory size for zram so that VM
can try to reclaim anonymous pages even though zram is full.
It makes system alomost hang(ie, unresponsible) easily in
my kernel build test(ie, 1G DRAM, CPU 12, 4G zram swap,
50M zram limit). VM should have killed someone.

This patch adds new hint SWAP_FULL so VM can ask fullness
to zram and if it founds zram is full, VM doesn't reclaim
anonymous pages until zram-swap gets new free space.

With this patch, I see OOM when zram-swap is full instead of
hang with no response.

Minchan Kim (5):
  zram: generalize swap_slot_free_notify
  mm: add full variable in swap_info_struct
  mm: VM can be aware of zram fullness
  zram: add swap full hint
  zram: add fullness knob to control swap full

 Documentation/ABI/testing/sysfs-block-zram |  10 +++
 Documentation/filesystems/Locking          |   4 +-
 drivers/block/zram/zram_drv.c              | 114 +++++++++++++++++++++++++++--
 drivers/block/zram/zram_drv.h              |   2 +
 include/linux/blkdev.h                     |   8 +-
 include/linux/swap.h                       |   1 +
 mm/page_io.c                               |   6 +-
 mm/swapfile.c                              |  77 ++++++++++++++-----
 8 files changed, 189 insertions(+), 33 deletions(-)

-- 
2.0.0

