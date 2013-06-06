Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3FFBUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:20:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35400 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab3FFBUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:20:13 -0400
Date: Thu, 6 Jun 2013 02:20:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] corner cases of open() on procfs symlinks
Message-ID: <20130606012010.GE13110@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	I'm not sure whether to treat that as a bug or as a weird misfeature
enshrined in userland ABI:
	open("/tmp", O_CREAT, 0) => -EISDIR	// LAST_NORM case
	open("/", O_CREAT, 0) => -EISDIR	// LAST_ROOT
	open(".", O_CREAT, 0) => -EISDIR	// LAST_DOT
	open("..", O_CREAT, 0) => -EISDIR	// LAST_DOTDOT
	open("/proc/self/cwd", O_CREAT, 0) => success	// LAST_BIND
	open("/proc/self/cwd/", O_CREAT, 0) => -EISDIR	// trailing slashes
At the very least, it's inconsistent.  OTOH, it's exposed to userland.
OTTH, SuS says that O_CREAT without O_RDWR or O_WRONLY is undefined, and
either of those two would suffice for -EISDIR in all cases (may_open() takes
care of that).

Another unpleasantness:
	open("/proc/self/exe", LOOKUP_DIRECTORY, 0) -> success
That one is clearly a bug.  Moreover, getting rid of both of those
bugs actually simplifies the mess in do_last().  I would obviously
like to do that - do_last() is far too convoluted as it is; the only
question is whether we can change the first weirdness...  Comments?

FWIW, the simplification of do_last() would look like that:

diff --git a/fs/namei.c b/fs/namei.c
index 85e40d1..617599c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2690,28 +2690,10 @@ static int do_last(struct nameidata *nd, struct path *path,
 	nd->flags &= ~LOOKUP_PARENT;
 	nd->flags |= op->intent;
 
-	switch (nd->last_type) {
-	case LAST_DOTDOT:
-	case LAST_DOT:
+	if (nd->last_type != LAST_NORM) {
 		error = handle_dots(nd, nd->last_type);
 		if (error)
 			return error;
-		/* fallthrough */
-	case LAST_ROOT:
-		error = complete_walk(nd);
-		if (error)
-			return error;
-		audit_inode(name, nd->path.dentry, 0);
-		if (open_flag & O_CREAT) {
-			error = -EISDIR;
-			goto out;
-		}
-		goto finish_open;
-	case LAST_BIND:
-		error = complete_walk(nd);
-		if (error)
-			return error;
-		audit_inode(name, dir, 0);
 		goto finish_open;
 	}
 
@@ -2841,6 +2823,7 @@ finish_lookup:
 	}
 	nd->inode = inode;
 	/* Why this, you ask?  _Now_ we might have grown LOOKUP_JUMPED... */
+finish_open:
 	error = complete_walk(nd);
 	if (error) {
 		path_put(&save_parent);
@@ -2853,7 +2836,6 @@ finish_lookup:
 	if ((nd->flags & LOOKUP_DIRECTORY) && !nd->inode->i_op->lookup)
 		goto out;
 	audit_inode(name, nd->path.dentry, 0);
-finish_open:
 	if (!S_ISREG(nd->inode->i_mode))
 		will_truncate = false;
 
