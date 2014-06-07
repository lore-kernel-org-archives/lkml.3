Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaFGI2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 04:28:08 -0400
Received: from ns.horizon.com ([71.41.210.147]:53791 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752805AbaFGI2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 04:28:06 -0400
Date: 7 Jun 2014 04:28:05 -0400
Message-ID: <20140607082805.10120.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com, linux@horizon.com,
        shemminger@osdl.org, tytso@mit.edu
Subject: [PATCH 5/7] lib/random32.c: Make prandom_u32_max efficient for powers of 2
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20140607081828.9294.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multiply-and-shift is efficient in the general case, but slower than
a simple bitwise AND if the range is a power of 2.  Make the function
handle this case so callers don't have to worry about micro-optimizing it.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 include/linux/random.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/random.h b/include/linux/random.h
index 57fbbffd..e1f3ec9a 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -47,11 +47,23 @@ void prandom_bytes_state(struct rnd_state *state, void *buf, int nbytes);
  * generator, that is, prandom_u32(). This is useful when requesting a
  * random index of an array containing ep_ro elements, for example.
  *
+ * If ep_ro is a power of 2 known at compile time, a modulo operation
+ * reduces to a simple mask to extract the low order bits.  Otherwise,
+ * it uses a multiply and shift, which is faster than a general modulus.
+ *
  * Returns: pseudo-random number in interval [0, ep_ro)
  */
 static inline u32 prandom_u32_max(u32 ep_ro)
 {
-	return (u32)(((u64) prandom_u32() * ep_ro) >> 32);
+	/*
+	 * Instead of just __builtin_constant_p(ep_ro), this test is
+	 * "is it known at compile time that ep_ro is a power of 2?", and
+	 * can in theory handle the case that it's an unknown power of 2.
+	 */
+	if (__builtin_constant_p(ep_ro & (ep_ro-1)) && !(ep_ro & (ep_ro-1)))
+		return prandom_u32() & (ep_ro-1);
+	else
+		return (u32)((u64)prandom_u32() * ep_ro >> 32);
 }
 
 /*
-- 
2.0.0

