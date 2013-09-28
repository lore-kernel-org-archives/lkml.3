Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3I1Vtu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:49:50 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:49167 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab3I1Vts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:49:48 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: [PATCHSET] sysfs: use seq_file and unify regular and bin file handling
Date: Sat, 28 Sep 2013 17:49:30 -0400
Message-Id: <1380404984-31858-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

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

After the conversion, LOC is reduced by ~110 lines and read path is
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
 0009-sysfs-prepare-llseek-path-for-unified-regular-bin-fi.patch
 0010-sysfs-prepare-path-write-for-unified-regular-bin-fil.patch
 0011-sysfs-prepare-read-path-for-unified-regular-bin-file.patch
 0012-sysfs-copy-bin-mmap-support-from-fs-sysfs-bin.c-to-f.patch
 0013-sysfs-prepare-open-path-for-unified-regular-bin-file.patch
 0014-sysfs-merge-regular-and-bin-file-handling.patch

0001-0006 are misc preps.

0007 makes write path use transient buffer instead of the one
persistent during open.

0008 makes read path use seq_file.

0009-0014 merge bin file handling into regular file support.

The patches are on top of

  linus#master c2d95729e3 ("Merge branch 'akpm' (patches from Andrew Morton)")
+ [1] [PATCHSET] sysfs: disentangle kobject namespace handling from sysfs
+ [2] [PATCHSET] sysfs: implement sysfs_remove()

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-sysfs-seq_file

diffstat follows, thanks.

 fs/sysfs/Makefile     |    3 
 fs/sysfs/bin.c        |  502 -------------------------------
 fs/sysfs/dir.c        |    2 
 fs/sysfs/file.c       |  805 ++++++++++++++++++++++++++++++++++++--------------
 fs/sysfs/inode.c      |    2 
 fs/sysfs/sysfs.h      |    6 
 include/linux/sysfs.h |    7 
 7 files changed, 606 insertions(+), 721 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1560372
[2] http://thread.gmane.org/gmane.linux.kernel/1564002
