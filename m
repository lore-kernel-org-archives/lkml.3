Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934983Ab3JPSMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:12:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761459Ab3JPRpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 50/69] ipc: drop ipcctl_pre_down
Date: Wed, 16 Oct 2013 10:44:59 -0700
Message-Id: <20131016174318.999979404@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

commit 3b1c4ad37741e53804ffe0a30dd01e08b2ab6241 upstream.

Now that sem, msgque and shm, through *_down(), all use the lockless
variant of ipcctl_pre_down(), go ahead and delete it.

[akpm@linux-foundation.org: fix function name in kerneldoc, cleanups]
Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/util.c |   24 ++++--------------------
 ipc/util.h |    3 ---
 2 files changed, 4 insertions(+), 23 deletions(-)

--- a/ipc/util.c
+++ b/ipc/util.c
@@ -733,7 +733,7 @@ int ipc_update_perm(struct ipc64_perm *i
 }
 
 /**
- * ipcctl_pre_down - retrieve an ipc and check permissions for some IPC_XXX cmd
+ * ipcctl_pre_down_nolock - retrieve an ipc and check permissions for some IPC_XXX cmd
  * @ns:  the ipc namespace
  * @ids:  the table of ids where to look for the ipc
  * @id:   the id of the ipc to retrieve
@@ -746,29 +746,13 @@ int ipc_update_perm(struct ipc64_perm *i
  * It must be called without any lock held and
  *  - retrieves the ipc with the given id in the given table.
  *  - performs some audit and permission check, depending on the given cmd
- *  - returns the ipc with the ipc lock held in case of success
- *    or an err-code without any lock held otherwise.
+ *  - returns a pointer to the ipc object or otherwise, the corresponding error.
  *
  * Call holding the both the rw_mutex and the rcu read lock.
  */
-struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
-				      struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extra_perm)
-{
-	struct kern_ipc_perm *ipcp;
-
-	ipcp = ipcctl_pre_down_nolock(ns, ids, id, cmd, perm, extra_perm);
-	if (IS_ERR(ipcp))
-		goto out;
-
-	spin_lock(&ipcp->lock);
-out:
-	return ipcp;
-}
-
 struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
-					     struct ipc_ids *ids, int id, int cmd,
-					     struct ipc64_perm *perm, int extra_perm)
+					struct ipc_ids *ids, int id, int cmd,
+					struct ipc64_perm *perm, int extra_perm)
 {
 	kuid_t euid;
 	int err = -EPERM;
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -131,9 +131,6 @@ int ipc_update_perm(struct ipc64_perm *i
 struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 					     struct ipc_ids *ids, int id, int cmd,
 					     struct ipc64_perm *perm, int extra_perm);
-struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
-				      struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extra_perm);
 
 #ifndef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 


