Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3HUPiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:38:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:2810 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab3HUPiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:38:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,928,1367996400"; 
   d="scan'208";a="390991157"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, NeilBrown <neilb@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] mm, fs: avoid page allocation beyond i_size on read
Date: Wed, 21 Aug 2013 18:37:21 +0300
Message-Id: <1377099441-2224-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that we allocated unneeded page for cache on read beyond
i_size. Simple test case (I checked it on ramfs):

$ touch testfile
$ cat testfile

It triggers 'no_cached_page' code path in do_generic_file_read().

Looks like it's regression since commit a32ea1e. Let's fix it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: NeilBrown <neilb@suse.de>
---
 mm/filemap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 1905f0e..b1a4d35 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1163,6 +1163,10 @@ static void do_generic_file_read(struct file *filp, loff_t *ppos,
 		loff_t isize;
 		unsigned long nr, ret;
 
+		isize = i_size_read(inode);
+		if (!isize || index > (isize - 1) >> PAGE_CACHE_SHIFT)
+			goto out;
+
 		cond_resched();
 find_page:
 		page = find_get_page(mapping, index);
-- 
1.8.4.rc2

