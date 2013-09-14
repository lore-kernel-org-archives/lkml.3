Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3INVfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 17:35:39 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:40979 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab3INVfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 17:35:38 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Mike Galbraith <efault@gmx.de>,
        Manfred Spraul <manfred@colorfullife.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: [PATCH 2/2] ipc/sem.c: optimize sem_lock().
Date: Sat, 14 Sep 2013 23:34:56 +0200
Message-Id: <1379194496-4642-2-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379194496-4642-1-git-send-email-manfred@colorfullife.com>
References: <1379194496-4642-1-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Operations that need access to the whole array must guarantee that there are
no simple operations ongoing. Right now this is achieved by
spin_unlock_wait(sem->lock) on all semaphores.

If complex_count is nonzero, then this spin_unlock_wait() is not necessary,
because it was already performed in the past by the thread that increased
complex_count and even though sem_perm.lock was dropped inbetween, no simple
operation could have started, because simple operations cannot start when
complex_count is non-zero.

What do you think?
The patch survived some testing.

Its not a bugfix - thus I don't know if it should go into linux-next first.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 ipc/sem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/ipc/sem.c b/ipc/sem.c
index 4836ea7..5274ed1 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -248,12 +248,20 @@ static void merge_queues(struct sem_array *sma)
  * Caller must own sem_perm.lock.
  * New simple ops can start, because simple ops first check
  * that sem_perm.lock is free.
+ * that a) sem_perm.lock is free and b) complex_count is 0.
  */
 static void sem_wait_array(struct sem_array *sma)
 {
 	int i;
 	struct sem *sem;
 
+	if (sma->complex_count)  {
+		/* The thread that increased sma->complex_count waited on
+		 * all sem->lock locks. Thus we don't need to wait again.
+		 */
+		return;
+	}
+
 	for (i = 0; i < sma->sem_nsems; i++) {
 		sem = sma->sem_base + i;
 		spin_unlock_wait(&sem->lock);
-- 
1.8.3.1

