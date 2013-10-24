Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3JXIWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:22:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63260 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3JXIWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:22:32 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-bc-5268d8bced3d
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH V2] f2fs: check all ones or zeros bitmap with bitops
 for better mount performance
Date: Thu, 24 Oct 2013 16:21:28 +0800
Message-id: <000401ced092$28087a90$78196fb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7Qgix0aVOP3OzdT4eyTrKpTVQTQA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd09NzKCDBYc0re4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujJnfnjMV
	NPNUXH/1iK2B8T5nFyMnh4SAicSLhqOsELaYxIV769lAbCGB6YwSPdt9uxi5gOwfjBIdrzaw
	gyTYBFQklnf8ZwKxRQSkJWZ9mscCUsQsMBuo4cszRpCEsECexLTP88FsFgFViQWTmsFsXgFL
	ia41u6BsQYkfk+8BNXMANatLTJmSCxJmFtCWePLuAtRBChI7zr5mhNilJzFl+S02iBpxiY1H
	brFMYBSYhWTSLIRJs5BMmoWkYwEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4IB+JrWD
	cWWDxSFGAQ5GJR5ejQ/pQUKsiWXFlbmHGCU4mJVEeD0rMoKEeFMSK6tSi/Lji0pzUosPMUpz
	sCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1MKpt+6S077jl8hmxDR255dUhiptvBRr2zGr3
	ma3hncOyUqztwzafWu/i+oQl/Zui1wluvqRm+I/hwFOzpKeLX4sJXv1ZxV2zunz6vXqLbz1/
	6+z/c/UWvTCVZWFoUD7w4PLnbPPNyayJ5h4Z/zmYl51/defXrFNxn7ZJ7PzLnPn5fuGzFxbr
	m5VYijMSDbWYi4oTAa4GF7lkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, check_block_count check valid_map with bit data type in common scenario that sit has all ones or zeros bitmap, it makes low mount performance.
So let's check the special bitmap with integer data type instead of the bit one.

v2:
    use find_next_bit_le/find_next_zero_bit_le for better performance and readable as Jaegeuk suggested.

Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Signed-off-by: Tan Shu <shu.tan@samsung.com>
Signed-off-by: Yu Chao <chao2.yu@samsung.com>
---
 fs/f2fs/segment.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 7f94d78..d25b6af 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -552,6 +552,23 @@ static inline void check_block_count(struct f2fs_sb_info *sbi,
 	/* check boundary of a given segment number */
 	BUG_ON(segno > end_segno);
 
+	/* check all ones or zeros valid_map */
+	if (GET_SIT_VBLOCKS(raw_sit) == 0) {
+		int pos = find_next_bit_le(&raw_sit->valid_map,
+					sbi->blocks_per_seg,
+					0);
+		if (pos != sbi->blocks_per_seg)
+			BUG();
+		return;
+	} else if (GET_SIT_VBLOCKS(raw_sit) == sbi->blocks_per_seg) {
+		int pos = find_next_zero_bit_le(&raw_sit->valid_map,
+					sbi->blocks_per_seg,
+					0);
+		if (pos != sbi->blocks_per_seg)
+			BUG();
+		return;
+	}
+
 	/* check bitmap with valid block count */
 	for (i = 0; i < sbi->blocks_per_seg; i++)
 		if (f2fs_test_bit(i, raw_sit->valid_map))
-- 
1.7.9.5

