Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaENVfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:35:12 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:47412 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaENVfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:10 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 00/11] Add support for devtmpfs in user namespaces
Date: Wed, 14 May 2014 16:34:48 -0500
Message-Id: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unpriveleged containers cannot run mknod, making it difficult to support
devices which appear at runtime. Using devtmpfs is one possible
solution, and it would have the added benefit of making container setup
simpler. But simply letting containers mount devtmpfs isn't sufficient
since the container may need to see a different, more limited set of
devices, and because different environments making modifications to
the filesystem could lead to conflicts.

This series solves these problems by assigning devices to user
namespaces. Each device has an "owner" namespace which specifies which
devtmpfs mount the device should appear in as well allowing priveleged
operations on the device from that namespace. This defaults to
init_user_ns. There's also an ns_global flag to indicate a device should
appear in all devtmpfs mounts.

devtmpfs is updated to present a different superblock to each user
namespace. Each super block contains nodes for only global devices and
the devices assigned to the associated namespace.

The implementation isn't complete at this point - it's lacking proper
cleanup when a namespace is no longer in use, and only a sampling of
devices are updated to support use in namespaces. I'm sending the
patches now for feedback on the overall approach and the implementation
so far. I also have a couple of areas where I'd appreciate some
suggestions:

 * If devices are owned by a namespace it might be useful to have this
   awareness for uevents and sysfs as well. Would it make sense to apply
   the ownership to kobjects rather than devices?

 * I'd like to be able to do clean up when a namespace is destroyed,
   e.g. with loop devices I'd probably free up any devices owned by the
   namespace. But that's impossible in the current implementation since
   the device has a reference to the namespace. Any suggestions to get
   around this? I haven't spent much time thinking about it yet, but my
   first thought was to add some kind of weak reference to user
   namespaces. Then when the main reference count hits zero the
   namespace isn't destroyed, but there would be a notification that
   drivers could use to perform cleanup. Once all weak references were
   released the memory would actually be freed.

Thanks,
Seth


Seth Forshee (11):
  driver core: Assign owning user namespace to devices
  driver core: Add device_create_global()
  tmpfs: Add sub-filesystem data pointer to shmem_sb_info
  ramfs: Add sub-filesystem data pointer to ram_fs_info
  devtmpfs: Add support for mounting in user namespaces
  drivers/char/mem.c: Make null/zero/full/random/urandom available to
    user namespaces
  block: Make partitions inherit namespace from whole disk device
  block: Allow blkdev ioctls within user namespaces
  misc: Make loop-control available to all user namespaces
  loop: Assign devices to current_user_ns()
  loop: Allow priveleged operations for root in the namespace which owns
    a device

 block/compat_ioctl.c       |   3 +-
 block/ioctl.c              |  16 +-
 block/partition-generic.c  |   2 +
 drivers/base/core.c        |  54 ++++-
 drivers/base/devtmpfs.c    | 509 ++++++++++++++++++++++++++++++++-------------
 drivers/block/loop.c       |  22 +-
 drivers/char/mem.c         |  28 ++-
 drivers/char/misc.c        |  11 +-
 fs/ramfs/inode.c           |   8 -
 include/linux/device.h     |  18 ++
 include/linux/miscdevice.h |   1 +
 include/linux/ramfs.h      |   9 +
 include/linux/shmem_fs.h   |   1 +
 13 files changed, 499 insertions(+), 183 deletions(-)

