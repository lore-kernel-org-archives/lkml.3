Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaFGIZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 04:25:21 -0400
Received: from ns.horizon.com ([71.41.210.147]:43561 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752839AbaFGIZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 04:25:19 -0400
Date: 7 Jun 2014 04:25:18 -0400
Message-ID: <20140607082518.9989.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com, linux@horizon.com,
        shemminger@osdl.org, tytso@mit.edu
Subject: [PATCH 4/7] lib/random32.c: Use <asm/unaligned.h> instead of hand-rolling it
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20140607081828.9294.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions exist for a reason; the manual byte-at-a-time code
is unnecessarily slow (and bloated).

Signed-off-by: George Spelvin <linux@horizon.com>
---
 lib/random32.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/lib/random32.c b/lib/random32.c
index e8f3557b..eee60100 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -37,6 +37,7 @@
 #include <linux/jiffies.h>
 #include <linux/random.h>
 #include <linux/sched.h>
+#include <asm/unaligned.h>
 
 #ifdef CONFIG_RANDOM32_SELFTEST
 static void __init prandom_state_selftest(void);
@@ -97,25 +98,23 @@ EXPORT_SYMBOL(prandom_u32);
  */
 void prandom_bytes_state(struct rnd_state *state, void *buf, int bytes)
 {
-	unsigned char *p = buf;
+	u8 *p = buf;
 	int i;
 
-	for (i = 0; i < round_down(bytes, sizeof(u32)); i += sizeof(u32)) {
-		u32 random = prandom_u32_state(state);
-		int j;
+	for (i = 0; i < round_down(bytes, sizeof(u32)); i += sizeof(u32))
+		put_unaligned_le32(prandom_u32_state(state), p+i);
 
-		for (j = 0; j < sizeof(u32); j++) {
-			p[i + j] = random;
-			random >>= BITS_PER_BYTE;
-		}
-	}
 	if (i < bytes) {
 		u32 random = prandom_u32_state(state);
 
-		for (; i < bytes; i++) {
-			p[i] = random;
-			random >>= BITS_PER_BYTE;
+		if (bytes & 2) {
+			put_unaligned_le16((u16)random, p+i);
+			if ((bytes & 1) == 0)
+				return;
+			i += 2;
+			random >>= 16;
 		}
+		p[i] = (u8)random;
 	}
 }
 EXPORT_SYMBOL(prandom_bytes_state);
-- 
2.0.0

