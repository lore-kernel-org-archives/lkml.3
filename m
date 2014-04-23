Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbaDWImc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:42:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53173 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaDWIm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:42:29 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-41-53577cf42447
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Minchan Kim'" <minchan@kernel.org>, "'Nitin Gupta'" <ngupta@vflare.org>,
        iamjoonsoo.kim@lge.com,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] zram: correct offset usage in zram_bio_discard
Date: Wed, 23 Apr 2014 16:41:15 +0800
Message-id: <000001cf5ecf$f4f4f850$dedee8f0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9ez8mDZWljxjzHRwmAox3SRtRIPg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQd0vNeHBBjf2C1nMWb+GzaLr1FQW
	i5XdzWwWl3fNYbNY9vU9u8WGllnsFms/P2a3eHLiP4sDh8fOWXfZPTat6mTz6Hp7hcnjxIzf
	LB4fn95i8dj5aTOrx+dNcgHsUVw2Kak5mWWpRfp2CVwZT08tZSr4yV3x7VZEA+MVzi5GTg4J
	AROJA1vXMUPYYhIX7q1n62Lk4hASmM4osfDTc3YI5w+jxKI7K8Gq2AS0Je72b2TtYuTgEBHQ
	l2hr0QAJMwu0Mkl0HFYEsYUF3CQed08AK2ERUJXobKgACfMK2Ek0Pv/KAmELSvyYfI8FolVd
	YtK8RcwQtrzE5jVvmUFaJYDij/7qgoRFBPQkGv5PZ4IoEZfYeOQWywRGgVlIJs1CMmkWkkmz
	kLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcFc+kdjCubLA4xCjAwajEw1uwMixY
	iDWxrLgy9xCjBAezkghvTHl4sBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6Yklqdmp
	qQWpRTBZJg5OqQZG9rlJZ18Lt3/rsQp5MVfzSMvrk6XvBbSjg8yXsAizP2w0XsDw6oGeqyj/
	erkQ5sXrJM4pvrCzlInwCkm5aFBXbna7IFBC4lZwmzvL3GfLNrtcOJFeH/JhF5cit7rkN9Mv
	p1n9J7Lf7NEU+WBcb6p7lcl+74ND/zmY5c7eMbEUq3Fujbr05YMSS3FGoqEWc1FxIgC3qbgW
	hgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to skip the physical block(PAGE_SIZE) which is partially
covered by the discard bio, so we check the remaining size and
subtract it if there is a need to goto the next physical block.

The current offset usage in zram_bio_discard is incorrect, it will
cause its upper filesystem breakdown.
Consider the following scenario:
on some architecture or config, PAGE_SIZE is 64K for example,
filesystem is set up on zram disk without PAGE_SIZE aligned,
a discard bio leads to a offset = 4K and size=72K,
normally, it should not really discard any physical block as it
partially cover two physical blocks.
However, with the current offset usage, it will discard the second
physical block and free its memory, which will cause filesystem breakdown.

This patch corrects the offset usage in zram_bio_discard.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
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


