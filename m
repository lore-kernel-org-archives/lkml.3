Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161531AbaDQG2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 02:28:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64290 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbaDQG2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 02:28:53 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-09-534f749956bf
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH] f2fs: fix wrong number of max_nid when init
Date: Thu, 17 Apr 2014 14:27:55 +0800
Message-id: <000c01cf5a06$46b1ba30$d4152e90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9aAxBgRScnntk3RFWjGvFXPAQc+w==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd1ZJf7BBitfsllc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfF0+mT2glaOipOb
	57E2MJ5n62Lk5JAQMJH4+n4KK4QtJnHh3nqgOBeHkMB0RokLz94yQTg/GCXmXutnAaliE1CR
	WN7xnwnEFhFQlNjwfgM7iM0skClxr2kGM4gtLOAu0bfiFVA9BweLgKrE+kNlIGFeAUuJ9mVP
	mCBsQYkfk++xQLRqSazfeZwJwpaX2LzmLTPEQQoSO86+ZoRYpScx/9lMNogacYmNR26xTGAU
	mIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGB/Ex6B+OqBotD
	jAIcjEo8vJy//YKFWBPLiitzDzFKcDArifCKh/kHC/GmJFZWpRblxxeV5qQWH2KU5mBREuc9
	2GodKCSQnliSmp2aWpBaBJNl4uCUamDcvC27IDt9whmtxzXv00RYvurNzdsS8qu0ZnNo68pb
	cqIXnudwft2UwPN69VqBhx15J9oPLOH58mqaTHv1oyuT43WWh3qIMq/TadDb8OCK86u5C967
	fjzhyiYeyb7nRdbF9i9PBVpS/9z99eFj68kpW1aYSc23uOGd6ccYdexLxzJDx8Dqy2vElViK
	MxINtZiLihMBn/KlT2ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since max_nid value was minus three in previous commit:
'b63da15e8b475245026bdf2096853683f189706b', Our last three nids could not be
used ever, but 0/node nid/meta nid is still occupied.
And also our ra_meta_pages() could not readahead the last block of NAT.
Let's fix the wrong calculation of this value, and left the reserved nids there.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 84f9b7b..3f0bb50 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1860,7 +1860,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 	nat_blocks = nat_segs << le32_to_cpu(sb_raw->log_blocks_per_seg);
 
 	/* not used nids: 0, node, meta, (and root counted as valid node) */
-	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks - 3;
+	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks;
 	nm_i->fcnt = 0;
 	nm_i->nat_cnt = 0;
 	nm_i->ram_thresh = DEF_RAM_THRESHOLD;
-- 
1.7.9.5


