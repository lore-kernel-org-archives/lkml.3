Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3LKVDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:03:10 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:44961 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3LKVDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:03:07 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, kay@vrfy.org
Subject: [PATCHSET driver-core-next] kernfs: implement kernfs_dir_ops
Date: Wed, 11 Dec 2013 16:02:54 -0500
Message-Id: <1386795780-23324-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

kernfs is now properly separated out from sysfs and can be used for
other pseudo filesystems too; however, there are still some missing
features - kernfs filesystems can't process any directory manipulation
systemcalls such as mkdir(2), rmdir(2) and rename(2), which cgroup,
one of the prospect kernfs users, requires for cgroup management.

This patchset implements those directory operation hooks so that
kernfs users can be hooked into those system calls and implement
appropriate actions, which may or may not match the actual semantics
of those syscalls.

The implementation is mostly straight forward except for one aspect.
sysfs, and thus kernfs, never allowed negative dentries.  They are
actively shot down and lookup callback assumes that there's no
negative dentries.  This doesn't really have a lot of benefits and
changing isn't difficult.  The lookup path simply needs to tell the
vfs layer that a full fresh lookup is necessary for negative dentries.

The patchset is lightly tested with sample module which implements
"test" filesystem with weird behaviors using kernfs (will be posted as
a reply to this message).  Note that the module needs kernfs APIs to
be exported.  It might be necessary that we might need further changes
to actually convert cgroup to kernfs but I think this should provide
pretty good basis.

This patchset contains the following six patches.

 0001-kernfs-add-mode-to-kernfs_create_dir-_ns.patch
 0002-kernfs-add-REMOVED-check-to-create-and-rename-paths.patch
 0003-kernfs-mark-static-names-with-KERNFS_STATIC_NAME.patch
 0004-kernfs-update-kernfs_rename_ns-to-consider-KERNFS_ST.patch
 0005-kernfs-allow-negative-dentries.patch
 0006-kernfs-add-kernfs_dir_ops.patch

0001-0004 are prepatory patches.

0005 updates kernfs to allow negative dentries.

0006 implements kernfs_dir_ops.

This patchset is based on

  driver-core-next a8b1c0193602 ("Documentation: start documenting driver design patterns")
+ [1] [PATCHSET] kernfs: s/sysfs/kernfs/

and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-kernfs-dir_ops

diffstat follows.

 fs/kernfs/dir.c             |  111 ++++++++++++++++++++++++++++++--------------
 fs/kernfs/file.c            |   23 +++++----
 fs/kernfs/kernfs-internal.h |    2
 fs/sysfs/dir.c              |    3 -
 fs/sysfs/file.c             |    4 -
 fs/sysfs/group.c            |    3 -
 fs/sysfs/mount.c            |    2
 include/linux/kernfs.h      |   61 +++++++++++++++---------
 8 files changed, 140 insertions(+), 69 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/1386789118-24733-1-git-send-email-tj@kernel.org
