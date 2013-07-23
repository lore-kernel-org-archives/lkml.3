Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934805Ab3GWW1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934780Ab3GWW1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 075/103] svcrpc: fix handling of too-short rpcs
Date: Tue, 23 Jul 2013 15:26:26 -0700
Message-Id: <20130723220428.123692856@linuxfoundation.org>
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

commit cf3aa02cb4a0c5af5557dd47f15a08a7df33182a upstream.

If we detect that an rpc is too short, we abort and close the
connection.  Except, there's a bug here: we're leaving sk_datalen
nonzero without leaving any pages in the sk_pages array.  The most
likely result of the inconsistency is a subsequent crash in
svc_tcp_clear_pages.

Also demote the BUG_ON in svc_tcp_clear_pages to a WARN.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/svcsock.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -917,7 +917,10 @@ static void svc_tcp_clear_pages(struct s
 	len = svsk->sk_datalen;
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
@@ -1092,8 +1095,10 @@ static int svc_tcp_recvfrom(struct svc_r
 		goto err_noclose;
 	}
 
-	if (svc_sock_reclen(svsk) < 8)
+	if (svc_sock_reclen(svsk) < 8) {
+		svsk->sk_datalen = 0;
 		goto err_delete; /* client is nuts. */
+	}
 
 	rqstp->rq_arg.len = svsk->sk_datalen;
 	rqstp->rq_arg.page_base = 0;


