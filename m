Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaIXI1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:27:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbaIXI1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:18 -0400
Message-Id: <20140924082242.119255706@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Sep 2014 10:18:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 03/11] wait: Add might_sleep()
References: <20140924081845.572814794@infradead.org>
Content-Disposition: inline; filename=peterz-wait-might_sleep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more might_sleep() checks, suppose someone put a wait_event() like
thing in a wait loop..

Can't put might_sleep() in ___wait_event() because there's the locked
primitives which call ___wait_event() with locks held.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/wait.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -260,6 +260,7 @@ __out:	__ret;								\
  */
 #define wait_event(wq, condition)					\
 do {									\
+	might_sleep();							\
 	if (condition)							\
 		break;							\
 	__wait_event(wq, condition);					\
@@ -292,6 +293,7 @@ do {									\
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
+	might_sleep();							\
 	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
@@ -317,6 +319,7 @@ do {									\
  */
 #define wait_event_cmd(wq, condition, cmd1, cmd2)			\
 do {									\
+	might_sleep();							\
 	if (condition)							\
 		break;							\
 	__wait_event_cmd(wq, condition, cmd1, cmd2);			\
@@ -344,6 +347,7 @@ do {									\
 #define wait_event_interruptible(wq, condition)				\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_interruptible(wq, condition);	\
 	__ret;								\
@@ -377,6 +381,7 @@ do {									\
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
 	long __ret = timeout;						\
+	might_sleep();							\
 	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_timeout(wq,		\
 						condition, timeout);	\
@@ -427,6 +432,7 @@ do {									\
 #define wait_event_hrtimeout(wq, condition, timeout)			\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
 					       TASK_UNINTERRUPTIBLE);	\
@@ -452,6 +458,7 @@ do {									\
 #define wait_event_interruptible_hrtimeout(wq, condition, timeout)	\
 ({									\
 	long __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
 					       TASK_INTERRUPTIBLE);	\
@@ -465,6 +472,7 @@ do {									\
 #define wait_event_interruptible_exclusive(wq, condition)		\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_interruptible_exclusive(wq, condition);\
 	__ret;								\
@@ -639,6 +647,7 @@ do {									\
 #define wait_event_killable(wq, condition)				\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_killable(wq, condition);		\
 	__ret;								\
@@ -888,6 +897,7 @@ extern int bit_wait_io(struct wait_bit_k
 static inline int
 wait_on_bit(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
@@ -912,6 +922,7 @@ wait_on_bit(void *word, int bit, unsigne
 static inline int
 wait_on_bit_io(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
@@ -938,6 +949,7 @@ wait_on_bit_io(void *word, int bit, unsi
 static inline int
 wait_on_bit_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit, action, mode);
@@ -965,6 +977,7 @@ wait_on_bit_action(void *word, int bit,
 static inline int
 wait_on_bit_lock(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, bit_wait, mode);
@@ -988,6 +1001,7 @@ wait_on_bit_lock(void *word, int bit, un
 static inline int
 wait_on_bit_lock_io(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, bit_wait_io, mode);
@@ -1013,6 +1027,7 @@ wait_on_bit_lock_io(void *word, int bit,
 static inline int
 wait_on_bit_lock_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
@@ -1031,6 +1046,7 @@ wait_on_bit_lock_action(void *word, int
 static inline
 int wait_on_atomic_t(atomic_t *val, int (*action)(atomic_t *), unsigned mode)
 {
+	might_sleep();
 	if (atomic_read(val) == 0)
 		return 0;
 	return out_of_line_wait_on_atomic_t(val, action, mode);


