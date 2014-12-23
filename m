Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaLWTIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 14:08:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:44388 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaLWTIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 14:08:47 -0500
Date: Tue, 23 Dec 2014 11:08:38 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 6/6 v2] f2fs: avoid double lock for cp_rwsem
Message-ID: <20141223190838.GA13638@jaegeuk-mac02>
References: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
 <1419179723-3234-6-git-send-email-jaegeuk@kernel.org>
 <003201d01e7e$66126ae0$323740a0$@samsung.com>
 <20141223074041.GB9946@jaegeuk-mac02.hsd1.ca.comcast.net>
 <003801d01e8e$c496f080$4dc4d180$@samsung.com>
 <20141223190537.GB12880@jaegeuk-mac02>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223190537.GB12880@jaegeuk-mac02>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:
 o fix description

>From fc897d61c01acc19dba434cd4aa29baeb1537b60 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Thu, 18 Dec 2014 19:32:36 -0800
Subject: [PATCH] f2fs: avoid double lock for cp_rwsem

The __f2fs_add_link is covered by cp_rwsem all the time.
This calls init_inode_metadata, which conducts some acl operations including
memory allocation with GFP_KERNEL previously.
But, under memory pressure, f2fs_write_data_page can be called, which also
grabs cp_rwsem too.

In this case, this incurs a deadlock pointed by Chao.
Thread #1        Thread #2
 down_read
                 down_write
  down_read
 -> here down_read should wait forever.

Reviewed-by: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/acl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index 1ccb26b..7f12d28 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -62,7 +62,7 @@ static struct posix_acl *f2fs_acl_from_disk(const char *value, size_t size)
 	if (count == 0)
 		return NULL;
 
-	acl = posix_acl_alloc(count, GFP_KERNEL);
+	acl = posix_acl_alloc(count, GFP_NOFS);
 	if (!acl)
 		return ERR_PTR(-ENOMEM);
 
@@ -116,7 +116,7 @@ static void *f2fs_acl_to_disk(const struct posix_acl *acl, size_t *size)
 	int i;
 
 	f2fs_acl = kmalloc(sizeof(struct f2fs_acl_header) + acl->a_count *
-			sizeof(struct f2fs_acl_entry), GFP_KERNEL);
+			sizeof(struct f2fs_acl_entry), GFP_NOFS);
 	if (!f2fs_acl)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.1.1


