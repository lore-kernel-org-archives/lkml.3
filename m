Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3EIVCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 17:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab3EIVCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 17:02:01 -0400
Date: Thu, 9 May 2013 16:59:59 -0400
From: Rik van Riel <riel@redhat.com>
To: torvalds@linux-foundation.org
Cc: davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, koverstreet@google.com
Subject: [PATCH] ipc,sem: fix semctl(..., GETNCNT)
Message-ID: <20130509165959.08801612@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semctl GETNCNT returns the number of semops waiting for the
specified semaphore to become nonzero. After changeset 9f1bc2c,
the semops waiting on just one semaphore are waiting on that
semaphore's list.

In order to return the correct count, we have to walk that list
too, in addition to the sem_array's list for complex operations.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
This is the semncnt equivalent of the previous patch.

 ipc/sem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/ipc/sem.c b/ipc/sem.c
index 04b264d..a7e40ed 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -796,6 +796,13 @@ static int count_semncnt (struct sem_array * sma, ushort semnum)
 	struct sem_queue * q;
 
 	semncnt = 0;
+	list_for_each_entry(q, &sma->sem_base[semnum].sem_pending, list) {
+		struct sembuf * sops = q->sops;
+		BUG_ON(sops->sem_num != semnum);
+		if ((sops->sem_op < 0) && !(sops->sem_flg & IPC_NOWAIT))
+			semncnt++;
+	}
+
 	list_for_each_entry(q, &sma->sem_pending, list) {
 		struct sembuf * sops = q->sops;
 		int nsops = q->nsops;

