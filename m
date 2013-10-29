Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3J2HmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:42:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9422 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3J2HmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:42:18 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-21-526f66d970bd
From: Fan Li <fanofcode.li@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <21040538.71861382950468176.JavaMail.weblogic@epv6ml09>
 <1382956476.992.94.camel@kjgkr>
In-reply-to: <1382956476.992.94.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: change the method of calculating the
 number summary blocks
Date: Tue, 29 Oct 2013 15:41:27 +0800
Message-id: <001401ced47a$61fe2fb0$25fa8f10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGLGSCSKTOiuzbPk65RCytXtzsMdwEdJqSLmonTaIA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jQd2baflBBnP/Gllc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbH4zW3GggtiFX9f
	HmZtYFws1MXIySEhYCIx5dwlZghbTOLCvfVsILaQwHRGiX1HeLsYuYDsH4wSdy9NBStiE1CX
	2DKzmwnEFhGQlpj1aR4LiM0skCkx5/VkVojmVIn9B/oYQWxOAR2Jr0+mgg0VFkiS+H9lKzuI
	zSKgKnGoYTlYnFfAUuL+mttQtqDEj8n3gGZyAM1Ul5gyJRdivLbEk3cXWCHuVJDYcfY1I8QJ
	VhJ3Hm9ihKgRl5j04CH7BEahWUgmzUKYNAvJpFlIOhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECA76Z9I7GFc1WBxiFOBgVOLhtWDLDxJiTSwrrsw9xCjBwawkwrsjGCjEm5JYWZVa
	lB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBMbJty53QlZlnljQVnPZe
	srqqdZb2hQWfezgUG/ersf/NO1HMbB2QZcs/t3H31A0tfn+ty5cnT5Gv1/yg0PSm8KjANfkG
	4T0flkytPa5QJi3QENmXdj09u10vaKvFUYtLCkpzMrUfMXFWft21S42hoZv5ecWVqpizUq1a
	ki2bZCZWKBZslJqoxFKckWioxVxUnAgATYdrxHYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> 2013-10-28 (월), 08:54 +0000, Fan Li:
> > "There is a HTML error in the previous email, so I send this one.If you
> already received this before, please ignore it.Sorry for the inconvenience"
> >
> > This patch change the method of calculating the number of summary blocks
> in function  npages_for_summary_flush.
> > npages_for_summary_flush uses (SUMMARY_SIZE + 1) as the size of a
> f2fs_summary while the actual size is just SUMMARY_SIZE.
> > As a result, occasionally the return value of npages_for_summary_flush will
> be bigger than the actual number by one, and the checkpoint won't be
> written contiguously  into disk.
> > Besides, struct f2fs_summary can't be split to two pages, so it could take
> more space than the sum of its size, the current version seems not to take it
> into account.
> >
> 
> Again. Please write a description not to exceed 80 columns.
> 

Sorry, didn't know. here's the short version:
npages_for_summary_flush uses (SUMMARY_SIZE + 1) as the size of a f2fs_summary 
while its actual size is  SUMMARY_SIZE. So the result sometimes is bigger than 
actual number by one, which causes checkpoint can't be written into disk contiguously,
and sometimes summary blocks can't be compacted like they should.
Besides, when writing summary blocks into pages, if remain space in a page isn't 
big enough for one f2fs_summary, it will be left unused, current code seems 
not to take it into account.

Signed-off-by: Fan Li <fanofcode.li@samsung.com>
---
 fs/f2fs/segment.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 487af61..e40cdc4 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -279,9 +279,8 @@ static void __add_sum_entry(struct f2fs_sb_info *sbi, int type,
  */
 int npages_for_summary_flush(struct f2fs_sb_info *sbi)
 {
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

