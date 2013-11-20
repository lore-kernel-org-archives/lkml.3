Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3KTQpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:45:19 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:55254 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab3KTQpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:45:15 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [RFC PATCH v2 0/5] locks: implement "filp-private" (aka UNPOSIX) locks
Date: Wed, 20 Nov 2013 11:45:01 -0500
Message-Id: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is the second posting of this set. Here's an overview of
the changes:

The inheritance semantics have been changed to be much more like BSD
(aka flock()) locks. With this change, what we basically have are a
hybrid of BSD and POSIX locks. They conflict with "classic" POSIX locks
but are not noticed by flock() locks.  OTOH, they act like flock locks
with respect to inheritance and behavior when an fd is closed.

This change actually makes the patchset smaller. Instead of needing a
bunch of special handling, we can simply consider these new locks to be
a POSIX lock like any other and simply give them a different fl_owner
value (that of the filp). This does mean that we need to add a new
F_UNLCKP l_type value, but I think that's a reasonable thing to do
anyway.

Note too that I've gone ahead and opened a request for the POSIX folks
to consider adding this to the POSIX spec once we have something
mergeable. They seem amenable to the idea but don't want to enshrine it
into the standard until there's a real implementation of it:

    http://austingroupbugs.net/view.php?id=768

The code changes are pretty straightforward, so my questions are pretty
much the same as that in the last set. Cover letter from the v1 posting
follows.

Comments and suggestions welcome...

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

Jeff Layton (5):
  locks: consolidate checks for compatible filp->f_mode values in setlk
    handlers
  locks: rename locks_remove_flock to locks_remove_filp
  locks: add new "private" lock type that is owned by the filp
  locks: show private lock types in /proc/locks
  locks: report l_pid as -1 for FL_FILP_PRIVATE locks

 fs/file_table.c                  |   2 +-
 fs/locks.c                       | 102 ++++++++++++++++++++++-----------------
 include/linux/fs.h               |   5 +-
 include/uapi/asm-generic/fcntl.h |  15 ++++++
 4 files changed, 78 insertions(+), 46 deletions(-)

-- 
1.8.3.1

