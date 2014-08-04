Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaHDKjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:39:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:33271 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaHDKjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:39:54 -0400
Message-Id: <20140804103537.426757643@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Aug 2014 12:30:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 2/7] wait: Provide 
References: <20140804103025.478913141@infradead.org>
Content-Disposition: inline; filename=peterz-wait-might_sleep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more might_sleep() checks, suppose someone put a wait_event() like
thing in a wait loop..

Can't put might_sleep() in ___wait_event() because there's the locked
primitives which call ___wait_event() with locks held.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/wait.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -272,6 +272,7 @@ __out:	__ret;								\
  */
 #define wait_event(wq, condition)					\
 do {									\
+	might_sleep();							\
 	if (condition)							\
 		break;							\
 	__wait_event(wq, condition);					\
@@ -302,6 +303,7 @@ do {									\
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
+	might_sleep();							\
 	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
@@ -327,6 +329,7 @@ do {									\
  */
 #define wait_event_cmd(wq, condition, cmd1, cmd2)			\
 do {									\
+	might_sleep();							\
 	if (condition)							\
 		break;							\
 	__wait_event_cmd(wq, condition, cmd1, cmd2);			\
@@ -354,6 +357,7 @@ do {									\
 #define wait_event_interruptible(wq, condition)				\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_interruptible(wq, condition);	\
 	__ret;								\
@@ -385,6 +389,7 @@ do {									\
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
 	long __ret = timeout;						\
+	might_sleep();							\
 	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_timeout(wq,		\
 						condition, timeout);	\
@@ -435,6 +440,7 @@ do {									\
 #define wait_event_hrtimeout(wq, condition, timeout)			\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
 					       TASK_UNINTERRUPTIBLE);	\
@@ -460,6 +466,7 @@ do {									\
 #define wait_event_interruptible_hrtimeout(wq, condition, timeout)	\
 ({									\
 	long __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
 					       TASK_INTERRUPTIBLE);	\
@@ -473,6 +480,7 @@ do {									\
 #define wait_event_interruptible_exclusive(wq, condition)		\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_interruptible_exclusive(wq, condition);\
 	__ret;								\
@@ -647,6 +655,7 @@ do {									\
 #define wait_event_killable(wq, condition)				\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_killable(wq, condition);		\
 	__ret;								\
@@ -895,6 +904,7 @@ extern int bit_wait_io(struct wait_bit_k
 static inline int
 wait_on_bit(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
@@ -919,6 +929,7 @@ wait_on_bit(void *word, int bit, unsigne
 static inline int
 wait_on_bit_io(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
@@ -945,6 +956,7 @@ wait_on_bit_io(void *word, int bit, unsi
 static inline int
 wait_on_bit_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit, action, mode);
@@ -972,6 +984,7 @@ wait_on_bit_action(void *word, int bit,
 static inline int
 wait_on_bit_lock(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, bit_wait, mode);
@@ -995,6 +1008,7 @@ wait_on_bit_lock(void *word, int bit, un
 static inline int
 wait_on_bit_lock_io(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, bit_wait_io, mode);
@@ -1020,6 +1034,7 @@ wait_on_bit_lock_io(void *word, int bit,
 static inline int
 wait_on_bit_lock_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
@@ -1038,6 +1053,7 @@ wait_on_bit_lock_action(void *word, int
 static inline
 int wait_on_atomic_t(atomic_t *val, int (*action)(atomic_t *), unsigned mode)
 {
+	might_sleep();
 	if (atomic_read(val) == 0)
 		return 0;
 	return out_of_line_wait_on_atomic_t(val, action, mode);


