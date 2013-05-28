Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab3E1D4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52633 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758926Ab3E1DyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:17 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ian Kent" <raven@themaw.net>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "David Jeffery" <djeffery@redhat.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.771268023@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [13/94] autofs - remove autofs dentry mount check
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/autofs4/expire.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -61,15 +61,6 @@ static int autofs4_mount_busy(struct vfs
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

