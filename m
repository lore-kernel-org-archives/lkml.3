Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3FDWnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:43:43 -0400
Received: from 1wt.eu ([62.212.114.60]:35745 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab3FDWnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:31 -0400
Message-Id: <20130604172137.725419704@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 179/184] llc: fix info leak via getsockname()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 3592aaeb80290bda0f2cf0b5456c97bfc638b192 ]

The LLC code wrongly returns 0, i.e. "success", when the socket is
zapped. Together with the uninitialized uaddrlen pointer argument from
sys_getsockname this leads to an arbitrary memory leak of up to 128
bytes kernel stack via the getsockname() syscall.

Return an error instead when the socket is zapped to prevent the info
leak. Also remove the unnecessary memset(0). We don't directly write to
the memory pointed by uaddr but memcpy() a local structure at the end of
the function that is properly initialized.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/llc/af_llc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 2da8d14..606b6ad 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -912,14 +912,13 @@ static int llc_ui_getname(struct socket *sock, struct sockaddr *uaddr,
 	struct sockaddr_llc sllc;
 	struct sock *sk = sock->sk;
 	struct llc_sock *llc = llc_sk(sk);
-	int rc = 0;
+	int rc = -EBADF;
 
 	memset(&sllc, 0, sizeof(sllc));
 	lock_sock(sk);
 	if (sock_flag(sk, SOCK_ZAPPED))
 		goto out;
 	*uaddrlen = sizeof(sllc);
-	memset(uaddr, 0, *uaddrlen);
 	if (peer) {
 		rc = -ENOTCONN;
 		if (sk->sk_state != TCP_ESTABLISHED)
-- 
1.7.12.2.21.g234cd45.dirty



