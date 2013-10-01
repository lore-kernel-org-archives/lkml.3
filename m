Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab3JAQAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:00:36 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:44959 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3JAQAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:00:04 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, tytso@mit.edu, mszeredi@suse.cz
Subject: [RFC PATCH 0/7] cross rename
Date: Tue,  1 Oct 2013 18:00:32 +0200
Message-Id: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds a new syscall, renameat2(), which is the same as renameat() but
with a flags argument.  Internally i_op->reaname2() is also added, which can
later be merged with ->rename() but is kept separately for now, since this would
just blow up this patch without helping review.

The purpose of extending rename is to add cross-rename, a symmetric variant of
rename, which exchanges the two files.  This allows interesting things, which
were not possible before, for example atomically replacing a directory tree with
a symlink, etc...

The other reason to introduce this is for whiteout handling in union/overlay
solutions in an atomic manner without having to add complex code to each
filesystem's rmdir, mkdir and rename just for handling whiteouts.  With
cross-rename it becomes possible to handle whiteouts in a generic manner in most
of the cases:

rmdir(P) where P needs to be whiteout:
  - create-whiteout(orphan/X)
  - exchange(orphan/X, P)
  - rmdir(orphan/X)

mkdir(P) where P is currently a whiteout:
  - mkdir(orphan/X)
  - exchange(orphan/X, P)
  - unlink(orphan/X)

rename(P, Q) where P needs to be whiteout and Q is negative:
  - create-whiteout(Q)
  - exchange(P, Q)

rename(P, Q) where Q is a directory containing only whiteouts:
  - mkdir(orphan/X) (marked as opaque)
  - exchange(orphan/X, Q)
  - recursive-remove(orphan/X)
  - rename(P, Q)

The case that cannot be handled with cross rename is:

rename(P, Q) where P needs to be whiteout and Q exists

For this case a new rename flag will be propsed that atomically creates the
whiteout.

Thanks,
Miklos

---
Miklos Szeredi (7):
      vfs: rename: move d_move() up
      vfs: rename: use common code for dir and non-dir
      vfs: add renameat2 syscall and cross-rename
      ext4: rename: create ext4_renament structure for local vars
      ext4: rename: move EMLINK check up
      ext4: rename: split out helper functions
      ext4: add cross rename support

---
 arch/x86/syscalls/syscall_64.tbl |   1 +
 fs/dcache.c                      |  46 ++++-
 fs/ext4/namei.c                  | 379 +++++++++++++++++++++++++--------------
 fs/namei.c                       | 218 ++++++++++++----------
 include/linux/dcache.h           |   1 +
 include/linux/fs.h               |   2 +
 include/uapi/linux/fs.h          |   2 +
 7 files changed, 415 insertions(+), 234 deletions(-)


