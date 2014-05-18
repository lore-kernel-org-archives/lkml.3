Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaERH7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 03:59:46 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40228 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaERH66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 03:58:58 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 5/6] ipc/sem.c: Store which operation blocks in perform_atomic_semop()
Date: Sun, 18 May 2014 09:58:36 +0200
Message-Id: <1400399917-17583-6-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400399917-17583-5-git-send-email-manfred@colorfullife.com>
References: <1400399917-17583-1-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-2-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-3-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-4-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-5-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation for the next patch:
In the slow-path of perform_atomic_semop(), store a pointer to the operation
that caused the operation to block.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ipc/sem.c b/ipc/sem.c
index 7b1585d..8b5e976 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -109,6 +109,7 @@ struct sem_queue {
 	int			pid;	 /* process id of requesting process */
 	int			status;	 /* completion status of operation */
 	struct sembuf		*sops;	 /* array of pending operations */
+	struct sembuf		*blocking; /* the operation that blocked */
 	int			nsops;	 /* number of operations */
 	int			alter;	 /* does *sops alter the array? */
 };
@@ -642,6 +643,8 @@ out_of_range:
 	goto undo;
 
 would_block:
+	q->blocking = sop;
+
 	if (sop->sem_flg & IPC_NOWAIT)
 		result = -EAGAIN;
 	else
-- 
1.9.0

