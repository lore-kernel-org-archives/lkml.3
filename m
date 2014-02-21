Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaBULyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:54:16 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:51539 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbaBULyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:54:15 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv6 0/6] add compressing abstraction and multi stream support
Date: Fri, 21 Feb 2014 14:50:37 +0300
Message-Id: <1392983443-9807-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.291.g027825b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces zcomp compression backend abstraction
adding ability to support compression algorithms other than LZO;
support for multi compression streams, making parallel compressions
possible.

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

v3->v4:
-- renamed compression backend and working memory structs as requested
   by Minchan Kim; fixed several issues noted by Minchan Kim.


Sergey Senozhatsky (6):
  zram: introduce compressing backend abstraction
  zram: use zcomp compressing backends
  zram: factor out single stream compression
  zram: add multi stream functionality
  zram: enalbe multi stream compression support in zram
  zram: document max_comp_streams

 Documentation/ABI/testing/sysfs-block-zram |   9 +-
 Documentation/blockdev/zram.txt            |  24 ++-
 drivers/block/zram/Kconfig                 |  10 ++
 drivers/block/zram/Makefile                |   2 +-
 drivers/block/zram/zcomp.c                 | 271 +++++++++++++++++++++++++++++
 drivers/block/zram/zcomp.h                 |  56 ++++++
 drivers/block/zram/zcomp_lzo.c             |  48 +++++
 drivers/block/zram/zram_drv.c              | 103 +++++++----
 drivers/block/zram/zram_drv.h              |  10 +-
 9 files changed, 486 insertions(+), 47 deletions(-)
 create mode 100644 drivers/block/zram/zcomp.c
 create mode 100644 drivers/block/zram/zcomp.h
 create mode 100644 drivers/block/zram/zcomp_lzo.c

-- 
1.9.0.291.g027825b

