Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab3FDWoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:44:12 -0400
Received: from 1wt.eu ([62.212.114.60]:35858 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab3FDWoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:08 -0400
Message-Id: <20130604172137.849084668@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 182/184] rose: fix info leak via msg_name in rose_recvmsg()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 4a184233f21645cf0b719366210ed445d1024d72 ]

The code in rose_recvmsg() does not initialize all of the members of
struct sockaddr_rose/full_sockaddr_rose when filling the sockaddr info.
Nor does it initialize the padding bytes of the structure inserted by
the compiler for alignment. This will lead to leaking uninitialized
kernel stack bytes in net/socket.c.

Fix the issue by initializing the memory used for sockaddr info with
memset(0).

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/rose/af_rose.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 523efbb..2984999 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1275,6 +1275,7 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
 	skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
 
 	if (srose != NULL) {
+		memset(srose, 0, msg->msg_namelen);
 		srose->srose_family = AF_ROSE;
 		srose->srose_addr   = rose->dest_addr;
 		srose->srose_call   = rose->dest_call;
-- 
1.7.12.2.21.g234cd45.dirty



