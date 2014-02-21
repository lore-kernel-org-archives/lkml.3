Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbaBUNay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:30:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47171 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbaBUMvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 089/121] block: Fix nr_vecs for inline integrity vectors
Date: Fri, 21 Feb 2014 12:48:33 +0000
Message-Id: <1392986945-9693-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit 087787959ce851d7bbb19f10f6e9241b7f85a3ca upstream.

Commit 9f060e2231ca changed the way we handle allocations for the
integrity vectors. When the vectors are inline there is no associated
slab and consequently bvec_nr_vecs() returns 0. Ensure that we check
against BIP_INLINE_VECS in that case.

Reported-by: David Milburn <dmilburn@redhat.com>
Tested-by: David Milburn <dmilburn@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/bio-integrity.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 45e944f..8dccf73 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -114,6 +114,14 @@ void bio_integrity_free(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_integrity_free);
 
+static inline unsigned int bip_integrity_vecs(struct bio_integrity_payload *bip)
+{
+	if (bip->bip_slab == BIO_POOL_NONE)
+		return BIP_INLINE_VECS;
+
+	return bvec_nr_vecs(bip->bip_slab);
+}
+
 /**
  * bio_integrity_add_page - Attach integrity metadata
  * @bio:	bio to update
@@ -129,7 +137,7 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct bio_vec *iv;
 
-	if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
+	if (bip->bip_vcnt >= bip_integrity_vecs(bip)) {
 		printk(KERN_ERR "%s: bip_vec full\n", __func__);
 		return 0;
 	}
-- 
1.9.0

