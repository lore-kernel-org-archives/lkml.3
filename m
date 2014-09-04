Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbaIDHvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:51:16 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47703 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783AbaIDHvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:51:14 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: gioh.kim@lge.com, akpm@linux-foundation.org, jack@suse.cz, tytso@mit.edu,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org,
        adilger.kernel@dilger.ca
Cc: minchan@kernel.org, js1304@gmail.com, gunho.lee@lge.com
Subject: [PATCHv4 0/3] new APIs to allocate buffer-cache with user specific flag
Date: Thu,  4 Sep 2014 16:29:38 +0900
Message-Id: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch try to solve problem that a long-lasting page caches of
ext4 superblock and journaling of superblock disturb page migration.

I've been testing CMA feature on my ARM-based platform
and found that two page caches cannot be migrated.
They are page caches of superblock of ext4 filesystem and its journaling data.

Current ext4 reads superblock with sb_bread() that allocates page
from movable area. But the problem is that ext4 hold the page until
it is unmounted. If root filesystem is ext4 the page cannot be migrated
forever.
And also the journaling data for the superblock cannot be migreated.

I introduce new APIs that allocates page cache with specific flag passed by an
argument.
*_gfp APIs are for user want to set page allocation flag for page cache
allocation.
And *_unmovable APIs are for the user wants to allocate page cache from
non-movable area.

It is useful for ext4/ext3 and others that want to hold page cache for a long
time.

I have 3 patchs:

1. Patch 1/3: introduce a new API that create page cache with allocation flag
2. Patch 2/3: have ext4 use the new API to read superblock
3. Patch 3/3: have jbd/jbd2 use the new API to make journaling of superblock

This patchset is based on linux-next-20140814.

Thanks a lot.

Gioh Kim (3):
  fs.c: support buffer cache allocations with gfp modifiers
  ext4: use non-movable memory for the ext4 superblock
  jbd/jbd2: use non-movable memory for the jbd superblock

 fs/buffer.c                 |   45 ++++++++++++++++++++++++-----------------
 fs/ext4/super.c             |    6 +++---
 fs/jbd/journal.c            |    2 +-
 fs/jbd2/journal.c           |    2 +-
 include/linux/buffer_head.h |   47 ++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 73 insertions(+), 29 deletions(-)

-- 
1.7.9.5

