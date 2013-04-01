Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab3DACiH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 22:38:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30584 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab3DACiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 22:38:05 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: riel@surriel.com, davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] ipc,sem: prevent releasing RCU read lock twice in semctl_main
Date: Sun, 31 Mar 2013 22:36:44 -0400
Message-Id: <1364783804-28415-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will release RCU read lock twice if the sem id passed from userspace is
not within the legal range in semctl_main.

Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 ipc/sem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 6e109ef..ac36671 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1333,8 +1333,10 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	/* GETVAL, GETPID, GETNCTN, GETZCNT: fall-through */
 	}
 	err = -EINVAL;
-	if(semnum < 0 || semnum >= nsems)
-		goto out_unlock;
+	if(semnum < 0 || semnum >= nsems) {
+		rcu_read_unlock();
+		goto out_wakeup;
+	}
 
 	sem_lock(sma, NULL, -1);
 	curr = &sma->sem_base[semnum];
-- 
1.8.1.5

