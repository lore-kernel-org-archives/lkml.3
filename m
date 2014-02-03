Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaBCTDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:03:14 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:52102 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaBCTDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:03:12 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com
Subject: [PATCHSET v5 driver-core-next] kernfs, sysfs, driver-core: implement synchronous self-removal
Date: Mon,  3 Feb 2014 14:02:53 -0500
Message-Id: <1391454185-32143-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(Please note that 0001 was posted separately before and should be
routed through driver-core-linus)

This is v5 of kernfs self-removal patchset.  The changes from v4[4]
are

* Being rebased on v3.14-rc1.

* 0001-kernfs-make-kernfs_deactivate-honor-KERNFS_LOCKDEP-f.patch
  separated out from later patches and put at the head of the series.
  This change fixes a spurious lockdep warning and should be sent to
  Linus through driver-core-linus as fix in this devel cycle.  The
  rest are for the next merge window.

Unfortunately, this series has a somewhat turbulent history upto v4.
After sending out the first iteration[1], I realized that cgroup's use
case would need more flexibility so I called it off and after a while
posted the second version[2] which contained patches which were
slightly stale by mistake, so soon after v3[3] was posted, which got
applied to the driver-core-next for 3.14-rc1 inclusion; unfortunately,
while working on it later, I realized that the new more flexible
scheme was fundamentally broken and the first approach in v1 was
actually the correct one.  So, the whole series got reverted and this
is the fourth trial aiming for the 3.15-rc1 window.  This time, the
whole cgroup conversion is completed on top and verified to work
properly, so hopefully this take is the last for this series.

As described above, the approach used in the first iteration was the
correct one, so the current patchset is an updated version of v1.  The
only necessary addition was exposing breaking out of s_active
protection as a separate API.

* Incorporate fixes from v3 of the patchset.

* kernfs_[un]break_active_protection() added.  "break" puts the active
  reference while "unbreak" undoes it so that the refcnt is balanced;
  however, unbreaking doesn't and can't restore active reference
  protection itself.  Once broken, active ref protection is gone for
  the full duration of the method invocation.  This allows more
  complex implementation of self-removal where self-removal attempts
  may be rejected by shifting the responsibility of ensuring object
  accessbility to the kernfs user.

  This API is a bit cumbersome to use but the simpler
  kernfs_remove_self() is still provided and built on top of the above
  API.

Original patch description follows.

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

This patchset contains the following twelve patches.

 0001-kernfs-make-kernfs_deactivate-honor-KERNFS_LOCKDEP-f.patch
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
 0012-sysfs-driver-core-remove-unused-sysfs-device-_schedu.patch

0001 is a fix patch which should be applied through driver-core-linus.

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

This patchset is on top of v3.14-rc1 38dbfb59d117.  and also available
in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-kernfs-suicide

diffstat follows.

 arch/s390/include/asm/ccwgroup.h |    1 
 arch/s390/pci/pci_sysfs.c        |   18 -
 drivers/base/core.c              |   50 +---
 drivers/pci/pci-sysfs.c          |   17 -
 drivers/s390/block/dcssblk.c     |   14 -
 drivers/s390/cio/ccwgroup.c      |   26 +-
 drivers/scsi/scsi_sysfs.c        |   15 -
 fs/kernfs/dir.c                  |  447 +++++++++++++++++++++++----------------
 fs/kernfs/file.c                 |    6 
 fs/kernfs/kernfs-internal.h      |   14 -
 fs/kernfs/symlink.c              |    6 
 fs/sysfs/file.c                  |  115 ++--------
 include/linux/device.h           |   13 -
 include/linux/kernfs.h           |   18 -
 include/linux/sysfs.h            |   16 -
 15 files changed, 373 insertions(+), 403 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/1389117590-25705-1-git-send-email-tj@kernel.org
[2] http://lkml.kernel.org/g/1389361620-5086-1-git-send-email-tj@kernel.org
[3] http://lkml.kernel.org/g/1389362251-8128-1-git-send-email-tj@kernel.org
[4] http://lkml.kernel.org/g/1390951311-15325-1-git-send-email-tj@kernel.org
