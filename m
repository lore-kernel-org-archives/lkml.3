Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab3EGEZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:25:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552Ab3EGEZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:45 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zPicwlgtGtgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OTdBvroBXikA:10 a=mK_AVkanAAAA:8 a=WPyIoOwQAAAA:8 a=J1Y8HTJGAAAA:8 a=I4WkRd2SZrKB_yTbCMkA:9 a=9xyTavCNlvEA:10 a=1DbiqZag68YA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035858.267285695@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [104/126] netrom: fix info leak via msg_name in nr_recvmsg()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0104-netrom-fix-info-leak-via-msg_name-in-nr_recvmsg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 3ce5efad47b62c57a4f5c54248347085a750ce0e ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/netrom/af_netrom.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 7261eb8..14c106b 100644
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
1.7.10.4


