Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab3EGNlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3EGNlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 036/118] llc: Fix missing msg_namelen update in llc_ui_recvmsg()
Date: Tue,  7 May 2013 14:38:02 +0100
Message-Id: <1367933964-1564-37-git-send-email-luis.henriques@canonical.com>
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

commit c77a4b9cffb6215a15196ec499490d116dfad181 upstream.

For stream sockets the code misses to update the msg_namelen member
to 0 and therefore makes net/socket.c leak the local, uninitialized
sockaddr_storage variable to userland -- 128 bytes of kernel stack
memory. The msg_namelen update is also missing for datagram sockets
in case the socket is shutting down during receive.

Fix both issues by setting msg_namelen to 0 early. It will be
updated later if we're going to fill the msg_name member.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/llc/af_llc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index a13c3e2..445882cb 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -720,6 +720,8 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 	int target;	/* Read at least this many bytes */
 	long timeo;
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 	copied = -ENOTCONN;
 	if (unlikely(sk->sk_type == SOCK_STREAM && sk->sk_state == TCP_LISTEN))
-- 
1.8.1.2

