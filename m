Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935231Ab3JPSIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:08:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761289Ab3JPRqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 60/69] ipc: drop ipc_lock_by_ptr
Date: Wed, 16 Oct 2013 10:45:09 -0700
Message-Id: <20131016174320.232751887@linuxfoundation.org>
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

commit 32a2750010981216fb788c5190fb0e646abfab30 upstream.

After previous cleanups and optimizations, this function is no longer
heavily used and we don't have a good reason to keep it.  Update the few
remaining callers and get rid of it.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/namespace.c |    3 ++-
 ipc/util.c      |    6 ++++--
 ipc/util.h      |    6 ------
 3 files changed, 6 insertions(+), 9 deletions(-)

--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -89,7 +89,8 @@ void free_ipcs(struct ipc_namespace *ns,
 		perm = idr_find(&ids->ipcs_idr, next_id);
 		if (perm == NULL)
 			continue;
-		ipc_lock_by_ptr(perm);
+		rcu_read_lock();
+		ipc_lock_object(perm);
 		free(ns, perm);
 		total++;
 	}
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -205,7 +205,8 @@ static struct kern_ipc_perm *ipc_findkey
 			continue;
 		}
 
-		ipc_lock_by_ptr(ipc);
+		rcu_read_lock();
+		ipc_lock_object(ipc);
 		return ipc;
 	}
 
@@ -838,7 +839,8 @@ static struct kern_ipc_perm *sysvipc_fin
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
 			*new_pos = pos + 1;
-			ipc_lock_by_ptr(ipc);
+			rcu_read_lock();
+			ipc_lock_object(ipc);
 			return ipc;
 		}
 	}
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -171,12 +171,6 @@ static inline void ipc_assert_locked_obj
 	assert_spin_locked(&perm->lock);
 }
 
-static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
-{
-	rcu_read_lock();
-	ipc_lock_object(perm);
-}
-
 static inline void ipc_unlock(struct kern_ipc_perm *perm)
 {
 	ipc_unlock_object(perm);


