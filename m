Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3LFN4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:56:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab3LFNBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 100/272] ipc: update locking scheme comments
Date: Fri,  6 Dec 2013 12:56:29 +0000
Message-Id: <1386334761-25517-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr@hp.com>

commit 18ccee263c7e250a57f01c9434658f11f4118a64 upstream.

The initial documentation was a bit incomplete, update accordingly.

[akpm@linux-foundation.org: make it more readable in 80 columns]
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 ipc/util.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index fdb8ae7..7684f41 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -17,12 +17,27 @@
  *            Pavel Emelianov <xemul@openvz.org>
  *
  * General sysv ipc locking scheme:
- *  when doing ipc id lookups, take the ids->rwsem
- *      rcu_read_lock()
- *          obtain the ipc object (kern_ipc_perm)
- *          perform security, capabilities, auditing and permission checks, etc.
- *          acquire the ipc lock (kern_ipc_perm.lock) throught ipc_lock_object()
- *             perform data updates (ie: SET, RMID, LOCK/UNLOCK commands)
+ *	rcu_read_lock()
+ *          obtain the ipc object (kern_ipc_perm) by looking up the id in an idr
+ *	    tree.
+ *	    - perform initial checks (capabilities, auditing and permission,
+ *	      etc).
+ *	    - perform read-only operations, such as STAT, INFO commands.
+ *	      acquire the ipc lock (kern_ipc_perm.lock) through
+ *	      ipc_lock_object()
+ *		- perform data updates, such as SET, RMID commands and
+ *		  mechanism-specific operations (semop/semtimedop,
+ *		  msgsnd/msgrcv, shmat/shmdt).
+ *	    drop the ipc lock, through ipc_unlock_object().
+ *	rcu_read_unlock()
+ *
+ *  The ids->rwsem must be taken when:
+ *	- creating, removing and iterating the existing entries in ipc
+ *	  identifier sets.
+ *	- iterating through files under /proc/sysvipc/
+ *
+ *  Note that sems have a special fast path that avoids kern_ipc_perm.lock -
+ *  see sem_lock().
  */
 
 #include <linux/mm.h>
-- 
1.8.3.2

