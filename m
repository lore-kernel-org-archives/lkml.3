Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbaA1XWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:22:05 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:47083 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbaA1XWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:22:01 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/11] kernfs: invoke kernfs_unmap_bin_file() directly from kernfs_deactivate()
Date: Tue, 28 Jan 2014 18:21:43 -0500
Message-Id: <1390951311-15325-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951311-15325-1-git-send-email-tj@kernel.org>
References: <1390951311-15325-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_unmap_bin_file() is supposed to unmap all memory mappings of
the target file before kernfs_remove() finishes; however, it currently
is being called from kernfs_addrm_finish() and has the same race
problem as the original implementation of deactivation when there are
multiple removers - only the remover which snatches the node to its
addrm_cxt->removed list is guaranteed to wait for its completion
before returning.

It can be easily fixed by moving kernfs_unmap_bin_file() invocation
from kernfs_addrm_finish() to kernfs_deactivated().  The function may
be called multiple times but that shouldn't do any harm.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 9d99e6a..1cb74bd 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -177,9 +177,10 @@ void kernfs_put_active(struct kernfs_node *kn)
  *	kernfs_deactivate - deactivate kernfs_node
  *	@kn: kernfs_node to deactivate
  *
- *	Deny new active references and drain existing ones.  Mutiple
- *	removers may invoke this function concurrently on @kn and all will
- *	return after deactivation and draining are complete.
+ *	Deny new active references, drain existing ones and nuke all
+ *	existing mmaps.  Mutiple removers may invoke this function
+ *	concurrently on @kn and all will return after deactivation and
+ *	draining are complete.
  */
 static void kernfs_deactivate(struct kernfs_node *kn)
 	__releases(&kernfs_mutex) __acquires(&kernfs_mutex)
@@ -209,6 +210,8 @@ static void kernfs_deactivate(struct kernfs_node *kn)
 	lock_acquired(&kn->dep_map, _RET_IP_);
 	rwsem_release(&kn->dep_map, 1, _RET_IP_);
 
+	kernfs_unmap_bin_file(kn);
+
 	mutex_lock(&kernfs_mutex);
 }
 
@@ -489,7 +492,6 @@ void kernfs_addrm_finish(struct kernfs_addrm_cxt *acxt)
 
 		acxt->removed = kn->u.removed_list;
 
-		kernfs_unmap_bin_file(kn);
 		kernfs_put(kn);
 	}
 }
-- 
1.8.5.3

