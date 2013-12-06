Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161164Ab3LFVxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:53:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147Ab3LFVw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shawn Landden <shawn@churchofgit.com>
Subject: [PATCH 3.12 55/83] net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST
Date: Fri,  6 Dec 2013 13:51:45 -0800
Message-Id: <20131206214645.168649707@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Landden <shawn@churchofgit.com>

[ Upstream commit d3f7d56a7a4671d395e8af87071068a195257bf6 ]

Commit 35f9c09fe (tcp: tcp_sendpages() should call tcp_push() once)
added an internal flag MSG_SENDPAGE_NOTLAST, similar to
MSG_MORE.

algif_hash, algif_skcipher, and udp used MSG_MORE from tcp_sendpages()
and need to see the new flag as identical to MSG_MORE.

This fixes sendfile() on AF_ALG.

v3: also fix udp

Cc: Tom Herbert <therbert@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: <stable@vger.kernel.org> # 3.4.x + 3.2.x
Reported-and-tested-by: Shawn Landden <shawnlandden@gmail.com>
Original-patch: Richard Weinberger <richard@nod.at>
Signed-off-by: Shawn Landden <shawn@churchofgit.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algif_hash.c     |    3 +++
 crypto/algif_skcipher.c |    3 +++
 net/ipv4/udp.c          |    3 +++
 3 files changed, 9 insertions(+)

--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -114,6 +114,9 @@ static ssize_t hash_sendpage(struct sock
 	struct hash_ctx *ctx = ask->private;
 	int err;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	lock_sock(sk);
 	sg_init_table(ctx->sgl.sg, 1);
 	sg_set_page(ctx->sgl.sg, page, size, offset);
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -378,6 +378,9 @@ static ssize_t skcipher_sendpage(struct
 	struct skcipher_sg_list *sgl;
 	int err = -EINVAL;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	lock_sock(sk);
 	if (!ctx->more && ctx->used)
 		goto unlock;
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1072,6 +1072,9 @@ int udp_sendpage(struct sock *sk, struct
 	struct udp_sock *up = udp_sk(sk);
 	int ret;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	if (!up->pending) {
 		struct msghdr msg = {	.msg_flags = flags|MSG_MORE };
 


