Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab3JXPtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:49:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56417 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3JXPtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:49:45 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Subject: [PATCHSET driver-core-next] sysfs: separate out kernfs, part #1
Date: Thu, 24 Oct 2013 11:49:06 -0400
Message-Id: <1382629780-10006-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains 34 patches to separate out core sysfs features
into kernfs.  kernfs exclusively deals with sysfs_dirent, which will
be later renamed to kernfs_node, and kernfs_ops.  sysfs becomes a
wrapping layer over sysfs which interfaces kobject and
[bin_]attribute.

The goal of these changes is to allow other users to make use of the
core features of sysfs instead of rolling their own pseudo filesystem
implementation which usually fails to deal with issues with file
shutdowns, locking separation from vfs layer and so on.  This patchset
refactors sysfs and separates out most core functionalities to kernfs;
however, the mount code hasn't been updated yet and it can't be used
by other users yet.  The patchset is pretty big already and the two
steps can be separated relatively well, so I think this is a good
split point.

This patchset shouldn't introduce any behavior differences and
contains the following 34 patches.

 0001-sysfs-merge-sysfs_elem_bin_attr-into-sysfs_elem_attr.patch
 0002-sysfs-honor-bin_attr.attr.ignore_lockdep.patch
 0003-sysfs-remove-unused-sysfs_get_dentry-prototype.patch
 0004-sysfs-move-sysfs_hash_and_remove-to-fs-sysfs-dir.c.patch
 0005-sysfs-separate-out-dup-filename-warning-into-a-separ.patch
 0006-sysfs-make-__sysfs_add_one-fail-if-the-parent-isn-t-.patch
 0007-sysfs-kernfs-add-skeletons-for-kernfs.patch
 0008-sysfs-kernfs-introduce-kernfs_remove-_by_name-_ns.patch
 0009-sysfs-kernfs-introduce-kernfs_create_link.patch
 0010-sysfs-kernfs-introduce-kernfs_rename-_ns.patch
 0011-sysfs-kernfs-introduce-kernfs_setattr.patch
 0012-sysfs-kernfs-replace-sysfs_dirent-s_dir.kobj-and-s_a.patch
 0013-sysfs-kernfs-introduce-kernfs_create_dir-_ns.patch
 0014-sysfs-kernfs-prepare-read-path-for-kernfs.patch
 0015-sysfs-kernfs-prepare-write-path-for-kernfs.patch
 0016-sysfs-kernfs-prepare-llseek-path-for-kernfs.patch
 0017-sysfs-kernfs-prepare-mmap-path-for-kernfs.patch
 0018-sysfs-kernfs-prepare-open-release-poll-paths-for-ker.patch
 0019-sysfs-kernfs-move-sysfs_open_file-to-include-linux-k.patch
 0020-sysfs-kernfs-introduce-kernfs_ops.patch
 0021-sysfs-kernfs-add-sysfs_dirent-s_attr.size.patch
 0022-sysfs-kernfs-remove-SYSFS_KOBJ_BIN_ATTR.patch
 0023-sysfs-kernfs-introduce-kernfs_create_file-_ns.patch
 0024-sysfs-kernfs-remove-sysfs_add_one.patch
 0025-sysfs-kernfs-add-kernfs_ops-seq_-start-next-stop.patch
 0026-sysfs-kernfs-introduce-kernfs_notify.patch
 0027-sysfs-kernfs-reorganize-SYSFS_-constants.patch
 0028-sysfs-kernfs-revamp-sysfs_dirent-active_ref-lockdep-.patch
 0029-sysfs-kernfs-introduce-kernfs-_find_and-_get-and-ke.patch
 0030-sysfs-kernfs-move-internal-decls-to-fs-kernfs-kernfs.patch
 0031-sysfs-kernfs-move-inode-code-to-fs-kernfs-inode.c.patch
 0032-sysfs-kernfs-move-dir-core-code-to-fs-kernfs-dir.c.patch
 0033-sysfs-kernfs-move-file-core-code-to-fs-kernfs-file.c.patch
 0034-sysfs-kernfs-move-symlink-core-code-to-fs-kernfs-sym.patch

0001-0006 are prep patches.

0007 preps fs/kernfs/ directory with skeleton files.

0008-0029 refactor various code paths so that all externally visible
interfaces are split to core kernfs interface which deals with
sysfs_dirent and kernfs_ops and sysfs wrapping it to provide the
existing interface.

0030-0034 move kernfs part of the implementation under fs/kernfs.

This patchset is on top of

  driver-core-next 0cba7de7f6cd ("input: gameport: convert bus code to use dev_groups")
+ [1] sysfs: fix sysfs_write_file for bin file

While this patchset doesn't depend on it, it probably would be a good
idea to apply the fix for devm.kmalloc bug before applying these as
that bug makes bisecting quite painful.

diffstat follows.  Thanks.

 fs/Makefile                 |   2 +-
 fs/kernfs/Makefile          |   5 +
 fs/kernfs/dir.c             | 978 ++++++++++++++++++++++++++++++++++++++++++++
 fs/kernfs/file.c            | 800 ++++++++++++++++++++++++++++++++++++
 fs/kernfs/inode.c           | 336 +++++++++++++++
 fs/kernfs/kernfs-internal.h | 157 +++++++
 fs/kernfs/symlink.c         | 147 +++++++
 fs/sysfs/Makefile           |   2 +-
 fs/sysfs/dir.c              | 965 +------------------------------------------
 fs/sysfs/file.c             | 914 ++++++++---------------------------------
 fs/sysfs/group.c            |  59 +--
 fs/sysfs/inode.c            | 357 ----------------
 fs/sysfs/mount.c            |  14 -
 fs/sysfs/symlink.c          | 156 +------
 fs/sysfs/sysfs.h            | 208 +---------
 include/linux/kernfs.h      | 185 +++++++++
 include/linux/sysfs.h       |  43 +-
 17 files changed, 2871 insertions(+), 2457 deletions(-)
 create mode 100644 fs/kernfs/Makefile
 create mode 100644 fs/kernfs/dir.c
 create mode 100644 fs/kernfs/file.c
 create mode 100644 fs/kernfs/inode.c
 create mode 100644 fs/kernfs/kernfs-internal.h
 create mode 100644 fs/kernfs/symlink.c
 delete mode 100644 fs/sysfs/inode.c
 create mode 100644 include/linux/kernfs.h

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1584113
