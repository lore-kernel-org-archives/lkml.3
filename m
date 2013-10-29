Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab3J2IW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:22:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18409 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3J2IWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:22:50 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-cd-526f7058cabc
From: Fan Li <fanofcode.li@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH V2] f2fs: change the method of calculating the
 number summary blocks
Date: Tue, 29 Oct 2013 16:21:47 +0800
Message-id: <002701ced480$0ab1cd10$20156730$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7Uf6DYi+t1N5jrSIqXE+R3Ogz+LA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQd2Igvwgg3cNShbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZayee4i14CBfxZy9
	DcwNjA+4uxg5OSQETCT+nTzGDmGLSVy4t56ti5GLQ0hgOqPEp7kzmSCcH4wSLcdfglWxCahL
	bJnZzQRiiwhIS8z6NI8FxGYWyJSY83oyK4gtLJAoMWVNO1icRUBVYlbffWYQm1fAUmJewwEm
	CFtQ4sfke1C9WhLrdx5ngrDlJTavecsMcZGCxI6zrxkhdulJLNozmxWiRlxi0oOH7BMYBWYh
	GTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwKD+T2sG4ssHiEKMA
	B6MSD+8D5vwgIdbEsuLK3EOMEhzMSiK8O4KBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoH
	CgmkJ5akZqemFqQWwWSZODilGhizG3b6HDzcNmvGzGOt4W2GBnpx0/crmrwXDblw6Etb6LX3
	T+Nb+KTFtNy5DotFlMVl5HxKN/tRfHC9dyDr0ccfX0YsitGqdI2UatkqNeOEk1NFuNaZpZ8l
	zlpn10o/b/Bd8UHtY4z959LJvKHLr+VdF73HK7TlNPdj1c4jt+75X+g+3cl9bboSS3FGoqEW
	c1FxIgB6JNyaYQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npages_for_summary_flush uses (SUMMARY_SIZE + 1) as the size of a
f2fs_summary 
while its actual size is  SUMMARY_SIZE. So the result sometimes is bigger
than actual 
number by one, which causes checkpoint can't be written into disk
contiguously, 
and sometimes summary blocks can't be compacted like they should.
Besides, when writing summary blocks into pages, if remain space in a page
isn't 
big enough for one f2fs_summary, it will be left unused, current code seems
not to 
take it into account.

Signed-off-by: Fan Li <fanofcode.li@samsung.com>
---
 fs/f2fs/segment.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c index 487af61..e40cdc4
100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -279,9 +279,8 @@ static void __add_sum_entry(struct f2fs_sb_info *sbi,
int type,
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
+	sum_in_page = (PAGE_CACHE_SIZE - 2 * SUM_JOURNAL_SIZE -
+			SUM_FOOTER_SIZE) / SUMMARY_SIZE;
+	if (valid_sum_count <= sum_in_page)
 		return 1;
-	else if (total_size_bytes < 2 * sum_space)
+	else if ((valid_sum_count - sum_in_page) <=
+		(PAGE_CACHE_SIZE - SUM_FOOTER_SIZE) / SUMMARY_SIZE)
 		return 2;
 	return 3;
 }
--
1.7.9.5


