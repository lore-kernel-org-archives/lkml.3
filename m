Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934844Ab3GWW1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934781Ab3GWW1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 076/103] svcrpc: dont error out on small tcp fragment
Date: Tue, 23 Jul 2013 15:26:27 -0700
Message-Id: <20130723220428.308894054@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/svcsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1095,7 +1095,7 @@ static int svc_tcp_recvfrom(struct svc_r
 		goto err_noclose;
 	}
 
-	if (svc_sock_reclen(svsk) < 8) {
+	if (svsk->sk_datalen < 8) {
 		svsk->sk_datalen = 0;
 		goto err_delete; /* client is nuts. */
 	}


