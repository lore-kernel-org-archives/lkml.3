Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaCCFJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 00:09:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45415 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaCCFJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 00:09:08 -0500
X-AuditID: cbfee690-b7f266d00000287c-d5-53140e725580
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: hbx7d@yandex.com
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix to write node pages with WRITE_SYNC
Date: Mon, 03 Mar 2014 14:07:18 +0900
Message-id: <1393823238-31989-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t8zQ90iPpFgg3uPOSyW3zjDanF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k5zHhyvHGANYorhsUlJzMstSi/TtErgy
	2te9ZC14xVHx9PEdlgbGPvYuRk4OCQETicPbrjFC2GISF+6tZwOxhQSWMUo83WgEUzNp2nag
	OBdQfBGjxJpz+1kgnE4miZZTM4EmcXCwCWhLbN5vANIgIiAi8XzNDmaQGmaBCYwS/xe9ZwFJ
	CAvYSZxfu4oJxGYRUJX41PACLM4r4C5xdMs1Joht2hLbnk9kBGmWEHjNJrFo3SFmiAYBiW+T
	D7GALJMQkJXYdIAZol5S4uCKGywTGAUXMDKsYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAgJ
	ywk7GO8dsD7EmAw0biKzlGhyPjCs80riDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5Ykpqd
	mlqQWhRfVJqTWnyIkYmDU6qB0dK2a/ESFu3S73ebl+o6PI48ceVmxYKoxTmx+a+Xbe6+5/RO
	sEJo5ZXi4GM7S8rO3JwVySuy1vfo29Wls+etyfVs21Adwbtso+7GI8wP8nxbvVkj0xb2nuy0
	cpTivCcacCnjYff9+qBmx0W9Da2NzZUp1xl570kJdvEuuyA9+/DL148+3Cg6qMRSnJFoqMVc
	VJwIALPlncBhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jAd0iPpFgg1m3WCyW3zjDanF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k5zHhyvHGANYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYM9rXvWQteMVR8fTxHZYGxj72LkZODgkBE4lJ07azQdhi
	EhfurQeyuTiEBBYxSqw5t58Fwulkkmg5NROog4ODTUBbYvN+A5AGEQERiedrdjCD1DALTGCU
	+L/oPQtIQljATuL82lVMIDaLgKrEp4YXYHFeAXeJo1uuMUFs05bY9nwi4wRG7gWMDKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxgsP+mdQOxpUNFocYBTgYlXh4O5YLBwuxJpYVV+YeYpTg
	YFYS4c1fBhTiTUmsrEotyo8vKs1JLT7EmAy0fSKzlGhyPjAm80riDY1NzIwsjcwsjEzMzUkT
	VhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB0THDJqgnc/FG79gGw9WrA2Pevjpl6SLg6s4W
	v/n+Re+OdP192Xt8M52bb6ldkcm0CO3/MKc51XmGfInu9KSlTFeeXfi6Y3/9lez5L4O2HL8y
	45qT24YJHzduta97ePJf+U72jZ/lDbSq/32TeTvnwZ9O55TDExc2MR4o3/ftcuRWttKX1YYG
	5kosxRmJhlrMRcWJAK5qQpC/AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes performance regression of dbench reported by
Alex <hbx7d@yandex.com>.

This issue was revealed by Phoronix tests results:
http://www.phoronix.com/scan.php?page=article&item=linux_314_ssdfs&num=2

It turns out that we need to assign WRITE_SYNC to the node writes, if
fsync is triggered.

The performance numbers are like below, which is measured by Alex.
1. 355MB/s       ext4
2. 225MB/s       f2fs : WRITE for node writes
3. 525MB/s       f2fs : WRITE_SYNC for node writes

Reported-And-Tested-by: Alex <hbx7d@yandex.com>.
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 00f937e..a4cc1d6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -115,7 +115,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	int ret = 0;
 	bool need_cp = false;
 	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_NONE,
+		.sync_mode = WB_SYNC_ALL,
 		.nr_to_write = LONG_MAX,
 		.for_reclaim = 0,
 	};
-- 
1.8.4.474.g128a96c

