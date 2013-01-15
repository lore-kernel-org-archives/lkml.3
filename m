Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab3AOWtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:49:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:45551 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758228Ab3AOWtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:49:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 032/171] SUNRPC: continue run over clients list on PipeFS event instead of break
Date: Tue, 15 Jan 2013 14:43:17 -0800
Message-Id: <20130115224315.730729378@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit cd6c5968582a273561464fe6b1e8cc8214be02df upstream.

There are SUNRPC clients, which program doesn't have pipe_dir_name. These
clients can be skipped on PipeFS events, because nothing have to be created or
destroyed. But instead of breaking in case of such a client was found, search
for suitable client over clients list have to be continued. Otherwise some
clients could not be covered by PipeFS event handler.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -236,7 +236,7 @@ static struct rpc_clnt *rpc_get_client_f
 	spin_lock(&sn->rpc_client_lock);
 	list_for_each_entry(clnt, &sn->all_clients, cl_clients) {
 		if (clnt->cl_program->pipe_dir_name == NULL)
-			break;
+			continue;
 		if (rpc_clnt_skip_event(clnt, event))
 			continue;
 		if (atomic_inc_not_zero(&clnt->cl_count) == 0)


