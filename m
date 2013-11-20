Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3KTMvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 07:51:15 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:32814 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3KTMvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 07:51:13 -0500
MIME-Version: 1.0
In-Reply-To: <1384501749.14041.107.camel@kjgkr>
References: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
	<1384096401-25169-5-git-send-email-huajun.li.lee@gmail.com>
	<1384501749.14041.107.camel@kjgkr>
Date: Wed, 20 Nov 2013 20:51:12 +0800
Message-ID: <CA+v9cxZTJrcYZVoqNcopU3sWwMn2zvde89YfMW=2pK=W1DJYtw@mail.gmail.com>
Subject: Re: [f2fs-dev][PATCH V2 4/6] f2fs: Key functions to handle inline data
From: Huajun Li <huajun.li.lee@gmail.com>
To: "jaegeuk.kim" <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 3:49 PM, Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> Hi Huajun,
>
> [snip]
>
>> +static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
>> +{
>> +     int err;
>> +     struct page *ipage;
>> +     struct dnode_of_data dn;
>> +     void *src_addr, *dst_addr;
>> +     block_t old_blk_addr, new_blk_addr;
>> +     struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>> +
>> +     f2fs_lock_op(sbi);
>> +     ipage = get_node_page(sbi, inode->i_ino);
>> +     if (IS_ERR(ipage))
>> +             return PTR_ERR(ipage);
>> +
>> +     /*
>> +      * i_addr[0] is not used for inline data,
>> +      * so reserving new block will not destroy inline data
>> +      */
>> +     set_new_dnode(&dn, inode, ipage, ipage, 0);
>> +     err = f2fs_reserve_block(&dn, 0);
>> +     if (err) {
>> +             f2fs_put_page(ipage, 1);
>> +             f2fs_unlock_op(sbi);
>> +             return err;
>> +     }
>> +
>> +     src_addr = inline_data_addr(ipage);
>> +     dst_addr = page_address(page);
>> +     zero_user_segment(page, 0, PAGE_CACHE_SIZE);
>> +
>> +     /* Copy the whole inline data block */
>> +     memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
>> +
>> +     /* write data page to try to make data consistent */
>> +     old_blk_addr = dn.data_blkaddr;
>> +     set_page_writeback(page);
>> +     write_data_page(inode, page, &dn,
>> +                     old_blk_addr, &new_blk_addr);
>> +     update_extent_cache(new_blk_addr, &dn);
>> +     f2fs_wait_on_page_writeback(page, DATA, true);
>> +
>> +     /* clear inline data and flag after data writeback */
>> +     zero_user_segment(ipage, INLINE_DATA_OFFSET,
>> +                              INLINE_DATA_OFFSET + MAX_INLINE_DATA);
>> +     clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
>> +
>> +     sync_inode_page(&dn);
>> +     f2fs_put_page(ipage, 1);
>
> Again, it seems that you missed what I mentioned.
> If we write the inlined data block only, we cannot recover the data
> block after SPO.
> In order to avoid that, we should write its dnode block too by
> triggering sync_node_pages(ino) at this point as similar as fsync
> routine.
>
> Thanks,
>
> --
> Jaegeuk Kim
> Samsung
>

Hi Jaegeuk,
Previously, I refactored f2fs_sync_file() and tried to call it while
converting inline data, but find it is easily dead lock, so just write
data block here.
Then, how about following enhancement to this patch ?  it only copies
some codes to the end of  __f2fs_convert_inline_data(),  and keeps
others same as before.

-----------------------------------------------------------------------------
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index e9b33d7..6ceb2e6 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -10,6 +10,8 @@

 #include <linux/fs.h>
 #include <linux/f2fs_fs.h>
+#include <linux/writeback.h>
+#include <linux/blkdev.h>

 #include "f2fs.h"

@@ -71,6 +73,11 @@ static int __f2fs_convert_inline_data(struct inode
*inode, struct page *page)
     void *src_addr, *dst_addr;
     block_t old_blk_addr, new_blk_addr;
     struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+    struct writeback_control wbc = {
+        .sync_mode = WB_SYNC_ALL,
+        .nr_to_write = LONG_MAX,
+        .for_reclaim = 0,
+    };

     f2fs_lock_op(sbi);
     ipage = get_node_page(sbi, inode->i_ino);
@@ -108,9 +115,20 @@ static int __f2fs_convert_inline_data(struct
inode *inode, struct page *page)
     zero_user_segment(ipage, INLINE_DATA_OFFSET,
                  INLINE_DATA_OFFSET + MAX_INLINE_DATA);
     clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
-
     sync_inode_page(&dn);
     f2fs_put_page(ipage, 1);
+
+    while (!sync_node_pages(sbi, inode->i_ino, &wbc)) {
+        mark_inode_dirty_sync(inode);
+        err = f2fs_write_inode(inode, NULL);
+        if (err)
+            goto out;
+    }
+    err = wait_on_node_pages_writeback(sbi, inode->i_ino);
+    if (err)
+        goto out;
+    err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+
+out:
     f2fs_unlock_op(sbi);

     return err;
