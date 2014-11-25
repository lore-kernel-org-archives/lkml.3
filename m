Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbaKYLm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:42:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58328 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaKYKlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 072/254] SUNRPC: Add missing support for RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT
Date: Tue, 25 Nov 2014 10:37:02 +0000
Message-Id: <1416912004-5928-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 2aca5b869ace67a63aab895659e5dc14c33a4d6e upstream.

The flag RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT was intended introduced in
order to allow NFSv4 clients to disable resend timeouts. Since those
cause the RPC layer to break the connection, they mess up the duplicate
reply caches that remain indexed on the port number in NFSv4..

This patch includes the code that was missing in the original to
set the appropriate flag in struct rpc_clnt, when the caller of
rpc_create() sets RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT.

Fixes: 8a19a0b6cb2e (SUNRPC: Add RPC task and client level options to...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/clnt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 2e6ab10734f6..70273ab30e85 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -461,6 +461,8 @@ struct rpc_clnt *rpc_create_xprt(struct rpc_create_args *args,
 
 	if (args->flags & RPC_CLNT_CREATE_AUTOBIND)
 		clnt->cl_autobind = 1;
+	if (args->flags & RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT)
+		clnt->cl_noretranstimeo = 1;
 	if (args->flags & RPC_CLNT_CREATE_DISCRTRY)
 		clnt->cl_discrtry = 1;
 	if (!(args->flags & RPC_CLNT_CREATE_QUIET))
@@ -579,6 +581,7 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	/* Turn off autobind on clones */
 	new->cl_autobind = 0;
 	new->cl_softrtry = clnt->cl_softrtry;
+	new->cl_noretranstimeo = clnt->cl_noretranstimeo;
 	new->cl_discrtry = clnt->cl_discrtry;
 	new->cl_chatty = clnt->cl_chatty;
 	return new;
-- 
2.1.0

