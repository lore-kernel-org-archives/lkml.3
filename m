Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab3EGEZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:25:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415Ab3EGEZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:44 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=fEm7r0F1DdkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=iI492zOF3K0A:10 a=mK_AVkanAAAA:8 a=ls8vHrqWAAAA:8 a=QyXUC8HyAAAA:8 a=J1Y8HTJGAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=9xyTavCNlvEA:10 a=KZ3pOzVjQMkA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035858.752928220@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [106/126] NFC: llcp: fix info leaks via msg_name in llcp_sock_recvmsg()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0106-NFC-llcp-fix-info-leaks-via-msg_name-in-llcp_sock_re.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit d26d6504f23e803824e8ebd14e52d4fc0a0b09cb ]

The code in llcp_sock_recvmsg() does not initialize all the members of
struct sockaddr_nfc_llcp when filling the sockaddr info. Nor does it
initialize the padding bytes of the structure inserted by the compiler
for alignment.

Also, if the socket is in state LLCP_CLOSED or is shutting down during
receive the msg_namelen member is not updated to 0 while otherwise
returning with 0, i.e. "success". The msg_namelen update is also
missing for stream and seqpacket sockets which don't fill the sockaddr
info.

Both issues lead to the fact that the code will leak uninitialized
kernel stack bytes in net/socket.c.

Fix the first issue by initializing the memory used for sockaddr info
with memset(0). Fix the second one by setting msg_namelen to 0 early.
It will be updated later if we're going to fill the msg_name member.

Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/nfc/llcp/sock.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index ddeb9aa..6832022 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -579,6 +579,8 @@ static int llcp_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	pr_debug("%p %zu\n", sk, len);
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 
 	if (sk->sk_state == LLCP_CLOSED &&
-- 
1.7.10.4


