Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbaAJStE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:49:04 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39500 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbaAJSsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:48:51 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, manfred@colorfullife.com
Cc: riel@redhat.com, aswin@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] ipc: share ids rwsem when possible in ipcget_public
Date: Fri, 10 Jan 2014 10:48:26 -0800
Message-Id: <1389379707-20298-7-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
References: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and rewrite the function. For scenarios where the key is found and we end
up just doing different routinary checks, we can downgrade the ids->rwsem and
share it among concurrent readers. These checks include the following, which
are all safe to share the lock:

ops->more_checks() >>  sem_more_checks(), shm_more_checks()
ipc_check_perms()  >>  ipcperms(),ops->associate() >> [lsm]_[ipctype]_associate()

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/util.c | 60 +++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index e1b4c6d..fc5c655 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -183,7 +183,7 @@ void __init ipc_init_proc_interface(const char *path, const char *header,
  * ipc_findkey	- find a key in an ipc identifier set
  * @ids: ipc identifier set
  * @key: key to find
- *	
+ *
  * Returns the locked pointer to the ipc structure if found or NULL
  * otherwise. If key is found ipc points to the owning ipc structure
  *
@@ -375,48 +375,54 @@ static int ipc_check_perms(struct ipc_namespace *ns,
  * On success, the ipc id is returned.
  */
 static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
-		struct ipc_ops *ops, struct ipc_params *params)
+			 struct ipc_ops *ops, struct ipc_params *params)
 {
 	struct kern_ipc_perm *ipcp;
 	int flg = params->flg;
-	int err;
+	int err = 0;
 
-	/*
-	 * Take the lock as a writer since we are potentially going to add
-	 * a new entry + read locks are not "upgradable"
-	 */
 	down_write(&ids->rwsem);
 	ipcp = ipc_findkey(ids, params->key);
-	if (ipcp == NULL) {
+
+	if (!ipcp) {
 		/* key not used */
 		if (!(flg & IPC_CREAT))
 			err = -ENOENT;
-		else
+		else /* create new ipc object */
 			err = ops->getnew(ns, params);
-	} else {
-		/* ipc object has been locked by ipc_findkey() */
-
-		if (flg & IPC_CREAT && flg & IPC_EXCL)
-			err = -EEXIST;
-		else {
-			err = 0;
-			if (ops->more_checks)
-				err = ops->more_checks(ipcp, params);
-			if (!err)
-				/*
-				 * ipc_check_perms returns the IPC id on
-				 * success
-				 */
-				err = ipc_check_perms(ns, ipcp, ops, params);
-		}
+
+		goto done_write;
+	}
+
+	if ((flg & IPC_CREAT) && (flg & IPC_EXCL)) {
+		/* ipc object was locked by successful ipc_findkey() lookup */
 		ipc_unlock(ipcp);
+		err = -ENOENT;
+
+		goto done_write;
 	}
-	up_write(&ids->rwsem);
 
+	/*
+	 * The key was found, so we will just perform routinary checks on
+	 * ipc the object. Share the lock among other readers.
+	 */
+	downgrade_write(&ids->rwsem);
+
+	if (ops->more_checks)
+		err = ops->more_checks(ipcp, params);
+	if (!err)
+		/* returns the IPC id on success */
+		err = ipc_check_perms(ns, ipcp, ops, params);
+
+	ipc_unlock(ipcp);
+
+	up_read(&ids->rwsem);
+	return err;
+done_write:
+	up_write(&ids->rwsem);
 	return err;
 }
 
-
 /**
  * ipc_rmid - remove an ipc identifier
  * @ids: ipc identifier set
-- 
1.8.1.4

