Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaATVFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:05:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaATVFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:05:17 -0500
Date: Mon, 20 Jan 2014 13:06:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Driver core / sysfs patches for 3.14-rc1
Message-ID: <20140120210603.GA32738@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.14-rc1

for you to fetch changes up to db4aad209bc9aefd91f0a9aeb9e37364088b39ad:

  kernfs: associate a new kernfs_node with its parent on creation (2014-01-17 11:50:07 -0800)

----------------------------------------------------------------
Driver core / sysfs patches for 3.14-rc1

Here's the big driver core and sysfs patch set for 3.14-rc1.

There's a lot of work here moving sysfs logic out into a "kernfs" to
allow other subsystems to also have a virtual filesystem with the same
attributes of sysfs (handle device disconnect, dynamic creation /
removal  as needed / unneeded, etc.  This is primarily being done for
the cgroups filesystem, but the goal is to also move debugfs to it when
it is ready, solving all of the known issues in that filesystem as well.
The code isn't completed yet, but all should be stable now (there is a
big section that was reverted due to problems found when testing.)

There's also some other smaller fixes, and a driver core addition that
allows for a "collection" of objects, that the DRM people will be using
soon (it's in this tree to make merges after -rc1 easier.)

All of this has been in linux-next with no reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Axel Lin (1):
      devtmpfs: Calling delete_path() only when necessary

Bart Van Assche (3):
      kobject: Fix source code comment spelling
      firmware loader: Add sparse annotation
      driver-core: Fix use-after-free triggered by bus_unregister()

Ben Hutchings (1):
      firmware_class: Fix the file size check

Bjorn Helgaas (5):
      kobject: fix kset sample error path
      kobject: delay kobject release for random time
      kobject: remove kset from sysfs immediately in kset_unregister()
      firmware: dmi-sysfs: Don't remove dmi-sysfs "raw" file explicitly
      firmware: dmi-sysfs: Remove "dmi" directory on module exit

David Herrmann (1):
      driver core: fix device_create() error path

Greg Kroah-Hartman (19):
      Merge branch 'driver-core-linus' into driver-core-next
      Merge 3.13-rc2 into driver-core-next
      Merge 3.13-rc5 into staging-next
      Revert "kobject: introduce kobj_completion"
      Revert "kernfs: remove unnecessary NULL check in __kernfs_remove()"
      Revert "sysfs, driver-core: remove unused {sysfs|device}_schedule_callback_owner()"
      Revert "s390: use device_remove_file_self() instead of device_schedule_callback()"
      Revert "scsi: use device_remove_file_self() instead of device_schedule_callback()"
      Revert "pci: use device_remove_file_self() instead of device_schedule_callback()"
      Revert "kernfs, sysfs, driver-core: implement kernfs_remove_self() and its wrappers"
      Revert "kernfs: implement kernfs_{de|re}activate[_self]()"
      Revert "kernfs: make kernfs_get_active() block if the node is deactivated but not removed"
      Revert "kernfs: remove kernfs_addrm_cxt"
      Revert "kernfs: invoke kernfs_unmap_bin_file() directly from __kernfs_remove()"
      Revert "kernfs: restructure removal path to fix possible premature return"
      Revert "kernfs: remove KERNFS_REMOVED"
      Revert "kernfs: remove KERNFS_ACTIVE_REF and add kernfs_lockdep()"
      Revert "kernfs: replace kernfs_node->u.completion with kernfs_root->deactivate_waitq"
      Revert "kernfs: fix get_active failure handling in kernfs_seq_*()"

Linus Walleij (2):
      Documentation: start documenting driver design patterns
      Documentation: fix spelling in design-patterns

Maurizio Lombardi (1):
      kobject: fix memory leak in kobject_set_name_vargs

Rafael J. Wysocki (1):
      Driver core: Fix device_add_attrs() error code path

Rashika Kheria (1):
      drivers: base: Add prototype declaration to the header file

Russell King (1):
      drivers/base: provide an infrastructure for componentised subsystems

Takashi Iwai (4):
      firmware: Introduce request_firmware_direct()
      microcode: Use request_firmware_direct()
      firmware: Use bit flags instead of boolean combos
      firmware: Suppress fallback warnings when CONFIG_FW_LOADER_USER_HELPER=n

Tejun Heo (76):
      sysfs: drop kobj_ns_type handling, take #2
      sysfs: make __sysfs_add_one() fail if the parent isn't a directory
      sysfs, kernfs: add skeletons for kernfs
      sysfs, kernfs: introduce kernfs_remove[_by_name[_ns]]()
      sysfs, kernfs: introduce kernfs_create_link()
      sysfs, kernfs: introduce kernfs_rename[_ns]()
      sysfs, kernfs: introduce kernfs_setattr()
      sysfs, kernfs: replace sysfs_dirent->s_dir.kobj and ->s_attr.[bin_]attr with ->priv
      sysfs, kernfs: introduce kernfs_create_dir[_ns]()
      sysfs, kernfs: prepare read path for kernfs
      sysfs, kernfs: prepare write path for kernfs
      sysfs, kernfs: prepare mmap path for kernfs
      sysfs, kernfs: prepare open, release, poll paths for kernfs
      sysfs, kernfs: move sysfs_open_file to include/linux/kernfs.h
      sysfs, kernfs: introduce kernfs_ops
      sysfs, kernfs: add sysfs_dirent->s_attr.size
      sysfs, kernfs: remove SYSFS_KOBJ_BIN_ATTR
      sysfs, kernfs: introduce kernfs_create_file[_ns]()
      sysfs, kernfs: remove sysfs_add_one()
      sysfs, kernfs: add kernfs_ops->seq_{start|next|stop}()
      sysfs, kernfs: introduce kernfs_notify()
      sysfs, kernfs: reorganize SYSFS_* constants
      sysfs, kernfs: revamp sysfs_dirent active_ref lockdep annotation
      sysfs, kernfs: introduce kernfs[_find_and]_get() and kernfs_put()
      sysfs, kernfs: move internal decls to fs/kernfs/kernfs-internal.h
      sysfs, kernfs: move inode code to fs/kernfs/inode.c
      sysfs, kernfs: move dir core code to fs/kernfs/dir.c
      sysfs, kernfs: move file core code to fs/kernfs/file.c
      sysfs, kernfs: move symlink core code to fs/kernfs/symlink.c
      sysfs, kernfs: drop unused params from sysfs_fill_super()
      sysfs, kernfs: make sysfs_super_info->ns const
      sysfs, kernfs: no need to kern_mount() sysfs from sysfs_init()
      sysfs, kernfs: introduce sysfs_root_sd
      sysfs, kernfs: implement kernfs_create/destroy_root()
      sysfs, kernfs: make inode number ida per kernfs_root
      sysfs, kernfs: make super_blocks bind to different kernfs_roots
      sysfs, kernfs: prepare mount path for kernfs
      sysfs, kernfs: move mount core code to fs/kernfs/mount.c
      sysfs, kernfs: make sysfs_dirent definition public
      sysfs, kernfs: implement kernfs_ns_enabled()
      sysfs, kernfs: remove cross inclusions of internal headers
      kernfs: update sysfs_init_inode_attrs()
      kernfs: implement "trusted.*" xattr support
      Merge branch 'driver-core-linus' into driver-core-next
      sysfs: bail early from kernfs_file_mmap() to avoid spurious lockdep warning
      sysfs: fix use-after-free in sysfs_kill_sb()
      kernfs: s/sysfs_dirent/kernfs_node/ and rename its friends accordingly
      kernfs: drop s_ prefix from kernfs_node members
      kernfs: s/sysfs/kernfs/ in various data structures
      kernfs: s/sysfs/kernfs/ in constants
      kernfs: s/sysfs/kernfs/ in global variables
      kernfs: s/sysfs/kernfs/ in internal functions and whatever is left
      kernfs: add @mode to kernfs_create_dir[_ns]()
      kernfs: add REMOVED check to create and rename paths
      kernfs: mark static names with KERNFS_STATIC_NAME
      kernfs: update kernfs_rename_ns() to consider KERNFS_STATIC_NAME
      kernfs: allow negative dentries
      kernfs: add kernfs_dir_ops
      kernfs: fix get_active failure handling in kernfs_seq_*()
      kernfs: replace kernfs_node->u.completion with kernfs_root->deactivate_waitq
      kernfs: remove KERNFS_ACTIVE_REF and add kernfs_lockdep()
      kernfs: remove KERNFS_REMOVED
      kernfs: restructure removal path to fix possible premature return
      kernfs: invoke kernfs_unmap_bin_file() directly from __kernfs_remove()
      kernfs: remove kernfs_addrm_cxt
      kernfs: make kernfs_get_active() block if the node is deactivated but not removed
      kernfs: implement kernfs_{de|re}activate[_self]()
      kernfs, sysfs, driver-core: implement kernfs_remove_self() and its wrappers
      pci: use device_remove_file_self() instead of device_schedule_callback()
      scsi: use device_remove_file_self() instead of device_schedule_callback()
      s390: use device_remove_file_self() instead of device_schedule_callback()
      sysfs, driver-core: remove unused {sysfs|device}_schedule_callback_owner()
      kernfs: remove unnecessary NULL check in __kernfs_remove()
      kernfs: fix get_active failure handling in kernfs_seq_*()
      kernfs: add struct dentry declaration in kernfs.h
      kernfs: associate a new kernfs_node with its parent on creation

Wei Yongjun (1):
      sysfs, kernfs: remove duplicated include from file.c

 Documentation/driver-model/design-patterns.txt |  116 +++
 Documentation/kobject.txt                      |    5 +-
 arch/x86/kernel/microcode_amd.c                |    2 +-
 arch/x86/kernel/microcode_intel.c              |    2 +-
 drivers/base/Makefile                          |    2 +-
 drivers/base/bus.c                             |   13 +-
 drivers/base/component.c                       |  382 +++++++++
 drivers/base/core.c                            |    7 +-
 drivers/base/devtmpfs.c                        |    2 +-
 drivers/base/firmware_class.c                  |   93 +-
 drivers/firmware/dmi-sysfs.c                   |    3 +-
 drivers/gpio/gpiolib.c                         |    4 +-
 drivers/md/bitmap.c                            |    2 +-
 drivers/md/bitmap.h                            |    2 +-
 drivers/md/md.h                                |   10 +-
 drivers/misc/mic/host/mic_device.h             |    2 +-
 fs/Makefile                                    |    2 +-
 fs/kernfs/Makefile                             |    5 +
 fs/kernfs/dir.c                                | 1073 +++++++++++++++++++++++
 fs/kernfs/file.c                               |  867 +++++++++++++++++++
 fs/kernfs/inode.c                              |  377 +++++++++
 fs/kernfs/kernfs-internal.h                    |  122 +++
 fs/kernfs/mount.c                              |  165 ++++
 fs/kernfs/symlink.c                            |  151 ++++
 fs/namespace.c                                 |    2 +
 fs/sysfs/Makefile                              |    2 +-
 fs/sysfs/dir.c                                 | 1075 +-----------------------
 fs/sysfs/file.c                                |  961 ++++-----------------
 fs/sysfs/group.c                               |  102 +--
 fs/sysfs/inode.c                               |  331 --------
 fs/sysfs/mount.c                               |  184 +---
 fs/sysfs/symlink.c                             |  219 +----
 fs/sysfs/sysfs.h                               |  236 +-----
 include/linux/component.h                      |   32 +
 include/linux/firmware.h                       |    7 +
 include/linux/kernfs.h                         |  376 +++++++++
 include/linux/kobj_completion.h                |   18 -
 include/linux/kobject.h                        |    2 +-
 include/linux/memory.h                         |    1 +
 include/linux/sysfs.h                          |   47 +-
 lib/kobject.c                                  |   95 +--
 samples/kobject/kset-example.c                 |    1 +
 42 files changed, 4186 insertions(+), 2914 deletions(-)
 create mode 100644 Documentation/driver-model/design-patterns.txt
 create mode 100644 drivers/base/component.c
 create mode 100644 fs/kernfs/Makefile
 create mode 100644 fs/kernfs/dir.c
 create mode 100644 fs/kernfs/file.c
 create mode 100644 fs/kernfs/inode.c
 create mode 100644 fs/kernfs/kernfs-internal.h
 create mode 100644 fs/kernfs/mount.c
 create mode 100644 fs/kernfs/symlink.c
 delete mode 100644 fs/sysfs/inode.c
 create mode 100644 include/linux/component.h
 create mode 100644 include/linux/kernfs.h
 delete mode 100644 include/linux/kobj_completion.h
