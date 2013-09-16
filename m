Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3IPMvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:51:45 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:56126 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3IPMvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:43 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 00/11] atomic open related fixes
Date: Mon, 16 Sep 2013 14:51:54 +0200
Message-Id: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found an atomic open related fix in the 9p tree (b6f4bee02f); tured out, it
didn't fully fix 9p and introduced another bug in the process and also several
other filesystems are affected by the same bug.  Then I reviewed all the atomic
open implementations and found more bugs.  This series tries to address these.

Only tested the fuse fix, the others are compile tested only.

One issue that crops up several times, and which is not strictly related to
atomic open, is that a non-NULL return value of d_splice_alias() (or ->lookup(),
etc..)  are not handled properly by filesystems.  The reason for this is that a
non-NULL return gets very little testing (only if exported and even then not
easy to trigger).  There should be some way to more easily expose such bugs or
improve the API so that these bugs are harder to introduce.

Thanks,
Miklos

---
Miklos Szeredi (11):
      vfs: improve i_op->atomic_open() documentation
      9p: fix dentry leak in v9fs_vfs_atomic_open_dotl()
      9p: fix O_EXCL in v9fs_vfs_atomic_open()
      fuse: fix O_EXCL in fuse_atomic_open()
      cifs: fix filp leak in cifs_atomic_open()
      gfs2: d_splice_alias() cant return error
      gfs2: pass correct dentry to finish_open() in __gfs2_lookup()
      gfs2: fix dentry leaks
      gfs2: set FILE_CREATED
      nfs: set FILE_CREATED
      vfs: don't set FILE_CREATED before calling ->atomic_open()

---
 Documentation/filesystems/vfs.txt | 14 +++++++-------
 fs/9p/vfs_inode.c                 |  9 ++++++++-
 fs/9p/vfs_inode_dotl.c            |  9 +++++----
 fs/cifs/dir.c                     |  1 +
 fs/fuse/dir.c                     | 10 +++++++++-
 fs/gfs2/inode.c                   | 40 ++++++++++++++++++++++-----------------
 fs/namei.c                        | 11 ++++++++---
 fs/nfs/dir.c                      |  3 +++
 fs/open.c                         | 21 +++++++++++++++++---
 9 files changed, 82 insertions(+), 36 deletions(-)

