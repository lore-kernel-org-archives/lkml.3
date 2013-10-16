Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761768Ab3JPRyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:54:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761636Ab3JPRqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 33/50] ipc,shm: shorten critical region in shmctl_down
Date: Wed, 16 Oct 2013 10:45:19 -0700
Message-Id: <20131016174402.341337598@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

commit 79ccf0f8c8e04e8b9eda6645ba0f63b0915a3075 upstream.

Instead of holding the ipc lock for the entire function, use the
ipcctl_pre_down_nolock and only acquire the lock for specific commands:
RMID and SET.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/shm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -787,11 +787,10 @@ static int shmctl_down(struct ipc_namesp
 	down_write(&shm_ids(ns).rw_mutex);
 	rcu_read_lock();
 
-	ipcp = ipcctl_pre_down(ns, &shm_ids(ns), shmid, cmd,
-			       &shmid64.shm_perm, 0);
+	ipcp = ipcctl_pre_down_nolock(ns, &shm_ids(ns), shmid, cmd,
+				      &shmid64.shm_perm, 0);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
-		/* the ipc lock is not held upon failure */
 		goto out_unlock1;
 	}
 
@@ -799,14 +798,16 @@ static int shmctl_down(struct ipc_namesp
 
 	err = security_shm_shmctl(shp, cmd);
 	if (err)
-		goto out_unlock0;
+		goto out_unlock1;
 
 	switch (cmd) {
 	case IPC_RMID:
+		ipc_lock_object(&shp->shm_perm);
 		/* do_shm_rmid unlocks the ipc object and rcu */
 		do_shm_rmid(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
+		ipc_lock_object(&shp->shm_perm);
 		err = ipc_update_perm(&shmid64.shm_perm, ipcp);
 		if (err)
 			goto out_unlock0;
@@ -814,6 +815,7 @@ static int shmctl_down(struct ipc_namesp
 		break;
 	default:
 		err = -EINVAL;
+		goto out_unlock1;
 	}
 
 out_unlock0:


