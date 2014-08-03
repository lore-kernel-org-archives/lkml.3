Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaHCLV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 07:21:29 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53311 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaHCLV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 07:21:27 -0400
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH (resend)] fs: Fix theoretical division by 0 in super_cache_scan().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201408032021.IDI35961.MSOJVLFFOFtOQH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 3 Aug 2014 20:21:18 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7a2ed4e9c91864736ce5ad89489fd5862d59542e Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 17 May 2014 20:56:38 +0900
Subject: [PATCH] fs: Fix theoretical division by 0 in super_cache_scan().

total_objects could be 0 and is used as a denom.

While total_objects is a "long", total_objects == 0 unlikely happens for
3.12 and later kernels because 32-bit architectures would not be able to
hold (1 << 32) objects. However, total_objects == 0 may happen for kernels
between 3.1 and 3.11 because total_objects in prune_super() was an "int"
and (e.g.) x86_64 architecture might be able to hold (1 << 32) objects.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable <stable@kernel.org> # 3.1+
---
 fs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 48377f7..1408362 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -81,6 +81,8 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	inodes = list_lru_count_node(&sb->s_inode_lru, sc->nid);
 	dentries = list_lru_count_node(&sb->s_dentry_lru, sc->nid);
 	total_objects = dentries + inodes + fs_objects + 1;
+	if (!total_objects)
+		total_objects = 1;
 
 	/* proportion the scan between the caches */
 	dentries = mult_frac(sc->nr_to_scan, dentries, total_objects);
-- 
1.7.1
