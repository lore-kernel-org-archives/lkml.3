Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3LQIdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:33:10 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:33978 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3LQIdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:33:08 -0500
X-AuditID: cbfee68e-b7fb46d00000186a-1f-52b00c429969
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: write dirty meta pages collectively
Date: Tue, 17 Dec 2013 17:31:58 +0900
Message-id: <1387269118-22410-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zY10nng1BBhcn6Vhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXH29VnWgq1cFdPW
	CTcwnuHoYuTkkBAwkfjxdhsjhC0mceHeerYuRi4OIYFljBLXHkxlgilq6FvGDJFYxCgx6/Yh
	qKpmJok1d68BORwcbALaEpv3G4A0iAgwSyyYep4RpIZZYAKjxP9F71lAaoQFrCQWLFQDMVkE
	VCU6uiNBynkF3CU+HpnNBrFLW2Lb84lgrRICt9kkrv9axgKSYBEQkPg2+RDYGAkBWYlNB5gh
	6iUlDq64wTKBUXABI8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJDw69vBePOA9SHGZKBx
	E5mlRJPzgeGbVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYe88vPMNfO+HdcuXcmR7tbLPcDA69K/M58P/qd9OHuQJhSjOf6XNfam88sS3ji+Zy
	2Vk6F9JfMdudu3+169GzV+FrJu/b8rxcZ55C/p5dAe9Fj5Qpz6ssFe83Cu/9app7g23O8txt
	TsIpBqsvsD1nEVS8yaNb7Mb9Imq6xI/Nb6ZGrJH7e+LcBiWW4oxEQy3mouJEAFS9AqtVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAV0nng1BBktOqltc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx9vVZ1oKtXBXT1gk3MJ7h6GLk5JAQMJFo6FvGDGGLSVy4t56ti5GLQ0hg
	EaPErNuHoJxmJok1d68BORwcbALaEpv3G4A0iAgwSyyYep4RpIZZYAKjxP9F71lAaoQFrCQW
	LFQDMVkEVCU6uiNBynkF3CU+HpnNBrFLW2Lb84mMExi5FzAyrGIUTS1ILihOSs811CtOzC0u
	zUvXS87P3cQIDu5nUjsYVzZYHGIU4GBU4uHlmL0+SIg1say4MvcQowQHs5IIL0sBUIg3JbGy
	KrUoP76oNCe1+BBjMtDyicxSosn5wMjLK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJ
	anZqakFqEcwWJg5OqQbGSKHPdTu27tj592fMwh9nJwsnfRb1zH63P1jfM3P/o/XP2s5lBl2J
	2C53QptFKODf/k2HChT0ZePzZvH7hZ7ty+1WP7Ukel9TroD4/4+WExfO/LH0pJaW2bUX+6Kn
	61Y+bPsa/jT0+iLRosPab1mWeNxPtPtz9e6hj94pNtNN3WWE+WVEPgd2KrEUZyQaajEXFScC
	APitZReyAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances writing dirty meta pages collectively in background.
During the file data writes, it'd better avoid to write small dirty meta pages
frequently.
So let's give a chance to collect a number of dirty meta pages for a while.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index f8c0749..2004b7b 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -108,17 +108,19 @@ static int f2fs_write_meta_pages(struct address_space *mapping,
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
 	struct block_device *bdev = sbi->sb->s_bdev;
+	int nrpages = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 	long written;
 
 	if (wbc->for_kupdate)
 		return 0;
 
-	if (get_pages(sbi, F2FS_DIRTY_META) == 0)
+	/* collect a number of dirty meta pages and write together */
+	if (get_pages(sbi, F2FS_DIRTY_META) < nrpages)
 		return 0;
 
 	/* if mounting is failed, skip writing node pages */
 	mutex_lock(&sbi->cp_mutex);
-	written = sync_meta_pages(sbi, META, bio_get_nr_vecs(bdev));
+	written = sync_meta_pages(sbi, META, nrpages);
 	mutex_unlock(&sbi->cp_mutex);
 	wbc->nr_to_write -= written;
 	return 0;
-- 
1.8.4.474.g128a96c

