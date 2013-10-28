Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab3J1Iyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:54:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52019 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3J1Iya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:54:30 -0400
X-AuditID: cbfee6a3-b7ff36d000001162-ef-526e264486c3
Date: Mon, 28 Oct 2013 08:54:28 +0000 (GMT)
From: Fan Li <fanofcode.li@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: change the method of calculating the number
 summary blocks
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>
Reply-to: fanofcode.li@samsung.com
MIME-version: 1.0
X-MTR: 20131028084447562@fanofcode.li
Msgkey: 20131028084447562@fanofcode.li
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131028084447562@fanofcode.li
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <21040538.71861382950468176.JavaMail.weblogic@epv6ml09>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t/t6bouanlBBl++mVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M74sECvrEKt5PecbYwHhAtIuRk0NIQF3iz4u9jCC2hICJxPbl
	35khbDGJC/fWs3UxcgHVzGeU+Pr/HytIgkVAVWLln/dsIDabgIbEjcnTmUBsYYEYictfpoLZ
	IgLaEu17D7KDNDML3GSU+DVhLSvENiWJF5+Wgtm8AoISJ2c+YYHYpipxZNJCNoi4msTp3RD1
	EgJyEkumXmaCsHklZrQ/ZYGJT/u6BupSaYnzszYwwly9+PtjqDi/xLHbO4B6OcB6n9wPhhmz
	e/MXNghbQGLqmYNQrVoSHy+/h1rFJ7Fm4VsWmDG7Ti1nhum9v2UuWA2zgKLElO6H7BC2gcSR
	RXMwvMUr4Cyxtm0t2wRGuVlIUrOQtM9C0o6sZgEjyypG0dSC5ILipPQKY73ixNzi0rx0veT8
	3E2M4Dh/tngH4//z1ocYBTgYlXh4N6zNDRJiTSwrrsw9xCjBwawkwtt3CyjEm5JYWZValB9f
	VJqTWnyIUZqDRUmcN/5WUpCQQHpiSWp2ampBahFMlomDU6qB0Tf8nTpXUcrbT5JL2RdFrY3n
	mDf3h8pez79v3z9KNNOdPefEvcKqsy7n9xWvcZl6KdtTI/Z+sakry1Wes/vmBZX3GIhse5Qw
	m7vyq+tlBZ49HScrrzg+YZh017I3Jk5ss+O+r05JS0znRUhfifC4X/DWSdF96sryE8osgZ5x
	F+Udoyd4PhF6q8RSnJFoqMVcVJwIAJnry+vvAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9S8sc8I003451

"There is a HTML error in the previous email, so I send this one.If you already received this before, please ignore it.Sorry for the inconvenience"

This patch change the method of calculating the number of summary blocks in function  npages_for_summary_flush.
npages_for_summary_flush uses (SUMMARY_SIZE + 1) as the size of a f2fs_summary while the actual size is just SUMMARY_SIZE.
As a result, occasionally the return value of npages_for_summary_flush will be bigger than the actual number by one, and the checkpoint won't be written contiguously  into disk.
Besides, struct f2fs_summary can't be split to two pages, so it could take more space than the sum of its size, the current version seems not to take it into account.

Signed-off-by: Fan Li <fanofcode.li@samsung.com>
---
 fs/f2fs/segment.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c index 487af61..ba2930f 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -279,9 +279,8 @@ static void __add_sum_entry(struct f2fs_sb_info *sbi, int type,
  */
 int npages_for_summary_flush(struct f2fs_sb_info *sbi)  {
-	int total_size_bytes = 0;
 	int valid_sum_count = 0;
-	int i, sum_space;
+	int i, sum_in_page;
 
 	for (i = CURSEG_HOT_DATA; i <= CURSEG_COLD_DATA; i++) {
 		if (sbi->ckpt->alloc_type[i] == SSR)
@@ -290,13 +289,12 @@ int npages_for_summary_flush(struct f2fs_sb_info *sbi)
 			valid_sum_count += curseg_blkoff(sbi, i);
 	}
 
-	total_size_bytes = valid_sum_count * (SUMMARY_SIZE + 1)
-			+ sizeof(struct nat_journal) + 2
-			+ sizeof(struct sit_journal) + 2;
-	sum_space = PAGE_CACHE_SIZE - SUM_FOOTER_SIZE;
-	if (total_size_bytes < sum_space)
+	sum_in_page = (PAGE_CACHE_SIZE - 2*SUM_JOURNAL_SIZE - SUM_FOOTER_SIZE)/
+			SUMMARY_SIZE;
+	if (valid_sum_count <= sum_in_page)
 		return 1;
-	else if (total_size_bytes < 2 * sum_space)
+	else if (valid_sum_count-sum_in_page <=
+			(PAGE_CACHE_SIZE-SUM_FOOTER_SIZE)/SUMMARY_SIZE)
 		return 2;
 	return 3;
 }
--
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
