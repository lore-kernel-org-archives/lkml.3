Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaGNIrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:47:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10007 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaGNIq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:46:59 -0400
X-AuditID: cbfee61a-f79e46d00000134f-c3-53c39900f4f8
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: reduce searching region of segmap when free
 section
Date: Mon, 14 Jul 2014 16:45:15 +0800
Message-id: <000001cf9f40$28976ed0$79c64c70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+fP+fKy8ArP1zOQNqSuBKTJC+hng==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAV2GmYeDDQ42Wlpc29fIZPFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	2x6cYC64zFGxa8UR9gbGSexdjJwcEgImEk82rGKBsMUkLtxbz9bFyMUhJLCIUWLN5yvMEM4P
	RomHi/4yglSxCahILO/4zwRiiwh4SUzafwKsm1kgU+Je0wxmEFtYIExib+sLsA0sAqoSL1dP
	BavnFbCU2NKzlR3CFpT4MfkeVK+WxPqdx5kgbHmJzWveMkNcpCCx4+xrRohdehL7pn6BqheX
	2HjkFssERoFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHN7P
	pHYwrmywOMQowMGoxMObwXE4WIg1say4MvcQowQHs5IIb7gbUIg3JbGyKrUoP76oNCe1+BCj
	NAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAPjbJOngrMqUtUtN4h7ibRWMT7h3Fpo+Dm9
	++v5C+sSp6cdKJAyenFg2mKnq0uWTLU96yya/e/BznNzBK34dnx6+Sfm8ns2qeY9bUvcrwp0
	tghFG1wRKkop6jscxqBWe1iKY+Lc1mtxU5WZur+dnFkoxvpD4uSqiwuZvulUzpo0e9k59hd/
	05ieKLEUZyQaajEXFScCAFI/Cp5rAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __set_test_and_free we will check whether all segment are free in one section
When free one segment, in order to set section to free status.
But the searching region of segmap is from start segno to last segno of f2fs,
it's not necessary. So let's just only check all segment bitmap of target
section.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/segment.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 7091204..ee5c75e 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -347,8 +347,8 @@ static inline void __set_test_and_free(struct f2fs_sb_info *sbi,
 	if (test_and_clear_bit(segno, free_i->free_segmap)) {
 		free_i->free_segments++;
 
-		next = find_next_bit(free_i->free_segmap, TOTAL_SEGS(sbi),
-								start_segno);
+		next = find_next_bit(free_i->free_segmap,
+				start_segno + sbi->segs_per_sec, start_segno);
 		if (next >= start_segno + sbi->segs_per_sec) {
 			if (test_and_clear_bit(secno, free_i->free_secmap))
 				free_i->free_sections++;
-- 
2.0.0.421.g786a89d


