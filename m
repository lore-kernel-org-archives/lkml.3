Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbaGOVhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:37:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54581 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759491AbaGOVg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:36:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 047/198] SUNRPC: Fix a module reference leak in svc_handle_xprt
Date: Tue, 15 Jul 2014 14:28:37 -0700
Message-Id: <1405459868-15089-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit c789102c20bbbdda6831a273e046715be9d6af79 upstream.

If the accept() call fails, we need to put the module reference.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sunrpc/svc_xprt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 80a6640..b9aad47 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -730,6 +730,8 @@ static int svc_handle_xprt(struct svc_rqst *rqstp, struct svc_xprt *xprt)
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt)
 			svc_add_new_temp_xprt(serv, newxpt);
+		else
+			module_put(xprt->xpt_class->xcl_owner);
 	} else if (xprt->xpt_ops->xpo_has_wspace(xprt)) {
 		/* XPT_DATA|XPT_DEFERRED case: */
 		dprintk("svc: server %p, pool %u, transport %p, inuse=%d\n",
-- 
1.9.1

