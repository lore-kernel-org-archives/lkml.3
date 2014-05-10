Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbaEJKEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 06:04:20 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64294 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbaEJKDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 06:03:47 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 5/6] ipc/sem.c: Store which operation blocks in perform_atomic_semop()
Date: Sat, 10 May 2014 12:03:18 +0200
Message-Id: <1399716199-26776-6-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399716199-26776-5-git-send-email-manfred@colorfullife.com>
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
 <1399716199-26776-2-git-send-email-manfred@colorfullife.com>
 <1399716199-26776-3-git-send-email-manfred@colorfullife.com>
 <1399716199-26776-4-git-send-email-manfred@colorfullife.com>
 <1399716199-26776-5-git-send-email-manfred@colorfullife.com>
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
index 3962cca..22a4c12 100644
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

