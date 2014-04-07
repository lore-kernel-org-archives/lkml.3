Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaDGDTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 23:19:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18185 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbaDGDTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 23:19:19 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-e4-534219354722
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH v2] f2fs: fix wrong statistics of inline data
Date: Mon, 07 Apr 2014 11:18:34 +0800
Message-id: <000001cf5210$28c139e0$7a43ada0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9SDqS+x7I1jJ1uQJO5qbO7vHn0Pg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAV1TSadgg9Z7qhbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZfRtvcFc8I2tYvex
	fuYGxtOsXYycHBICJhIH9k1ng7DFJC7cWw9kc3EICSxilJh2cCUzhPODUWLztSawKjYBFYnl
	Hf+ZQGwRAUWJDe83sIPYzAKZEveaZjCD2MICHhJrDy8Fs1kEVCX+tz8Aq+cVsJTYsuQkK4Qt
	KPFj8j0WiF4tifU7jzNB2PISm9e8ZYa4SEFix9nXjBC79CQaNn9mhqgRl9h45BbLBEaBWUhG
	zUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzKz6R3MK5qsDjEKMDB
	qMTDG3jAMViINbGsuDL3EKMEB7OSCO9udqdgId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60D
	hQTSE0tSs1NTC1KLYLJMHJxSDYw8Ofw/lwiv1VG+uaFU4cjrpw83npqkW9naXXW1+FLhnx6B
	q2qfVKz4m66+Z33VOmvWFNHsFvOOgOR5H/Pe19wOPpyz+n3jnD0ir6QmxFo9mBBoE5GnNDUw
	PH/qVanXRjK9h/TVxbL+nmmeK3U7ptiq1G/JTNl6vVeHNR6trjJJqAq4zMkm+0+JpTgj0VCL
	uag4EQBXilE4YQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we remove a file that has inline data after mount, our statistics turns to
inaccurate.

cat /sys/kernel/debug/f2fs/status
  - Inline_data Inode: 4294967295

Let's add stat_inc_inline_inode() to stat inline info of the file when lookup.

Change log from v1:
 o stat in f2fs_lookup() instead of in do_read_inode() for excluding wrong stat.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/namei.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 0cea874..a9409d1 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -207,6 +207,8 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 		inode = f2fs_iget(dir->i_sb, ino);
 		if (IS_ERR(inode))
 			return ERR_CAST(inode);
+
+		stat_inc_inline_inode(inode);
 	}
 
 	return d_splice_alias(inode, dentry);
-- 
1.7.9.5


