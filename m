Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3JAVmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:42:23 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:36593 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab3JAVmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:16 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: [PATCHSET v2] sysfs: use seq_file and unify regular and bin file handling
Date: Tue,  1 Oct 2013 17:41:54 -0400
Message-Id: <1380663729-18243-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes from the last take[L] are,

* bin file reads no longer go through seq_file.  It goes through a
  separate read path implemented in sysfs_bin_read().  bin files
  shouldn't see any behavior difference now.

* bin files now use a separate file_operations struct -
  sysfs_bin_operations.  Open and write paths are still shared but
  read path is separate and mmap exists only for the bin files.  While
  this is less uniform than before, it should still render itself well
  to extracting the core functionality.

* 0001-0008 are the same as before.

Patchset description follows.

Currently, sysfs's file handling is a bit weird.

* Regular and bin file paths are similar but implemented completely
  separately duplicating some hairy logics.

* Read path implements custom buffering which is essentially
  degenerate seq_file.

In addition, sysfs core implementation is planned to be separated out
so that it can be shared by other subsystems and the current file
handling is too restrictive and quirky to spread further to other
parts of the kernel.  It'd be a lot more desirable to have read path
completely handled by seq_file which is a lot more versatile and would
also increase overall behavior consistency.

This patchset updates file handling such that read is handled by
seq_file and then merges bin file handling into regular file path.
While some changes introduces behavior changes in extreme corner
cases, they are highly unlikely to be noticeable (please refer to the
description of each patch for details) and generally bring sysfs's
behavior closer to those of procfs or any pseudo filesystem which
makes use of seq_file.

After the conversion, LOC is reduced by ~150 lines and read path is
fully handled by seq_file, which allows defining a new seq_file based
core interface which will enable sharing sysfs from other subsystems.

This patchset contains the following patches.

 0001-sysfs-remove-unused-sysfs_buffer-pos.patch
 0002-sysfs-remove-sysfs_buffer-needs_read_fill.patch
 0003-sysfs-remove-sysfs_buffer-ops.patch
 0004-sysfs-add-sysfs_open_file_mutex.patch
 0005-sysfs-rename-sysfs_buffer-to-sysfs_open_file.patch
 0006-sysfs-add-sysfs_open_file-sd-and-file.patch
 0007-sysfs-use-transient-write-buffer.patch
 0008-sysfs-use-seq_file-when-reading-regular-files.patch
 0009-sysfs-skip-bin_buffer-buffer-while-reading.patch
 0010-sysfs-collapse-fs-sysfs-bin.c-fill_read-into-read.patch
 0011-sysfs-prepare-path-write-for-unified-regular-bin-fil.patch
 0012-sysfs-add-sysfs_bin_read.patch
 0013-sysfs-copy-bin-mmap-support-from-fs-sysfs-bin.c-to-f.patch
 0014-sysfs-prepare-open-path-for-unified-regular-bin-file.patch
 0015-sysfs-merge-regular-and-bin-file-handling.patch

0001-0006 are misc preps.

0007 makes write path use transient buffer instead of the one
persistent during open.

0008 makes read path use seq_file.

0009-0011 prepare for merging bin and regular file handling.

0012-0015 merge bin file handling into regular file support.

The patches are on top of

  linus#master c2d95729e3 ("Merge branch 'akpm' (patches from Andrew Morton)")
+ [1] [PATCHSET] sysfs: disentangle kobject namespace handling from sysfs
+ [2] [PATCHSET] sysfs: implement sysfs_remove()

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-sysfs-seq_file

diffstat follows, thanks.

 Documentation/DocBook/filesystems.tmpl |    1
 fs/sysfs/Makefile                      |    3
 fs/sysfs/bin.c                         |  502 ---------------------
 fs/sysfs/dir.c                         |    2
 fs/sysfs/file.c                        |  766 ++++++++++++++++++++++++---------
 fs/sysfs/inode.c                       |    2
 fs/sysfs/sysfs.h                       |    7
 7 files changed, 567 insertions(+), 716 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1569578
[1] http://thread.gmane.org/gmane.linux.kernel/1560372
[2] http://thread.gmane.org/gmane.linux.kernel/1564002
