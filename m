Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3EGOPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:15:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42174 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598Ab3EGNky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 030/118] ax25: fix info leak via msg_name in ax25_recvmsg()
Date: Tue,  7 May 2013 14:37:56 +0100
Message-Id: <1367933964-1564-31-git-send-email-luis.henriques@canonical.com>
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

commit ef3313e84acbf349caecae942ab3ab731471f1a1 upstream.

When msg_namelen is non-zero the sockaddr info gets filled out, as
requested, but the code fails to initialize the padding bytes of struct
sockaddr_ax25 inserted by the compiler for alignment. Additionally the
msg_namelen value is updated to sizeof(struct full_sockaddr_ax25) but is
not always filled up to this size.

Both issues lead to the fact that the code will leak uninitialized
kernel stack bytes in net/socket.c.

Fix both issues by initializing the memory with memset(0).

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ax25/af_ax25.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 779095d..d53a123 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1647,6 +1647,7 @@ static int ax25_recvmsg(struct kiocb *iocb, struct socket *sock,
 		ax25_address src;
 		const unsigned char *mac = skb_mac_header(skb);
 
+		memset(sax, 0, sizeof(struct full_sockaddr_ax25));
 		ax25_addr_parse(mac + 1, skb->data - mac - 1, &src, NULL,
 				&digi, NULL, NULL);
 		sax->sax25_family = AF_AX25;
-- 
1.8.1.2

