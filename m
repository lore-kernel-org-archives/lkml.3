Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaIJO3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:29:01 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:35030 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaIJO25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:28:57 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, bfields@fieldses.org
Subject: [RFC PATCH 00/12] locks: saner method for managing file locks
Date: Wed, 10 Sep 2014 10:28:38 -0400
Message-Id: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently manage all file_locks via a singly-linked list. This is
problematic for a number of reasons:

- we have to protect all file locks with the same spinlock (or
  equivalent). Currently that uses the i_lock, but Christoph has voiced
  objections due to the potential for contention with other i_lock
  users. He'd like to see us move to using a different lock.

- we have to walk through irrelevant file locks in order to get to the
  ones we're interested in. For instance, POSIX locks are at the end
  of the list, so we have to skip over all of the flock locks and
  leases before we can work with them.

- the singly-linked list is primitive and difficult to work with. We
  have to keep track of the "before" pointer and it's easy to get that
  wrong.

Cleaning all of this up is complicated by the fact that no one really
wants to grow struct inode in order to do so. We have a single pointer
in the inode now and I don't think we want to use any more.

One possibility that Trond raised was to move this to an hlist, but
that doesn't do anything about the desire for a new spinlock.

This patchset takes the approach of replacing the i_flock list with a
new struct file_lock_context that is allocated when we intend to add a
new file lock to an inode. The file_lock_context is only freed when we
destroy the inode.

Within that, we have separate (and standard!) lists for each lock type,
and a dedicated spinlock for managing those lists. In principle we could
even consider adding separate locks for each, but I didn't bother with
that for now.

For now, the code is still pretty "raw" and isn't bisectable. This is
just a RFC for the basic approach. This is probably v3.19 material at
best.

Anyone have thoughts or comments on the basic approach?

Jeff Layton (12):
  locks: add a new struct file_locking_context pointer to struct inode
  locks: add new struct list_head to struct file_lock
  locks: have locks_release_file use flock_lock_file to release generic
    flock locks
  locks: move flock locks to file_lock_context
  locks: convert posix locks to file_lock_context
  locks: convert lease handling to file_lock_context
  ceph: convert to looking for locks in struct file_lock_context
  nfs: convert lock handling to use file_lock_context
  cifs: convert it to use file_lock_context
  lockd: convert it to use file_lock_context
  nfsd: convert to file_lock_context
  locks: remove i_flock field from struct inode

 fs/ceph/locks.c      |  45 +++--
 fs/ceph/mds_client.c |   4 -
 fs/cifs/file.c       |  34 ++--
 fs/inode.c           |   3 +-
 fs/lockd/svcsubs.c   |  26 ++-
 fs/locks.c           | 504 ++++++++++++++++++++++++++-------------------------
 fs/nfs/delegation.c  |  37 ++--
 fs/nfs/nfs4state.c   |  24 ++-
 fs/nfs/pagelist.c    |   3 +-
 fs/nfs/write.c       |  39 +++-
 fs/nfsd/nfs4state.c  |  18 +-
 fs/read_write.c      |   2 +-
 include/linux/fs.h   |  25 ++-
 13 files changed, 425 insertions(+), 339 deletions(-)

-- 
1.9.3

