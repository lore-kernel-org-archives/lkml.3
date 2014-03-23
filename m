Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaCWHQF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 03:16:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55115 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaCWHQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 03:16:04 -0400
Date: Sun, 23 Mar 2014 07:16:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs fixes
Message-ID: <20140323071601.GH18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Several fixes; first 4 commits are obvious fixes (a couple
of fdget_pos()-related ones from Eric Biggers, prepend_name() fix, missing
checks for false negatives from __lookup_mnt() in fs/namei.c), followed
by 4 commits dealing with the bug found by Max last week - switch of
mnt_hash to hlist, to avoid the fun with non-terminating __lookup_mnt().
I'm fairly comfortable with that pile, but whether its second part is OK
at this point is up to you; it seems to survive everything I'd thrown
at it, and it's quite straightforward.  If you really feel that it's
too close to -final, well... alternative variant is to replace the last
4 with "if we are spinning too much in __lookup_mnt(), check mount_lock"
kludge like the one I've posted early in the "don't clobber mnt_hash.next"
thread.  I'd rather go for "let's just use hlist", obviously...

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (6):
      make prepend_name() work correctly when called with negative *buflen
      rcuwalk: recheck mount_lock after mountpoint crossing attempts
      resizable namespace.c hashes
      keep shadowed vfsmounts together
      don't bother with propagate_mnt() unless the target is shared
      switch mnt_hash to hlist

Eric Biggers (2):
      vfs: atomic f_pos access in llseek()
      vfs: Don't let __fdget_pos() get FMODE_PATH files

Diffstat:
 fs/dcache.c     |    4 +-
 fs/file.c       |   19 ++----
 fs/mount.h      |    4 +-
 fs/namei.c      |   29 ++++-----
 fs/namespace.c  |  177 ++++++++++++++++++++++++++++++++++++-------------------
 fs/pnode.c      |   26 ++++----
 fs/pnode.h      |    4 +-
 fs/read_write.c |    4 +-
 8 files changed, 155 insertions(+), 112 deletions(-)
