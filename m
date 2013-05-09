Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab3EIWhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:37:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab3EIWh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:37:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Jeffery <djeffery@redhat.com>, Ian Kent <raven@themaw.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 02/12] autofs - remove autofs dentry mount check
Date: Thu,  9 May 2013 15:37:15 -0700
Message-Id: <20130509223611.696809242@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509223611.432377360@linuxfoundation.org>
References: <20130509223611.432377360@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


