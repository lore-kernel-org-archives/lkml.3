Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab3CKVWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:22:05 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33539 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab3CKVPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:37 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 42/44] tty: Reduce and simplify ldsem atomic ops
Date: Mon, 11 Mar 2013 16:45:02 -0400
Message-Id: <1363034704-28036-43-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge all atomic operations on the sem count into only
2 functions: atomic add w/ result and cmpxchg w/ success/fail
and in-memory value return.

Reduce the waiting readers and writer trylocks to a single
optimistic grant attempt followed by looping on unsuccessful
reversal attempts with cmpxchg. This allows unsuccessful
reversals that already grant the lock to pass through without
needing to retry the grant atomically.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldsem.c | 59 +++++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index fd95950..e750ac3 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -83,6 +83,12 @@ static inline long ldsem_atomic_update(long delta, struct ld_semaphore *sem)
 	return atomic_long_add_return(delta, (atomic_long_t *)&sem->count);
 }
 
+static inline int ldsem_cmpxchg(long *old, long new, struct ld_semaphore *sem)
+{
+	long tmp = *old;
+	*old = atomic_long_cmpxchg(&sem->count, *old, new);
+	return *old == tmp;
+}
 
 /*
  * Initialize an ldsem:
@@ -108,20 +114,18 @@ static void __ldsem_wake_readers(struct ld_semaphore *sem)
 {
 	struct ldsem_waiter *waiter, *next;
 	struct task_struct *tsk;
-	long adjust;
+	long adjust, count;
 
 	/* Try to grant read locks to all readers on the read wait list.
 	 * Note the 'active part' of the count is incremented by
 	 * the number of readers before waking any processes up.
 	 */
 	adjust = sem->wait_readers * (LDSEM_ACTIVE_BIAS - LDSEM_WAIT_BIAS);
+	count = ldsem_atomic_update(adjust, sem);
 	do {
-		long count;
-		count = ldsem_atomic_update(adjust, sem);
 		if (count > 0)
 			break;
-		count = ldsem_atomic_update(-adjust, sem);
-		if (count + adjust < 0)
+		if (ldsem_cmpxchg(&count, count - adjust, sem))
 			return;
 	} while (1);
 
@@ -141,23 +145,13 @@ static inline int writer_trylock(struct ld_semaphore *sem)
 	/* only wake this writer if the active part of the count can be
 	 * transitioned from 0 -> 1
 	 */
+	long count = ldsem_atomic_update(LDSEM_ACTIVE_BIAS, sem);
 	do {
-		long count;
-
-		count = ldsem_atomic_update(LDSEM_ACTIVE_BIAS, sem);
-		if ((count & LDSEM_ACTIVE_MASK) == 1)
-			break;
-
-		/* Someone grabbed the sem already -
-		 * undo the change to the active count, but check for
-		 * a transition 1->0
-		 */
-		count = ldsem_atomic_update(-LDSEM_ACTIVE_BIAS, sem);
-		if (count & LDSEM_ACTIVE_MASK)
+		if ((count & LDSEM_ACTIVE_MASK) == LDSEM_ACTIVE_BIAS)
+			return 1;
+		if (ldsem_cmpxchg(&count, count - LDSEM_ACTIVE_BIAS, sem))
 			return 0;
 	} while (1);
-
-	return 1;
 }
 
 static void __ldsem_wake_writer(struct ld_semaphore *sem)
@@ -305,7 +299,7 @@ static inline int __ldsem_down_read_nested(struct ld_semaphore *sem,
 {
 	lockdep_acquire_read(sem, subclass, 0, _RET_IP_);
 
-	if (atomic_long_inc_return((atomic_long_t *)&sem->count) <= 0) {
+	if (ldsem_atomic_update(LDSEM_READ_BIAS, sem) <= 0) {
 		lock_stat(sem, contended);
 		if (!down_read_failed(sem, timeout)) {
 			lockdep_release(sem, 1, _RET_IP_);
@@ -323,8 +317,7 @@ static inline int __ldsem_down_write_nested(struct ld_semaphore *sem,
 
 	lockdep_acquire(sem, subclass, 0, _RET_IP_);
 
-	count = atomic_long_add_return(LDSEM_WRITE_BIAS,
-				       (atomic_long_t *)&sem->count);
+	count = ldsem_atomic_update(LDSEM_WRITE_BIAS, sem);
 	if ((count & LDSEM_ACTIVE_MASK) != LDSEM_ACTIVE_BIAS) {
 		lock_stat(sem, contended);
 		if (!down_write_failed(sem, timeout)) {
@@ -351,11 +344,10 @@ int __sched ldsem_down_read(struct ld_semaphore *sem, long timeout)
  */
 int ldsem_down_read_trylock(struct ld_semaphore *sem)
 {
-	long count;
+	long count = sem->count;
 
-	while ((count = sem->count) >= 0) {
-		if (count == atomic_long_cmpxchg(&sem->count, count,
-						 count + LDSEM_READ_BIAS)) {
+	while (count >= 0) {
+		if (ldsem_cmpxchg(&count, count + LDSEM_READ_BIAS, sem)) {
 			lockdep_acquire_read(sem, 0, 1, _RET_IP_);
 			lock_stat(sem, acquired);
 			return 1;
@@ -378,14 +370,10 @@ int __sched ldsem_down_write(struct ld_semaphore *sem, long timeout)
  */
 int ldsem_down_write_trylock(struct ld_semaphore *sem)
 {
-	long count;
-
-	while (((count = sem->count) & LDSEM_ACTIVE_MASK) == 0) {
-		long tmp;
+	long count = sem->count;
 
-		tmp = atomic_long_cmpxchg(&sem->count, count,
-					  count + LDSEM_WRITE_BIAS);
-		if (count == tmp) {
+	while ((count & LDSEM_ACTIVE_MASK) == 0) {
+		if (ldsem_cmpxchg(&count, count + LDSEM_WRITE_BIAS, sem)) {
 			lockdep_acquire(sem, 0, 1, _RET_IP_);
 			lock_stat(sem, acquired);
 			return 1;
@@ -403,7 +391,7 @@ void ldsem_up_read(struct ld_semaphore *sem)
 
 	lockdep_release(sem, 1, _RET_IP_);
 
-	count = atomic_long_dec_return((atomic_long_t *)&sem->count);
+	count = ldsem_atomic_update(-LDSEM_READ_BIAS, sem);
 	if (count < 0 && (count & LDSEM_ACTIVE_MASK) == 0)
 		ldsem_wake(sem);
 }
@@ -417,8 +405,7 @@ void ldsem_up_write(struct ld_semaphore *sem)
 
 	lockdep_release(sem, 1, _RET_IP_);
 
-	count = atomic_long_sub_return(LDSEM_WRITE_BIAS,
-				       (atomic_long_t *)&sem->count);
+	count = ldsem_atomic_update(-LDSEM_WRITE_BIAS, sem);
 	if (count < 0)
 		ldsem_wake(sem);
 }
-- 
1.8.1.2

