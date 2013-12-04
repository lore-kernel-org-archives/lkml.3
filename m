Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3LDBK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:10:28 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:40127 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab3LDBK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:10:26 -0500
Message-ID: <1386119423.2836.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc: avoid overflow of semop undo (semadj) value
From: Davidlohr Bueso <davidlohr@hp.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Date: Tue, 03 Dec 2013 17:10:23 -0800
In-Reply-To: <1386063865-23966-1-git-send-email-pmladek@suse.cz>
References: <1386063865-23966-1-git-send-email-pmladek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 10:44 +0100, Petr Mladek wrote:
> When trying to understand semop code, I found a small mistake in the check for
> semadj (undo) value overflow. The new undo value is not stored immediately
> and next potential checks are done against the old value.
> 
> The failing scenario is not much practical. One semop call has to do more
> operations on the same semaphore. Also semval and semadj must have different
> values, so there has to be some operations without SEM_UNDO flag. For example:
> 
> 	struct sembuf depositor_op[1];
> 	struct sembuf collector_op[2];
> 
> 	depositor_op[0].sem_num = 0;
> 	depositor_op[0].sem_op = 20000;
> 	depositor_op[0].sem_flg = 0;
> 
> 	collector_op[0].sem_num = 0;
> 	collector_op[0].sem_op = -10000;
> 	collector_op[0].sem_flg = SEM_UNDO;
> 	collector_op[1].sem_num = 0;
> 	collector_op[1].sem_op = -10000;
> 	collector_op[1].sem_flg = SEM_UNDO;
> 
> 	if (semop(semid, depositor_op, 1) == -1)
> 		{ perror("Failed to do 1st deposit"); return 1; }
> 
> 	if (semop(semid, collector_op, 2) == -1)
> 		{ perror("Failed to do 1st collect"); return 1; }
> 
> 	if (semop(semid, depositor_op, 1) == -1)
> 		{ perror("Failed to do 2nd deposit"); return 1; }
> 
> 	if (semop(semid, collector_op, 2) == -1)
> 		{ perror("Failed to do 2nd collect"); return 1; }
> 
> 	return 0;
> 
> It passes without error now but the semadj value has overflown in the
> 2nd collector operation.

Might as well correct the comments for the function while we're at it.

8<-----------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH] ipc,sem: correct header comment for perform_atomic_semop

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/sem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 0d43757..5fc15a9 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -584,10 +584,11 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
 	return ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
 }
 
-/** perform_atomic_semop - Perform (if possible) a semaphore operation
+/**
+ * perform_atomic_semop - Perform (if possible) a semaphore operation
  * @sma: semaphore array
  * @sops: array with operations that should be checked
- * @nsems: number of sops
+ * @nsops: number of operations
  * @un: undo array
  * @pid: pid that did the change
  *
@@ -595,7 +596,6 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
  * Returns 1 if the operation is impossible, the caller must sleep.
  * Negative values are error codes.
  */
-
 static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
 			     int nsops, struct sem_undo *un, int pid)
 {
-- 
1.8.1.4



