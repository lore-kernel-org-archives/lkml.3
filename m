Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab3FDWoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:44:00 -0400
Received: from 1wt.eu ([62.212.114.60]:35810 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab3FDWnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:53 -0400
Message-Id: <20130604172137.766177027@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 180/184] llc: Fix missing msg_namelen update in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 llc_ui_recvmsg()

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit c77a4b9cffb6215a15196ec499490d116dfad181 ]

For stream sockets the code misses to update the msg_namelen member
to 0 and therefore makes net/socket.c leak the local, uninitialized
sockaddr_storage variable to userland -- 128 bytes of kernel stack
memory. The msg_namelen update is also missing for datagram sockets
in case the socket is shutting down during receive.

Fix both issues by setting msg_namelen to 0 early. It will be
updated later if we're going to fill the msg_name member.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/llc/af_llc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 606b6ad..8a814a5 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -674,6 +674,8 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 	int target;	/* Read at least this many bytes */
 	long timeo;
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 	copied = -ENOTCONN;
 	if (unlikely(sk->sk_type == SOCK_STREAM && sk->sk_state == TCP_LISTEN))
-- 
1.7.12.2.21.g234cd45.dirty



