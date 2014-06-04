Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaFEAjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:39:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaFDXVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 053/228] dm verity: fix biovecs hash calculation regression
Date: Wed,  4 Jun 2014 16:21:22 -0700
Message-Id: <20140604232349.775441906@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milan Broz <gmazyland@gmail.com>

commit 3a7745215e7f73a5c7d9bcdc50661a55b39052a3 upstream.

Commit 003b5c5719f159f4f4bf97511c4702a0638313dd ("block: Convert drivers
to immutable biovecs") incorrectly converted biovec iteration in
dm-verity to always calculate the hash from a full biovec, but the
function only needs to calculate the hash from part of the biovec (up to
the calculated "todo" value).

Fix this issue by limiting hash input to only the requested data size.

This problem was identified using the cryptsetup regression test for
veritysetup (verity-compat-test).

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-verity.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -330,15 +330,17 @@ test_block_hash:
 				return r;
 			}
 		}
-
 		todo = 1 << v->data_dev_block_bits;
-		while (io->iter.bi_size) {
+		do {
 			u8 *page;
+			unsigned len;
 			struct bio_vec bv = bio_iter_iovec(bio, io->iter);
 
 			page = kmap_atomic(bv.bv_page);
-			r = crypto_shash_update(desc, page + bv.bv_offset,
-						bv.bv_len);
+			len = bv.bv_len;
+			if (likely(len >= todo))
+				len = todo;
+			r = crypto_shash_update(desc, page + bv.bv_offset, len);
 			kunmap_atomic(page);
 
 			if (r < 0) {
@@ -346,8 +348,9 @@ test_block_hash:
 				return r;
 			}
 
-			bio_advance_iter(bio, &io->iter, bv.bv_len);
-		}
+			bio_advance_iter(bio, &io->iter, len);
+			todo -= len;
+		} while (todo);
 
 		if (!v->version) {
 			r = crypto_shash_update(desc, v->salt, v->salt_size);


