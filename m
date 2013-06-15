Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3FOOGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:06:54 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:43344 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab3FOOGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:06:51 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] ipc/sem.c: scan complex wait-for-zero after undefined updates
Date: Sat, 15 Jun 2013 16:06:24 +0200
Message-Id: <1371305184-14667-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After an update of a semaphore array that does not use struct sembuf,
complex wait-for-zero operations were not checked if they are able to
proceed.

Andrew: Could you add it to -mm?
I've introduced the bug with
   ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues.patch

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index f9d1c06..ad9daca 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -785,8 +785,10 @@ static int do_smart_wakeup_zero(struct sem_array *sma, struct sembuf *sops,
 		 * Assume all were changed.
 		 */
 		for (i = 0; i < sma->sem_nsems; i++) {
-			if (sma->sem_base[i].semval == 0)
+			if (sma->sem_base[i].semval == 0) {
+				got_zero = 1;
 				semop_completed |= wake_const_ops(sma, i, pt);
+			}
 		}
 	}
 	/*
-- 
1.8.1.4

