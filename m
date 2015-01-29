Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbbA2KKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:10:40 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63015 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbbA2KKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:10:38 -0500
From: Karl Beldan <karl.beldan@gmail.com>
X-Google-Original-From: Karl Beldan <karl.beldan@rivierawaves.com>
To: "David S . Miller" <davem@davemloft.net>
Cc: Karl Beldan <karl.beldan@gmail.com>,
        Karl Beldan <karl.beldan@rivierawaves.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH] lib/checksum.c: fix build for generic csum_tcpudp_nofold
Date: Thu, 29 Jan 2015 11:10:22 +0100
Message-Id: <1422526222-2445-1-git-send-email-karl.beldan@rivierawaves.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed commit added from64to32 under _#ifndef do_csum_ but used it
under _#ifndef csum_tcpudp_nofold_, breaking some builds (Fengguang's
robot reported TILEGX's). Move from64to32 under the latter.

Fixes: 150ae0e94634 ("lib/checksum.c: fix carry in csum_tcpudp_nofold")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: David S. Miller <davem@davemloft.net>
---
 lib/checksum.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/checksum.c b/lib/checksum.c
index fcf3894..8b39e86 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -47,15 +47,6 @@ static inline unsigned short from32to16(unsigned int x)
 	return x;
 }
 
-static inline u32 from64to32(u64 x)
-{
-	/* add up 32-bit and 32-bit for 32+c bit */
-	x = (x & 0xffffffff) + (x >> 32);
-	/* add up carry.. */
-	x = (x & 0xffffffff) + (x >> 32);
-	return (u32)x;
-}
-
 static unsigned int do_csum(const unsigned char *buff, int len)
 {
 	int odd;
@@ -190,6 +181,15 @@ csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
 EXPORT_SYMBOL(csum_partial_copy);
 
 #ifndef csum_tcpudp_nofold
+static inline u32 from64to32(u64 x)
+{
+	/* add up 32-bit and 32-bit for 32+c bit */
+	x = (x & 0xffffffff) + (x >> 32);
+	/* add up carry.. */
+	x = (x & 0xffffffff) + (x >> 32);
+	return (u32)x;
+}
+
 __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 			unsigned short len,
 			unsigned short proto,
-- 
2.0.1

