Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaAGSAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:00:09 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:59198 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaAGSAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:00:03 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com
Subject: [PATCHSET driver-core-next] kernfs, sysfs, driver-core: implement synchronous self-removal
Date: Tue,  7 Jan 2014 12:59:38 -0500
Message-Id: <1389117590-25705-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

kernfs / sysfs implement the "sever" semantic for userland accesses.
When a node is removed, no further userland operations are allowed and
the in-flight ones are drained before removal is finished.  This makes
policing post-mortem userland accesses trivial for its users;
unfortunately, this comes with a drawback - a node which tries to
delete oneself through one of its userland operations deadlocks.
Removal wants to drain the active access that the operation itself is
running on top of.

This currently is worked around in the sysfs layer using
sysfs_schedule_callback() which punts the actual removal to a work
item.  While making the operation asynchronous kinda works, it's a bit
cumbersome to use and its behavior isn't quite correct as the caller
has no way of telling when or even whether the operation is actually
complete.  If such self-removal is followed by another operation which
expects the removed name to be available, there's no way to make the
second operation reliable - e.g. something like "echo 1 > asdf/delete;
echo asdf > create_new_child" can't work properly.

This patchset improves kernfs removal path and implements
kernfs_remove_self() which is to be called from an on-going kernfs
operation and removes the self node.  The function can be called
concurrently and only one will return %true and all others will wait
until the winner's file operation is complete (not the
kernfs_remove_self() call itself but the enclosing file operation
which invoked the function).  This ensures that if there are multiple
concurrent "echo 1 > asdf/delete", all of them would finish only after
the whole store_delete() method is complete.

kernfs_remove_self() is exposed to upper layers through
sysfs_remove_file_self() and device_remove_file_self().  The existing
users of device_schedule_callback() are converted to use remove_self
and the unused async mechanism is removed.

This patchset contains the following 12 patches.

 0001-kernfs-fix-get_active-failure-handling-in-kernfs_seq.patch
 0002-kernfs-replace-kernfs_node-u.completion-with-kernfs_.patch
 0003-kernfs-restructure-removal-path-to-fix-possible-prem.patch
 0004-kernfs-invoke-kernfs_unmap_bin_file-directly-from-ke.patch
 0005-kernfs-remove-kernfs_addrm_cxt.patch
 0006-kernfs-remove-KERNFS_ACTIVE_REF-and-add-kernfs_lockd.patch
 0007-kernfs-remove-KERNFS_REMOVED.patch
 0008-kernfs-sysfs-driver-core-implement-kernfs_remove_sel.patch
 0009-pci-use-device_remove_file_self-instead-of-device_sc.patch
 0010-scsi-use-device_remove_file_self-instead-of-device_s.patch
 0011-s390-use-device_remove_file_self-instead-of-device_s.patch
 0012-remove-unused-callback-mechanism.patch

0001 fixes -ENODEV failure handling in kernfs.  I *think* this could
be the fix for the issue Sasha reported with trinity fuzzying.  Sasha,
would it be possible to confirm whether the issue is reproducible with
this patch applied?

0002 replaces kernfs_node->u.completion with a hierarchy-wide
wait_queue_head.  This will be used to fix concurrent removal
behavior.

0003 fixes premature completion of node removal when multiple removers
are competing.  This shouldn't matter for the existing sysfs users.

0004-0007 clean up removal path.  The size of kernfs_node is reduced
by one pointer in the process.

0008 implements kernfs_remove_self() and friends.

0009-0012 convert the existing users of device_schedule_callback() to
device_remove_file_self() and removes now unused async mechanism.

After the changes, kernfs_node is shrunken by a pointer and LOC goes
down a bit too.

The patchset is on top of the current driver-core-next eb4c69033fd1
("Revert "kobject: introduce kobj_completion"") and also available in
the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git kernfs-suicide

diffstat follows.

 arch/s390/include/asm/ccwgroup.h |    1 
 arch/s390/pci/pci_sysfs.c        |   18 -
 drivers/base/core.c              |   50 +---
 drivers/pci/pci-sysfs.c          |   24 --
 drivers/s390/block/dcssblk.c     |   14 -
 drivers/s390/cio/ccwgroup.c      |   26 +-
 drivers/scsi/scsi_sysfs.c        |   15 -
 fs/kernfs/dir.c                  |  394 +++++++++++++++++++++------------------
 fs/kernfs/file.c                 |   57 ++++-
 fs/kernfs/kernfs-internal.h      |   12 -
 fs/kernfs/symlink.c              |    6 
 fs/sysfs/file.c                  |  115 ++---------
 include/linux/device.h           |   13 -
 include/linux/kernfs.h           |   13 -
 include/linux/sysfs.h            |   15 -
 15 files changed, 362 insertions(+), 411 deletions(-)

Thanks.

--
tejun
