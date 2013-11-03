Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3KCJxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:53:25 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:57735 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3KCJxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:53:23 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: [PATCHSET driver-core-next] sysfs: separate out kernfs, take #2
Date: Sun,  3 Nov 2013 04:52:39 -0500
Message-Id: <1383472398-17812-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

(This is for 3.14-rc1.  Posting early for review.  Will refresh and
repost once the next driver-core-next opens.)

This is the second take of the patchset to separate out kernfs from
sysfs.

Changes from the last take[L] are,

* Patches applied to driver-core-next are dropped and the rest are
  refreshed.

* Mount portion of kernfs implemented.  kernfs now supports multiple
  sysfs_dirent hierarchies and sysfs is just one of them.

* Dummy interface for kernfs for !CONFIG_SYSFS updated to return
  -ENOSYS / ERR_PTR(-ENOSYS) where applicable.

* Several bug fixes.

This patchset contains 39 patches to separate out core sysfs features
into kernfs.  kernfs exclusively deals with sysfs_dirent, which will
be later renamed to kernfs_node, and kernfs_ops.  sysfs becomes a
wrapping layer over sysfs which interfaces kobject and
[bin_]attribute.

The goal of these changes is to allow other users to make use of the
core features of sysfs instead of rolling their own pseudo filesystem
implementation which usually fails to deal with issues with file
shutdowns, locking separation from vfs layer and so on.  This patchset
refactors sysfs and separates out core functionalities to kernfs.
After the patchset, kernfs is fully functional - multiple sysfs_dirent
hierarchies can be created and mounted and sysfs is just one user of
kernfs.

This patchset shouldn't introduce any behavior differences and
contains the following patches.

 0001-sysfs-make-__sysfs_add_one-fail-if-the-parent-isn-t-.patch
 0002-sysfs-kernfs-add-skeletons-for-kernfs.patch
 0003-sysfs-kernfs-introduce-kernfs_remove-_by_name-_ns.patch
 0004-sysfs-kernfs-introduce-kernfs_create_link.patch
 0005-sysfs-kernfs-introduce-kernfs_rename-_ns.patch
 0006-sysfs-kernfs-introduce-kernfs_setattr.patch
 0007-sysfs-kernfs-replace-sysfs_dirent-s_dir.kobj-and-s_a.patch
 0008-sysfs-kernfs-introduce-kernfs_create_dir-_ns.patch
 0009-sysfs-kernfs-prepare-read-path-for-kernfs.patch
 0010-sysfs-kernfs-prepare-write-path-for-kernfs.patch
 0011-sysfs-kernfs-prepare-mmap-path-for-kernfs.patch
 0012-sysfs-kernfs-prepare-open-release-poll-paths-for-ker.patch
 0013-sysfs-kernfs-move-sysfs_open_file-to-include-linux-k.patch
 0014-sysfs-kernfs-introduce-kernfs_ops.patch
 0015-sysfs-kernfs-add-sysfs_dirent-s_attr.size.patch
 0016-sysfs-kernfs-remove-SYSFS_KOBJ_BIN_ATTR.patch
 0017-sysfs-kernfs-introduce-kernfs_create_file-_ns.patch
 0018-sysfs-kernfs-remove-sysfs_add_one.patch
 0019-sysfs-kernfs-add-kernfs_ops-seq_-start-next-stop.patch
 0020-sysfs-kernfs-introduce-kernfs_notify.patch
 0021-sysfs-kernfs-reorganize-SYSFS_-constants.patch
 0022-sysfs-kernfs-revamp-sysfs_dirent-active_ref-lockdep-.patch
 0023-sysfs-kernfs-introduce-kernfs-_find_and-_get-and-ker.patch
 0024-sysfs-kernfs-move-internal-decls-to-fs-kernfs-kernfs.patch
 0025-sysfs-kernfs-move-inode-code-to-fs-kernfs-inode.c.patch
 0026-sysfs-kernfs-move-dir-core-code-to-fs-kernfs-dir.c.patch
 0027-sysfs-kernfs-move-file-core-code-to-fs-kernfs-file.c.patch
 0028-sysfs-kernfs-move-symlink-core-code-to-fs-kernfs-sym.patch
 0029-sysfs-kernfs-drop-unused-params-from-sysfs_fill_supe.patch
 0030-sysfs-kernfs-make-sysfs_super_info-ns-const.patch
 0031-sysfs-kernfs-no-need-to-kern_mount-sysfs-from-sysfs_.patch
 0032-sysfs-kernfs-introduce-sysfs_root_sd.patch
 0033-sysfs-kernfs-implement-kernfs_create-destroy_root.patch
 0034-sysfs-kernfs-make-inode-number-ida-per-kernfs_root.patch
 0035-sysfs-kernfs-make-super_blocks-bind-to-different-ker.patch
 0036-sysfs-kernfs-prepare-mount-path-for-kernfs.patch
 0037-sysfs-kernfs-move-mount-core-code-to-fs-kernfs-mount.patch
 0038-sysfs-kernfs-make-sysfs_dirent-definition-public.patch
 0039-sysfs-kernfs-remove-cross-inclusions-of-internal-hea.patch

 0001 is prep patch.

 0002 preps fs/kernfs/ directory with skeleton files.

 0003-0023 refactor various code paths so that all externally visible
 interfaces are split to core kernfs interface which deals with
 sysfs_dirent and kernfs_ops and sysfs wrapping it to provide the
 existing interface.

 0024-0028 move kernfs part of the implementation under fs/kernfs.

 0029-0035 update mount logic so that it can support multiple
 sysfs_dirent hierarchies instead of assuming single sysfs hierarchy.

 0036-0037 refactor mount code path for kernfs and moves kernfs
 interface and implementation to fs/kernfs.

 0038-0039 cut the remaining entanglement between sysfs and kernfs and
 make the former proper user of the latter.

Multiple hierarchy support tested with the attached module (needs
adding EXPORT_SYMBOL to kernfs interface).  Works as expected.

This patchset is on top of

 driver-core-next 0cae60f91494 ("sysfs: rename sysfs_assoc_lock and explain what it's about")

The patches are also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-separate-out-kernfs

diffstat follows.  Thanks.

 fs/Makefile                 |    2 
 fs/kernfs/Makefile          |    5 
 fs/kernfs/dir.c             | 1007 ++++++++++++++++++++++++++++++++++++++++++++
 fs/kernfs/file.c            |  797 ++++++++++++++++++++++++++++++++++
 fs/kernfs/inode.c           |  337 ++++++++++++++
 fs/kernfs/kernfs-internal.h |  124 +++++
 fs/kernfs/mount.c           |  165 +++++++
 fs/kernfs/symlink.c         |  148 ++++++
 fs/namespace.c              |    2 
 fs/sysfs/Makefile           |    2 
 fs/sysfs/dir.c              |  990 -------------------------------------------
 fs/sysfs/file.c             |  913 +++++++--------------------------------
 fs/sysfs/group.c            |   59 +-
 fs/sysfs/inode.c            |  331 --------------
 fs/sysfs/mount.c            |  166 -------
 fs/sysfs/symlink.c          |  162 -------
 fs/sysfs/sysfs.h            |  217 ---------
 include/linux/kernfs.h      |  311 +++++++++++++
 include/linux/sysfs.h       |   43 -
 19 files changed, 3174 insertions(+), 2607 deletions(-)

--
tejun

[L] https://lkml.kernel.org/g/1382629780-10006-1-git-send-email-tj@kernel.org
