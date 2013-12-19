Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3LSNek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:34:40 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:47076 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab3LSNeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:34:37 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/13] locks: implement "filp-private" (aka UNPOSIX) locks
Date: Thu, 19 Dec 2013 08:34:12 -0500
Message-Id: <1387460065-28269-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is the fourth posting of this set. Behavior between this
set and the last should be more or less the same. Here is a summary of
changes:

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

On the last set, I made note that we could consider implementing this
with new cmd values instead of new l_type values. That's still doable
but I haven't made that change in this set. I'm still open to that
change, but I'd like to hear from others as to which they'd prefer.

Note too that I've gone ahead and opened a request for the POSIX folks
to consider adding this to the POSIX spec once we have something
mergeable. They seem amenable to the idea but don't want to enshrine it
into the standard until there's a real implementation of it:

    http://austingroupbugs.net/view.php?id=768

I also owe them a better writeup of the semantics for these new locks,
but have been holding off on doing that until they're a little more
settled.

Original cover letter from v1 posting follows. Comments and suggestions
welcome.

-------------------------------[snip]------------------------------

At LSF this year, there was a discussion about the "wishlist" for
userland file servers. One of the things brought up was the goofy and
problematic behavior of POSIX locks when a file is closed. Boaz started
a thread on it here:

    http://permalink.gmane.org/gmane.linux.file-systems/73364

Userland fileservers often need to maintain more than one open file
descriptor on a file. The POSIX spec says:

"All locks associated with a file for a given process shall be removed
 when a file descriptor for that file is closed by that process or the
 process holding that file descriptor terminates."

This is problematic since you can't close any file descriptor without
dropping all your POSIX locks. Most userland file servers therefore
end up opening the file with more access than is really necessary, and
keeping fd's open for longer than is necessary to work around this.

This patchset is a first stab at an approach to address this problem by
adding two new l_type values -- F_RDLCKP and F_WRLCKP (the 'P' is short
for "private" -- I'm open to changing that if you have a better
mnemonic).

For all intents and purposes these lock types act just like their
"non-P" counterpart. The difference is that they are only implicitly
released when the fd against which they were acquired is closed. As a
side effect, these locks cannot be merged with "non-P" locks since they
have different semantics on close.

I've given this patchset some very basic smoke testing and it seems to
do the right thing, but it is still pretty rough. If this looks
reasonable I'll plan to do some documentation updates and will take a
stab at trying to get these new lock types added to the POSIX spec (as
HCH recommended).

At this point, my main questions are:

1) does this look useful, particularly for fileserver implementors?

2) does this look OK API-wise? We could consider different "cmd" values
   or even different syscalls, but I figured this makes it clearer that
   "P" and "non-P" locks will still conflict with one another.


J. Bruce Fields (2):
  locks: consolidate common code in the flock_to_posix_lock routines
  locks: simplify overflow checking

Jeff Layton (11):
  locks: close potential race between setlease and open
  locks: clean up comment typo
  locks: remove "inline" qualifier from fl_link manipulation functions
  locks: add __acquires and __releases annotations to locks_start and
    locks_stop
  locks: eliminate BUG() call when there's an unexpected lock on file
    close
  locks: consolidate checks for compatible filp->f_mode values in setlk
    handlers
  locks: don't reference original flock struct in F_GETLK handlers
  locks: rename locks_remove_flock to locks_remove_file
  locks: show private lock types in /proc/locks
  locks: report l_pid as -1 for FL_FILE_PVT locks
  locks: add new "private" lock type that is owned by the filp

 fs/file_table.c                  |   2 +-
 fs/locks.c                       | 321 ++++++++++++++++++++++-----------------
 include/linux/fs.h               |  11 +-
 include/uapi/asm-generic/fcntl.h |  19 ++-
 4 files changed, 204 insertions(+), 149 deletions(-)

-- 
1.8.4.2

