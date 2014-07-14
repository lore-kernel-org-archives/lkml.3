Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbaGNTTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:19:14 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:60922 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaGNTTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:19:04 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
        lxc-devel@lists.linuxcontainers.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@WittsEnd.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 0/3] fuse: Allow mounts in containers
Date: Mon, 14 Jul 2014 14:18:13 -0500
Message-Id: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches allow unprivileged users to mount with fuse from within
containers. The first patch is really just a bug fix and related only
because the bug allows unprivileged users to crash the system. The
second patch translates the pid which is making a request into the
server's pid namespace, and the third adds user namespace support to
fuse. This is limited only to the "fuse" fs type. fuseblk could likely
be supported as well, but I haven't spent any time testing it, and I
haven't really given cuse much consideration at all (though cuse ioctls
look rather frightening).

The server's pid and user namespaces are both assumed to be those of the
process which calls mount. This does't necessarily have to be the same
as those of the server, especially since fuse mounts are routinely done
by a process other than the server. However I didn't find any way to
ensure that we use those of the server with the information currently
available to fuse in the kernel. If the mount is done from a different
namespace it could result in reduced functionality, however it should
not result in any privileges not already available to the user.

In preparing these patches I spent some time considering the security
aspects of allowing fuse mounts from containers. fuse is already
sufficiently untrusting of input from userspace, and it has mechanisms
to prevent several types of attacks. However some of these mechanisms
rely on having a trusted setuid root helper (fusermount) to enforce
policy, such as forcing certain mount options for unprivileged monts. In
a container we can't rely on a userspace helper to enforce policy. Here
are details about how these issues work out:

* devices: fusermount forces nodev for unprivileged mounts. In these
  patches I use the existing kernel support for forcing nodev for fuse
  mounts from user namspaces.

* set[ug]id files: fusermount also forces nosuid for unprivileged
  mounts. In a user namespace all file uids and gids are treated as
  being mapped into the user ns, so it's not possible to setuid to
  anything outside the server's namespace. This means setuid can't be
  used to gain elevated privileges, and thus the kernel doesn't need to
  force nosuid.

* mounting over files or directories: fusermount ensures that the
  unprivileged user has write permissions to the mountpoint before
  mounting. But since mounting is only allowed by CAP_SYS_ADMIN in the
  user ns of the mount ns, a user cannot use a namespace to mount over
  any files or directories unless the user already had the ability to do
  so, or if it does so in a different mount ns. Namespaces therefore
  don't open the door to this type of attack, and kernel enforcment is
  not needed.

* affecting behavior of other users' processes: A user could DoS other
  users' processes if those processes accessed files or directories
  within a fuse mount. For this reason the default behavoior of fuse is
  that only the mount owner can access the filesystem. This can be
  overridden with the allow_other mount option, but fusermount forbids
  this option unless allowed by system policy in /etc/fuse.conf.

  To protect against this, these patches patches change the meaning of
  allow_other slightly, from "any user can access this filesystem" to
  "users in the mount owner's namespace or a child namespace can access
  this filesystem." This protects more privileged contexts while
  maintaining the existing behavior.

* {user,group}_id mount options: These are being mapped into the user
  ns, which prevents specifying any user outside the ns. Any ids which
  do not map to the user ns wil cause the mount to fail.

That represents everything I could think of that would be possible as a
consequence of allowing mounts from user namespaces. I also read through
the fuse kernel code (espeically the parts handling input from
userspace) looking for additional vectors for attack or any other
weaknesses, but I didn't find anything. So I believe these should be all
the changes needed to make fuse mounts from user namespaces safe, but
please let me know if I missed anything.

Thanks,
Seth


Seth Forshee (3):
  fuse/dev: Fix unbalanced calls to kunmap_atomic() during splice I/O
  fuse: Translate pid making a request into the server's pid namespace
  fuse: Allow mounts from user namespaces

 fs/fuse/dev.c    | 19 +++++++++----------
 fs/fuse/dir.c    | 30 +++++++++++++++++++-----------
 fs/fuse/fuse_i.h |  8 ++++++++
 fs/fuse/inode.c  | 21 ++++++++++++++-------
 4 files changed, 50 insertions(+), 28 deletions(-)

