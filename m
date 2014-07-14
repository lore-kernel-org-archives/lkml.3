Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaGNM0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:26:00 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:48384 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaGNMZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:25:53 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: davem@davemloft.net
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH] net: clean up some sparse endianness warnings in ipv6.h
Date: Mon, 14 Jul 2014 08:25:46 -0400
Message-Id: <1405340746-10678-1-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse is throwing warnings when building sunrpc modules due to some
endianness shenanigans in ipv6.h. Sprinkle some endianness fixups to
silence them. These should all get fixed up at compile time, so I don't
think this will add any extra work to be done at runtime.

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 include/net/ipv6.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 574337fe72dd..5ed2c24fe950 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -557,9 +557,9 @@ static inline u32 __ipv6_addr_jhash(const struct in6_addr *a, const u32 initval)
 static inline bool ipv6_addr_loopback(const struct in6_addr *a)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
-	const unsigned long *ul = (const unsigned long *)a;
+	const __be64 *be = (const __be64 *)a;
 
-	return (ul[0] | (ul[1] ^ cpu_to_be64(1))) == 0UL;
+	return (be[0] | (be[1] ^ cpu_to_be64(1))) == cpu_to_be64(0UL);
 #else
 	return (a->s6_addr32[0] | a->s6_addr32[1] |
 		a->s6_addr32[2] | (a->s6_addr32[3] ^ htonl(1))) == 0;
@@ -570,11 +570,11 @@ static inline bool ipv6_addr_v4mapped(const struct in6_addr *a)
 {
 	return (
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
-		*(__be64 *)a |
+		(*(__be64 *)a != cpu_to_be64(0)) |
 #else
-		(a->s6_addr32[0] | a->s6_addr32[1]) |
+		((a->s6_addr32[0] | a->s6_addr32[1]) != cpu_to_be32(0)) |
 #endif
-		(a->s6_addr32[2] ^ htonl(0x0000ffff))) == 0UL;
+		((a->s6_addr32[2] ^ htonl(0x0000ffff)) == cpu_to_be32(0)));
 }
 
 /*
-- 
1.9.3

