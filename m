Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaBEUEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:04:04 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47917 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaBEUDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:45 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 024/213] llc: fix info leak via getsockname()
Date: Wed, 5 Feb 2014 14:59:39 -0500
Message-ID: <1391630568-49251-25-git-send-email-paul.gortmaker@windriver.com>
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

commit 3592aaeb80290bda0f2cf0b5456c97bfc638b192 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/llc/af_llc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index ad4296c852eb..06010e1e89f9 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -959,14 +959,13 @@ static int llc_ui_getname(struct socket *sock, struct sockaddr *uaddr,
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
1.8.5.2

