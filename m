Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbaEJKE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 06:04:57 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:45718 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaEJKDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 06:03:43 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 2/6] ipc/sem.c: Bugfix for semctl(,,GETZCNT)
Date: Sat, 10 May 2014 12:03:15 +0200
Message-Id: <1399716199-26776-3-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399716199-26776-2-git-send-email-manfred@colorfullife.com>
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
 <1399716199-26776-2-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GETZCNT is supposed to return the number of threads that wait until
a semaphore value becomes 0.
The current implementation overlooks complex operations that contain
both wait-for-zero operation and operations that alter at least one semaphore.

The patch fixes that.
It's intentionally copy&paste, this will be cleaned up in the next patch.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/ipc/sem.c b/ipc/sem.c
index 5749b9c..dc648f8 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1047,6 +1047,16 @@ static int count_semzcnt(struct sem_array *sma, ushort semnum)
 			    && !(sops[i].sem_flg & IPC_NOWAIT))
 				semzcnt++;
 	}
+	list_for_each_entry(q, &sma->pending_alter, list) {
+		struct sembuf *sops = q->sops;
+		int nsops = q->nsops;
+		int i;
+		for (i = 0; i < nsops; i++)
+			if (sops[i].sem_num == semnum
+			    && (sops[i].sem_op == 0)
+			    && !(sops[i].sem_flg & IPC_NOWAIT))
+				semzcnt++;
+	}
 	return semzcnt;
 }
 
-- 
1.9.0

