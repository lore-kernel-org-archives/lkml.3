Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaKLDCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:02:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbaKLBkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:40:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 016/203] SUNRPC: Add missing support for RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT
Date: Wed, 12 Nov 2014 10:14:46 +0900
Message-Id: <20141112011543.450408843@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -533,6 +533,8 @@ struct rpc_clnt *rpc_create(struct rpc_c
 
 	if (args->flags & RPC_CLNT_CREATE_AUTOBIND)
 		clnt->cl_autobind = 1;
+	if (args->flags & RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT)
+		clnt->cl_noretranstimeo = 1;
 	if (args->flags & RPC_CLNT_CREATE_DISCRTRY)
 		clnt->cl_discrtry = 1;
 	if (!(args->flags & RPC_CLNT_CREATE_QUIET))
@@ -571,6 +573,7 @@ static struct rpc_clnt *__rpc_clone_clie
 	/* Turn off autobind on clones */
 	new->cl_autobind = 0;
 	new->cl_softrtry = clnt->cl_softrtry;
+	new->cl_noretranstimeo = clnt->cl_noretranstimeo;
 	new->cl_discrtry = clnt->cl_discrtry;
 	new->cl_chatty = clnt->cl_chatty;
 	return new;


