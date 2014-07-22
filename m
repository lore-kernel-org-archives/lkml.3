Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758AbaGVWea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:34:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44828 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422AbaGVW0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 025/116] SUNRPC: Fix a module reference leak in svc_handle_xprt
Date: Tue, 22 Jul 2014 15:20:36 -0700
Message-Id: <1406067727-19683-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

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
index ca71056..9088c68 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -723,6 +723,8 @@ static int svc_handle_xprt(struct svc_rqst *rqstp, struct svc_xprt *xprt)
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

