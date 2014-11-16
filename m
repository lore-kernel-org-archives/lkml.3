Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaKPWBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:01:09 -0500
Received: from 1wt.eu ([62.212.114.60]:47949 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaKPWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:04 -0500
Message-Id: <20141116215329.896343849@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:58 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 30/48] dm crypt: fix access beyond the end of allocated space
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit d49ec52ff6ddcda178fc2476a109cf1bd1fa19ed upstream

The DM crypt target accesses memory beyond allocated space resulting in
a crash on 32 bit x86 systems.

This bug is very old (it dates back to 2.6.25 commit 3a7f6c990ad04 "dm
crypt: use async crypto").  However, this bug was masked by the fact
that kmalloc rounds the size up to the next power of two.  This bug
wasn't exposed until 3.17-rc1 commit 298a9fa08a ("dm crypt: use per-bio
data").  By switching to using per-bio data there was no longer any
padding beyond the end of a dm-crypt allocated memory block.

To minimize allocation overhead dm-crypt puts several structures into one
block allocated with kmalloc.  The block holds struct ablkcipher_request,
cipher-specific scratch pad (crypto_ablkcipher_reqsize(any_tfm(cc))),
struct dm_crypt_request and an initialization vector.

The variable dmreq_start is set to offset of struct dm_crypt_request
within this memory block.  dm-crypt allocates the block with this size:
cc->dmreq_start + sizeof(struct dm_crypt_request) + cc->iv_size.

When accessing the initialization vector, dm-crypt uses the function
iv_of_dmreq, which performs this calculation: ALIGN((unsigned long)(dmreq
+ 1), crypto_ablkcipher_alignmask(any_tfm(cc)) + 1).

dm-crypt allocated "cc->iv_size" bytes beyond the end of dm_crypt_request
structure.  However, when dm-crypt accesses the initialization vector, it
takes a pointer to the end of dm_crypt_request, aligns it, and then uses
it as the initialization vector.  If the end of dm_crypt_request is not
aligned on a crypto_ablkcipher_alignmask(any_tfm(cc)) boundary the
alignment causes the initialization vector to point beyond the allocated
space.

Fix this bug by calculating the variable iv_size_padding and adding it
to the allocated size.

Also correct the alignment of dm_crypt_request.  struct dm_crypt_request
is specific to dm-crypt (it isn't used by the crypto subsystem at all),
so it is aligned on __alignof__(struct dm_crypt_request).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[wt: minor context adaptations, hopefully ok]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/md/dm-crypt.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 959d6d1..a44a908 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -998,6 +998,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	char *ivopts;
 	unsigned int key_size;
 	unsigned long long tmpll;
+	size_t iv_size_padding;
 
 	if (argc != 5) {
 		ti->error = "Not enough arguments";
@@ -1106,12 +1107,23 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	cc->dmreq_start = sizeof(struct ablkcipher_request);
 	cc->dmreq_start += crypto_ablkcipher_reqsize(tfm);
-	cc->dmreq_start = ALIGN(cc->dmreq_start, crypto_tfm_ctx_alignment());
-	cc->dmreq_start += crypto_ablkcipher_alignmask(tfm) &
-			   ~(crypto_tfm_ctx_alignment() - 1);
+	cc->dmreq_start = ALIGN(cc->dmreq_start, __alignof__(struct dm_crypt_request));
+
+	if (crypto_ablkcipher_alignmask(tfm) < CRYPTO_MINALIGN) {
+		/* Allocate the padding exactly */
+		iv_size_padding = -(cc->dmreq_start + sizeof(struct dm_crypt_request))
+				& crypto_ablkcipher_alignmask(tfm);
+	} else {
+		/*
+		 * If the cipher requires greater alignment than kmalloc
+		 * alignment, we don't know the exact position of the
+		 * initialization vector. We must assume worst case.
+		 */
+		iv_size_padding = crypto_ablkcipher_alignmask(tfm);
+	}
 
 	cc->req_pool = mempool_create_kmalloc_pool(MIN_IOS, cc->dmreq_start +
-			sizeof(struct dm_crypt_request) + cc->iv_size);
+			sizeof(struct dm_crypt_request) + iv_size_padding + cc->iv_size);
 	if (!cc->req_pool) {
 		ti->error = "Cannot allocate crypt request mempool";
 		goto bad_req_pool;
-- 
1.7.12.2.21.g234cd45.dirty



