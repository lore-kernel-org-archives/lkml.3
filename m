Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbaHVNnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:43:13 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:44466 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329AbaHVNnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:43:12 -0400
Date: Fri, 22 Aug 2014 16:43:03 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] afs: inode: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140822134303.GA30918@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 fs/afs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 2946712..6457621 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -445,7 +445,7 @@ void afs_evict_inode(struct inode *inode)
 
 	mutex_lock(&vnode->permits_lock);
 	permits = vnode->permits;
-	rcu_assign_pointer(vnode->permits, NULL);
+	RCU_INIT_POINTER(vnode->permits, NULL);
 	mutex_unlock(&vnode->permits_lock);
 	if (permits)
 		call_rcu(&permits->rcu, afs_zap_permits);
-- 
1.9.1

