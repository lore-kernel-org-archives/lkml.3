Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385Ab3JPSUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:20:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761315Ab3JPRpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 31/69] ipc: introduce ipc object locking helpers
Date: Wed, 16 Oct 2013 10:44:40 -0700
Message-Id: <20131016174316.701235018@linuxfoundation.org>
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

commit 1ca7003ab41152d673d9e359632283d05294f3d6 upstream.

Simple helpers around the (kern_ipc_perm *)->lock spinlock.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/util.h |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/ipc/util.h
+++ b/ipc/util.h
@@ -159,23 +159,33 @@ static inline int ipc_checkid(struct ker
 	return uid / SEQ_MULTIPLIER != ipcp->seq;
 }
 
-static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
+static inline void ipc_lock_object(struct kern_ipc_perm *perm)
 {
-	rcu_read_lock();
 	spin_lock(&perm->lock);
 }
 
-static inline void ipc_unlock(struct kern_ipc_perm *perm)
+static inline void ipc_unlock_object(struct kern_ipc_perm *perm)
 {
 	spin_unlock(&perm->lock);
-	rcu_read_unlock();
 }
 
-static inline void ipc_lock_object(struct kern_ipc_perm *perm)
+static inline void ipc_assert_locked_object(struct kern_ipc_perm *perm)
 {
+	assert_spin_locked(&perm->lock);
+}
+
+static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
+{
+	rcu_read_lock();
 	spin_lock(&perm->lock);
 }
 
+static inline void ipc_unlock(struct kern_ipc_perm *perm)
+{
+	spin_unlock(&perm->lock);
+	rcu_read_unlock();
+}
+
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,


