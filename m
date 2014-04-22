Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaDVDOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:14:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19933 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaDVDOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:14:10 -0400
X-AuditID: cbfee61b-b7f766d00000646c-20-5355de8080ae
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>, iamjoonsoo.kim@lge.com,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Bob Liu'" <bob.liu@oracle.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] zram: correct offset usage in zram_bio_discard
Date: Tue, 22 Apr 2014 11:14:02 +0800
Message-id: <000001cf5dd8$ecf1c360$c6d54a20$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9d2OkahhKhZeOIS9qBUeDWbqT/yg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jAd2Ge6HBBufWGljMWb+GzaLr1FQW
	i5XdzWwWl3fNYbNY9vU9u8WGllnsFms/P2Z3YPfYOesuu8emVZ1sHl1vrzB5nJjxm8Xj49Nb
	LB47P21m9fi8SS6APYrLJiU1J7MstUjfLoEr4+XPFYwFTewVS669YmpgPM7axcjJISFgIvHp
	/AImCFtM4sK99WxdjFwcQgKLGCUa2lcxQTh/GCVan9xnBKliE9CWuNu/EaxbREBNYt3BFywg
	RcwCXxglel99ZwFJCAvYS2y7OZMdxGYRUJXYPHUxWAOvgJ3ExUl/mCFsQYkfk+8B1XMANatL
	TJmSCxJmFpCX2LzmLTNIWAIo/OivLogpIqAnsfaqIUSFuMTGI7dYJjAKzEIyZxbCnFlI5sxC
	0rGAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnA0PJPewbiqweIQowAHoxIPr4RBaLAQ
	a2JZcWXuIUYJDmYlEV7pw0Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1ML
	UotgskwcnFINjA76+Zx10QVPbt47oqL5zqPw3Jf0xbt1RQNu2Zs58fjduH/hh/Oydy17Ngtm
	1wj3ncgO5Z8VWDyVf5595iFWow0vnIqO314l4PDapihhbWHUh2vPF+SxpgW9Kwx8xX7svCGn
	W3Iyb4DnMznlefnebXr9017s2yN+ao7epQ23Fh2bFGEYUhLOoMRSnJFoqMVcVJwIAFs226mC	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we want to skip the logical block which is partially covered by
the discard bio, so check the remaining size and subtract it if
there is a need to goto the next logical block.

This patch corrects the offset usage in zram_bio_discard.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9849b52..48eccb3 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -572,10 +572,10 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 	 * skipping this logical block is appropriate here.
 	 */
 	if (offset) {
-		if (n < offset)
+		if (n <= (PAGE_SIZE - offset))
 			return;
 
-		n -= offset;
+		n -= (PAGE_SIZE - offset);
 		index++;
 	}
 
-- 
1.7.10.4


