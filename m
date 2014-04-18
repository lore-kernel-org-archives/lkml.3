Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaDRJtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:49:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45888 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 11/72] SUNRPC: Fix potential memory scribble in xprt_free_bc_request()
Date: Fri, 18 Apr 2014 11:21:44 +0200
Message-Id: <8eab668ee966f88601da1f04d4b2494cb9ea63f7.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 628356791b04ea988fee070f66a748a823d001bb upstream.

The call to xprt_free_allocation() will call list_del() on
req->rq_bc_pa_list, which is not attached to a list.
This patch moves the list_del() out of xprt_free_allocation()
and into those callers that need it.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/sunrpc/backchannel_rqst.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/backchannel_rqst.c b/net/sunrpc/backchannel_rqst.c
index 890a29912d5a..e860d4f7ed2a 100644
--- a/net/sunrpc/backchannel_rqst.c
+++ b/net/sunrpc/backchannel_rqst.c
@@ -64,7 +64,6 @@ static void xprt_free_allocation(struct rpc_rqst *req)
 	free_page((unsigned long)xbufp->head[0].iov_base);
 	xbufp = &req->rq_snd_buf;
 	free_page((unsigned long)xbufp->head[0].iov_base);
-	list_del(&req->rq_bc_pa_list);
 	kfree(req);
 }
 
@@ -168,8 +167,10 @@ out_free:
 	/*
 	 * Memory allocation failed, free the temporary list
 	 */
-	list_for_each_entry_safe(req, tmp, &tmp_list, rq_bc_pa_list)
+	list_for_each_entry_safe(req, tmp, &tmp_list, rq_bc_pa_list) {
+		list_del(&req->rq_bc_pa_list);
 		xprt_free_allocation(req);
+	}
 
 	dprintk("RPC:       setup backchannel transport failed\n");
 	return -ENOMEM;
@@ -198,6 +199,7 @@ void xprt_destroy_backchannel(struct rpc_xprt *xprt, unsigned int max_reqs)
 	xprt_dec_alloc_count(xprt, max_reqs);
 	list_for_each_entry_safe(req, tmp, &xprt->bc_pa_list, rq_bc_pa_list) {
 		dprintk("RPC:        req=%p\n", req);
+		list_del(&req->rq_bc_pa_list);
 		xprt_free_allocation(req);
 		if (--max_reqs == 0)
 			break;
-- 
1.9.2

