Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab3D2TVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:21:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759727Ab3D2TDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 14/34] NFC: llcp: fix info leaks via msg_name in llcp_sock_recvmsg()
Date: Mon, 29 Apr 2013 12:02:21 -0700
Message-Id: <20130429184702.509549397@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp/sock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -514,6 +514,8 @@ static int llcp_sock_recvmsg(struct kioc
 
 	pr_debug("%p %zu\n", sk, len);
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 
 	if (sk->sk_state == LLCP_CLOSED &&


