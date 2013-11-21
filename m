Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3KUJg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:36:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29445 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3KUJgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:36:54 -0500
X-AuditID: cbfee691-b7f866d000001b8c-ed-528dd42b4c4b
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: merge read IOs at ra_nat_pages()
Date: Thu, 21 Nov 2013 18:35:50 +0900
Message-id: <1385026550-21055-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ13tK71BBmf3GVlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfFh/iaWghbuiv1P
	VzI3MH7i6GLk5JAQMJF49vwhO4QtJnHh3nq2LkYuDiGBZYwSTR3bGGGKWi/uYYVITGeUmHll
	DzOE08wkcbirm6mLkYODTUBbYvN+A5AGEQFmiQVTzzOC1DALTGCU+L/oPQtIjbCAucTizd4g
	NSwCqhJ//h5iAbF5Bdwlvi3bCbVMW2Lb84lgvRICj9kkLl3fyAzRICDxbfIhsDkSArISmw4w
	Q9RLShxccYNlAqPgAkaGVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxghIThxB+P9A9aHGJOB
	xk1klhJNzgeGcF5JvKGxmZGFqYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MPJyGX+YdNVh/YEyFrbY6RkqHyuFp1n8/nfn8Mk7Dqz7863uhmj+WRv8wj/ajM1p
	V+jmqd8uzZK9btr0wobr7+9dm22PL0/tk7V3yAxcfeeBZm/DBtlJRr06D/ZpK84V8rffIH3R
	7ibPT/0i1dObnutoPedkWpa2j33pwpQtO2REJN3nyrb5ZyqxFGckGmoxFxUnAgAvAjo/VwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQV3tK71BBo2P9Syu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8z4MH8TS0ELd8X+pyuZGxg/cXQxcnJICJhItF7cwwphi0lcuLeerYuRi0NI
	YDqjxMwre5ghnGYmicNd3UxdjBwcbALaEpv3G4A0iAgwSyyYep4RpIZZYAKjxP9F71lAaoQF
	zCUWb/YGqWERUJX48/cQC4jNK+Au8W3ZTkaIZdoS255PZJzAyL2AkWEVo2hqQXJBcVJ6rpFe
	cWJucWleul5yfu4mRnCAP5PewbiqweIQowAHoxIP74OnPUFCrIllxZW5hxglOJiVRHiL5/cG
	CfGmJFZWpRblxxeV5qQWH2JMBto+kVlKNDkfGH15JfGGxiZmRpZGZhZGJubmpAkrifMebLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cCY/1vDJ3CThtmBN9ZLbK8GdHWE+rlenS+cftyLtzf5da/f
	4aKA/mMbfFh83p/pDY08WFlyP3jRAlstq23cV1xmXOf1+fLr2TSv/0sm3tCYxSH8v3z6hKbH
	e96/5j272XFGjEHDnJjT8f801/+x4XP89LlqGq//44Jpe6f9rD2tvDojuY7xd/VuJZbijERD
	Leai4kQA9nOcc7QCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the policy of submitting read bios at ra_nat_pages.

Previously, f2fs submits small read bios with block plugging.
But, with this patch, f2fs itself merges read bios first and then submits a
large bio, which can reduce the bio handling overheads.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index b843a5b..c06871f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -89,13 +89,10 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
 {
 	struct address_space *mapping = sbi->meta_inode->i_mapping;
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
-	struct blk_plug plug;
 	struct page *page;
 	pgoff_t index;
 	int i;
 
-	blk_start_plug(&plug);
-
 	for (i = 0; i < FREE_NID_PAGES; i++, nid += NAT_ENTRY_PER_BLOCK) {
 		if (nid >= nm_i->max_nid)
 			nid = 0;
@@ -108,12 +105,11 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
 			f2fs_put_page(page, 1);
 			continue;
 		}
-		if (f2fs_readpage(sbi, page, index, READ))
-			continue;
+		submit_read_page(sbi, page, index, READ_SYNC);
 
 		f2fs_put_page(page, 0);
 	}
-	blk_finish_plug(&plug);
+	f2fs_submit_read_bio(sbi, READ_SYNC);
 }
 
 static struct nat_entry *__lookup_nat_cache(struct f2fs_nm_info *nm_i, nid_t n)
-- 
1.8.4.474.g128a96c

