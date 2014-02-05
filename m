Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaBEUPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:15:32 -0500
Received: from mail.windriver.com ([147.11.1.11]:55586 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbaBEUH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "J. Bruce Fields" <bfields@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 196/213] svcrpc: fix svc_xprt_enqueue/svc_recv busy-looping
Date: Wed, 5 Feb 2014 15:02:31 -0500
Message-ID: <1391630568-49251-197-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d10f27a750312ed5638c876e4bd6aa83664cccd8 upstream.

The rpc server tries to ensure that there will be room to send a reply
before it receives a request.

It does this by tracking, in xpt_reserved, an upper bound on the total
size of the replies that is has already committed to for the socket.

Currently it is adding in the estimate for a new reply *before* it
checks whether there is space available.  If it finds that there is not
space, it then subtracts the estimate back out.

This may lead the subsequent svc_xprt_enqueue to decide that there is
space after all.

The results is a svc_recv() that will repeatedly return -EAGAIN, causing
server threads to loop without doing any actual work.

Reported-by: Michael Tokarev <mjt@tls.msk.ru>
Tested-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sunrpc/svc_xprt.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 957a7e88e827..afa0bceb67ad 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -310,7 +310,6 @@ static void svc_thread_dequeue(struct svc_pool *pool, struct svc_rqst *rqstp)
  */
 void svc_xprt_enqueue(struct svc_xprt *xprt)
 {
-	struct svc_serv	*serv = xprt->xpt_server;
 	struct svc_pool *pool;
 	struct svc_rqst	*rqstp;
 	int cpu;
@@ -384,8 +383,6 @@ void svc_xprt_enqueue(struct svc_xprt *xprt)
 				rqstp, rqstp->rq_xprt);
 		rqstp->rq_xprt = xprt;
 		svc_xprt_get(xprt);
-		rqstp->rq_reserved = serv->sv_max_mesg;
-		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 		pool->sp_stats.threads_woken++;
 		BUG_ON(xprt->xpt_pool != pool);
 		wake_up(&rqstp->rq_wait);
@@ -663,8 +660,6 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
 	if (xprt) {
 		rqstp->rq_xprt = xprt;
 		svc_xprt_get(xprt);
-		rqstp->rq_reserved = serv->sv_max_mesg;
-		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 	} else {
 		/* No data pending. Go to sleep */
 		svc_thread_enqueue(pool, rqstp);
@@ -754,6 +749,8 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
 		} else
 			len = xprt->xpt_ops->xpo_recvfrom(rqstp);
 		dprintk("svc: got len=%d\n", len);
+		rqstp->rq_reserved = serv->sv_max_mesg;
+		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 	}
 
 	/* No data, incomplete (TCP) read, or accept() */
-- 
1.8.5.2

