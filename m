Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab3I3WZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:25:42 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:42460 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755920Ab3I3WZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:25:39 -0400
To: akpm@linux-foundation.org
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        nelhage@nelhage.com, davidel@xmailserver.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <b1823a82dec20f813dafd4ce6a7a85edb446e680.1380577995.git.jbaron@akamai.com>
In-Reply-To: <cover.1380577995.git.jbaron@akamai.com>
References: <cover.1380577995.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 1/3] epoll: optimize EPOLL_CTL_DEL using rcu
Date: Mon, 30 Sep 2013 22:25:38 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize EPOLL_CTL_DEL so that it does not require the 'epmutex' by
converting the file->f_ep_links list into an rcu one. In this way, we can
traverse the epoll network on the add path in parallel with deletes. Since
deletes can't create loops or worse wakeup paths, this is safe.

Note that I've removed the build time check limiting 'struct epitem' to
128 bytes or less. This check is restored by subsequent patch. The reason
for separating it out was to call attention to its somewhat hacky nature.

This patch in combination with the patch "epoll: Do not take global 'epmutex'
for simple topologies", shows a dramatic performance improvement in
scalability for SPECjbb.

Tested-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c | 58 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 473e09d..f4251a6 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -42,6 +42,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/compat.h>
+#include <linux/rculist.h>
 
 /*
  * LOCKING:
@@ -166,6 +167,13 @@ struct epitem {
 
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
+
+	/*
+	 * Free the epitem using rcu to enable a CTL_DEL to happen in parallel
+	 * with reverse path checks.
+	 */
+	struct rcu_head rcu;
+	int on_list;
 };
 
 /*
@@ -672,6 +680,12 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	return error;
 }
 
+static void epi_rcu_free(struct rcu_head *head)
+{
+	struct epitem *epi = container_of(head, struct epitem, rcu);
+	kmem_cache_free(epi_cache, epi);
+}
+
 /*
  * Removes a "struct epitem" from the eventpoll RB tree and deallocates
  * all the associated resources. Must be called with "mtx" held.
@@ -693,8 +707,10 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 
 	/* Remove the current item from the list of epoll hooks */
 	spin_lock(&file->f_lock);
-	if (ep_is_linked(&epi->fllink))
-		list_del_init(&epi->fllink);
+	if (epi->on_list) {
+		list_del_rcu(&epi->fllink);
+		epi->on_list = 0;
+	}
 	spin_unlock(&file->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
@@ -707,7 +723,7 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	wakeup_source_unregister(ep_wakeup_source(epi));
 
 	/* At this point it is safe to free the eventpoll item */
-	kmem_cache_free(epi_cache, epi);
+	call_rcu(&epi->rcu, epi_rcu_free);
 
 	atomic_long_dec(&ep->user->epoll_watches);
 
@@ -873,7 +889,6 @@ static const struct file_operations eventpoll_fops = {
  */
 void eventpoll_release_file(struct file *file)
 {
-	struct list_head *lsthead = &file->f_ep_links;
 	struct eventpoll *ep;
 	struct epitem *epi;
 
@@ -891,17 +906,12 @@ void eventpoll_release_file(struct file *file)
 	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
 	 */
 	mutex_lock(&epmutex);
-
-	while (!list_empty(lsthead)) {
-		epi = list_first_entry(lsthead, struct epitem, fllink);
-
+	list_for_each_entry_rcu(epi, &file->f_ep_links, fllink) {
 		ep = epi->ep;
-		list_del_init(&epi->fllink);
 		mutex_lock_nested(&ep->mtx, 0);
 		ep_remove(ep, epi);
 		mutex_unlock(&ep->mtx);
 	}
-
 	mutex_unlock(&epmutex);
 }
 
@@ -1139,7 +1149,9 @@ static int reverse_path_check_proc(void *priv, void *cookie, int call_nests)
 	struct file *child_file;
 	struct epitem *epi;
 
-	list_for_each_entry(epi, &file->f_ep_links, fllink) {
+	/* CTL_DEL can remove links here, but that can't increase our count */
+	rcu_read_lock();
+	list_for_each_entry_rcu(epi, &file->f_ep_links, fllink) {
 		child_file = epi->ep->file;
 		if (is_file_epoll(child_file)) {
 			if (list_empty(&child_file->f_ep_links)) {
@@ -1161,6 +1173,7 @@ static int reverse_path_check_proc(void *priv, void *cookie, int call_nests)
 				"file is not an ep!\n");
 		}
 	}
+	rcu_read_unlock();
 	return error;
 }
 
@@ -1255,6 +1268,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	epi->event = *event;
 	epi->nwait = 0;
 	epi->next = EP_UNACTIVE_PTR;
+	epi->on_list = 0;
 	if (epi->event.events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
 		if (error)
@@ -1287,7 +1301,8 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 	/* Add the current item to the list of active epoll hook for this file */
 	spin_lock(&tfile->f_lock);
-	list_add_tail(&epi->fllink, &tfile->f_ep_links);
+	list_add_tail_rcu(&epi->fllink, &tfile->f_ep_links);
+	epi->on_list = 1;
 	spin_unlock(&tfile->f_lock);
 
 	/*
@@ -1328,8 +1343,8 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 error_remove_epi:
 	spin_lock(&tfile->f_lock);
-	if (ep_is_linked(&epi->fllink))
-		list_del_init(&epi->fllink);
+	if (epi->on_list)
+		list_del_rcu(&epi->fllink);
 	spin_unlock(&tfile->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
@@ -1846,15 +1861,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 * and hang them on the tfile_check_list, so we can check that we
 	 * haven't created too many possible wakeup paths.
 	 *
-	 * We need to hold the epmutex across both ep_insert and ep_remove
-	 * b/c we want to make sure we are looking at a coherent view of
-	 * epoll network.
+	 * We need to hold the epmutex across both ep_insert to prevent
+	 * multple adds from creating loops in parallel.
 	 */
-	if (op == EPOLL_CTL_ADD || op == EPOLL_CTL_DEL) {
+	if (op == EPOLL_CTL_ADD) {
 		mutex_lock(&epmutex);
 		did_lock_epmutex = 1;
-	}
-	if (op == EPOLL_CTL_ADD) {
 		if (is_file_epoll(tf.file)) {
 			error = -ELOOP;
 			if (ep_loop_check(ep, tf.file) != 0) {
@@ -2072,12 +2084,6 @@ static int __init eventpoll_init(void)
 	/* Initialize the structure used to perform file's f_op->poll() calls */
 	ep_nested_calls_init(&poll_readywalk_ncalls);
 
-	/*
-	 * We can have many thousands of epitems, so prevent this from
-	 * using an extra cache line on 64-bit (and smaller) CPUs
-	 */
-	BUILD_BUG_ON(sizeof(void *) <= 8 && sizeof(struct epitem) > 128);
-
 	/* Allocates slab cache used to allocate "struct epitem" items */
 	epi_cache = kmem_cache_create("eventpoll_epi", sizeof(struct epitem),
 			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
-- 
1.8.2

