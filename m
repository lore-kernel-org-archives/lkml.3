Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab3LBVOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:14:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3LBTNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 043/173] ipc: update locking scheme comments
Date: Mon,  2 Dec 2013 11:10:26 -0800
Message-Id: <20131202191147.609232256@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr@hp.com>

commit 18ccee263c7e250a57f01c9434658f11f4118a64 upstream.

The initial documentation was a bit incomplete, update accordingly.

[akpm@linux-foundation.org: make it more readable in 80 columns]
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/util.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

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


