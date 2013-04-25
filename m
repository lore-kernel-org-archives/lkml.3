Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab3DYUnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:43:37 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62479 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab3DYUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:43:35 -0400
Date: Thu, 25 Apr 2013 22:43:31 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Maxim V. Patlasov" <mpatlasov@parallels.com>
Cc: Kirill Korotaev <dev@parallels.com>, Pavel Emelianov <xemul@parallels.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, devel@openvz.org,
        Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
        mgorman@suse.de
Subject: Re: [fuse-devel] [PATCH 14/14] mm: Account for WRITEBACK_TEMP in
 balance_dirty_pages
Message-ID: <20130425204331.GB16238@tucsk.piliscsaba.szeredi.hu>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
 <20130401104250.19027.27795.stgit@maximpc.sw.ru>
 <51793DE6.3000503@parallels.com>
 <CAJfpegv1zc4oeE=YXrQd0jmzVXB8jjvXkz-_4Nv_ELcvfsa74Q@mail.gmail.com>
 <517956ED.7060102@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517956ED.7060102@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 08:16:45PM +0400, Maxim V. Patlasov wrote:
> 
> As Mel Gorman pointed out, fuse daemon diving into
> balance_dirty_pages should not kick flusher judging on
> NR_WRITEBACK_TEMP. Essentially, all we need in balance_dirty_pages
> is:
> 
>     if (I'm not fuse daemon)
>         nr_dirty += global_page_state(NR_WRITEBACK_TEMP);

I strongly dislike the above.

What about something like the following untested patch?

The idea is that fuse filesystems should not go over the bdi limit even if the
global limit hasn't been reached.

Thanks,
Miklos

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 137185c..195ee45 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -291,6 +291,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 		inode->i_flags |= S_NOATIME|S_NOCMTIME;
 		inode->i_generation = generation;
 		inode->i_data.backing_dev_info = &fc->bdi;
+		set_bit(AS_STRICTLIMIT, &inode->i_data.flags);
 		fuse_init_inode(inode, attr);
 		unlock_new_inode(inode);
 	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0e38e13..97f6a0c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -25,6 +25,7 @@ enum mapping_flags {
 	AS_MM_ALL_LOCKS	= __GFP_BITS_SHIFT + 2,	/* under mm_take_all_locks() */
 	AS_UNEVICTABLE	= __GFP_BITS_SHIFT + 3,	/* e.g., ramdisk, SHM_LOCK */
 	AS_BALLOON_MAP  = __GFP_BITS_SHIFT + 4, /* balloon page special map */
+	AS_STRICTLIMIT	= __GFP_BITS_SHIFT + 5, /* strict dirty limit */
 };
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index efe6814..91a9e6e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1226,6 +1226,7 @@ static void balance_dirty_pages(struct address_space *mapping,
 	unsigned long dirty_ratelimit;
 	unsigned long pos_ratio;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	int strictlimit = test_bit(AS_STRICTLIMIT, &mapping->flags);
 	unsigned long start_time = jiffies;
 
 	for (;;) {
@@ -1250,7 +1251,7 @@ static void balance_dirty_pages(struct address_space *mapping,
 		 */
 		freerun = dirty_freerun_ceiling(dirty_thresh,
 						background_thresh);
-		if (nr_dirty <= freerun) {
+		if (nr_dirty <= freerun && !strictlimit) {
 			current->dirty_paused_when = now;
 			current->nr_dirtied = 0;
 			current->nr_dirtied_pause =
@@ -1297,7 +1298,7 @@ static void balance_dirty_pages(struct address_space *mapping,
 		}
 
 		dirty_exceeded = (bdi_dirty > bdi_thresh) &&
-				  (nr_dirty > dirty_thresh);
+				  ((nr_dirty > dirty_thresh) || strictlimit);
 		if (dirty_exceeded && !bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
