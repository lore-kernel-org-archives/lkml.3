Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaBZMbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:31:44 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33736 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaBZMbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:31:38 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv8 0/6] add compressing abstraction and multi stream support
Date: Wed, 26 Feb 2014 15:27:53 +0300
Message-Id: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.291.g027825b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces zcomp compression backend abstraction
adding ability to support compression algorithms other than LZO;
support for multi compression streams, making parallel compressions
possible.

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

Sergey Senozhatsky (6):
  zram: introduce compressing backend abstraction
  zram: use zcomp compressing backends
  zram: factor out single stream compression
  zram: add multi stream functionality
  zram: add set_max_streams knob
  zram: document max_comp_streams

 Documentation/ABI/testing/sysfs-block-zram |   9 +-
 Documentation/blockdev/zram.txt            |  31 ++-
 drivers/block/zram/Makefile                |   2 +-
 drivers/block/zram/zcomp.c                 | 318 +++++++++++++++++++++++++++++
 drivers/block/zram/zcomp.h                 |  59 ++++++
 drivers/block/zram/zcomp_lzo.c             |  48 +++++
 drivers/block/zram/zram_drv.c              |  98 +++++----
 drivers/block/zram/zram_drv.h              |  10 +-
 8 files changed, 528 insertions(+), 47 deletions(-)
 create mode 100644 drivers/block/zram/zcomp.c
 create mode 100644 drivers/block/zram/zcomp.h
 create mode 100644 drivers/block/zram/zcomp_lzo.c

-- 
1.9.0.291.g027825b

