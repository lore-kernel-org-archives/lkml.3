Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaB1Rzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:55:47 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:61907 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaB1Rzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:55:45 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv9 0/7] add compressing abstraction and multi stream support
Date: Fri, 28 Feb 2014 20:52:00 +0300
Message-Id: <1393609927-22090-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.359.g5e34a15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces zcomp compression backend abstraction
adding ability to support compression algorithms other than LZO;
support for multi compression streams, making parallel compressions
possible; adds support for LZ4 compression algorithm.

v8->v9 (reviewed by Andrew Morton):
-- add LZ4 backend (+iozone test vs LZO)
-- merge patches 'zram: document max_comp_streams' and 'zram: add multi
   stream functionality'
-- do not extern backend struct from source file
-- use find()/release() naming instead of get()/put()
-- minor code, commit messages and code comments `nitpicks'
-- removed Acked-by Minchan Kim from first two patches, because I've
   changed them a bit.

v7->v8 (reviewed by Minchan Kim):
-- merge patches 'add multi stream functionality' and 'enable multi
   stream compression support in zram'
-- return status code from set_max_streams knob and print message on
   error
-- do not use atomic type for ->avail_strm
-- return back: allocate by default only one stream for multi stream backend
-- wake sleeping write in zcomp_strm_multi_put() only if we put stream
   to idle list
-- minor code `nitpicks'

v6->v7 (reviewed by Minchan Kim):
-- enable multi and single stream support out of the box (drop
   ZRAM_MULTI_STREAM config option)
-- add set_max_stream knob, so we can adjust max number of compression
   streams in runtime (for multi stream backend at the moment)
-- minor code `nitpicks'

v5->v6 (reviewed by Minchan Kim):
-- handle single compression stream case separately, using mutex locking,
   to address perfomance regression
-- handle multi compression stream using spin lock and wait_event()/wake_up()
-- make multi compression stream support configurable (ZRAM_MULTI_STREAM
   config option)

v4->v5 (reviewed by Minchan Kim):
-- renamed zcomp buffer_lock; removed src len and dst len from
   compress() and decompress(); not using term `buffer' and
   `workmem' in code and documentation; define compress() and
   decompress() functions for LZO backend; not using goto's;
   do not put idle zcomp_strm to idle list tail.

v3->v4 (reviewed by Minchan Kim):
-- renamed compression backend and working memory structs as requested
   by Minchan Kim; fixed several issues noted by Minchan Kim.

Sergey Senozhatsky (7):
  zram: introduce compressing backend abstraction
  zram: use zcomp compressing backends
  zram: factor out single stream compression
  zram: add multi stream functionality
  zram: add set_max_streams knob
  zram: make compression algorithm selection possible
  zram: add lz4 algorithm backend

 Documentation/ABI/testing/sysfs-block-zram |  17 +-
 Documentation/blockdev/zram.txt            |  45 +++-
 drivers/block/zram/Kconfig                 |  10 +
 drivers/block/zram/Makefile                |   4 +-
 drivers/block/zram/zcomp.c                 | 349 +++++++++++++++++++++++++++++
 drivers/block/zram/zcomp.h                 |  68 ++++++
 drivers/block/zram/zcomp_lz4.c             |  47 ++++
 drivers/block/zram/zcomp_lz4.h             |  17 ++
 drivers/block/zram/zcomp_lzo.c             |  47 ++++
 drivers/block/zram/zcomp_lzo.h             |  17 ++
 drivers/block/zram/zram_drv.c              | 131 ++++++++---
 drivers/block/zram/zram_drv.h              |  11 +-
 12 files changed, 715 insertions(+), 48 deletions(-)
 create mode 100644 drivers/block/zram/zcomp.c
 create mode 100644 drivers/block/zram/zcomp.h
 create mode 100644 drivers/block/zram/zcomp_lz4.c
 create mode 100644 drivers/block/zram/zcomp_lz4.h
 create mode 100644 drivers/block/zram/zcomp_lzo.c
 create mode 100644 drivers/block/zram/zcomp_lzo.h

-- 
1.9.0.359.g5e34a15

