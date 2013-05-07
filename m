Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab3EGNlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42203 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3EGNk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 033/118] caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()
Date: Tue,  7 May 2013 14:37:59 +0100
Message-Id: <1367933964-1564-34-git-send-email-luis.henriques@canonical.com>
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

commit 2d6fbfe733f35c6b355c216644e08e149c61b271 upstream.

The current code does not fill the msg_name member in case it is set.
It also does not set the msg_namelen member to 0 and therefore makes
net/socket.c leak the local, uninitialized sockaddr_storage variable
to userland -- 128 bytes of kernel stack memory.

Fix that by simply setting msg_namelen to 0 as obviously nobody cared
about caif_seqpkt_recvmsg() not filling the msg_name in case it was
set.

Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/caif/caif_socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 78f1cda..21a1840 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -286,6 +286,8 @@ static int caif_seqpkt_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (m->msg_flags&MSG_OOB)
 		goto read_error;
 
+	m->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags, 0 , &ret);
 	if (!skb)
 		goto read_error;
-- 
1.8.1.2

