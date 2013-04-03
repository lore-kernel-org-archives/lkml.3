Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762325Ab3DCJOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760506Ab3DCJN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:13:59 -0400
Date: Wed, 3 Apr 2013 14:43:48 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Petr Matousek <pmatouse@redhat.com>
Subject: Re: [PATCH] To add NULL pointer check
In-Reply-To: <1364975688.4353.7.camel@kjgkr>
Message-ID: <alpine.LFD.2.03.1304031342550.23577@erqung.pbz>
References: <alpine.LFD.2.03.1304021808410.12716@erqung.pbz> <1364958193.4353.4.camel@kjgkr> <alpine.LFD.2.03.1304031224180.21402@erqung.pbz> <1364975688.4353.7.camel@kjgkr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+-- On Wed, 3 Apr 2013, Jaegeuk Kim wrote --+
| I'm confusing the question because f2fs doesn't use generic_writepages(), 
| since f2fs_write_data_pages() is linked to a_ops->writepages. In 
| do_writepages(), always f2fs_write_data_pages() is triggered instead of 
| generic_writepages(). Isn't it?

Before commit fa9150a84c, when `generic_writepages' returned 0, it did not 
abort `f2fs_write_data_pages', as the proposed patch does. I was wondering if 
that's intentional OR if the patch below does it right?

===
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7bd22a2..7be750e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -561,7 +561,7 @@ static int f2fs_write_data_pages(struct address_space 
*mapping,
 {
        struct inode *inode = mapping->host;
        struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-       int ret;
+       int ret = 0;
        long excess_nrtw = 0, desired_nrtw;
 
        if (wbc->nr_to_write < MAX_DESIRED_PAGES_WP) {
@@ -572,7 +572,9 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 
        if (!S_ISDIR(inode->i_mode))
                mutex_lock(&sbi->writepages);
-       ret = write_cache_pages(mapping, wbc, __f2fs_writepage, mapping);
+       /* deal with chardevs and other special file */
+       if (mapping->a_ops->writepage)
+               ret = write_cache_pages(mapping, wbc, __f2fs_writepage, mapping);
        if (!S_ISDIR(inode->i_mode))
                mutex_unlock(&sbi->writepages);
        f2fs_submit_bio(sbi, DATA, (wbc->sync_mode == WB_SYNC_ALL));
===

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
