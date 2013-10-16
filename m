Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935158Ab3JPSF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:05:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761619Ab3JPRqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Manfred Spraul <manfred@colorfullife.com>,
        Mike Galbraith <bitbucket@online.de>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 65/69] ipc/sem.c: optimize sem_lock()
Date: Wed, 16 Oct 2013 10:45:14 -0700
Message-Id: <20131016174320.846628343@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manfred Spraul <manfred@colorfullife.com>

commit 6d07b68ce16ae9535955ba2059dedba5309c3ca1 upstream.

Operations that need access to the whole array must guarantee that there
are no simple operations ongoing.  Right now this is achieved by
spin_unlock_wait(sem->lock) on all semaphores.

If complex_count is nonzero, then this spin_unlock_wait() is not
necessary, because it was already performed in the past by the thread
that increased complex_count and even though sem_perm.lock was dropped
inbetween, no simple operation could have started, because simple
operations cannot start when complex_count is non-zero.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/sem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -257,12 +257,20 @@ static void sem_rcu_free(struct rcu_head
  * Caller must own sem_perm.lock.
  * New simple ops cannot start, because simple ops first check
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


