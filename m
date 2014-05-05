Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaEESfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:35:01 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40504 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaEESfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:35:00 -0400
From: Plamen Petrov <plamen.sisi@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] do_mounts: try all available filesystems before panicking
Date: Mon,  5 May 2014 21:34:49 +0300
Message-Id: <1399314889-9829-1-git-send-email-plamen.sisi@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging a kernel panic with 3.14.1 it became clear that some
filesystems' mount routines give back return codes other than zero, EACCES
or EINVAL. Such return codes can result in panic during boot before the kernel
tries to mount root with all of the available filesystems, as can be seen in
bugzilla entries 74901 and 74261.

Make mount_block_root continue trying other available filesystems by default,
not only when the last tried returned EACCES or EINVAL.

Cc: stable@vger.kernel.org
Signed-off-by: Plamen Petrov <plamen.sisi@gmail.com>
---
The story short: on systems with btrfs root I have a kernel .config with ext4,
xfs and btrfs built-in which works fine with 3.13.x, but 3.14.x panics. After
inserting some debug printks, I got this info from mount_block_root:

---> EACCESS=13, EINVAL=22, Available filesystems: ext3 ext2 ext4 fuseblk xfs btrfs
-----> Tried ext3, error code is -22.
-----> Tried ext2, error code is -22.
-----> Tried ext4, error code is -22.
-----> Tried fuseblk, error code is -22.
-----> Tried xfs, error code is -38.
VFS: Cannot open root device "sda2" or unknown-block(8,2): error -38
Please append a correct "root=" boot option; here are the available partitions:

Last one tried is xfs, the needed btrfs in this case never gets a chance.
Looking at the code in init/do_mounts.c we can see that it "continue"s only if
the return code it got is EINVAL, yet xfs clearly does not fit - so the kernel
panics. Maybe there are other filesystems like xfs - I did not check. This
patch fixes mount_block_root to try all available filesystems first, and then
panic. The patched 3.14.x works for me.

This patch was sent to LKML once, see
  http://article.gmane.org/gmane.linux.kernel/1691881
Maybe the first time around it got damaged by my mail client, lost in all of
the LKML traffic, or nobody picked it up, because scripts/get_maintainer.pl
said "Send it to LKML" only, and I did just that.
Either way - resending and CC-ing Linus, with stable- added as CC to the patch
as well.

 init/do_mounts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 82f2288..979bd71 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -396,7 +396,7 @@ retry:
 			case -EACCES:
 				flags |= MS_RDONLY;
 				goto retry;
-			case -EINVAL:
+			default:
 				continue;
 		}
 	        /*
-- 
1.9.0

