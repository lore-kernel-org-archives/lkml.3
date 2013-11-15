Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3KORMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:12:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab3KORMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:12:17 -0500
Date: Fri, 15 Nov 2013 18:12:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com,
        linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
        jiri@resnulli.us, gregkh@linuxfoundation.org
Subject: introduce list_get_first/last (Was: [PATCH 3/6] gfs2: simplify
	current_tail() via list_last_entry_or_null())
Message-ID: <20131115171259.GA10687@redhat.com>
References: <5285A3F4.4040000@oracle.com> <20131115163957.GA28467@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115163957.GA28467@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15, Oleg Nesterov wrote:
>
> But probably list_last_entry() makes sense in the "else" branch,
> athough this is minor.
>
>
> Off-topic. Not sure this really makes sense, but I was thinking about
>
> 	list_get_first(pos, head, member)	\
> 		((pos) = list_first_entry(head, typeof(*pos), member))
>
> and list_get_first() last of course. The obvious advantage is that
> compared to
>
> 	tr = list_last_entry(sdp->sd_ail1_list, struct gfs2_trans, tr_list);
>
> above you do not need to type "struct gfs2_trans",
>
> 	list_get_last(tr, sdp->sd_ail1_list, tr_list);
>
> looks a bit better.

And list.h can use it too.

So how about the patch below? I can't decide whether it cleanups or
uglfies the code, I do not trust my taste ;) But to me it looks a
bit better this way.

Oleg.
--

diff --git a/include/linux/list.h b/include/linux/list.h
index ef95941..f52aba8 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -372,6 +372,12 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_last_entry(ptr, type, member) \
 	list_entry((ptr)->prev, type, member)
 
+#define list_get_first(pos, head, member)	\
+	((pos) = list_first_entry(head, typeof(*(pos)), member))
+
+#define list_get_last(pos, head, member)	\
+	((pos) = list_last_entry(head, typeof(*(pos)), member))
+
 /**
  * list_first_entry_or_null - get the first element from a list
  * @ptr:	the list head to take the element from.
@@ -443,7 +449,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @member:	the name of the list_struct within the struct.
  */
 #define list_for_each_entry(pos, head, member)				\
-	for (pos = list_first_entry(head, typeof(*pos), member);	\
+	for (list_get_first(pos, head, member);				\
 	     &pos->member != (head);					\
 	     pos = list_next_entry(pos, member))
 
@@ -454,7 +460,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @member:	the name of the list_struct within the struct.
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
-	for (pos = list_last_entry(head, typeof(*pos), member);		\
+	for (list_get_last(pos, head, member);				\
 	     &pos->member != (head); 					\
 	     pos = list_prev_entry(pos, member))
 
@@ -517,7 +523,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @member:	the name of the list_struct within the struct.
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
-	for (pos = list_first_entry(head, typeof(*pos), member),	\
+	for (list_get_first(pos, head, member),				\
 		n = list_next_entry(pos, member);			\
 	     &pos->member != (head); 					\
 	     pos = n, n = list_next_entry(n, member))
@@ -564,7 +570,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * of list entry.
  */
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
-	for (pos = list_last_entry(head, typeof(*pos), member),		\
+	for (list_get_last(pos, head, member),				\
 		n = list_prev_entry(pos, member);			\
 	     &pos->member != (head); 					\
 	     pos = n, n = list_prev_entry(n, member))

