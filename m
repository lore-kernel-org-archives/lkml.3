Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3IVUkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:40:53 -0400
Received: from imap.thunk.org ([74.207.234.97]:35981 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab3IVUjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:39:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC 11/12] random: speed up the fast_mix function by a factor of four
Date: Sun, 22 Sep 2013 16:38:57 -0400
Message-Id: <1379882338-7209-12-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1379882338-7209-1-git-send-email-tytso@mit.edu>
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By mixing the entropy in chunks of 32-bit words instead of byte by
byte, we can speed up the fast_mix function significantly.  Since it
is called on every single interrupt, on systems with a very heavy
interrupt load, this can make a noticeable different.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Jörn Engel <joern@logfs.org>
---
 drivers/char/random.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 3439b1c..86879d1 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -583,21 +583,26 @@ struct fast_pool {
  * collector.  It's hardcoded for an 128 bit pool and assumes that any
  * locks that might be needed are taken by the caller.
  */
-static void fast_mix(struct fast_pool *f, const void *in, int nbytes)
+static void fast_mix(struct fast_pool *f, __u32 input[4])
 {
-	const char	*bytes = in;
 	__u32		w;
-	unsigned	i = f->count;
 	unsigned	input_rotate = f->rotate;
 
-	while (nbytes--) {
-		w = rol32(*bytes++, input_rotate & 31) ^ f->pool[i & 3] ^
-			f->pool[(i + 1) & 3];
-		f->pool[i & 3] = (w >> 3) ^ twist_table[w & 7];
-		input_rotate += (i++ & 3) ? 7 : 14;
-	}
-	f->count = i;
+	w = rol32(input[0], input_rotate) ^ f->pool[0] ^ f->pool[3];
+	f->pool[0] = (w >> 3) ^ twist_table[w & 7];
+	input_rotate = (input_rotate + 14) & 31;
+	w = rol32(input[1], input_rotate) ^ f->pool[1] ^ f->pool[0];
+	f->pool[1] = (w >> 3) ^ twist_table[w & 7];
+	input_rotate = (input_rotate + 7) & 31;
+	w = rol32(input[2], input_rotate) ^ f->pool[2] ^ f->pool[1];
+	f->pool[2] = (w >> 3) ^ twist_table[w & 7];
+	input_rotate = (input_rotate + 7) & 31;
+	w = rol32(input[3], input_rotate) ^ f->pool[3] ^ f->pool[2];
+	f->pool[3] = (w >> 3) ^ twist_table[w & 7];
+	input_rotate = (input_rotate + 7) & 31;
+
 	f->rotate = input_rotate;
+	f->count++;
 }
 
 /*
@@ -836,10 +841,9 @@ void add_interrupt_randomness(int irq, int irq_flags)
 		input[3] = ip >> 32;
 	}
 
-	fast_mix(fast_pool, input, sizeof(input));
+	fast_mix(fast_pool, input);
 
-	if ((fast_pool->count & 1023) &&
-	    !time_after(now, fast_pool->last + HZ))
+	if ((fast_pool->count & 63) && !time_after(now, fast_pool->last + HZ))
 		return;
 
 	fast_pool->last = now;
-- 
1.7.12.rc0.22.gcdd159b

