Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3ENBYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:24:53 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:47022 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab3ENBTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:11 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 05/21] aio: percpu ioctx refcount
Date: Mon, 13 May 2013 18:18:42 -0700
Message-Id: <1368494338-7069-6-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just converts the ioctx refcount to the new generic dynamic percpu
refcount code.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/aio.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index c341cee..93383b0 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -36,6 +36,7 @@
 #include <linux/eventfd.h>
 #include <linux/blkdev.h>
 #include <linux/compat.h>
+#include <linux/percpu-refcount.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -65,8 +66,7 @@ struct kioctx_cpu {
 };
 
 struct kioctx {
-	atomic_t		users;
-	atomic_t		dead;
+	struct percpu_ref	users;
 
 	/* This needs improving */
 	unsigned long		user_id;
@@ -370,7 +370,7 @@ static void free_ioctx(struct kioctx *ctx)
 
 static void put_ioctx(struct kioctx *ctx)
 {
-	if (unlikely(atomic_dec_and_test(&ctx->users)))
+	if (percpu_ref_put(&ctx->users))
 		free_ioctx(ctx);
 }
 
@@ -411,8 +411,13 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	ctx->max_reqs = nr_events;
 
-	atomic_set(&ctx->users, 2);
-	atomic_set(&ctx->dead, 0);
+	if (percpu_ref_init(&ctx->users))
+		goto out_freectx;
+
+	rcu_read_lock();
+	percpu_ref_get(&ctx->users);
+	rcu_read_unlock();
+
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_lock);
@@ -422,7 +427,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	ctx->cpu = alloc_percpu(struct kioctx_cpu);
 	if (!ctx->cpu)
-		goto out_freectx;
+		goto out_freeref;
 
 	if (aio_setup_ring(ctx) < 0)
 		goto out_freepcpu;
@@ -455,6 +460,8 @@ out_cleanup:
 	aio_free_ring(ctx);
 out_freepcpu:
 	free_percpu(ctx->cpu);
+out_freeref:
+	free_percpu(ctx->users.pcpu_count);
 out_freectx:
 	kmem_cache_free(kioctx_cachep, ctx);
 	pr_debug("error allocating ioctx %d\n", err);
@@ -484,7 +491,7 @@ static void kill_ioctx_rcu(struct rcu_head *head)
  */
 static void kill_ioctx(struct kioctx *ctx)
 {
-	if (!atomic_xchg(&ctx->dead, 1)) {
+	if (percpu_ref_kill(&ctx->users)) {
 		hlist_del_rcu(&ctx->list);
 		/* Between hlist_del_rcu() and dropping the initial ref */
 		synchronize_rcu();
@@ -530,12 +537,6 @@ void exit_aio(struct mm_struct *mm)
 	struct hlist_node *n;
 
 	hlist_for_each_entry_safe(ctx, n, &mm->ioctx_list, list) {
-		if (1 != atomic_read(&ctx->users))
-			printk(KERN_DEBUG
-				"exit_aio:ioctx still alive: %d %d %d\n",
-				atomic_read(&ctx->users),
-				atomic_read(&ctx->dead),
-				atomic_read(&ctx->reqs_available));
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -546,7 +547,7 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;
 
-		if (!atomic_xchg(&ctx->dead, 1)) {
+		if (percpu_ref_kill(&ctx->users)) {
 			hlist_del_rcu(&ctx->list);
 			call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
 		}
@@ -657,7 +658,7 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 
 	hlist_for_each_entry_rcu(ctx, &mm->ioctx_list, list) {
 		if (ctx->user_id == ctx_id) {
-			atomic_inc(&ctx->users);
+			percpu_ref_get(&ctx->users);
 			ret = ctx;
 			break;
 		}
@@ -870,7 +871,7 @@ static bool aio_read_events(struct kioctx *ctx, long min_nr, long nr,
 	if (ret > 0)
 		*i += ret;
 
-	if (unlikely(atomic_read(&ctx->dead)))
+	if (unlikely(percpu_ref_dead(&ctx->users)))
 		ret = -EINVAL;
 
 	if (!*i)
-- 
1.8.2.1

