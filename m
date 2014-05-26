Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaEZRMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:12:45 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:58976 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaEZRMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:12:44 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 7/6 v3] ipc/sem.c: add a printk_once for semctl(GETNCNT/GETZCNT)
Date: Mon, 26 May 2014 19:12:36 +0200
Message-Id: <1401124356-21174-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The actual Linux implementation for semctl(GETNCNT) and semctl(GETZCNT)
always (since 0.99.10) reported a thread as sleeping on all semaphores
that are listed in the semop() call.
The documented behavior (both in the Linux man page and in the Single Unix
Specification) is that a task should be reported on exactly one semaphore:
The semaphore that caused the thread to got to sleep.

This patch adds a pr_info_once() that is triggered if a thread hits
the relevant case.

The code triggers slightly too often, otherwise it would be necessary to
replicate the old code. As there are no known users of GETNCNT or GETZCNT,
this is done to prevent unnecessary bloat.

The task that triggered is reported with name (tsk->comm) and pid.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Joe Perches <joe@perches.com>
---
 ipc/sem.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/ipc/sem.c b/ipc/sem.c
index 71a3caf..a6c292d 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1000,6 +1000,17 @@ static int check_qop(struct sem_array *sma, int semnum, struct sem_queue *q,
 {
 	struct sembuf *sop = q->blocking;
 
+	/*
+	 * Linux always (since 0.99.10) reported a task as sleeping on all
+	 * semaphores. This violates SUS, therefore it was changed to the
+	 * standard compliant behavior.
+	 * Give the administrators a chance to notice that an application
+	 * might misbehave because it relies on the Linux behavior.
+	 */
+	pr_info_once("semctl(GETNCNT/GETZCNT) is since 3.16 Single Unix Specification compliant.\n"
+			"The task %s (%d) triggered the difference, watch for misbehavior.\n",
+			current->comm, task_pid_nr(current));
+
 	if (sop->sem_num != semnum)
 		return 0;
 
-- 
1.9.0

