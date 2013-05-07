Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab3EGOLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:11:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42241 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3EGNlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 040/118] rose: fix info leak via msg_name in rose_recvmsg()
Date: Tue,  7 May 2013 14:38:06 +0100
Message-Id: <1367933964-1564-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 4a184233f21645cf0b719366210ed445d1024d72 upstream.

The code in rose_recvmsg() does not initialize all of the members of
struct sockaddr_rose/full_sockaddr_rose when filling the sockaddr info.
Nor does it initialize the padding bytes of the structure inserted by
the compiler for alignment. This will lead to leaking uninitialized
kernel stack bytes in net/socket.c.

Fix the issue by initializing the memory used for sockaddr info with
memset(0).

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/rose/af_rose.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index c4719ce..7f645d1 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1257,6 +1257,7 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
 	skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
 
 	if (srose != NULL) {
+		memset(srose, 0, msg->msg_namelen);
 		srose->srose_family = AF_ROSE;
 		srose->srose_addr   = rose->dest_addr;
 		srose->srose_call   = rose->dest_call;
-- 
1.8.1.2

