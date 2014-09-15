Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbaIOUUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:20:11 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:34918 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbaIOUUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:20:07 -0400
Date: Mon, 15 Sep 2014 16:20:01 -0400
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
Message-ID: <cover.1410810247.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patcheset introduces an ability to perform a non-blocking read from 
regular files in buffered IO mode. This works by only for those filesystems
that have data in the page cache.

It does this by introducing new syscalls new syscalls readv2/writev2 and
preadv2/pwritev2. These new syscalls behave like the network sendmsg, recvmsg
syscalls that accept an extra flag argument (O_NONBLOCK).

It's a very common patern today (samba, libuv, etc..) use a large threadpool to 
perform buffered IO operations. They submit the work form another thread
that performs network IO and epoll or other threads that perform CPU work. This
leads to increased latency for processing, esp. in the case of data that's
already cached in the page cache.

With the new interface the applications will now be able to fetch the data in
their network / cpu bound thread(s) and only defer to a threadpool if it's not
there. In our own application (VLDB) we've observed a decrease in latency for
"fast" request by avoiding unnecessary queuing and having to swap out current
tasks in IO bound work threads.

I have co-developed these changes with Christoph Hellwig, a whole lot of his
fixes went into the first patch in the series (were squashed with his
approval).

I am going to post the perf report in a reply-to to this RFC.

Christoph Hellwig (3):
  documentation updates
  move flags enforcement to vfs_preadv/vfs_pwritev
  check for O_NONBLOCK in all read_iter instances

Milosz Tanski (4):
  Prepare for adding a new readv/writev with user flags.
  Define new syscalls readv2,preadv2,writev2,pwritev2
  Export new vector IO (with flags) to userland
  O_NONBLOCK flag for readv2/preadv2

 Documentation/filesystems/Locking |    4 +-
 Documentation/filesystems/vfs.txt |    4 +-
 arch/x86/syscalls/syscall_32.tbl  |    4 +
 arch/x86/syscalls/syscall_64.tbl  |    4 +
 drivers/target/target_core_file.c |    6 +-
 fs/afs/internal.h                 |    2 +-
 fs/afs/write.c                    |    4 +-
 fs/aio.c                          |    4 +-
 fs/block_dev.c                    |    9 ++-
 fs/btrfs/file.c                   |    2 +-
 fs/ceph/file.c                    |   10 ++-
 fs/cifs/cifsfs.c                  |    9 ++-
 fs/cifs/cifsfs.h                  |   12 ++-
 fs/cifs/file.c                    |   30 +++++---
 fs/ecryptfs/file.c                |    4 +-
 fs/ext4/file.c                    |    4 +-
 fs/fuse/file.c                    |   10 ++-
 fs/gfs2/file.c                    |    5 +-
 fs/nfs/file.c                     |   13 ++--
 fs/nfs/internal.h                 |    4 +-
 fs/nfsd/vfs.c                     |    4 +-
 fs/ocfs2/file.c                   |   13 +++-
 fs/pipe.c                         |    7 +-
 fs/read_write.c                   |  146 +++++++++++++++++++++++++++++++------
 fs/splice.c                       |    4 +-
 fs/ubifs/file.c                   |    5 +-
 fs/udf/file.c                     |    5 +-
 fs/xfs/xfs_file.c                 |   12 ++-
 include/linux/fs.h                |   16 ++--
 include/linux/syscalls.h          |   12 +++
 include/uapi/asm-generic/unistd.h |   10 ++-
 mm/filemap.c                      |   34 +++++++--
 mm/shmem.c                        |    6 +-
 33 files changed, 306 insertions(+), 112 deletions(-)

-- 
1.7.9.5

