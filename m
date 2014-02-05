Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaBEUQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:16:22 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48600 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaBEUH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:57 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "J. Bruce Fields" <bfields@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 195/213] svcrpc: sends on closed socket should stop immediately
Date: Wed, 5 Feb 2014 15:02:30 -0500
Message-ID: <1391630568-49251-196-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f06f00a24d76e168ecb38d352126fd203937b601 upstream.

svc_tcp_sendto sets XPT_CLOSE if we fail to transmit the entire reply.
However, the XPT_CLOSE won't be acted on immediately.  Meanwhile other
threads could send further replies before the socket is really shut
down.  This can manifest as data corruption: for example, if a truncated
read reply is followed by another rpc reply, that second reply will look
to the client like further read data.

Symptoms were data corruption preceded by svc_tcp_sendto logging
something like

	kernel: rpc-srv/tcp: nfsd: sent only 963696 when sending 1048708 bytes - shutting down socket

Reported-by: Malahal Naineni <malahal@us.ibm.com>
Tested-by: Malahal Naineni <malahal@us.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sunrpc/svc_xprt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 33df29bd8c61..957a7e88e827 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -807,7 +807,8 @@ int svc_send(struct svc_rqst *rqstp)
 
 	/* Grab mutex to serialize outgoing data. */
 	mutex_lock(&xprt->xpt_mutex);
-	if (test_bit(XPT_DEAD, &xprt->xpt_flags))
+	if (test_bit(XPT_DEAD, &xprt->xpt_flags)
+			|| test_bit(XPT_CLOSE, &xprt->xpt_flags))
 		len = -ENOTCONN;
 	else
 		len = xprt->xpt_ops->xpo_sendto(rqstp);
-- 
1.8.5.2

