Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbaBUAwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:52:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbaBTXv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Milburn <dmilburn@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.10 51/66] block: Fix nr_vecs for inline integrity vectors
Date: Thu, 20 Feb 2014 15:51:50 -0800
Message-Id: <20140220234910.945490095@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/bio-integrity.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

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
@@ -129,7 +137,7 @@ int bio_integrity_add_page(struct bio *b
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct bio_vec *iv;
 
-	if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
+	if (bip->bip_vcnt >= bip_integrity_vecs(bip)) {
 		printk(KERN_ERR "%s: bip_vec full\n", __func__);
 		return 0;
 	}


