Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaHLOsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:48:21 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63717 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaHLOsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:48:19 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH 0/5] locks: move most locks_release_private calls outside of i_lock
Date: Tue, 12 Aug 2014 10:48:08 -0400
Message-Id: <1407854893-2698-1-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the days of yore, the file locking code was primarily protected by
the BKL. That changed in commit 72f98e72551fa (locks: turn lock_flocks
into a spinlock), at which point the code was changed to be protected
by a conventional spinlock (mostly due to a push to finally eliminate
the BKL). Since then, the code has been changed to use the i_lock
instead of a global spinlock, but it's still under a spinlock.

With that change, several functions now no longer can block when they
originally could. This is a particular problem with the
fl_release_private operation. In NFSv4, that operation is used to kick
off a RELEASE_LOCKOWNER or FREE_STATEID call, and that requires being
able to do an allocation.

This was reported by Josh Stone here:

    https://bugzilla.redhat.com/show_bug.cgi?id=1089092

My initial stab at fixing this involved moving this to a workqueue, but
Trond pointed out the above change was technically a regression with the
way the spinlocking in the file locking code works, and suggested an
alternate approach to fixing it.

This set focuses on moving most of the locks_release_private calls
outside of the inode->i_lock. There are still a few that are done
under the i_lock in the lease handling code. Cleaning up the use of
the i_lock in the lease code is a larger project which we'll have to
tackle at some point, but there are some other cleanups that will
need to happen first.

Absent any objections, I'll plan to merge these for 3.18.

Jeff Layton (5):
  locks: don't call locks_release_private from locks_copy_lock
  locks: don't reuse file_lock in __posix_lock_file
  locks: defer freeing locks in locks_delete_lock until after i_lock has
    been dropped
  locks: move locks_free_lock calls in do_fcntl_add_lease outside
    spinlock
  locks: update Locking documentation to clarify fl_release_private
    behavior

 Documentation/filesystems/Locking |  6 ++-
 fs/locks.c                        | 80 +++++++++++++++++++++++++--------------
 2 files changed, 57 insertions(+), 29 deletions(-)

-- 
1.9.3

