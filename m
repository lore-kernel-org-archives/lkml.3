Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3CJLgC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:36:02 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:45439 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab3CJLgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:36:00 -0400
Date: Sun, 10 Mar 2013 11:35:59 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>
Subject: [PATCH] epoll: fix sparse error on RCU assignment
Message-ID: <20130310113559.GA16551@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following sparse error when using
CONFIG_SPARSE_RCU_POINTER=y and "make C=2 fs/eventpoll.o"

  fs/eventpoll.c:514:17: error: incompatible types in comparison expression (different address spaces)

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Eric Wong <normalperson@yhbt.net>
---
 Oleg: I found this error since I was working on an unrelated patch
 to convert wakeup_source users to RCU in epoll.  This was introduced
 in:

  commit 971316f0503a5c50633d07b83b6db2f15a3a5b00
  (epoll: ep_unregister_pollwait() can use the freed pwq->whead)

 fs/eventpoll.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 9fec183..1326409 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -228,7 +228,7 @@ struct eppoll_entry {
 	wait_queue_t wait;
 
 	/* The wait queue head that linked the "wait" wait queue item */
-	wait_queue_head_t *whead;
+	wait_queue_head_t __rcu *whead;
 };
 
 /* Wrapper struct used by poll queueing */
@@ -929,7 +929,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	struct eventpoll *ep = epi->ep;
 
 	if ((unsigned long)key & POLLFREE) {
-		ep_pwq_from_wait(wait)->whead = NULL;
+		RCU_INIT_POINTER(ep_pwq_from_wait(wait)->whead, NULL);
 		/*
 		 * whead = NULL above can race with ep_remove_wait_queue()
 		 * which can do another remove_wait_queue() after us, so we
@@ -1018,7 +1018,7 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
 
 	if (epi->nwait >= 0 && (pwq = kmem_cache_alloc(pwq_cache, GFP_KERNEL))) {
 		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
-		pwq->whead = whead;
+		RCU_INIT_POINTER(pwq->whead, whead);
 		pwq->base = epi;
 		add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
-- 
Eric Wong
