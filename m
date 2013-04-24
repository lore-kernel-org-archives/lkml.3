Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab3DXMCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:02:45 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:51738 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab3DXMCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:02:42 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] ath6kl: Unify sg_sz and buf_sz in ath6kl_sdio_alloc_prep_scat_req()
Date: Wed, 24 Apr 2013 14:02:34 +0200
Message-Id: <1366804954-20491-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sg_sz and buf_sz are initialized and used in a mutual exclusive way.
However, some versions of gcc are not smart enough to see this:

drivers/net/wireless/ath/ath6kl/sdio.c: In function ‘ath6kl_sdio_alloc_prep_scat_req’:
drivers/net/wireless/ath/ath6kl/sdio.c:338: warning: ‘sg_sz’ may be used uninitialized in this function

Unify the sg_sz and buf_sz variables into a single size variable to kill
the compiler warning.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index d111980..7638135 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -335,17 +335,17 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
 {
 	struct hif_scatter_req *s_req;
 	struct bus_request *bus_req;
-	int i, scat_req_sz, scat_list_sz, sg_sz, buf_sz;
+	int i, scat_req_sz, scat_list_sz, size;
 	u8 *virt_buf;
 
 	scat_list_sz = (n_scat_entry - 1) * sizeof(struct hif_scatter_item);
 	scat_req_sz = sizeof(*s_req) + scat_list_sz;
 
 	if (!virt_scat)
-		sg_sz = sizeof(struct scatterlist) * n_scat_entry;
+		size = sizeof(struct scatterlist) * n_scat_entry;
 	else
-		buf_sz =  2 * L1_CACHE_BYTES +
-			  ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER;
+		size =  2 * L1_CACHE_BYTES +
+			ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER;
 
 	for (i = 0; i < n_scat_req; i++) {
 		/* allocate the scatter request */
@@ -354,7 +354,7 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
 			return -ENOMEM;
 
 		if (virt_scat) {
-			virt_buf = kzalloc(buf_sz, GFP_KERNEL);
+			virt_buf = kzalloc(size, GFP_KERNEL);
 			if (!virt_buf) {
 				kfree(s_req);
 				return -ENOMEM;
@@ -364,7 +364,7 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
 				(u8 *)L1_CACHE_ALIGN((unsigned long)virt_buf);
 		} else {
 			/* allocate sglist */
-			s_req->sgentries = kzalloc(sg_sz, GFP_KERNEL);
+			s_req->sgentries = kzalloc(size, GFP_KERNEL);
 
 			if (!s_req->sgentries) {
 				kfree(s_req);
-- 
1.7.0.4

