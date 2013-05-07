Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab3EGNlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825Ab3EGNlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 037/118] netrom: fix info leak via msg_name in nr_recvmsg()
Date: Tue,  7 May 2013 14:38:03 +0100
Message-Id: <1367933964-1564-38-git-send-email-luis.henriques@canonical.com>
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

commit 3ce5efad47b62c57a4f5c54248347085a750ce0e upstream.

In case msg_name is set the sockaddr info gets filled out, as
requested, but the code fails to initialize the padding bytes of
struct sockaddr_ax25 inserted by the compiler for alignment. Also
the sax25_ndigis member does not get assigned, leaking four more
bytes.

Both issues lead to the fact that the code will leak uninitialized
kernel stack bytes in net/socket.c.

Fix both issues by initializing the memory with memset(0).

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netrom/af_netrom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 1b9024e..72cad6c 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1177,6 +1177,7 @@ static int nr_recvmsg(struct kiocb *iocb, struct socket *sock,
 	}
 
 	if (sax != NULL) {
+		memset(sax, 0, sizeof(sax));
 		sax->sax25_family = AF_NETROM;
 		skb_copy_from_linear_data_offset(skb, 7, sax->sax25_call.ax25_call,
 			      AX25_ADDR_LEN);
-- 
1.8.1.2

