Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbaLJTLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:11:49 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:49898 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932893AbaLJTIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:08:19 -0500
From: Jeff Layton <jlayton@primarydata.com>
To: bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        NeilBrown <neilb@suse.de>
Subject: [PATCH v2 07/16] sunrpc: factor svc_rqst allocation and freeing from sv_nrthreads refcounting
Date: Wed, 10 Dec 2014 14:07:51 -0500
Message-Id: <1418238480-18857-8-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418238480-18857-1-git-send-email-jlayton@primarydata.com>
References: <1418238480-18857-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In later patches, we'll want to be able to allocate and free svc_rqst
structures without monkeying with the serv->sv_nrthreads refcount.

Factor those pieces out of their respective functions.

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 include/linux/sunrpc/svc.h |  3 +++
 net/sunrpc/svc.c           | 58 ++++++++++++++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 28e5f5716a87..3d2113222dda 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -458,8 +458,11 @@ void svc_rpcb_cleanup(struct svc_serv *serv, struct net *net);
 int svc_bind(struct svc_serv *serv, struct net *net);
 struct svc_serv *svc_create(struct svc_program *, unsigned int,
 			    struct svc_serv_ops *);
+struct svc_rqst *svc_rqst_alloc(struct svc_serv *serv,
+					struct svc_pool *pool, int node);
 struct svc_rqst *svc_prepare_thread(struct svc_serv *serv,
 					struct svc_pool *pool, int node);
+void		   svc_rqst_free(struct svc_rqst *);
 void		   svc_exit_thread(struct svc_rqst *);
 unsigned int	   svc_pool_map_get(void);
 void		   svc_pool_map_put(void);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 04c083a53121..165fa1803a0a 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -583,40 +583,52 @@ svc_release_buffer(struct svc_rqst *rqstp)
 }
 
 struct svc_rqst *
-svc_prepare_thread(struct svc_serv *serv, struct svc_pool *pool, int node)
+svc_rqst_alloc(struct svc_serv *serv, struct svc_pool *pool, int node)
 {
 	struct svc_rqst	*rqstp;
 
 	rqstp = kzalloc_node(sizeof(*rqstp), GFP_KERNEL, node);
 	if (!rqstp)
-		goto out_enomem;
+		return rqstp;
 
-	serv->sv_nrthreads++;
 	__set_bit(RQ_BUSY, &rqstp->rq_flags);
 	spin_lock_init(&rqstp->rq_lock);
 	rqstp->rq_server = serv;
 	rqstp->rq_pool = pool;
-	spin_lock_bh(&pool->sp_lock);
-	pool->sp_nrthreads++;
-	list_add_rcu(&rqstp->rq_all, &pool->sp_all_threads);
-	spin_unlock_bh(&pool->sp_lock);
 
 	rqstp->rq_argp = kmalloc_node(serv->sv_xdrsize, GFP_KERNEL, node);
 	if (!rqstp->rq_argp)
-		goto out_thread;
+		goto out_enomem;
 
 	rqstp->rq_resp = kmalloc_node(serv->sv_xdrsize, GFP_KERNEL, node);
 	if (!rqstp->rq_resp)
-		goto out_thread;
+		goto out_enomem;
 
 	if (!svc_init_buffer(rqstp, serv->sv_max_mesg, node))
-		goto out_thread;
+		goto out_enomem;
 
 	return rqstp;
-out_thread:
-	svc_exit_thread(rqstp);
 out_enomem:
-	return ERR_PTR(-ENOMEM);
+	svc_rqst_free(rqstp);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(svc_rqst_alloc);
+
+struct svc_rqst *
+svc_prepare_thread(struct svc_serv *serv, struct svc_pool *pool, int node)
+{
+	struct svc_rqst	*rqstp;
+
+	rqstp = svc_rqst_alloc(serv, pool, node);
+	if (!rqstp)
+		return ERR_PTR(-ENOMEM);
+
+	serv->sv_nrthreads++;
+	spin_lock_bh(&pool->sp_lock);
+	pool->sp_nrthreads++;
+	list_add_rcu(&rqstp->rq_all, &pool->sp_all_threads);
+	spin_unlock_bh(&pool->sp_lock);
+	return rqstp;
 }
 EXPORT_SYMBOL_GPL(svc_prepare_thread);
 
@@ -747,19 +759,25 @@ svc_set_num_threads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 EXPORT_SYMBOL_GPL(svc_set_num_threads);
 
 /*
- * Called from a server thread as it's exiting. Caller must hold the BKL or
- * the "service mutex", whichever is appropriate for the service.
+ * Called from a server thread as it's exiting. Caller must hold the service's
+ * mutex.
  */
 void
-svc_exit_thread(struct svc_rqst *rqstp)
+svc_rqst_free(struct svc_rqst *rqstp)
 {
-	struct svc_serv	*serv = rqstp->rq_server;
-	struct svc_pool	*pool = rqstp->rq_pool;
-
 	svc_release_buffer(rqstp);
 	kfree(rqstp->rq_resp);
 	kfree(rqstp->rq_argp);
 	kfree(rqstp->rq_auth_data);
+	kfree_rcu(rqstp, rq_rcu_head);
+}
+EXPORT_SYMBOL_GPL(svc_rqst_free);
+
+void
+svc_exit_thread(struct svc_rqst *rqstp)
+{
+	struct svc_serv	*serv = rqstp->rq_server;
+	struct svc_pool	*pool = rqstp->rq_pool;
 
 	spin_lock_bh(&pool->sp_lock);
 	pool->sp_nrthreads--;
@@ -767,7 +785,7 @@ svc_exit_thread(struct svc_rqst *rqstp)
 		list_del_rcu(&rqstp->rq_all);
 	spin_unlock_bh(&pool->sp_lock);
 
-	kfree_rcu(rqstp, rq_rcu_head);
+	svc_rqst_free(rqstp);
 
 	/* Release the server */
 	if (serv)
-- 
2.1.0

