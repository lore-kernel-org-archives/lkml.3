Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3KJQ6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:58:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab3KJQ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:58:43 -0500
Date: Sun, 10 Nov 2013 18:00:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eilon Greenstein <eilong@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] list: change list_for_each_entry*() to use
	list_*_entry()
Message-ID: <20131110170007.GA311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131110165947.GA32758@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have list_{next,prev}_entry() we can change
list_for_each_entry*() and list_safe_reset_next() to use the
new helpers to improve the readability.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/list.h |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 2ece638..c88a591 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -433,8 +433,8 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     &pos->member != (head); 	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
+	     &pos->member != (head);					\
+	     pos = list_next_entry(pos, member))
 
 /**
  * list_for_each_entry_reverse - iterate backwards over list of given type.
@@ -444,8 +444,8 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
-	     &pos->member != (head); 	\
-	     pos = list_entry(pos->member.prev, typeof(*pos), member))
+	     &pos->member != (head); 					\
+	     pos = list_prev_entry(pos, member))
 
 /**
  * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue()
@@ -468,9 +468,9 @@ static inline void list_splice_tail_init(struct list_head *list,
  * the current position.
  */
 #define list_for_each_entry_continue(pos, head, member) 		\
-	for (pos = list_entry(pos->member.next, typeof(*pos), member);	\
-	     &pos->member != (head);	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
+	for (pos = list_next_entry(pos, member);			\
+	     &pos->member != (head);					\
+	     pos = list_next_entry(pos, member))
 
 /**
  * list_for_each_entry_continue_reverse - iterate backwards from the given point
@@ -482,9 +482,9 @@ static inline void list_splice_tail_init(struct list_head *list,
  * the current position.
  */
 #define list_for_each_entry_continue_reverse(pos, head, member)		\
-	for (pos = list_entry(pos->member.prev, typeof(*pos), member);	\
-	     &pos->member != (head);	\
-	     pos = list_entry(pos->member.prev, typeof(*pos), member))
+	for (pos = list_prev_entry(pos, member);			\
+	     &pos->member != (head);					\
+	     pos = list_prev_entry(pos, member))
 
 /**
  * list_for_each_entry_from - iterate over list of given type from the current point
@@ -495,8 +495,8 @@ static inline void list_splice_tail_init(struct list_head *list,
  * Iterate over list of given type, continuing from current position.
  */
 #define list_for_each_entry_from(pos, head, member) 			\
-	for (; &pos->member != (head);	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
+	for (; &pos->member != (head);					\
+	     pos = list_next_entry(pos, member))
 
 /**
  * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
@@ -507,9 +507,9 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_entry((head)->next, typeof(*pos), member),	\
-		n = list_entry(pos->member.next, typeof(*pos), member);	\
+		n = list_next_entry(pos, member);			\
 	     &pos->member != (head); 					\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+	     pos = n, n = list_next_entry(n, member))
 
 /**
  * list_for_each_entry_safe_continue - continue list iteration safe against removal
@@ -522,10 +522,10 @@ static inline void list_splice_tail_init(struct list_head *list,
  * safe against removal of list entry.
  */
 #define list_for_each_entry_safe_continue(pos, n, head, member) 		\
-	for (pos = list_entry(pos->member.next, typeof(*pos), member), 		\
-		n = list_entry(pos->member.next, typeof(*pos), member);		\
+	for (pos = list_next_entry(pos, member), 				\
+		n = list_next_entry(pos, member);				\
 	     &pos->member != (head);						\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+	     pos = n, n = list_next_entry(n, member))
 
 /**
  * list_for_each_entry_safe_from - iterate over list from current point safe against removal
@@ -538,9 +538,9 @@ static inline void list_splice_tail_init(struct list_head *list,
  * removal of list entry.
  */
 #define list_for_each_entry_safe_from(pos, n, head, member) 			\
-	for (n = list_entry(pos->member.next, typeof(*pos), member);		\
+	for (n = list_next_entry(pos, member);					\
 	     &pos->member != (head);						\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+	     pos = n, n = list_next_entry(n, member))
 
 /**
  * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
@@ -554,9 +554,9 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
 	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
-		n = list_entry(pos->member.prev, typeof(*pos), member);	\
+		n = list_prev_entry(pos, member);			\
 	     &pos->member != (head); 					\
-	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
+	     pos = n, n = list_prev_entry(n, member))
 
 /**
  * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
@@ -571,7 +571,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * completing the current iteration of the loop body.
  */
 #define list_safe_reset_next(pos, n, member)				\
-	n = list_entry(pos->member.next, typeof(*pos), member)
+	n = list_next_entry(pos, member)
 
 /*
  * Double linked lists with a single pointer list head.
-- 
1.5.5.1

