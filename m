Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab3EGOLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:11:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3EGNlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 039/118] NFC: llcp: fix info leaks via msg_name in llcp_sock_recvmsg()
Date: Tue,  7 May 2013 14:38:05 +0100
Message-Id: <1367933964-1564-40-git-send-email-luis.henriques@canonical.com>
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

commit d26d6504f23e803824e8ebd14e52d4fc0a0b09cb upstream.

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
[ luis: 3.5 is not affected by first issue. ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/nfc/llcp/sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index e06d458..80200ac 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -570,6 +570,8 @@ static int llcp_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	pr_debug("%p %zu\n", sk, len);
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 
 	if (sk->sk_state == LLCP_CLOSED &&
-- 
1.8.1.2

