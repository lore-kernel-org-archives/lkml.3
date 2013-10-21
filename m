Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3JUVt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:49:28 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:47721 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3JUVtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:49:25 -0400
Date: Mon, 21 Oct 2013 14:49:20 -0700
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
Subject: [PATCHv2 12/13] mm, thp, tmpfs: enable thp page cache in tmpfs
Message-ID: <20131021214920.GM29870@hippobay.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From inode, mark to enable thp in the page cache for tmpfs

Signed-off-by: Ning Qu <quning@gmail.com>
---
 mm/Kconfig | 4 ++--
 mm/shmem.c | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 562f12f..4d2f90f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -428,8 +428,8 @@ config TRANSPARENT_HUGEPAGE_PAGECACHE
        help
          Enabling the option adds support hugepages for file-backed
          mappings. It requires transparent hugepage support from
-         filesystem side. For now, the only filesystem which supports
-         hugepages is ramfs.
+         filesystem side. For now, the filesystems which support
+         hugepages are: ramfs and tmpfs.

 config CROSS_MEMORY_ATTACH
        bool "Cross Memory Support"
diff --git a/mm/shmem.c b/mm/shmem.c
index c42331a..391c4eb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1655,6 +1655,11 @@ static struct inode *shmem_get_inode(struct super_block *sb, const struct inode
                        break;
                case S_IFREG:
                        inode->i_mapping->a_ops = &shmem_aops;
+                       /*
+                        * TODO: make tmpfs pages movable
+                        */
+                       mapping_set_gfp_mask(inode->i_mapping,
+                                            GFP_TRANSHUGE);
                        inode->i_op = &shmem_inode_operations;
                        inode->i_fop = &shmem_file_operations;
                        mpol_shared_policy_init(&info->policy,
-- 
1.8.4
