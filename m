Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3IPHIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:08:51 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56087 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3IPHIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:08:50 -0400
X-AuditID: 9c93017e-b7b60ae000007051-32-5236ae8125f5
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, ch0.han@lge.com, gunho.lee@lge.com,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 0/5] squashfs enhance
Date: Mon, 16 Sep 2013 16:08:34 +0900
Message-Id: <1379315319-7752-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our proudct have used squashfs for rootfs and it saves a few bucks
per device. Super thanks, Squashfs! You were a perfect for us.
But unfortunately, our device start to become complex so sometime
we need better throughput for sequential I/O but current squashfs
couldn't meet our usecase.

When I dive into the code, it has some problems.

1) Too many copy
2) Only a decompression stream buffer so that concurrent read stuck with that
3) short of readpages

This patchset try to solve above problems.

Just two patches are clean up so it shouldn't change any behavior.
And functions factored out will be used for later patches.
If they changes some behavior, it's not what I intended. :(

3rd patch removes cache usage for (not-fragemented, no-tail-end)
data pages so that we can reduce memory copy.

4th patch supports multiple decompress stream buffer so concurrent
read could be handled at the same time. When I tested experiment,
It obviously reduces a half time.

5th patch try to implement asynchronous readahead functions
so I found it can enhance about 35% with lots of I/O merging.

Any comments are welcome.
Thanks.

Minchan Kim (5):
  squashfs: clean up squashfs_read_data
  squashfs: clean up squashfs_readpage
  squashfs: remove cache for normal data page
  squashfs: support multiple decompress stream buffer
  squashfs: support readpages

 fs/squashfs/block.c          |  245 +++++++++-----
 fs/squashfs/cache.c          |   16 +-
 fs/squashfs/decompressor.c   |  107 +++++-
 fs/squashfs/decompressor.h   |   27 +-
 fs/squashfs/file.c           |  738 ++++++++++++++++++++++++++++++++++++++----
 fs/squashfs/lzo_wrapper.c    |   12 +-
 fs/squashfs/squashfs.h       |   12 +-
 fs/squashfs/squashfs_fs_sb.h |   11 +-
 fs/squashfs/super.c          |   44 ++-
 fs/squashfs/xz_wrapper.c     |   20 +-
 fs/squashfs/zlib_wrapper.c   |   12 +-
 11 files changed, 1024 insertions(+), 220 deletions(-)

-- 
1.7.9.5

