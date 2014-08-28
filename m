Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965681AbaH1C0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:26:38 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53177 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965650AbaH1C0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:26:35 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53FE9357.6000505@lge.com>
Date: Thu, 28 Aug 2014 11:26:31 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
CC: Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
Subject: [PATCHv3 0/3] new APIs to allocate buffer-cache with user specific
 flag
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
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
it is unmounted. If root filesystem is ext4 the page cannot be migrated forever.
And also the journaling data for the superblock cannot be migreated.

I introduce new APIs that allocates page cache with specific flag passed by an argument.
*_gfp APIs are for user want to set page allocation flag for page cache allocation.
And *_unmovable APIs are for the user wants to allocate page cache from non-movable area.

It is useful for ext4/ext3 and others that want to hold page cache for a long time.

I have 3 patchs:

1. Patch 1/3: introduce a new API that create page cache with allocation flag
2. Patch 2/3: have ext4 use the new API to read superblock
3. Patch 3/3: have jbd/jbd2 use the new API to make journaling of superblock

This patchset is based on linux-next-20140814.

Thanks a lot.

Gioh Kim (3):
 fs/buffer.c: allocate buffer cache with user specific flag
 ext4: allocate buffer-cache for superblock in non-movable area
 jbd-jbd2-allocate-buffer-cache-for-superblock-inode-.patch

 fs/buffer.c                 |   54 ++++++++++++++++++++++++++++++++++----------
 fs/ext4/super.c             |    6 ++--
 fs/jbd/journal.c            |    2 -
 fs/jbd2/journal.c           |    2 -
 include/linux/buffer_head.h |   14 ++++++++++-
 5 files changed, 60 insertions(+), 18 deletions(-)

