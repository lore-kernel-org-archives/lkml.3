Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3IVUjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:39:21 -0400
Received: from imap.thunk.org ([74.207.234.97]:35977 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab3IVUjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:39:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC 09/12] random: optimize the entropy_store structure
Date: Sun, 22 Sep 2013 16:38:55 -0400
Message-Id: <1379882338-7209-10-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1379882338-7209-1-git-send-email-tytso@mit.edu>
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use smaller types to slightly shrink the size of the entropy store
structure.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6d5e8e6..292e717 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -435,16 +435,16 @@ struct entropy_store {
 	__u32 *pool;
 	const char *name;
 	struct entropy_store *pull;
-	int limit;
 
 	/* read-write data: */
 	spinlock_t lock;
-	unsigned add_ptr;
-	unsigned input_rotate;
+	unsigned short add_ptr;
+	unsigned short input_rotate;
 	int entropy_count;
 	int entropy_total;
 	unsigned int initialized:1;
-	bool last_data_init;
+	unsigned int limit:1;
+	unsigned int last_data_init:1;
 	__u8 last_data[EXTRACT_SIZE];
 };
 
@@ -512,7 +512,7 @@ static void _mix_pool_bytes(struct entropy_store *r, const void *in,
 
 	/* mix one byte at a time to simplify size handling and churn faster */
 	while (nbytes--) {
-		w = rol32(*bytes++, input_rotate & 31);
+		w = rol32(*bytes++, input_rotate);
 		i = (i - 1) & wordmask;
 
 		/* XOR in the various taps */
@@ -532,7 +532,7 @@ static void _mix_pool_bytes(struct entropy_store *r, const void *in,
 		 * rotation, so that successive passes spread the
 		 * input bits across the pool evenly.
 		 */
-		input_rotate += i ? 7 : 14;
+		input_rotate = (input_rotate + (i ? 7 : 14)) & 31;
 	}
 
 	ACCESS_ONCE(r->input_rotate) = input_rotate;
@@ -1047,7 +1047,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	if (fips_enabled) {
 		spin_lock_irqsave(&r->lock, flags);
 		if (!r->last_data_init) {
-			r->last_data_init = true;
+			r->last_data_init = 1;
 			spin_unlock_irqrestore(&r->lock, flags);
 			trace_extract_entropy(r->name, EXTRACT_SIZE,
 					      r->entropy_count, _RET_IP_);
@@ -1187,7 +1187,7 @@ static void init_std_data(struct entropy_store *r)
 
 	r->entropy_count = 0;
 	r->entropy_total = 0;
-	r->last_data_init = false;
+	r->last_data_init = 0;
 	mix_pool_bytes(r, &now, sizeof(now), NULL);
 	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
 		if (!arch_get_random_long(&rv))
-- 
1.7.12.rc0.22.gcdd159b

