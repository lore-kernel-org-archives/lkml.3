Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaE0V7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:59:08 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45384 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaE0V7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:59:07 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>, Marian Marinov <mm@1h.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael J Coss <michael.coss@alcatel-lucent.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 0/2] Loop device psuedo filesystem
Date: Tue, 27 May 2014 23:58:54 +0200
Message-Id: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm posting these patches in response to the ongoing discussion of loop
devices in containers at [1].

The patches implement a psuedo filesystem for loop devices, which will
allow use of loop devices in containters using standard utilities. Under
normal use a loopfs mount will initially contain a single device node
for loop-control which can be used to request and release loop devices.
Any devices allocated via this node will automatically appear in that
loopfs mount (and in devtmpfs) but not in any other loopfs mounts.
CAP_SYS_ADMIN in the userns of the process which performed the mount is
allowed to perform privileged loop ioctls on these devices.

Alternately loopfs can be mounted with the hostmount option, intended
for mounting /dev/loop in the host. This is the default mount for any
devices not created via loop-control in a loopfs mount (e.g. devices
created during driver init, devices created via /dev/loop-control, etc).
This is only available to system-wide CAP_SYS_ADMIN.

I still have some testing to do on these patches, but they work at
minimum for simple use cases. It's possible to use an unmodified losetup
if it's new enough to know about loop-control, with a couple of caveats:

 * /dev/loop-control must be symlinked to /dev/loop/loop-control
 * In some cases losetup attempts to use /dev/loopN when the device node
   is at /dev/loop/N. For example, 'losetup -f disk.img' fails.

Device nodes for loop partitions are not created in loopfs. These
devices are created by the generic block layer, and the loop driver has
no way of knowing when they are created, so some kind of hook into the
driver will be needed to support this.

Thanks,
Seth

[1] http://article.gmane.org/gmane.linux.kernel/1703988

Seth Forshee (2):
  loop: Add loop filesystem
  loop: Permit priveleged operations within user namespaces

 drivers/block/loop.c       | 137 +++++++++++++----
 drivers/block/loop.h       |   2 +
 fs/Makefile                |   1 +
 fs/loopfs/Makefile         |   6 +
 fs/loopfs/inode.c          | 360 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/loopfs.h     |  53 +++++++
 include/uapi/linux/magic.h |   1 +
 7 files changed, 535 insertions(+), 25 deletions(-)
 create mode 100644 fs/loopfs/Makefile
 create mode 100644 fs/loopfs/inode.c
 create mode 100644 include/linux/loopfs.h

