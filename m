Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaIBPpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:45:00 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:47808 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaIBPo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:44:58 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 0/3] fuse: Add support for mounts from pid/user namespaces
Date: Tue,  2 Sep 2014 10:44:53 -0500
Message-Id: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an updated set of patches for allowing fuse mounts from pid and
user namespaces. I discussed some of the issues we debated with the last
patch set (and a few others) with Eric at LinuxCon, and the updates here
mainly reflect the outcome of those discussions.

The stickiest issue in the v1 patches was the question of where to get
the user and pid namespaces from that are used for translating ids for
communication with userspace. Eric told me that for user namespaces at
least we need to grab a namespace at open or mount time and use only
that namespace to prevent certain types of attacks. That rules out the
suggestion of using the user ns of current in the read/write paths, and
I think it makes sense to handle pid and user namespaces similarly. So
in these patches I'm still grabbing the namespaces of current during
mount, but I've added an additional check to fail the mount if the
f_cred's userns for the fd to userspace doesn't match.

Another issue mentioned by Eric was what to use for i_[ug]id if the ids
from userspace don't map into the user namespace, which is going to be a
problem for any other filesystems which become mountable from user
namespaces as well. We discussed a few options for addressing this, the
most promising of which seems to be either using INVALID_[UG]ID for
these inodes or creating vfs-wide "nobody" ids for this purpose. After
thinking about it for a while I'm favoring using the invalid ids, but
I'm hoping to solicit some more feedback.

For now these patches are using invalid ids if the user doesn't map into
the namespace. I went through the vfs code and found one place where
this could be handled better (addressed in patch 1 of the series). The
only other issue I found was that currently no one, not even root, can
change onwership of such inodes, but I suspect we can find a way around
this.

The only other change since v1 is that I now fail changing file
ownership if the new uid or gid does not map into the namespace used for
userspace communication.

Thanks,
Seth


Seth Forshee (3):
  vfs: Check for invalid i_uid in may_follow_link()
  fuse: Translate pids passed to userspace into pid namespaces
  fuse: Add support for mounts from user namespaces

 fs/fuse/dev.c    | 13 +++++++------
 fs/fuse/dir.c    | 46 +++++++++++++++++++++++++++++++++-------------
 fs/fuse/fuse_i.h |  8 ++++++++
 fs/fuse/inode.c  | 31 +++++++++++++++++++++++--------
 fs/namei.c       |  2 +-
 5 files changed, 72 insertions(+), 28 deletions(-)

