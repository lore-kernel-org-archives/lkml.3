Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3HDCP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 22:15:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:33183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab3HDCOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 22:14:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,810,1367996400"; 
   d="scan'208";a="380857125"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 15/23] mm, fs: avoid page allocation beyond i_size on read
Date: Sun,  4 Aug 2013 05:17:17 +0300
Message-Id: <1375582645-29274-16-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

I've noticed that we allocated unneeded page for cache on read beyond
i_size. Simple test case (I checked it on ramfs):

$ touch testfile
$ cat testfile

It triggers 'no_cached_page' code path in do_generic_file_read().

Looks like it's regression since commit a32ea1e. Let's fix it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>
---
 mm/filemap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 066bbff..c31d296 100644
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
1.8.3.2

