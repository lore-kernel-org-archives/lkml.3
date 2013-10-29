Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab3J2P1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:27:36 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:56482 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846Ab3J2P1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:27:35 -0400
MIME-Version: 1.0
In-Reply-To: <1383008170.14041.0.camel@kjgkr>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
	<1382716919-23345-4-git-send-email-huajun.li.lee@gmail.com>
	<1382962607.992.104.camel@kjgkr>
	<1382963296.992.108.camel@kjgkr>
	<CA+v9cxYx35Q=PS4wB52JSWj75T9xg_VYp9PySujZNhPWxj9jAA@mail.gmail.com>
	<1383008170.14041.0.camel@kjgkr>
Date: Tue, 29 Oct 2013 23:27:33 +0800
Message-ID: <CA+v9cxZ6gNxcX_uWHTmQ8rr8kCfxiMvPXembK8OQ3Ea4Y2PT5g@mail.gmail.com>
Subject: Re: [f2fs-dev 3/5] f2fs: Add a new function: f2fs_reserve_block()
From: Huajun Li <huajun.li.lee@gmail.com>
To: "jaegeuk.kim" <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 8:56 AM, Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> Hi Huajun,
>
> 2013-10-29 (화), 00:53 +0800, Huajun Li:
>> Hi Jaegeuk,
>>
>> Thanks for your kindly review and comments.
>>
>> On Mon, Oct 28, 2013 at 8:28 PM, Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
>> > 2013-10-28 (월), 21:16 +0900, Jaegeuk Kim:
>> > Hi,
>> >
>> >>
>> >> 2013-10-26 (토), 00:01 +0800, Huajun Li:
>> >> > From: Huajun Li <huajun.li@intel.com>
>> >> >
>> >> > Add the function f2fs_reserve_block() to easily reserve new blocks.
>> >> >
>> >> > Signed-off-by: Huajun Li <huajun.li@intel.com>
>> >> > Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
>> >> > Signed-off-by: Weihong Xu <weihong.xu@intel.com>
>> >> > ---
>> >> >  fs/f2fs/data.c |   29 ++++++++++++++++++-----------
>> >> >  fs/f2fs/f2fs.h |    1 +
>> >> >  2 files changed, 19 insertions(+), 11 deletions(-)
>> >> >
>> >> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
>> >> > index c8887d8..7b31911 100644
>> >> > --- a/fs/f2fs/data.c
>> >> > +++ b/fs/f2fs/data.c
>> >> > @@ -64,6 +64,23 @@ int reserve_new_block(struct dnode_of_data *dn)
>> >> >     return 0;
>> >> >  }
>> >> >
>> >> > +int f2fs_reserve_block(struct inode *inode,
>> >> > +                  struct dnode_of_data *dn, pgoff_t index)
>> >>
>> >
>> > We don't need to get dnode_of_data from parameters, since it is
>> > used by this function only.
>>
>> After calling f2fs_reserve_block(), we need dn.data_blkaddr to check
>> whether it is NEW_ADDR. So IMO, it's nice to keep this parameter.
>>
>
> Ah, got it.
> BTW, I found another flows we can clean up wrt this issue.
> How about this?
>

This can clean up more codes, thanks a lot.

