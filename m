Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbbAUGOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:14:39 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:38602 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbAUGOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:14:35 -0500
X-Original-SENDERIP: 10.177.222.143
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Nitin Gupta <ngupta@vflare.org>, Juneho Choi <juno.choi@lge.com>,
        Gunho Lee <gunho.lee@lge.com>, Luigi Semenzato <semenzato@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v1 00/10] zsmalloc compaction support
Date: Wed, 21 Jan 2015 15:14:16 +0900
Message-Id: <1421820866-26521-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, there was issue about zsmalloc fragmentation and
I got a report from Juneho that new fork failed although there
are plenty of free pages in the system.
His investigation revealed zram is one of the culprit to make
heavy fragmentation so there was no more contiguous 16K page
for pgd to fork in the ARM.

This patchset implement *basic* zsmalloc compaction support
and zram utilizes it so admin can do

        "echo 1 > /sys/block/zram0/compact"

In my experiment(high compress ratio data with heavy swap in/out
on zram 8G swap), data is as follows,

Before =
zram allocated object :      60212066 bytes
zram total used:     140103680 bytes
ratio:         42.98 percent
MemFree:          840192 kB

Compaction

After =
frag ratio after compaction
zram allocated object :      60212066 bytes
zram total used:      76185600 bytes
ratio:         79.03 percent
MemFree:          901932 kB

This patchset adds more logics in zsmalloc but when I tested
heavy swapin/out program, the regression is marginal because
most of overheads were caused by compress/decompress and
other MM reclaim stuff.

Minchan Kim (10):
  zram: avoid calling of zram_meta_free under init_lock
  zsmalloc: decouple handle and object
  zsmalloc: implement reverse mapping
  zsmalloc: factor out obj_[malloc|free]
  zsmalloc: add status bit
  zsmalloc: support compaction
  zsmalloc: adjust ZS_ALMOST_FULL
  zram: support compaction
  zsmalloc: add fullness into stat
  zsmalloc: record handle in page->private for huge object

 Documentation/ABI/testing/sysfs-block-zram |    8 +
 drivers/block/zram/zram_drv.c              |   30 +-
 drivers/block/zram/zram_drv.h              |    1 +
 include/linux/zsmalloc.h                   |    1 +
 mm/zsmalloc.c                              | 1008 +++++++++++++++++++++-------
 5 files changed, 786 insertions(+), 262 deletions(-)

-- 
1.9.3

