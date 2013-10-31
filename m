Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3JaOvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:51:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43488 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3JaOvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:51:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.25
Date: Thu, 31 Oct 2013 14:51:36 +0000
Message-Id: <1383231096-11941-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383231096-11941-1-git-send-email-luis.henriques@canonical.com>
References: <1383231096-11941-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index f51c204..e753078 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .24
+EXTRAVERSION = .25
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/fs/buffer.c b/fs/buffer.c
index 2675e5a..2c78739 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -957,19 +957,9 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 	struct buffer_head *bh;
 	sector_t end_block;
 	int ret = 0;		/* Will call free_more_memory() */
-	gfp_t gfp_mask;
 
-	gfp_mask = mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
-	gfp_mask |= __GFP_MOVABLE;
-	/*
-	 * XXX: __getblk_slow() can not really deal with failure and
-	 * will endlessly loop on improvised global reclaim.  Prefer
-	 * looping in the allocator rather than here, at least that
-	 * code knows what it's doing.
-	 */
-	gfp_mask |= __GFP_NOFAIL;
-
-	page = find_or_create_page(inode->i_mapping, index, gfp_mask);
+	page = find_or_create_page(inode->i_mapping, index,
+		(mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS)|__GFP_MOVABLE);
 	if (!page)
 		return ret;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 953bf3c..226b63e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2405,8 +2405,6 @@ done:
 	return 0;
 nomem:
 	*ptr = NULL;
-	if (gfp_mask & __GFP_NOFAIL)
-		return 0;
 	return -ENOMEM;
 bypass:
 	*ptr = root_mem_cgroup;
