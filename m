Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3IKE3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:29:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab3IKE3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:03 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=pG7dL-MUccMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=28dCtkkjwH8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042857.267804656@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: <stable@kernel.org>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [030/251] svcrpc: fix handling of too-short rpcs
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0030-svcrpc-fix-handling-of-too-short-rpc-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit cf3aa02cb4a0c5af5557dd47f15a08a7df33182a ]

If we detect that an rpc is too short, we abort and close the
connection.  Except, there's a bug here: we're leaving sk_datalen
nonzero without leaving any pages in the sk_pages array.  The most
likely result of the inconsistency is a subsequent crash in
svc_tcp_clear_pages.

Also demote the BUG_ON in svc_tcp_clear_pages to a WARN.

Cc: stable@kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/sunrpc/svcsock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 998aa8c..da0980a 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -963,7 +963,10 @@ static void svc_tcp_clear_pages(struct svc_sock *svsk)
 	len = svsk->sk_tcplen - sizeof(rpc_fraghdr);
 	npages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	for (i = 0; i < npages; i++) {
-		BUG_ON(svsk->sk_pages[i] == NULL);
+		if (svsk->sk_pages[i] == NULL) {
+			WARN_ON_ONCE(1);
+			continue;
+		}
 		put_page(svsk->sk_pages[i]);
 		svsk->sk_pages[i] = NULL;
 	}
-- 
1.7.10.4


