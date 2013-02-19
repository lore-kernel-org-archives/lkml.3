Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab3BSSH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:07:28 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:61208 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208Ab3BSSH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:07:27 -0500
Date: Tue, 19 Feb 2013 10:07:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Rusty Russell <rusty@rustcorp.com.au>, arjan@linux.intel.com
Subject: [GIT PULL] async changes for 3.9-rc1
Message-ID: <20130219180722.GO17414@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

These are followups for the earlier deadlock issue involving async
ending up waiting for itself through block requesting module[1].  The
following changes are made by these commits.

* Instead of requesting default elevator on each request_queue init,
  block now requests it once early during boot.

* Kmod triggers warning if invoked from an async worker.

* Async synchronization implementation has been reimplemented.  It's a
  lot simpler now.

This branch depends on wq/for-3.9 for current_is_async() and this pull
request assumes that wq/for-3.9 is already pulled in.  It also
contains a pull from 3.8-rc4 to base async synchronization
reimplementation on top of async fixes there.

The changes are available in the following git branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.9-async

for you to fetch changes up to a0327ff0eda915be623658babacef706099c11a8:

  async: initialise list heads to fix crash (2013-01-25 09:14:48 -0800)

----------------------------------------------------------------
James Hogan (1):
      async: initialise list heads to fix crash

Tejun Heo (8):
      init, block: try to load default elevator module early during boot
      block: don't request module during elevator init
      async, kmod: warn on synchronous request_module() from async workers
      Merge branch 'master' into for-3.9-async
      async: bring sanity to the use of words domain and running
      async: use ULLONG_MAX for infinity cookie value
      async: keep pending tasks on async_domain and remove async_pending
      async: replace list of active domains with global list of pending items

 block/elevator.c            |  35 +++++++--
 include/linux/async.h       |  10 +--
 include/linux/elevator.h    |   5 ++
 include/linux/init.h        |   1 +
 init/do_mounts_initrd.c     |   3 +
 init/initramfs.c            |   8 +-
 init/main.c                 |  16 ++++
 kernel/async.c              | 167 ++++++++++++++++++-----------------------
 kernel/kmod.c               |   9 +++
 kernel/sched/core.c         |   2 +-
 kernel/workqueue.c          | 178 +++++++++++++++++---------------------------
 kernel/workqueue_internal.h |  66 ++++++++++++++++
 kernel/workqueue_sched.h    |   9 ---
 13 files changed, 280 insertions(+), 229 deletions(-)
 create mode 100644 kernel/workqueue_internal.h
 delete mode 100644 kernel/workqueue_sched.h

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1420814
