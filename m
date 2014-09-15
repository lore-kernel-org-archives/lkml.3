Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaIOKGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:06:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24156 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbaIOKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:06:45 -0400
X-AuditID: cbfee61a-f79e46d00000134f-51-5416ba333bea
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 5/5] f2fs: fix to search whole dirty segmap when
 get_victim
Date: Mon, 15 Sep 2014 18:05:44 +0800
Message-id: <003101cfd0cc$c0335890$409a09b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/MlBCeO4iJFNh9RA6yU6jv1jkB3A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jAV3jXWIhBsvXqVtc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4926B8wF
	nzgrtv6cw97A2MfRxcjBISFgInHyTEEXIyeQKSZx4d56NhBbSGARo8TUS5ZdjFxA9g9GiXNv
	JrKCJNgEVCSWd/xnArFFBLwkJu0/wQJiMwt4SDR2fAerERYIlzi17BbYIBYBVYn5048zg9i8
	ApYS89avhbIFJX5MvgfVqyWxfudxJghbXmLzmrfMEAcpSOw4+5oRYpeeRNfll2wQNeISG4/c
	YpnAKDALyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCA/qZ1A7G
	lQ0WhxgFOBiVeHgL+sRChFgTy4orcw8xSnAwK4nwTt0KFOJNSaysSi3Kjy8qzUktPsQozcGi
	JM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cCopVC750zs6y8dWvHFX5z6A3MMc/+vfCUqfKk0
	iv9P2XbGAKHilhfZOX/0dGY+TDo8J573VYWt9XSGc2XsJ//o7+J6fCrj1ay7ib537hbYC5nm
	v1uYfPLEsvrvW2SCj4oKHwlNezeze2NyuHrp3SOdZu0d7gFOSotq2SWYb5xYYJCWv1beVEyJ
	pTgj0VCLuag4EQBSgh1sZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ->get_victim we get max_search value from dirty_i->nr_dirty without
protection of seglist_lock, after that, nr_dirty can be increased/decreased
before we hold seglist_lock lock.
Then in main loop we attempt to traverse all dirty section one time to find
victim section, but it's not accurate to use max_search as the total loop count,
because we might lose checking several sections or check sections redundantly
for the case of nr_dirty are increased or decreased previously.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/gc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 075ea1e..4481edc 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -263,14 +263,14 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 	unsigned int secno, max_cost;
 	int nsearched = 0;
 
+	mutex_lock(&dirty_i->seglist_lock);
+
 	p.alloc_mode = alloc_mode;
 	select_policy(sbi, gc_type, type, &p);
 
 	p.min_segno = NULL_SEGNO;
 	p.min_cost = max_cost = get_max_cost(sbi, &p);
 
-	mutex_lock(&dirty_i->seglist_lock);
-
 	if (p.alloc_mode == LFS && gc_type == FG_GC) {
 		p.min_segno = check_bg_victims(sbi);
 		if (p.min_segno != NULL_SEGNO)
-- 
2.0.1.474.g72c7794


