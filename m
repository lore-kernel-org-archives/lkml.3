Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3IPDF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 23:05:59 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:10922 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab3IPDEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 23:04:53 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 2/4] ipc,shm: prevent race with rmid in shmat(2)
Date: Sun, 15 Sep 2013 20:04:35 -0700
Message-Id: <1379300677-24188-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a race in shmat() between finding the msq and
actually attaching the segment, as another thread can delete shmid
underneath us if we are preempted before acquiring the kern_ipc_perm.lock.

Reported-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/shm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/ipc/shm.c b/ipc/shm.c
index bc3e897..1afde7e 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -1093,6 +1093,14 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
 		goto out_unlock;
 
 	ipc_lock_object(&shp->shm_perm);
+
+	/* have we raced with RMID? */
+	if (shp->shm_perm.deleted) {
+		err = -EIDRM;
+		ipc_unlock_object(&shp->shm_perm);
+		goto out_unlock;
+	}
+
 	err = security_shm_shmat(shp, shmaddr, shmflg);
 	if (err) {
 		ipc_unlock_object(&shp->shm_perm);
-- 
1.7.11.7

