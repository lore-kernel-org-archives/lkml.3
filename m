Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965244Ab3DJXIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:08:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937307Ab3DJWrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 46/64] SUNRPC: Remove extra xprt_put()
Date: Wed, 10 Apr 2013 15:46:43 -0700
Message-Id: <20130410224344.108712690@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit a58e0be6f6b3eb2079b0b8fedc9df6fa86869f1e upstream.

While testing error cases where rpc_new_client() fails, I saw
some oopses.

If rpc_new_client() fails, it already invokes xprt_put().  Thus
__rpc_clone_client() does not need to invoke it again.

Introduced by commit 1b63a751 "SUNRPC: Refactor rpc_clone_client()"
Fri Sep 14, 2012.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -511,7 +511,7 @@ static struct rpc_clnt *__rpc_clone_clie
 	new = rpc_new_client(args, xprt);
 	if (IS_ERR(new)) {
 		err = PTR_ERR(new);
-		goto out_put;
+		goto out_err;
 	}
 
 	atomic_inc(&clnt->cl_count);
@@ -524,8 +524,6 @@ static struct rpc_clnt *__rpc_clone_clie
 	new->cl_chatty = clnt->cl_chatty;
 	return new;
 
-out_put:
-	xprt_put(xprt);
 out_err:
 	dprintk("RPC:       %s: returned error %d\n", __func__, err);
 	return ERR_PTR(err);


