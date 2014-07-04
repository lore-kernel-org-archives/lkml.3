Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498AbaGDWQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:16:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760426AbaGDWQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:16:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.15 33/66] SUNRPC: Fix a module reference leak in svc_handle_xprt
Date: Fri,  4 Jul 2014 15:14:32 -0700
Message-Id: <20140704221424.322626942@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit c789102c20bbbdda6831a273e046715be9d6af79 upstream.

If the accept() call fails, we need to put the module reference.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/svc_xprt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -730,6 +730,8 @@ static int svc_handle_xprt(struct svc_rq
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt)
 			svc_add_new_temp_xprt(serv, newxpt);
+		else
+			module_put(xprt->xpt_class->xcl_owner);
 	} else if (xprt->xpt_ops->xpo_has_wspace(xprt)) {
 		/* XPT_DATA|XPT_DEFERRED case: */
 		dprintk("svc: server %p, pool %u, transport %p, inuse=%d\n",