> ---
>  fs/f2fs/data.c | 51 +++++++++++++++++++++++----------------------------
>  fs/f2fs/f2fs.h |  1 +
>  fs/f2fs/file.c | 39 ++++++---------------------------------
>  3 files changed, 30 insertions(+), 61 deletions(-)
>
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index c8887d8..b8c4f76d 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -64,6 +64,22 @@ int reserve_new_block(struct dnode_of_data *dn)
>         return 0;
>  }
>
> +int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index)
> +{
> +       bool need_put = dn->inode_page ? false : true;
> +       int err;
> +
> +       err = get_dnode_of_data(dn, index, ALLOC_NODE);
> +       if (err)
> +               return err;
> +       if (dn->data_blkaddr == NULL_ADDR)
> +               err = reserve_new_block(dn);
> +
> +       if (need_put)
> +               f2fs_put_dnode(dn);
> +       return err;
> +}
> +
>  static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
>                                         struct buffer_head *bh_result)
>  {
> @@ -300,19 +316,9 @@ struct page *get_new_data_page(struct inode *inode,
>         int err;
>
>         set_new_dnode(&dn, inode, npage, npage, 0);
> -       err = get_dnode_of_data(&dn, index, ALLOC_NODE);
> +       err = f2fs_reserve_block(&dn, index);
>         if (err)
>                 return ERR_PTR(err);
> -
> -       if (dn.data_blkaddr == NULL_ADDR) {
> -               if (reserve_new_block(&dn)) {
> -                       if (!npage)
> -                               f2fs_put_dnode(&dn);
> -                       return ERR_PTR(-ENOSPC);
> -               }
> -       }
> -       if (!npage)
> -               f2fs_put_dnode(&dn);
>  repeat:
>         page = grab_cache_page(mapping, index);
>         if (!page)
> @@ -644,21 +650,15 @@ repeat:
>         *pagep = page;
>
>         f2fs_lock_op(sbi);
> -
>         set_new_dnode(&dn, inode, NULL, NULL, 0);
> -       err = get_dnode_of_data(&dn, index, ALLOC_NODE);
> -       if (err)
> -               goto err;
> -
> -       if (dn.data_blkaddr == NULL_ADDR)
> -               err = reserve_new_block(&dn);
> -
> -       f2fs_put_dnode(&dn);
> -       if (err)
> -               goto err;
> -
> +       err = f2fs_reserve_block(&dn, index);
>         f2fs_unlock_op(sbi);
>
> +       if (err) {
> +               f2fs_put_page(page, 1);
> +               return err;
> +       }
> +
>         if ((len == PAGE_CACHE_SIZE) || PageUptodate(page))
>                 return 0;
>
> @@ -691,11 +691,6 @@ out:
>         SetPageUptodate(page);
>         clear_cold_data(page);
>         return 0;
> -
> -err:
> -       f2fs_unlock_op(sbi);
> -       f2fs_put_page(page, 1);
> -       return err;
>  }
>
>  static int f2fs_write_end(struct file *file,
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index c9d394c..e77ca20 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1112,6 +1112,7 @@ void destroy_checkpoint_caches(void);
>   * data.c
>   */
>  int reserve_new_block(struct dnode_of_data *);
> +int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
>  void update_extent_cache(block_t, struct dnode_of_data *);
>  struct page *find_data_page(struct inode *, pgoff_t, bool);
>  struct page *get_lock_data_page(struct inode *, pgoff_t);
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 2d4190a..21ef0d1 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -33,7 +33,6 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct
> *vma,
>         struct page *page = vmf->page;
>         struct inode *inode = file_inode(vma->vm_file);
>         struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> -       block_t old_blk_addr;
>         struct dnode_of_data dn;
>         int err;
>
> @@ -44,24 +43,10 @@ static int f2fs_vm_page_mkwrite(struct
> vm_area_struct *vma,
>         /* block allocation */
>         f2fs_lock_op(sbi);
>         set_new_dnode(&dn, inode, NULL, NULL, 0);
> -       err = get_dnode_of_data(&dn, page->index, ALLOC_NODE);
> -       if (err) {
> -               f2fs_unlock_op(sbi);
> -               goto out;
> -       }
> -
> -       old_blk_addr = dn.data_blkaddr;
> -
> -       if (old_blk_addr == NULL_ADDR) {
> -               err = reserve_new_block(&dn);
> -               if (err) {
> -                       f2fs_put_dnode(&dn);
> -                       f2fs_unlock_op(sbi);
> -                       goto out;
> -               }
> -       }
> -       f2fs_put_dnode(&dn);
> +       err = f2fs_reserve_block(&dn, page->index);
>         f2fs_unlock_op(sbi);
> +       if (err)
> +               goto out;
>
>         file_update_time(vma->vm_file);
>         lock_page(page);
> @@ -531,22 +516,10 @@ static int expand_inode_data(struct inode *inode,
> loff_t offset,
>
>                 f2fs_lock_op(sbi);
>                 set_new_dnode(&dn, inode, NULL, NULL, 0);
> -               ret = get_dnode_of_data(&dn, index, ALLOC_NODE);
> -               if (ret) {
> -                       f2fs_unlock_op(sbi);
> -                       break;
> -               }
> -
> -               if (dn.data_blkaddr == NULL_ADDR) {
> -                       ret = reserve_new_block(&dn);
> -                       if (ret) {
> -                               f2fs_put_dnode(&dn);
> -                               f2fs_unlock_op(sbi);
> -                               break;
> -                       }
> -               }
> -               f2fs_put_dnode(&dn);
> +               ret = f2fs_reserve_block(&dn, index);
>                 f2fs_unlock_op(sbi);
> +               if (ret)
> +                       break;
>
>                 if (pg_start == pg_end)
>                         new_size = offset + len;
> --
> 1.8.4.474.g128a96c
>
> --
> Jaegeuk Kim
> Samsung
>
