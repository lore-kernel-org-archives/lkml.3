Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbaFJTyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:54:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35591 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaFJTx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:53:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 159/160] autofs: fix lockref lookup
Date: Tue, 10 Jun 2014 12:46:39 -0700
Message-Id: <1402429600-20477-160-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Kent <raven@themaw.net>

commit 6b6751f7feba68d8f5c72b72cc69a1c5a625529c upstream.

autofs needs to be able to see private data dentry flags for its dentrys
that are being created but not yet hashed and for its dentrys that have
been rmdir()ed but not yet freed.  It needs to do this so it can block
processes in these states until a status has been returned to indicate
the given operation is complete.

It does this by keeping two lists, active and expring, of dentrys in
this state and uses ->d_release() to keep them stable while it checks
the reference count to determine if they should be used.

But with the recent lockref changes dentrys being freed sometimes don't
transition to a reference count of 0 before being freed so autofs can
occassionally use a dentry that is invalid which can lead to a panic.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/autofs4/root.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 92ef341..2a69bde 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -179,7 +179,7 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 		spin_lock(&active->d_lock);
 
 		/* Already gone? */
-		if (!d_count(active))
+		if ((int) d_count(active) <= 0)
 			goto next;
 
 		qstr = &active->d_name;
@@ -230,7 +230,7 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 
 		spin_lock(&expiring->d_lock);
 
-		/* Bad luck, we've already been dentry_iput */
+		/* We've already been dentry_iput or unlinked */
 		if (!expiring->d_inode)
 			goto next;
 
-- 
1.9.1

