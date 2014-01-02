Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaABRRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:17:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40503 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbaABRJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:09:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Herbert <therbert@google.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shawn Landden <shawn@churchofgit.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 34/91] net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST
Date: Thu,  2 Jan 2014 09:04:09 -0800
Message-Id: <1388682306-30859-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

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
Reported-and-tested-by: Shawn Landden <shawnlandden@gmail.com>
Original-patch: Richard Weinberger <richard@nod.at>
Signed-off-by: Shawn Landden <shawn@churchofgit.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 crypto/algif_hash.c     | 3 +++
 crypto/algif_skcipher.c | 3 +++
 net/ipv4/udp.c          | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index ef5356c..8502462 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -114,6 +114,9 @@ static ssize_t hash_sendpage(struct socket *sock, struct page *page,
 	struct hash_ctx *ctx = ask->private;
 	int err;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	lock_sock(sk);
 	sg_init_table(ctx->sgl.sg, 1);
 	sg_set_page(ctx->sgl.sg, page, size, offset);
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6a6dfc0..a19c027 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -378,6 +378,9 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	struct skcipher_sg_list *sgl;
 	int err = -EINVAL;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	lock_sock(sk);
 	if (!ctx->more && ctx->used)
 		goto unlock;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c8cf2f1..9de5641 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1045,6 +1045,9 @@ int udp_sendpage(struct sock *sk, struct page *page, int offset,
 	struct udp_sock *up = udp_sk(sk);
 	int ret;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	if (!up->pending) {
 		struct msghdr msg = {	.msg_flags = flags|MSG_MORE };
 
-- 
1.8.3.2

