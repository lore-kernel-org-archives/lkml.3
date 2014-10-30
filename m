Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbaJ3GVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:21:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10798 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaJ3GVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:21:35 -0400
X-AuditID: cbfee61a-f79c06d000004e71-65-5451d8ececaa
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] zram: avoid kunmap_atomic a NULL pointer
Date: Thu, 30 Oct 2014 14:20:31 +0800
Message-id: <000001cff409$bf7bfa50$3e73eef0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/0CZtK3FSAJJLQRf6BxYWPocEcfg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t9jQd03NwJDDG7clraYs34Nm8WFtt0s
	Fpd3zWGzuLfmP6vFsq/v2S02tMxit1j7+TG7xZMT/1kcODx2zrrL7vF0wkEmj02rOtk8Nn2a
	xO5xYsZvFo+dnzazenzeJBfAHsVlk5Kak1mWWqRvl8CVMfPFM8aCm+wVS2/sY21gXM/WxcjJ
	ISFgIvFx2xJ2CFtM4sI9kDgXh5DAdEaJD+2nGCGcP4wS+/8eYAWpYhPQlrjbvxHMFhFQk1h3
	8AULSBGzwDomiT3THzKBJIQFLCV+bt/CAmKzCKhKtHw9xwhi8wrYSUy/MhPKFpT4MfkeWA2z
	gLrEpHmLmCFseYnNa94C2RxAJ6lLPPqrC7FLT+LEtyZ2iBJxiY1HbrFMYBSYhWTSLCSTZiGZ
	NAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwdHxTGoH48oGi0OMAhyMSjy8GicC
	Q4RYE8uKK3MPMUpwMCuJ8CZeBgrxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5Ykpqd
	mlqQWgSTZeLglGpgPF37cWHj48gadbtDXfPPlvrneAt4XQ8yEat6fvnHiRV6gft+R4mwhpwW
	57/13nzF9GUq8Qsu16yQMrvxV8W3K6VY6W7qA8U7Zi/vR2hF+x29a1X3lVVhwRSjtXKL3Q9t
	fMxUINT+cJXkdkke8W0qoq912Ky23Ij3ZMyozBGY835T0zPhEM1gJZbijERDLeai4kQApP6n
	GYoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram could kunmap_atomic a NULL pointer in a rare situation:
a zram page become a full-zeroed page after a partial write io.
The current code doesn't handle this case and kunmap_atomic a
NULL porinter, which panic the kernel.

This patch fixes this issue.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 drivers/block/zram/zram_drv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 2ad0b5b..3920ee4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -560,7 +560,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	}
 
 	if (page_zero_filled(uncmem)) {
-		kunmap_atomic(user_mem);
+		if (user_mem)
+			kunmap_atomic(user_mem);
 		/* Free memory associated with this sector now. */
 		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 		zram_free_page(zram, index);
-- 
1.7.0.4


