Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab3LJIl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:41:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3LJH7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:59:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shawn Landden <shawn@churchofgit.com>
Subject: [PATCH 3.4 14/25] net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST
Date: Tue, 10 Dec 2013 00:00:22 -0800
Message-Id: <20131210075931.838036216@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075930.808460227@linuxfoundation.org>
References: <20131210075930.808460227@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Landden <shawn@churchofgit.com>

commit d3f7d56a7a4671d395e8af87071068a195257bf6 upstream.

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
@@ -117,6 +117,9 @@ static ssize_t hash_sendpage(struct sock
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		flags |= MSG_MORE;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	lock_sock(sk);
 	sg_init_table(ctx->sgl.sg, 1);
 	sg_set_page(ctx->sgl.sg, page, size, offset);
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -381,6 +381,9 @@ static ssize_t skcipher_sendpage(struct
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		flags |= MSG_MORE;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	lock_sock(sk);
 	if (!ctx->more && ctx->used)
 		goto unlock;
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1042,6 +1042,9 @@ int udp_sendpage(struct sock *sk, struct
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		flags |= MSG_MORE;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	if (!up->pending) {
 		struct msghdr msg = {	.msg_flags = flags|MSG_MORE };
 


