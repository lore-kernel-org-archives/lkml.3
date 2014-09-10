Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaIJB4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:56:30 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52136 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047AbaIJB42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:56:28 -0400
X-Sasl-enc: ty+ckWULxuY43dfR+q8K/nTHuVBLlvaWNIokRXmbBzEc 1410314185
Subject: [PATCH] autofs - remove obsolete d_invalidate() from expire
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 10 Sep 2014 09:56:22 +0800
Message-ID: <20140910015622.4059.66829.stgit@perseus.themaw.net>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Biederman's commit c4625721f changes d_invalidate() to sumarily remove
mounts under the passed in dentry regardless of whether they are busy
or not. So calling this in fs/autofs4/expire.c:autofs4_tree_busy() is
definitely the wrong thing to do becuase it will silently umount entries
instead of just cleaning stale dentrys.

But this call shouldn't be needed and testing shows that automounting
continues to function without it.

As Al Viro correctly surmises the original intent of the call was to
perform what shrink_dcache_parent() does.

If at some time in the future I see stale dentries accumulating
following failed mounts I'll revisit the issue and possibly add a
shrink_dcache_parent() call if needed.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/autofs4/expire.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index d97a761..b45fe2c 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -249,12 +249,6 @@ static int autofs4_tree_busy(struct vfsmount *mnt,
 			struct autofs_info *ino = autofs4_dentry_ino(p);
 			unsigned int ino_count = atomic_read(&ino->count);
 
-			/*
-			 * Clean stale dentries below that have not been
-			 * invalidated after a mount fail during lookup
-			 */
-			d_invalidate(p);
-
 			/* allow for dget above and top is already dgot */
 			if (p == top)
 				ino_count += 2;

