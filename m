Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3JUVsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:48:36 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:42334 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab3JUVsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:48:33 -0400
Date: Mon, 21 Oct 2013 14:48:28 -0700
From: Ning Qu <quning@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ning Qu <quning@google.com>, Ning Qu <quning@gmail.com>
Subject: [PATCHv2 11/13] mm, thp, tmpfs: only alloc small pages in
 shmem_file_splice_read
Message-ID: <20131021214828.GL29870@hippobay.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We just hope this is not a common case path. The huge page can't be
added without completely refactoring the code.

Signed-off-by: Ning Qu <quning@gmail.com>
---
 mm/shmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 48b1d84..c42331a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1950,6 +1950,7 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 	index += spd.nr_pages;
 	error = 0;
 
+	i_split_down_read(inode);
 	while (spd.nr_pages < nr_pages) {
 		error = shmem_getpage(inode, index, &page, SGP_CACHE, gfp,
 					0, NULL);
@@ -2019,6 +2020,7 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 		*ppos += error;
 		file_accessed(in);
 	}
+	i_split_up_read(inode);
 	return error;
 }
 
-- 
1.8.4

