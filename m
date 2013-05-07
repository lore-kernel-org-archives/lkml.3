Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172Ab3EGEiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:38:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab3EGEZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:47 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=V7q1piWhxU8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=zrhfpVX8anUA:10 a=mK_AVkanAAAA:8 a=WPyIoOwQAAAA:8 a=J1Y8HTJGAAAA:8 a=f8cKZyGMXCixRa4P8U4A:9 a=9xyTavCNlvEA:10 a=1DbiqZag68YA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035856.971642635@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [096/126] ax25: fix info leak via msg_name in ax25_recvmsg()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0096-ax25-fix-info-leak-via-msg_name-in-ax25_recvmsg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit ef3313e84acbf349caecae942ab3ab731471f1a1 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ax25/af_ax25.c |    1 +
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
1.7.10.4


