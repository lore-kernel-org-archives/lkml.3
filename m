Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbaLBTra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:47:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaLBTXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:23:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Weijie Yang <weijie.yang@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, Nitin Gupta <ngupta@vflare.org>,
        Weijie Yang <weijie.yang.kh@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 084/121] zram: avoid kunmap_atomic() of a NULL pointer
Date: Tue,  2 Dec 2014 11:19:23 -0800
Message-Id: <1417548000-1794-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weijie Yang <weijie.yang@samsung.com>

commit c406515239376fc93a30d5d03192182160cbd3fb upstream.

zram could kunmap_atomic() a NULL pointer in a rare situation: a zram
page becomes a full-zeroed page after a partial write io.  The current
code doesn't handle this case and performs kunmap_atomic() on a NULL
pointer, which panics the kernel.

This patch fixes this issue.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Weijie Yang <weijie.yang.kh@gmail.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/zram/zram_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index e2f0add..63c2a5b 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -430,7 +430,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	}
 
 	if (page_zero_filled(uncmem)) {
-		kunmap_atomic(user_mem);
+		if (user_mem)
+			kunmap_atomic(user_mem);
 		/* Free memory associated with this sector now. */
 		zram_free_page(zram, index);
 
-- 
1.9.1

