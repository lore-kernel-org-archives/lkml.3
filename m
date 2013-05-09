Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3EIUza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:55:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab3EIUz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:55:29 -0400
Date: Thu, 9 May 2013 16:53:28 -0400
From: Rik van Riel <riel@redhat.com>
To: torvalds@linux-foundation.org
Cc: davidlohr.bueso@hp.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, koverstreet@google.com
Subject: [PATCH] ipc,sem: fix semctl(..., GETZCNT)
Message-ID: <20130509165328.28237233@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semctl GETZCNT returns the number of semops waiting for the
specified semaphore to become zero.  After changeset 9f1bc2c,
the semops waiting on just one semaphore are waiting on that
semaphore's list.

In order to return the correct count, we have to walk that list
too, in addition to the sem_array's list for complex operations.

This bug broke dbench; it works again with this patch applied.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Kent Overstreet <koverstreet@google.com>
Tested-by: Kent Overstreet <koverstreet@google.com>
---
 ipc/sem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/ipc/sem.c b/ipc/sem.c
index 899b598..04b264d 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -815,6 +815,13 @@ static int count_semzcnt (struct sem_array * sma, ushort semnum)
 	struct sem_queue * q;
 
 	semzcnt = 0;
+	list_for_each_entry(q, &sma->sem_base[semnum].sem_pending, list) {
+		struct sembuf * sops = q->sops;
+		BUG_ON(sops->sem_num != semnum);
+		if ((sops->sem_op == 0) && !(sops->sem_flg & IPC_NOWAIT))
+			semzcnt++;
+	}
+
 	list_for_each_entry(q, &sma->sem_pending, list) {
 		struct sembuf * sops = q->sops;
 		int nsops = q->nsops;

