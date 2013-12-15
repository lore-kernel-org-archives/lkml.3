Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3LOCBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:01:20 -0500
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:59239 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab3LOCBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:01:16 -0500
X-AuditID: 12074425-b7fd96d000000c39-84-52ad0d6b035e
Date: Sat, 14 Dec 2013 21:01:13 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] random: move transfer accounting into account() helper
Message-ID: <20131215020112.GE27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsUixG6nopvNuzbIYM57SYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWx4+QF9oJLehXNs9azNjC+UO1i5OSQEDCR2PP/AguELSZx4d56
	ti5GLg4hgdlMEj8efWWGcDYySqzfPpkFwvnFKHHt4U6wFhYBVYkpf26yg9hsAgoSP+avYwax
	RQSUJVbN3MQEYjMDxX/d28QKYgsL+ErcfbMaqJeDg1fASqLzczhIWEjAQKJ9ZgNYOa+AoMTJ
	mU9YIFq1JG78e8kEUs4sIC2x/B8HSJhTwFDi3cKrjCC2qICKxJST29gmMArOQtI9C0n3LITu
	BYzMqxhlU3KrdHMTM3OKU5N1i5MT8/JSi3Qt9HIzS/RSU0o3MYLD1EV1B+OEQ0qHGAU4GJV4
	eCXY1gYJsSaWFVfmHmKU5GBSEuWV4gQK8SXlp1RmJBZnxBeV5qQWH2KU4GBWEuHdcX5NkBBv
	SmJlVWpRPkxKmoNFSZz3Fod9kJBAemJJanZqakFqEUxWhoNDSYI3kwdoqGBRanpqRVpmTglC
	momDE2Q4D9DwfpAa3uKCxNzizHSI/ClGXY4rHz99YxRiycvPS5US5/UHKRIAKcoozYObA0sv
	rxjFgd4S5g0EqeIBpia4Sa+AljABLfHeswpkSUkiQkqqgXEFI5f/89at3yKiPmYeSl4cfMWd
	++OsLr77cV9kLj62CtNLzHi71ME8bkkVS43w7HO1i+4ptj9w+nvk6NnqI8eOPDOKs4ypuzJX
	3KWzJmSa4FelYwxxXE6Nom8f2U/4GmubPtu9vkHifdOrCP5bWZXiq+yP+omU5Jm65nPp5+W+
	+6ldrPE4RomlOCPRUIu5qDgRAEFi+V8KAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings the logic that determines "min" and "reserved" next to
the closely related logic that uses it, in account(), and reduces
the number of different points involved in communicating "min" and
"reserved" from one place to the other.

This will be particularly helpful in the next commit, where we add
another parameter to account() and extract_entropy().

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 61 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9f24f6468..a624262e8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -896,7 +896,7 @@ void add_disk_randomness(struct gendisk *disk)
  *********************************************************************/
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-			       size_t nbytes, int min, int rsvd);
+			       size_t nbytes, struct entropy_store *dest);
 
 /*
  * This utility inline function is responsible for transferring entropy
@@ -920,33 +920,36 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 		_xfer_secondary_pool(r, nbytes);
 }
 
-static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
+static void account_xfer(struct entropy_store *dest, int nbytes,
+			 int *min_bytes, int *reserved_bytes)
 {
-	__u32 tmp[OUTPUT_POOL_WORDS];
-	int bytes, min_bytes, reserved_bytes;
-
 	/* Try to pull a full wakeup's worth if we might have just woken up
 	 * for it, and a full reseed's worth (which is controlled by the same
 	 * parameter) for the nonblocking pool... */
