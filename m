Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab3LOCBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:01:23 -0500
Received: from dmz-mailsec-scanner-1.mit.edu ([18.9.25.12]:52810 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200Ab3LOCBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:01:20 -0500
X-AuditID: 1209190c-b7f7f6d000000bbd-48-52ad0d6f5834
Date: Sat, 14 Dec 2013 21:01:17 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] random: separate quantity of bytes extracted and
 entropy to credit
Message-ID: <20131215020117.GF27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUgTYRzn2W63Z2MX5/myx1kRV2EtZwpJKaHVp0LCGIFgQV7e03a4t+62
	4fxQYlC+ZRYVbCVaEJZMpWUhJYnrS0ahkqWD8ENJ5CjTBBlS0p3Dl28/fq88D3+oZuo1Jii4
	vFh0cQ6W1BOMtjjb4qZ6rHl3vhYc+vjyPnkEHF+MbD8FKvSHeewQ/FjcX1ypt8fmo1rPDFuz
	8GVcUwdatjYBHUT0AfQjFtImcQYam+4jm4AeMvQ9Fap/1kwoAkM/Bah3nE8KywBdWXxMKgJB
	70afu5Imkt6BEh29agWn0TtRdzCiUrBa5penIxoFp9Jn0JM306seii5Cicl6VXIgD10L1qmS
	fAoaCc4QyawZTa3MyjyUcRbqWoEKraPz0dyDT0DB6fQudHvkBdkGUkKb0qFN6dBGuhOou8E2
	3llrcXKCQ8JVFqmKc7mwaMnPdQreXMz7IkD5U12mYQD8HGajgIaANVCI7LEyGs4vBZxRkAlV
	bDpl0snUlvNuPmDnJPs50efAUhQgqGbTqIHRsJWheC5Qi0X3mpQFCdZIxWCJlaFtnBdXY+zB
	4pqaDSE9MbRcbiJcbhdmESUY5P4UEdtwzQXB4d1wqqBO2THIOzcUDyV5OKck2JL6O2CBEwt/
	lgCzWmQyUmWKiVZMdp9rvWftdOLAKL8wlWpRXAb5sNab4vKISh4pHexWRrzchmSqA8Qvnfrh
	9erLRebf89r3jZWnm3OcuH9w7N/cpP95Sc7Fqw03A8bsrrHW9taCD8PfzbqVeONU2Ujxq0Rn
	RWH7XFEs+LriBD72926hrSO8eDDjVptmj6P0bOLtTr8nrrEXkBPh2fDUkMSXN/RdehQ4OjzK
	neT3ffNFg2ipeS/dzxKSncs3q0WJ+w/2aBtGFQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The account() function serves two purposes: it decides how many
bytes of data we allow ourselves to extract from a pool (and as a
corollary how much to debit that pool's entropy estimate), and
when the extraction is for the purpose of transferring to another
pool it also decides how many bits of estimated entropy we should
credit to the other pool.

Introduce an output parameter to tell the caller the one value
separately from the other.  The number of bits to credit is not
used in most callers, so do nothing with it there.

In isolation this would be useless abstraction as the values are
interchangeable, but the next commit will make them differ.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index a624262e8..c11281551 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -896,7 +896,8 @@ void add_disk_randomness(struct gendisk *disk)
  *********************************************************************/
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-			       size_t nbytes, struct entropy_store *dest);
+			       size_t nbytes, struct entropy_store *dest,
+			       int *credit_bits);
 
 /*
  * This utility inline function is responsible for transferring entropy
@@ -944,14 +945,14 @@ static void account_xfer(struct entropy_store *dest, int nbytes,
 static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
 	__u32 tmp[OUTPUT_POOL_WORDS];
-	int bytes;
+	int bytes, credit_bits;
 
 	bytes = min_t(int, nbytes, sizeof(tmp));
 	trace_xfer_secondary_pool(r->name, bytes * 8, nbytes * 8,
 				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
-	bytes = extract_entropy(r->pull, tmp, bytes, r);
+	bytes = extract_entropy(r->pull, tmp, bytes, r, &credit_bits);
 	mix_pool_bytes(r, tmp, bytes, NULL);
-	credit_entropy_bits(r, bytes*8);
+	credit_entropy_bits(r, credit_bits);
 }
 
 /*
@@ -975,7 +976,7 @@ static void push_to_pool(struct work_struct *work)
  * given pool, and also debits the entropy count accordingly.
  */
 static size_t account(struct entropy_store *r, size_t nbytes,
-		      struct entropy_store *dest)
+		      struct entropy_store *dest, int *credit_bits)
 {
 	int have_bytes, min, reserved;
 	int entropy_count, orig;
@@ -998,6 +999,8 @@ retry:
 			       max(0, have_bytes - reserved));
 	if (ibytes < min)
 		ibytes = 0;
+	if (credit_bits != NULL)
+		*credit_bits = ibytes * 8;
 	entropy_count = max_t(int, 0,
 			      entropy_count - (ibytes << (ENTROPY_SHIFT + 3)));
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
@@ -1088,7 +1091,8 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
  * or is NULL if it's not to be used in another pool.
  */
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-			       size_t nbytes, struct entropy_store *dest)
+			       size_t nbytes, struct entropy_store *dest,
+			       int *credit_bits)
 {
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
@@ -1112,7 +1116,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 
 	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
-	nbytes = account(r, nbytes, dest);
+	nbytes = account(r, nbytes, dest, credit_bits);
 
 	while (nbytes) {
 		extract_buf(r, tmp);
@@ -1149,7 +1153,7 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 
 	trace_extract_entropy_user(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
-	nbytes = account(r, nbytes, NULL);
+	nbytes = account(r, nbytes, NULL, NULL);
 
 	while (nbytes) {
 		if (need_resched()) {
@@ -1196,7 +1200,7 @@ void get_random_bytes(void *buf, int nbytes)
 		       nonblocking_pool.entropy_total);
 #endif
 	trace_get_random_bytes(nbytes, _RET_IP_);
-	extract_entropy(&nonblocking_pool, buf, nbytes, NULL);
+	extract_entropy(&nonblocking_pool, buf, nbytes, NULL, NULL);
 }
 EXPORT_SYMBOL(get_random_bytes);
 
@@ -1228,7 +1232,7 @@ void get_random_bytes_arch(void *buf, int nbytes)
 	}
 
 	if (nbytes)
-		extract_entropy(&nonblocking_pool, p, nbytes, NULL);
+		extract_entropy(&nonblocking_pool, p, nbytes, NULL, NULL);
 }
 EXPORT_SYMBOL(get_random_bytes_arch);
 
-- 
1.8.3.2

