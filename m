Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaFLXR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:17:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaFLXRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:17:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.15 02/12] lock_parent: dont step on stale ->d_parent of all-but-freed one
Date: Thu, 12 Jun 2014 16:21:04 -0700
Message-Id: <20140612232045.011362521@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232044.886466924@linuxfoundation.org>
References: <20140612232044.886466924@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit c2338f2dc7c1e9f6202f370c64ffd7f44f3d4b51 upstream.

Dentry that had been through (or into) __dentry_kill() might be seen
by shrink_dentry_list(); that's normal, it'll be taken off the shrink
list and freed if __dentry_kill() has already finished.  The problem
is, its ->d_parent might be pointing to already freed dentry, so
lock_parent() needs to be careful.

We need to check that dentry hasn't already gone into __dentry_kill()
*and* grab rcu_read_lock() before dropping ->d_lock - the latter makes
sure that whatever we see in ->d_parent after dropping ->d_lock it
won't be freed until we drop rcu_read_lock().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -532,10 +532,12 @@ static inline struct dentry *lock_parent
 	struct dentry *parent = dentry->d_parent;
 	if (IS_ROOT(dentry))
 		return NULL;
+	if (unlikely((int)dentry->d_lockref.count < 0))
+		return NULL;
 	if (likely(spin_trylock(&parent->d_lock)))
 		return parent;
-	spin_unlock(&dentry->d_lock);
 	rcu_read_lock();
+	spin_unlock(&dentry->d_lock);
 again:
 	parent = ACCESS_ONCE(dentry->d_parent);
 	spin_lock(&parent->d_lock);


