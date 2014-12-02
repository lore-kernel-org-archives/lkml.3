Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaLBS2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:28:00 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:45252 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbaLBSYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:24:36 -0500
From: Jeff Layton <jlayton@primarydata.com>
To: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH 05/14] sunrpc: abstract out svc_set_num_threads to sv_ops
Date: Tue,  2 Dec 2014 13:24:14 -0500
Message-Id: <1417544663-13299-6-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417544663-13299-1-git-send-email-jlayton@primarydata.com>
References: <1417544663-13299-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an operation that will do setup of the service. In the case of a
classic thread-based service that means starting up threads. In the case
of a workqueue-based service, the setup will do something different.

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/nfsd/nfssvc.c           | 8 +++++---
 include/linux/sunrpc/svc.h | 3 +++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 5904c06cfd32..71e7b180c0d9 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -394,6 +394,7 @@ static struct svc_serv_ops nfsd_thread_sv_ops = {
 	.svo_shutdown		= nfsd_last_thread,
 	.svo_function		= nfsd,
 	.svo_enqueue_xprt	= svc_xprt_do_enqueue,
+	.svo_setup		= svc_set_num_threads,
 	.svo_module		= THIS_MODULE,
 };
 
@@ -506,8 +507,8 @@ int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
 	/* apply the new numbers */
 	svc_get(nn->nfsd_serv);
 	for (i = 0; i < n; i++) {
-		err = svc_set_num_threads(nn->nfsd_serv, &nn->nfsd_serv->sv_pools[i],
-				    	  nthreads[i]);
+		err = nn->nfsd_serv->sv_ops->svo_setup(nn->nfsd_serv,
+				&nn->nfsd_serv->sv_pools[i], nthreads[i]);
 		if (err)
 			break;
 	}
@@ -546,7 +547,8 @@ nfsd_svc(int nrservs, struct net *net)
 	error = nfsd_startup_net(nrservs, net);
 	if (error)
 		goto out_destroy;
-	error = svc_set_num_threads(nn->nfsd_serv, NULL, nrservs);
+	error = nn->nfsd_serv->sv_ops->svo_setup(nn->nfsd_serv,
+			NULL, nrservs);
 	if (error)
 		goto out_shutdown;
 	/* We are holding a reference to nn->nfsd_serv which
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 7429cdcb48b5..5e172c8329f8 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -61,6 +61,9 @@ struct svc_serv_ops {
 	/* queue up a transport for servicing */
 	void		(*svo_enqueue_xprt)(struct svc_xprt *);
 
+	/* set up thread (or whatever) execution context */
+	int		(*svo_setup)(struct svc_serv *, struct svc_pool *, int);
+
 	/* optional module to count when adding threads (pooled svcs only) */
 	struct module	*svo_module;
 };
-- 
2.1.0

