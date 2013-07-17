Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052Ab3GQXNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:13:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56628 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964918Ab3GQWzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 111/145] svcrpc: don't error out on small tcp fragment
Date: Wed, 17 Jul 2013 15:47:23 -0700
Message-Id: <1374101277-7915-112-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 1f691b07c5dc51b2055834f58c0f351defd97f27 upstream.

Though clients we care about mostly don't do this, it is possible for
rpc requests to be sent in multiple fragments.  Here we have a sanity
check to ensure that the final received rpc isn't too small--except that
the number we're actually checking is the length of just the final
fragment, not of the whole rpc.  So a perfectly legal rpc that's
unluckily fragmented could cause the server to close the connection
here.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sunrpc/svcsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index df74919..305374d 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1095,7 +1095,7 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
 		goto err_noclose;
 	}
 
-	if (svc_sock_reclen(svsk) < 8) {
+	if (svsk->sk_datalen < 8) {
 		svsk->sk_datalen = 0;
 		goto err_delete; /* client is nuts. */
 	}
-- 
1.8.1.2

