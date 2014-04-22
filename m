Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaDVFVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:21:44 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:55017 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbaDVFVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:21:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogTAAz8VVNXQDxk/2dsb2JhbABZgwarVJldAgKBHxd0glMTHCMYgQIkARKIRQHMfY5WhD8BA45pigQBimqHZoMzOw
Date: Tue, 22 Apr 2014 07:23:15 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH RESEND] FS: Remove bs paramater in biovec_create_pool
Message-Id: <20140422072315.f01b330b04c10eb0756e4e02@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bs is no longer used in biovec_create_pool
since 9f060e2231ca96
("block: Convert integrity to bvec_alloc_bs()")

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/bio-integrity.c  | 2 +-
 fs/bio.c            | 4 ++--
 include/linux/bio.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 1c2ce0c..9e24106 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -617,7 +617,7 @@ int bioset_integrity_create(struct bio_set *bs, int pool_size)
 	if (!bs->bio_integrity_pool)
 		return -1;
 
-	bs->bvec_integrity_pool = biovec_create_pool(bs, pool_size);
+	bs->bvec_integrity_pool = biovec_create_pool(pool_size);
 	if (!bs->bvec_integrity_pool) {
 		mempool_destroy(bs->bio_integrity_pool);
 		return -1;
diff --git a/fs/bio.c b/fs/bio.c
index 6f0362b..13a4fab 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1859,7 +1859,7 @@ EXPORT_SYMBOL_GPL(bio_trim);
  * create memory pools for biovec's in a bio_set.
  * use the global biovec slabs created for general use.
  */
-mempool_t *biovec_create_pool(struct bio_set *bs, int pool_entries)
+mempool_t *biovec_create_pool(int pool_entries)
 {
 	struct biovec_slab *bp = bvec_slabs + BIOVEC_MAX_IDX;
 
@@ -1922,7 +1922,7 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 	if (!bs->bio_pool)
 		goto bad;
 
-	bs->bvec_pool = biovec_create_pool(bs, pool_size);
+	bs->bvec_pool = biovec_create_pool(pool_size);
 	if (!bs->bvec_pool)
 		goto bad;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index bba5508..5a64576 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -333,7 +333,7 @@ static inline struct bio *bio_next_split(struct bio *bio, int sectors,
 
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
-extern mempool_t *biovec_create_pool(struct bio_set *bs, int pool_entries);
+extern mempool_t *biovec_create_pool(int pool_entries);
 
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
-- 
1.8.4.5

