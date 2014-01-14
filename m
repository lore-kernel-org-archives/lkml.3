Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaANTHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:07:13 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:38970 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaANTHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:09 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 00/14] locks: implement "file-private" (aka UNPOSIX) locks
Date: Tue, 14 Jan 2014 14:06:40 -0500
Message-Id: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the sixth posting of this patchset. The big change in this set
is that the new cmd values not available via the 32-bit interfaces.
So, programs running natively on 64-bit arches will use fcntl() to
access these as normal. 32-bit programs will need to use fcntl64()
to access them.

At this point, I think I'm pretty happy with this set and will plan
to pursue getting it into linux-next for a bit unless anyone has
objections.

Here is a summary of the more notable changes in each posting:

v6:
- eliminate 32-bit versions of the new cmd values

v5:
- switch to adding new cmd values instead of new l_type values
- corrected patch by Bruce to fix up range overflow handling
- patch to add Bruce and I as maintainers for fs/locks.c
- disable deadlock detection for file-private locks

v4:
- prefixed the set with the rest of the locks.c patches I have.
- added patch to get rid of BUG() call in locks_remove_flock. I think
  a WARN  + delete the lock is sufficient there.
- added patches from Bruce to consolidate the struct flock/flock64
  to file_lock conversion code
- fixed locks_remove_file not to assume that filp-private locks won't
  be added on filesystems that have a ->lock method.

v3:
- more consolidation of common code between flock_to_posix_lock and
  flock_to_posix_lock64
- better bisectability by reordering changes, such that partial
  implementation won't be exposed
- s/filp/file/ s/FILP/FILE/ in symbol names

v2:
- inheritance semantics have been change to be more BSD-lock like
- patchset size has been reduced by changing how lock ownership
  is handled
- new F_UNLCKP l_type value has been added

Note too that I've gone ahead and opened a request for the POSIX folks
to consider adding this to the POSIX spec once we have something
mergeable. They seem amenable to the idea but don't want to enshrine it
into the standard until there's a real implementation of it:

    http://austingroupbugs.net/view.php?id=768

I also owe them a better writeup of the semantics for these new locks,
but have been holding off on doing that until they're a little more
settled.

J. Bruce Fields (1):
  locks: fix posix lock range overflow handling

Jeff Layton (13):
  locks: close potential race between setlease and open
  locks: clean up comment typo
  locks: remove "inline" qualifier from fl_link manipulation functions
  locks: add __acquires and __releases annotations to locks_start and
    locks_stop
  locks: eliminate BUG() call when there's an unexpected lock on file
    close
  locks: consolidate checks for compatible filp->f_mode values in setlk
    handlers
  MAINTAINERS: add Bruce and myself to list of maintainers for file
    locking code
  locks: rename locks_remove_flock to locks_remove_file
  locks: make /proc/locks show IS_FILE_PVT locks with a P suffix
  locks: report l_pid as -1 for FL_FILE_PVT locks
  locks: pass the cmd value to fcntl_getlk/getlk64
  locks: skip deadlock detection on FL_FILE_PVT locks
  locks: add new fcntl cmd values for handling file private locks

 MAINTAINERS                       |   2 +
 arch/arm/kernel/sys_oabi-compat.c |   3 +
 fs/compat.c                       |  35 +++-
 fs/fcntl.c                        |  37 ++--
 fs/file_table.c                   |   2 +-
 fs/locks.c                        | 349 +++++++++++++++++++++++---------------
 include/linux/fs.h                |  21 ++-
 include/uapi/asm-generic/fcntl.h  |  19 ++-
 security/selinux/hooks.c          |   3 +
 9 files changed, 303 insertions(+), 168 deletions(-)

-- 
1.8.4.2

