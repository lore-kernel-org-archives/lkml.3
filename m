Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaBEVLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:11:41 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47948 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbaBEUD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 028/213] ax25: fix info leak via msg_name in ax25_recvmsg()
Date: Wed, 5 Feb 2014 14:59:43 -0500
Message-ID: <1391630568-49251-29-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ax25/af_ax25.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 12c350c63717..d082b6db6b81 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1655,6 +1655,7 @@ static int ax25_recvmsg(struct kiocb *iocb, struct socket *sock,
 		ax25_address src;
 		const unsigned char *mac = skb_mac_header(skb);
 
+		memset(sax, 0, sizeof(struct full_sockaddr_ax25));
 		ax25_addr_parse(mac + 1, skb->data - mac - 1, &src, NULL,
 				&digi, NULL, NULL);
 		sax->sax25_family = AF_AX25;
-- 
1.8.5.2

