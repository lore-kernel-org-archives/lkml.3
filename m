Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaJ1LK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:10:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51238 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaJ1LK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:10:56 -0400
Date: Tue, 28 Oct 2014 04:09:59 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-e22b886a8a43b147e1994a9f970f678fc0df2033@git.kernel.org>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org, torvalds@linux-foundation.org,
        oleg@redhat.com
Reply-To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, oleg@redhat.com
In-Reply-To: <20140924082242.119255706@infradead.org>
References: <20140924082242.119255706@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Add might_sleep() checks
Git-Commit-ID: e22b886a8a43b147e1994a9f970f678fc0df2033
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e22b886a8a43b147e1994a9f970f678fc0df2033
Gitweb:     http://git.kernel.org/tip/e22b886a8a43b147e1994a9f970f678fc0df2033
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 10:18:48 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:55:23 +0100

sched/wait: Add might_sleep() checks

Add more might_sleep() checks, suppose someone put a wait_event() like
thing in a wait loop..

Can't put might_sleep() in ___wait_event() because there's the locked
primitives which call ___wait_event() with locks held.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: tglx@linutronix.de
Cc: ilya.dryomov@inktank.com
Cc: umgwanakikbuti@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140924082242.119255706@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index fc0e993..0421775 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -261,6 +261,7 @@ __out:	__ret;								\
  */
 #define wait_event(wq, condition)					\
 do {									\
+	might_sleep();							\
 	if (condition)							\
 		break;							\
 	__wait_event(wq, condition);					\
@@ -293,6 +294,7 @@ do {									\
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
+	might_sleep();							\
 	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
@@ -318,6 +320,7 @@ do {									\
  */
 #define wait_event_cmd(wq, condition, cmd1, cmd2)			\
 do {									\
+	might_sleep();							\
 	if (condition)							\
 		break;							\
 	__wait_event_cmd(wq, condition, cmd1, cmd2);			\
@@ -345,6 +348,7 @@ do {									\
 #define wait_event_interruptible(wq, condition)				\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_interruptible(wq, condition);	\
 	__ret;								\
@@ -378,6 +382,7 @@ do {									\
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
 	long __ret = timeout;						\
+	might_sleep();							\
 	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_timeout(wq,		\
 						condition, timeout);	\
@@ -428,6 +433,7 @@ do {									\
 #define wait_event_hrtimeout(wq, condition, timeout)			\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
 					       TASK_UNINTERRUPTIBLE);	\
@@ -453,6 +459,7 @@ do {									\
 #define wait_event_interruptible_hrtimeout(wq, condition, timeout)	\
 ({									\
 	long __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
 					       TASK_INTERRUPTIBLE);	\
@@ -466,6 +473,7 @@ do {									\
 #define wait_event_interruptible_exclusive(wq, condition)		\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_interruptible_exclusive(wq, condition);\
 	__ret;								\
@@ -640,6 +648,7 @@ do {									\
 #define wait_event_killable(wq, condition)				\
 ({									\
 	int __ret = 0;							\
+	might_sleep();							\
 	if (!(condition))						\
 		__ret = __wait_event_killable(wq, condition);		\
 	__ret;								\
@@ -891,6 +900,7 @@ extern int bit_wait_io_timeout(struct wait_bit_key *);
 static inline int
 wait_on_bit(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
@@ -915,6 +925,7 @@ wait_on_bit(void *word, int bit, unsigned mode)
 static inline int
 wait_on_bit_io(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
@@ -941,6 +952,7 @@ wait_on_bit_io(void *word, int bit, unsigned mode)
 static inline int
 wait_on_bit_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
 {
+	might_sleep();
 	if (!test_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit, action, mode);
@@ -968,6 +980,7 @@ wait_on_bit_action(void *word, int bit, wait_bit_action_f *action, unsigned mode
 static inline int
 wait_on_bit_lock(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, bit_wait, mode);
@@ -991,6 +1004,7 @@ wait_on_bit_lock(void *word, int bit, unsigned mode)
 static inline int
 wait_on_bit_lock_io(void *word, int bit, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, bit_wait_io, mode);
@@ -1016,6 +1030,7 @@ wait_on_bit_lock_io(void *word, int bit, unsigned mode)
 static inline int
 wait_on_bit_lock_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
 {
+	might_sleep();
 	if (!test_and_set_bit(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
@@ -1034,6 +1049,7 @@ wait_on_bit_lock_action(void *word, int bit, wait_bit_action_f *action, unsigned
 static inline
 int wait_on_atomic_t(atomic_t *val, int (*action)(atomic_t *), unsigned mode)
 {
+	might_sleep();
 	if (atomic_read(val) == 0)
 		return 0;
 	return out_of_line_wait_on_atomic_t(val, action, mode);
