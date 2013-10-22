Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3JVJ3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 05:29:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55376 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3JVJ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 05:29:15 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-df-52664569f4a5
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: check all ones or zeros bitmap with integer
 data type for better mount performance
Date: Tue, 22 Oct 2013 17:28:18 +0800
Message-id: <000701cecf09$2b2a2280$817e6780$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7O+iBxrRKyoTi3RIObTxIC31DHww==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd1M17Qgg94eU4vru/4yWVxa5G6x
	Z+9JFovLu+awWbQuPM/swOqxe8FnJo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKeHt1O1tB
	G0/FrKOn2RoYr3F2MXJwSAiYSOzc79rFyAlkiklcuLeerYuRi0NIYDqjxJez/xkhnB+MEjs3
	XmAFqWITUJFY3vGfCcQWEVCU2PB+AztIEbPANEaJ+Uu+s4EkhAXKJJat7mQBsVkEVCV+XbrI
	DGLzClhKbFmxhhXCFpT4MfkeWA2zgIZE/6INbBC2vMTmNW+ZIU5SkNhx9jUjxDI9iWktG9kh
	asQlNh65xTKBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIE
	B/UzqR2MKxssDjEKcDAq8fBmWKUGCbEmlhVX5h5ilOBgVhLh/WuYFiTEm5JYWZValB9fVJqT
	WnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBsbA14qax2/xyu7x5c/uDUjau/DbF
	+kn9y3ZHb9cNfscWJTRO+iJvz86fIrH3QoQub0fq4iV+DwMiF1zZuac49rf99skqQiXrHoUm
	7vT8u3lu2IX5U9U3n9vC/Mp8aumkw2HzXR8mCdQKLXnIN3dPwReporUfs5YffzH50D/u0A+y
	EulLJ/9m+6DEUpyRaKjFXFScCAAIN0p+ZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, check_block_count check valid_map with bit data type in common
scenario that sit has all ones or zeros bitmap, it makes low mount
performance.
So let's check the special bitmap with integer data type instead of the bit
one.

Signed-off-by: Tan Shu <shu.tan@samsung.com>
Signed-off-by: Yu Chao <chao2.yu@samsung.com>
---
 fs/f2fs/segment.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 7f94d78..d43ab9f 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -543,6 +543,7 @@ static inline void check_block_count(struct f2fs_sb_info
*sbi,
 {
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
 	unsigned int end_segno = sm_info->segment_count - 1;
+	int *valid_map = (int *)raw_sit->valid_map;
 	int valid_blocks = 0;
 	int i;
 
@@ -552,6 +553,19 @@ static inline void check_block_count(struct
f2fs_sb_info *sbi,
 	/* check boundary of a given segment number */
 	BUG_ON(segno > end_segno);
 
+	/* check all ones or zeros valid_map */
+	if (GET_SIT_VBLOCKS(raw_sit) == 0) {
+		for (i = 0; i < SIT_VBLOCK_MAP_SIZE / sizeof(int); i++)
+			if (unlikely(valid_map[i] != 0))
+				BUG();
+		return;
+	} else if (GET_SIT_VBLOCKS(raw_sit) == sbi->blocks_per_seg) {
+		for (i = 0; i < SIT_VBLOCK_MAP_SIZE / sizeof(int); i++)
+			if (unlikely(valid_map[i] != -1))
+				BUG();
+		return;
+	}
+
 	/* check bitmap with valid block count */
 	for (i = 0; i < sbi->blocks_per_seg; i++)
 		if (f2fs_test_bit(i, raw_sit->valid_map))
---

