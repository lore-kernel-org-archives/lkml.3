Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3IFKmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:42:22 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:43623 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3IFKmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:42:18 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH v3 8/8] industrialio: use anon_inode_getfd() with O_CLOEXEC flag
Date: Fri,  6 Sep 2013 12:39:58 +0200
Message-Id: <91c7332bc0616447587ec64a0c8f512a1d9e498d.1378460926.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1378460926.git.ydroneaud@opteya.com>
References: <cover.1378460926.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1378460926.git.ydroneaud@opteya.com>
References: <cover.1378460926.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IIO uses anon_inode_get() to allocate file descriptors as part
of its ioctls. But those ioctls are lacking a flag argument
allowing userspace to choose options for the newly opened file
descriptor.

In such case it's advised to use O_CLOEXEC by default so that
userspace is allowed to choose, without race, if the file descriptor
is going to be inherited across exec().

KVM usage of anon_inode_getfd() was fixed in a previous patchset [1],
so IIO is the only subsystem using anon_inode_getfd() with a fixed set
of flags not including O_CLOEXEC.

This patch set O_CLOEXEC flag on the event file descriptor created
with anon_inode_getfd() to not leak file descriptors across exec().

Links:

- Secure File Descriptor Handling (Ulrich Drepper, 2008)
  http://udrepper.livejournal.com/20407.html

- Excuse me son, but your code is leaking !!! (Dan Walsh, March 2012)
  http://danwalsh.livejournal.com/53603.html

- [1] kvm: use anon_inode_getfd() with O_CLOEXEC flag
  http://lkml.kernel.org/r/cover.1377372576.git.ydroneaud@opteya.com

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Link: http://lkml.kernel.org/r/cover.1378460926.git.ydroneaud@opteya.com
---
 drivers/iio/industrialio-event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
index 10aa9ef..2390e3d 100644
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -159,7 +159,7 @@ int iio_event_getfd(struct iio_dev *indio_dev)
 	}
 	spin_unlock_irq(&ev_int->wait.lock);
 	fd = anon_inode_getfd("iio:event",
-				&iio_event_chrdev_fileops, ev_int, O_RDONLY);
+				&iio_event_chrdev_fileops, ev_int, O_RDONLY | O_CLOEXEC);
 	if (fd < 0) {
 		spin_lock_irq(&ev_int->wait.lock);
 		__clear_bit(IIO_BUSY_BIT_POS, &ev_int->flags);
-- 
1.8.3.1

