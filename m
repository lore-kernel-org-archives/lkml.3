Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3ETLOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:14:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56113 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab3ETKw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Jeffery <djeffery@redhat.com>, Ian Kent <raven@themaw.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 042/115] autofs - remove autofs dentry mount check
Date: Mon, 20 May 2013 11:50:42 +0100
Message-Id: <1369047116-9378-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

commit ce8a5dbdf9e709bdaf4618d7ef8cceb91e8adc69 upstream.

When checking if an autofs mount point is busy it isn't sufficient to
only check if it's a mount point.

For example, if the mount of an offset mountpoint in a tree is denied
for this host by its export and the dentry becomes a process working
directory the check incorrectly returns the mount as not in use at
expire.

This can happen since the default when mounting within a tree is
nostrict, which means ingnore mount fails on mounts within the tree and
continue.  The nostrict option is meant to allow mounting in this case.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/autofs4/expire.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 1feb68e..b1cdb0a 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -61,15 +61,6 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 		/* This is an autofs submount, we can't expire it */
 		if (autofs_type_indirect(sbi->type))
 			goto done;
-
-		/*
-		 * Otherwise it's an offset mount and we need to check
-		 * if we can umount its mount, if there is one.
-		 */
-		if (!d_mountpoint(path.dentry)) {
-			status = 0;
-			goto done;
-		}
 	}
 
 	/* Update the expiry counter if fs is busy */
-- 
1.8.1.2

