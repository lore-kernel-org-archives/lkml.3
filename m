Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab3ANWcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:32:09 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62874 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab3ANWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:32:06 -0500
Date: Mon, 14 Jan 2013 14:32:02 -0800
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        James.Bottomley@hansenpartnership.com, snitzer@redhat.com
Subject: Bcache v. whatever
Message-ID: <20130114223202.GV26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcache: a block layer SSD cache

Does writethrough and writeback, handles unclean shutdown, and has
various other nifty features. See the wiki and the documentation for
more:

http://bcache.evilpiepirate.org

Over the Christmas break I finally got the tree into a self contained
state that ought to be suitable for merging; this tree is fairly close
to the previous stable tree that people have been running on production
servers for awhile (and that I've been running on this workstation), 

So, I think this is ready for mainline and I'd like to get it in. I
should've tried to push it ages ago, but I was hoping to get in various
block layer cleanups first; I finally deided to work around them in the
meantime since I haven't had time to finish the block layer stuff.

Not everything has been addressed since I last posted for review
feedback - notably the closure code was controversial and for now I've
just moved that into drivers/block/bcache (though I've been refactoring
stuff to make it less asynchronous lately; most of that work is in the
testing/dev branches). The bigger issue IMO is the userspace interface -
I'd like to finish the md integration so it doesn't need userspace stuff
for probing/bootup. So, I'd be fine with it going into staging if that's
the consensus, but it's stable tested code.

The code is available at
http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream

This latest branch is on top of v3.8-rc3:

----------------------------------------------------------------
Kent Overstreet (5):
      Revert "rw_semaphore: remove up/down_read_non_owner"
      Export get_random_int()
      Export blk_fill_rwbs()
      Export __lockdep_no_validate__
      bcache: A block layer cache

 Documentation/ABI/testing/sysfs-block-bcache |  156 ++
 Documentation/bcache.txt                     |  343 ++++
 drivers/char/random.c                        |    1 +
 drivers/md/Kconfig                           |    2 +
 drivers/md/Makefile                          |    1 +
 drivers/md/bcache/Kconfig                    |   41 +
 drivers/md/bcache/Makefile                   |   14 +
 drivers/md/bcache/alloc.c                    |  612 +++++++
 drivers/md/bcache/bcache.h                   | 1207 +++++++++++++
 drivers/md/bcache/bset.c                     | 1175 ++++++++++++
 drivers/md/bcache/bset.h                     |  378 ++++
 drivers/md/bcache/btree.c                    | 2497 ++++++++++++++++++++++++++
 drivers/md/bcache/btree.h                    |  412 +++++
 drivers/md/bcache/closure.c                  |  347 ++++
 drivers/md/bcache/closure.h                  |  670 +++++++
 drivers/md/bcache/debug.c                    |  550 ++++++
 drivers/md/bcache/debug.h                    |   54 +
 drivers/md/bcache/io.c                       |  383 ++++
 drivers/md/bcache/journal.c                  |  703 ++++++++
 drivers/md/bcache/journal.h                  |  159 ++
 drivers/md/bcache/movinggc.c                 |  245 +++
 drivers/md/bcache/request.c                  | 1370 ++++++++++++++
 drivers/md/bcache/request.h                  |   61 +
 drivers/md/bcache/stats.c                    |  239 +++
 drivers/md/bcache/stats.h                    |   58 +
 drivers/md/bcache/super.c                    | 1952 ++++++++++++++++++++
 drivers/md/bcache/sysfs.c                    |  807 +++++++++
 drivers/md/bcache/sysfs.h                    |   98 +
 drivers/md/bcache/trace.c                    |   26 +
 drivers/md/bcache/util.c                     |  382 ++++
 drivers/md/bcache/util.h                     |  587 ++++++
 drivers/md/bcache/writeback.c                |  406 +++++
 include/linux/cgroup_subsys.h                |    6 +
 include/linux/rwsem.h                        |   10 +
 include/linux/sched.h                        |    4 +
 include/trace/events/bcache.h                |  271 +++
 kernel/fork.c                                |    4 +
 kernel/lockdep.c                             |    1 +
 kernel/rwsem.c                               |   16 +
 kernel/trace/blktrace.c                      |    1 +
 40 files changed, 16249 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-block-bcache
 create mode 100644 Documentation/bcache.txt
 create mode 100644 drivers/md/bcache/Kconfig
 create mode 100644 drivers/md/bcache/Makefile
 create mode 100644 drivers/md/bcache/alloc.c
 create mode 100644 drivers/md/bcache/bcache.h
 create mode 100644 drivers/md/bcache/bset.c
 create mode 100644 drivers/md/bcache/bset.h
 create mode 100644 drivers/md/bcache/btree.c
 create mode 100644 drivers/md/bcache/btree.h
 create mode 100644 drivers/md/bcache/closure.c
 create mode 100644 drivers/md/bcache/closure.h
 create mode 100644 drivers/md/bcache/debug.c
 create mode 100644 drivers/md/bcache/debug.h
 create mode 100644 drivers/md/bcache/io.c
 create mode 100644 drivers/md/bcache/journal.c
 create mode 100644 drivers/md/bcache/journal.h
 create mode 100644 drivers/md/bcache/movinggc.c
 create mode 100644 drivers/md/bcache/request.c
 create mode 100644 drivers/md/bcache/request.h
 create mode 100644 drivers/md/bcache/stats.c
 create mode 100644 drivers/md/bcache/stats.h
 create mode 100644 drivers/md/bcache/super.c
 create mode 100644 drivers/md/bcache/sysfs.c
 create mode 100644 drivers/md/bcache/sysfs.h
 create mode 100644 drivers/md/bcache/trace.c
 create mode 100644 drivers/md/bcache/util.c
 create mode 100644 drivers/md/bcache/util.h
 create mode 100644 drivers/md/bcache/writeback.c
 create mode 100644 include/trace/events/bcache.h
