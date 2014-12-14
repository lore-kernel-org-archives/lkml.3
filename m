Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaLNU0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:26:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaLNUZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:25:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Borkmann <dborkman@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 42/47] netlink: use jhash as hashfn for rhashtable
Date: Sun, 14 Dec 2014 12:21:17 -0800
Message-Id: <20141214201820.176666183@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 7f19fc5e0b617593dcda0d9956adc78b559ef1f5 ]

For netlink, we shouldn't be using arch_fast_hash() as a hashing
discipline, but rather jhash() instead.

Since netlink sockets can be opened by any user, a local attacker
would be able to easily create collisions with the DPDK-derived
arch_fast_hash(), which trades off performance for security by
using crc32 CPU instructions on x86_64.

While it might have a legimite use case in other places, it should
be avoided in netlink context, though. As rhashtable's API is very
flexible, we could later on still decide on other hashing disciplines,
if legitimate.

Reference: http://thread.gmane.org/gmane.linux.kernel/1844123
Fixes: e341694e3eb5 ("netlink: Convert netlink_lookup() to use RCU protected hash table")
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -3130,7 +3130,7 @@ static int __init netlink_proto_init(voi
 		.head_offset = offsetof(struct netlink_sock, node),
 		.key_offset = offsetof(struct netlink_sock, portid),
 		.key_len = sizeof(u32), /* portid */
-		.hashfn = arch_fast_hash,
+		.hashfn = jhash,
 		.max_shift = 16, /* 64K */
 		.grow_decision = rht_grow_above_75,
 		.shrink_decision = rht_shrink_below_30,


