Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422Ab3E1BVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 21:21:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63331 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab3E1BVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 21:21:01 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-ee-51a4067b5423
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/3] f2fs: iput only if whole data blocks are flushed
Date: Tue, 28 May 2013 10:19:43 +0900
Message-id: <1369703985-26284-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zfd1qtiWBBn8+Wltc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbH/2lPWgl6Oin93
	N7A1MF5l62Lk4JAQMJGYda2ki5ETyBSTuHBvPVCYi0NIYBmjxMfGo2wQCROJi4e+MUMkpjNK
	bFz1nx3CaWOS+DThBjPIJDYBbYnN+w1AGkQEmCUWTD3PCFLDLDCBUeL/ovcsIAlhAVeJfVvv
	MIPYLAKqEn03WllBbF4Bd4mG38eZIbbpSqz+/xxsgYTAbTaJR3+2QDUISHybfIgF4mxZiU0H
	oOolJQ6uuMEygVFwASPDKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQEJywg/HeAetDjMlA
	4yYyS4km5wNDOK8k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJD
	jEwcnFINjHEnGr5Ojky6aHdS9rj0l3uelYp7hS7syom4kL0s9619hunP3aXvbI97WatHfg7i
	0thR5MJTpHZ8U/dEwc1hwWz5zY9LLor1Wp7crblc4Ne7H31agXlHHdgeJz46tVlmgqfn9QVx
	9/PSBK46nZTTn+76dPNC2fSDLeopzRvX//bZ6bWmTdzESImlOCPRUIu5qDgRACkaEy5XAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd1qtiWBBqvumFtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix/9pT1oJejop/dzewNTBeZeti5OSQEDCRuHjoGzOELSZx4d56oDgXh5DA
	dEaJjav+s0M4bUwSnybcAKri4GAT0JbYvN8ApEFEgFliwdTzjCA1zAITGCX+L3rPApIQFnCV
	2Lf1DthUFgFVib4brawgNq+Au0TD7+NQ23QlVv9/zj6BkXsBI8MqRtHUguSC4qT0XCO94sTc
	4tK8dL3k/NxNjOAQfya9g3FVg8UhRgEORiUe3gnZiwOFWBPLiitzDzFKcDArifBuXwEU4k1J
	rKxKLcqPLyrNSS0+xJgMtH0is5Rocj4w/vJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCe
	WJKanZpakFoEs4WJg1OqgXH+Ri21ZXZhsfuX3GMRdf1gLnqC3eOI5TKuoO/Jjnbf1A8t6bIq
	lnl7vthlvvuarRr1l52nLNj2a2+p5mSO3Ow73N/NK0vXlH6+4HH2ZI6ymutKrjL9pyaNJ75o
	hWV4vnsarL9rZ6RYmLQQf4VfVLwPk9gl7ZsudzXynp0PU7fzPPd7tt5eSyWW4oxEQy3mouJE
	AM61JcG1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there remains some unwritten blocks from the recovery, we should not call
iput on that directory inode.
Otherwise, we can loose some dentry blocks after the recovery.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 01ddc91..0d3701d 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -501,8 +501,10 @@ void remove_dirty_dir_inode(struct inode *inode)
 		return;
 
 	spin_lock(&sbi->dir_inode_lock);
-	if (atomic_read(&F2FS_I(inode)->dirty_dents))
-		goto out;
+	if (atomic_read(&F2FS_I(inode)->dirty_dents)) {
+		spin_unlock(&sbi->dir_inode_lock);
+		return;
+	}
 
 	list_for_each(this, head) {
 		struct dir_inode_entry *entry;
@@ -516,7 +518,6 @@ void remove_dirty_dir_inode(struct inode *inode)
 			break;
 		}
 	}
-out:
 	spin_unlock(&sbi->dir_inode_lock);
 
 	/* Only from the recovery routine */
-- 
1.8.1.3.566.gaa39828