-	if (r == &blocking_pool || r->initialized) {
-		min_bytes = random_read_wakeup_bits / 8;
+	if (dest == &blocking_pool || dest->initialized) {
+		*min_bytes = random_read_wakeup_bits / 8;
 	} else {
 		/* ... except if we're hardly seeded at all, we'll settle for
-		 * enough to double what we have ... */
-		min_bytes = min(random_read_wakeup_bits / 8,
-				(r->entropy_total+7) / 8);
+		 * enough to double what we have. */
+		*min_bytes = min(random_read_wakeup_bits / 8,
+				 (dest->entropy_total+7) / 8);
 	}
-	/* ... and in any event no more than our (giant) buffer holds. */
-	bytes = min(sizeof(tmp), max_t(size_t, min_bytes, nbytes));
 
 	/* Reserve some for /dev/random's pool, unless we really need it. */
-	reserved_bytes = 0;
-	if (!r->limit && r->initialized)
-		reserved_bytes = 2 * (random_read_wakeup_bits / 8);
+	*reserved_bytes = 0;
+	if (!dest->limit && dest->initialized)
+		*reserved_bytes = 2 * (random_read_wakeup_bits / 8);
+}
 
+static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
+{
+	__u32 tmp[OUTPUT_POOL_WORDS];
+	int bytes;
+
+	bytes = min_t(int, nbytes, sizeof(tmp));
 	trace_xfer_secondary_pool(r->name, bytes * 8, nbytes * 8,
 				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
-	bytes = extract_entropy(r->pull, tmp, bytes, min_bytes, reserved_bytes);
+	bytes = extract_entropy(r->pull, tmp, bytes, r);
 	mix_pool_bytes(r, tmp, bytes, NULL);
 	credit_entropy_bits(r, bytes*8);
 }
@@ -971,13 +974,17 @@ static void push_to_pool(struct work_struct *work)
  * This function decides how many bytes to actually take from the
  * given pool, and also debits the entropy count accordingly.
  */
-static size_t account(struct entropy_store *r, size_t nbytes, int min,
-		      int reserved)
+static size_t account(struct entropy_store *r, size_t nbytes,
+		      struct entropy_store *dest)
 {
-	int have_bytes;
+	int have_bytes, min, reserved;
 	int entropy_count, orig;
 	size_t ibytes;
 
+	min = reserved = 0;
+	if (dest != NULL)
+		account_xfer(dest, nbytes, &min, &reserved);
+
 	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
 
 	/* Can we pull enough? */
@@ -1077,13 +1084,11 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
  * This function extracts randomness from the "entropy pool", and
  * returns it in a buffer.
  *
- * The min parameter specifies the minimum amount we can pull before
- * failing to avoid races that defeat catastrophic reseeding while the
- * reserved parameter indicates how much entropy we must leave in the
- * pool after each pull to avoid starving other readers.
+ * The 'dest' parameter identifies the pool the entropy is to be used for,
+ * or is NULL if it's not to be used in another pool.
  */
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-				 size_t nbytes, int min, int reserved)
+			       size_t nbytes, struct entropy_store *dest)
 {
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
@@ -1107,7 +1112,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 
 	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
-	nbytes = account(r, nbytes, min, reserved);
+	nbytes = account(r, nbytes, dest);
 
 	while (nbytes) {
 		extract_buf(r, tmp);
@@ -1144,7 +1149,7 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 
 	trace_extract_entropy_user(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
-	nbytes = account(r, nbytes, 0, 0);
+	nbytes = account(r, nbytes, NULL);
 
 	while (nbytes) {
 		if (need_resched()) {
@@ -1191,7 +1196,7 @@ void get_random_bytes(void *buf, int nbytes)
 		       nonblocking_pool.entropy_total);
 #endif
 	trace_get_random_bytes(nbytes, _RET_IP_);
-	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
+	extract_entropy(&nonblocking_pool, buf, nbytes, NULL);
 }
 EXPORT_SYMBOL(get_random_bytes);
 
@@ -1223,7 +1228,7 @@ void get_random_bytes_arch(void *buf, int nbytes)
 	}
 
 	if (nbytes)
-		extract_entropy(&nonblocking_pool, p, nbytes, 0, 0);
+		extract_entropy(&nonblocking_pool, p, nbytes, NULL);
 }
 EXPORT_SYMBOL(get_random_bytes_arch);
 
-- 
1.8.3.2

