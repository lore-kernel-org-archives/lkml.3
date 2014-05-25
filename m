Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaEYSVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:21:11 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50623 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaEYSVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:21:10 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 7/6] ipc/sem.c: add a printk_once for semctl(GETNCNT/GETZCNT)
Date: Sun, 25 May 2014 20:21:03 +0200
Message-Id: <1401042063-24666-1-git-send-email-manfred@colorfullife.com>
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

This patch adds a printk_once() that is triggered if a thread hits
the relevant case.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
---
 ipc/sem.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/ipc/sem.c b/ipc/sem.c
index 9106321..3cc2f7b6 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1000,6 +1000,18 @@ static int check_qop(struct sem_array *sma, int semnum, struct sem_queue *q,
 {
 	struct sembuf *sop = q->blocking;
 
+	/*
+	 * Linux always (since 0.99.10) reported a task as sleeping on all
+	 * semaphores. This violates SUS, therefore it was changed to the
+	 * standard compliant behavior.
+	 * Give the administrators a chance to notice that an application
+	 * might misbehave because it relies on the Linux behavior.
+	 */
+	printk_once(KERN_INFO "semctl(GETNCNT/GETZCNT) is since 3.16 Single " \
+				"Unix Specification compliant.\n" \
+				"The task %d triggered the difference, " \
+				"watch for misbehavior.", current->pid);
+
 	if (sop->sem_num != semnum)
 		return 0;
 
-- 
1.9.0

