Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbaDBDnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 23:43:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21959 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbaDBDnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 23:43:47 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-72-533b8770a6d0
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix to cover io->bio with io_rwsem
Date: Wed, 02 Apr 2014 12:41:49 +0900
Message-id: <1396410109-20156-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zfd2CdutggzefeS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyrj2cQJrwRH2io5p
	U1kaGCexdTFycEgImEi0Ts3uYuQEMsUkLtxbzwZiCwksY5S4dD0IpmT67rouRi6g8HRGieVv
	mlkgnE4miRu35zODFLEJaEts3m8A0isiwCyxYOp5RpAaZoEJjBL/F71nAUkIC1hKXPl/khXE
	ZhFQlVh8ezITiM0r4C6x/vNLRogjtCW2PZ8I1iwh8JhNYsKEBywQDQIS3yYfYoG4SFZi0wFm
	iHpJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMk/Hp3MN4+YH2IMRlo
	3ERmKdHkfGD45pXEGxqbGVmYmpgaG5lbmpEmrCTOm/QwKUhIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QD45qgCYG/Yq5/OXfCTqpjwnpbhUPdDQ36196xdE+7UDfvjsvHhnc1BdmdXErdHCc2
	Snz9eG1WwHJJzcQyi/XrNb7fLhB4fjAh+eOduv189zf+buy8pfrIsj6iP3D2vr6dOqcLns6Y
	5/PLPLvhfgfbt4nL0r94f7r1ffckKf1fexqmTNh9WNtcjF+JpTgj0VCLuag4EQDDvBhDVQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd2Cdutgg+99XBbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWZc+ziBteAIe0XHtKksDYyT2LoYOTgkBEwkpu+u62LkBDLFJC7cWw8U5uIQ
	EpjOKLH8TTMLhNPJJHHj9nxmkAY2AW2JzfsNQBpEBJglFkw9zwhSwywwgVHi/6L3LCAJYQFL
	iSv/T7KC2CwCqhKLb09mArF5Bdwl1n9+yQixTVti2/OJjBMYuRcwMqxiFE0tSC4oTkrPNdIr
	TswtLs1L10vOz93ECA7wZ9I7GFc1WBxiFOBgVOLhPXDeKliINbGsuDL3EKMEB7OSCO93X+tg
	Id6UxMqq1KL8+KLSnNTiQ4zJQNsnMkuJJucDoy+vJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaB
	QgLpiSWp2ampBalFMFuYODilGhiTpoqfOPOD848/+84TmUdYvy36qFPz3LDd0SQzW27Zb9N7
	STeMheeuWuEjVJ727rKOGLeIWmoC68rQ1e+WrrCbdVPWM2yRnd6H+lIbv9DqeN2K0As/LTQu
	TLy0unHv04z9GV2mzKu275/+6PuBthfzH8yfz2jhfE5eaW5WuP4bJmbh7j+cNreVWIozEg21
	mIuKEwGgWpSNtAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the f2fs_wait_on_page_writeback, io->bio should be covered by io_rwsem.
Otherwise, the bio pointer can become a dangling pointer due to data races.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index cb49e63..f799c6a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1049,15 +1049,14 @@ static inline bool is_merged_page(struct f2fs_sb_info *sbi,
 {
 	enum page_type btype = PAGE_TYPE_OF_BIO(type);
 	struct f2fs_bio_info *io = &sbi->write_io[btype];
-	struct bio *bio = io->bio;
 	struct bio_vec *bvec;
 	int i;
 
 	down_read(&io->io_rwsem);
-	if (!bio)
+	if (!io->bio)
 		goto out;
 
-	bio_for_each_segment_all(bvec, bio, i) {
+	bio_for_each_segment_all(bvec, io->bio, i) {
 		if (page == bvec->bv_page) {
 			up_read(&io->io_rwsem);
 			return true;
-- 
1.8.4.474.g128a96c

