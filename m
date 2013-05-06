Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3EFFtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 01:49:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41869 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443Ab3EFFte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 01:49:34 -0400
X-Sasl-enc: ADkztwXDZWgw0YB2LIIXtJYZYfdQOMxvk76cjdG8hmMc 1367819373
Subject: [REPOST PATCH] autofs - remove autofs dentry mount check
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: autofs mailing list <autofs@vger.kernel.org>,
        David Jeffery <djeffery@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Date: Mon, 06 May 2013 13:49:30 +0800
Message-ID: <20130506054929.6107.5469.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Jeffery <djeffery@redhat.com>

When checking if an autofs mount point is busy it isn't sufficient to
only check if it's a mount point.

For example, if the mount of an offset mountpoint in a tree is denied
for this host by its export and the dentry becomes a process working
directory the check incorrectly returns the mount as not in use at expire.

This can happen since the default when mounting within a tree is nostrict,
which means ingnore mount fails on mounts within the tree and continue. The
nostrict option is meant to allow mounting in this case.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: stable@vger.kernel.org
---
 fs/autofs4/expire.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 01443ce..13ddec9 100644
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

