Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3LRThJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:37:09 -0500
Received: from a6-209.smtp-out.eu-west-1.amazonses.com ([54.240.6.209]:52441
	"EHLO a6-209.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995Ab3LRThI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:37:08 -0500
X-Greylist: delayed 739 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2013 14:37:07 EST
Date: Wed, 18 Dec 2013 19:24:46 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Chinner <dchinner@redhat.com>
cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [fs] inode_lru_isolate(): Move counter increment into spinlock
 section
Message-ID: <00000143072add16-956bfa6c-d7d5-4df9-aabc-05a904a0edc4-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.18-54.240.6.209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The counter increment in inode_lru_isolate is happening after
spinlocks have been dropped with preemption on using __count_vm_events
making counter increment races possible.

Move the counter increments to be done when the spinlock is
reacquired later so that the counter can be safely incremented.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/fs/inode.c
===================================================================
--- linux.orig/fs/inode.c	2013-12-18 13:14:43.211693438 -0600
+++ linux/fs/inode.c	2013-12-18 13:15:58.489266129 -0600
@@ -715,21 +715,21 @@ inode_lru_isolate(struct list_head *item
 	}

 	if (inode_has_buffers(inode) || inode->i_data.nrpages) {
+		unsigned long reap = 0;
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(lru_lock);
 		if (remove_inode_buffers(inode)) {
-			unsigned long reap;
 			reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
-			if (current_is_kswapd())
-				__count_vm_events(KSWAPD_INODESTEAL, reap);
-			else
-				__count_vm_events(PGINODESTEAL, reap);
 			if (current->reclaim_state)
 				current->reclaim_state->reclaimed_slab += reap;
 		}
 		iput(inode);
 		spin_lock(lru_lock);
+		if (current_is_kswapd())
+			__count_vm_events(KSWAPD_INODESTEAL, reap);
+		else
+			__count_vm_events(PGINODESTEAL, reap);
 		return LRU_RETRY;
 	}

