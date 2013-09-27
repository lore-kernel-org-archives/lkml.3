Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025Ab3I0CxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:53:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20237 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab3I0CxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:53:13 -0400
X-IronPort-AV: E=Sophos;i="4.90,989,1371052800"; 
   d="scan'208";a="8635948"
Message-ID: <5244F1DF.2030706@cn.fujitsu.com>
Date: Fri, 27 Sep 2013 10:47:59 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jin Xu <jinuxstyle@gmail.com>
CC: Kim <jaegeuk.kim@samsung.com>,
        f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [f2fs-dev] [PATCH] f2fs: use rw_sem instead of fs_lock(locks
 mutex)
References: <524400F5.80402@cn.fujitsu.com> <52442925.1010701@gmail.com>
In-Reply-To: <52442925.1010701@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/27 10:51:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/27 10:51:24,
	Serialize complete at 2013/09/27 10:51:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jin,
Thanks for your comments.
On 09/26/2013 08:31 PM, Jin Xu wrote:

> Great to see fs_locks is to be replaced. :)
> 
> There is a potential problem with using r/w semaphore this way. The
> thread doing checkpoint might get starved if other threads are
> intensively locking the read semaphore for I/O. 

Yes, it's a weakness of r/w semaphore.

> I noticed that Josef
> introduced a rwsem_is_contended for solving similar issue happening
> in btrfs recently. Maybe it's not a problem for f2fs. I haven't
> verified that yet.

All users of r/w semaphore will face this problem, not only btrfs and f2fs.
IMHO, it's easy to fix, just like Josef's rwsem_is_contended, I'll fix this in
version next. And if rwsem_is_contended is merged into mainline kernel, we can
consider using the common function.

> 
> In addition, maybe we should avoid using the "rwsem" or "mutex" as
> part of the routine name to make the name independent of actual lock
> mechanism. It seems better using:
> f2fs_lock/unlock_all instead of write_lock/unlock_cp_rwsem
> f2fs_lock/unlock_op instead of read_lock/unlock_cp_rwsem

Got it, the original name seems more suitable.

Best regards,
Gu

> 
> Regards,
> Jin
> 
> On 26/09/2013 17:40, Gu Zheng wrote:
>> The fs_locks is used to block other ops(ex, recovery) when doing checkpoint.
>> And each other operate routine(besides checkpoint) needs to acquire a fs_lock,
>> there is a terrible problem here, if these are too many concurrency threads acquiring
>> fs_lock, so that they will block each other and may lead to some performance problem.
>> But this is not the phenomenon we want to see.
>> Though there are some optimization patches introduced to enhance the usage of fs_lock,
>> but the thorough solution is using a *rw_sem* to replace the fs_lock.
>> Checkpoint routine takes write_sem, and other ops take read_sem, so that we can block
>> other ops(ex, recovery) when doing checkpoint, and other ops will not disturb each other,
>> this can avoid the problem described above completely.
>>
>> Thanks to Kim's review and test, and other guys' test is also welcome.
>>
>> Reviewed-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
>> Tested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>   fs/f2fs/checkpoint.c |    7 ++---
>>   fs/f2fs/data.c       |   11 ++++-----
>>   fs/f2fs/f2fs.h       |   52 ++++++++-----------------------------------------
>>   fs/f2fs/file.c       |   37 ++++++++++++++++-------------------
>>   fs/f2fs/inode.c      |   11 ++++-----
>>   fs/f2fs/namei.c      |   50 +++++++++++++++++++++++-------------------------
>>   fs/f2fs/recovery.c   |    7 ++---
>>   fs/f2fs/super.c      |    4 +--
>>   fs/f2fs/xattr.c      |    7 +----
>>   9 files changed, 69 insertions(+), 117 deletions(-)
>>
>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>> index ca39442..1f3bd47 100644
>> --- a/fs/f2fs/checkpoint.c
>> +++ b/fs/f2fs/checkpoint.c
>> @@ -619,11 +619,10 @@ static void block_operations(struct f2fs_sb_info *sbi)
>>       blk_start_plug(&plug);
>>
>>   retry_flush_dents:
>> -    mutex_lock_all(sbi);
>> -
>> +    write_lock_cp_rwsem(sbi);
> 
> It seems better to use name f2fs_lock_all instead of
> write_lock_cp_rwsem.
> 
>>       /* write all the dirty dentry pages */
>>       if (get_pages(sbi, F2FS_DIRTY_DENTS)) {
>> -        mutex_unlock_all(sbi);
>> +        write_unlock_cp_rwsem(sbi);
> 
> f2fs_lock_
>>           sync_dirty_dir_inodes(sbi);
>>           goto retry_flush_dents;
>>       }
>> @@ -646,7 +645,7 @@ retry_flush_nodes:
>>   static void unblock_operations(struct f2fs_sb_info *sbi)
>>   {
>>       mutex_unlock(&sbi->node_write);
>> -    mutex_unlock_all(sbi);
>> +    write_unlock_cp_rwsem(sbi);
>>   }
>>
>>   static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
>> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
>> index 941f9b9..5f9ddc1 100644
>> --- a/fs/f2fs/data.c
>> +++ b/fs/f2fs/data.c
>> @@ -560,9 +560,9 @@ write:
>>           inode_dec_dirty_dents(inode);
>>           err = do_write_data_page(page);
>>       } else {
>> -        int ilock = mutex_lock_op(sbi);
>> +        read_lock_cp_rwsem(sbi);
>>           err = do_write_data_page(page);
>> -        mutex_unlock_op(sbi, ilock);
>> +        read_unlock_cp_rwsem(sbi);
>>           need_balance_fs = true;
>>       }
>>       if (err == -ENOENT)
>> @@ -641,7 +641,6 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
>>       pgoff_t index = ((unsigned long long) pos) >> PAGE_CACHE_SHIFT;
>>       struct dnode_of_data dn;
>>       int err = 0;
>> -    int ilock;
>>
>>       f2fs_balance_fs(sbi);
>>   repeat:
>> @@ -650,7 +649,7 @@ repeat:
>>           return -ENOMEM;
>>       *pagep = page;
>>
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>
>>       set_new_dnode(&dn, inode, NULL, NULL, 0);
>>       err = get_dnode_of_data(&dn, index, ALLOC_NODE);
>> @@ -664,7 +663,7 @@ repeat:
>>       if (err)
>>           goto err;
>>
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>
>>       if ((len == PAGE_CACHE_SIZE) || PageUptodate(page))
>>           return 0;
>> @@ -700,7 +699,7 @@ out:
>>       return 0;
>>
>>   err:
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>       f2fs_put_page(page, 1);
>>       return err;
>>   }
>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>> index 7fd99d8..0836e98 100644
>> --- a/fs/f2fs/f2fs.h
>> +++ b/fs/f2fs/f2fs.h
>> @@ -318,14 +318,6 @@ enum count_type {
>>   };
>>
>>   /*
>> - * Uses as sbi->fs_lock[NR_GLOBAL_LOCKS].
>> - * The checkpoint procedure blocks all the locks in this fs_lock array.
>> - * Some FS operations grab free locks, and if there is no free lock,
>> - * then wait to grab a lock in a round-robin manner.
>> - */
>> -#define NR_GLOBAL_LOCKS    8
>> -
>> -/*
>>    * The below are the page types of bios used in submti_bio().
>>    * The available types are:
>>    * DATA            User data pages. It operates as async mode.
>> @@ -365,10 +357,9 @@ struct f2fs_sb_info {
>>       struct f2fs_checkpoint *ckpt;        /* raw checkpoint pointer */
>>       struct inode *meta_inode;        /* cache meta blocks */
>>       struct mutex cp_mutex;            /* checkpoint procedure lock */
>> -    struct mutex fs_lock[NR_GLOBAL_LOCKS];    /* blocking FS operations */
>> +    struct rw_semaphore cp_rwsem;        /* blocking FS operations */
>>       struct mutex node_write;        /* locking node writes */
>>       struct mutex writepages;        /* mutex for writepages() */
>> -    unsigned char next_lock_num;        /* round-robin global locks */
>>       int por_doing;                /* recovery is doing or not */
>>       int on_build_free_nids;            /* build_free_nids is doing */
>>
>> @@ -520,50 +511,25 @@ static inline void clear_ckpt_flags(struct f2fs_checkpoint *cp, unsigned int f)
>>       cp->ckpt_flags = cpu_to_le32(ckpt_flags);
>>   }
>>
>> -static inline void mutex_lock_all(struct f2fs_sb_info *sbi)
>> +static inline void read_lock_cp_rwsem(struct f2fs_sb_info *sbi)
>>   {
>> -    int i;
>> -
>> -    for (i = 0; i < NR_GLOBAL_LOCKS; i++) {
>> -        /*
>> -         * This is the only time we take multiple fs_lock[]
>> -         * instances; the order is immaterial since we
>> -         * always hold cp_mutex, which serializes multiple
>> -         * such operations.
>> -         */
>> -        mutex_lock_nest_lock(&sbi->fs_lock[i], &sbi->cp_mutex);
>> -    }
>> +    down_read(&sbi->cp_rwsem);
>>   }
>>
>> -static inline void mutex_unlock_all(struct f2fs_sb_info *sbi)
>> +static inline void read_unlock_cp_rwsem(struct f2fs_sb_info *sbi)
>>   {
>> -    int i = 0;
>> -    for (; i < NR_GLOBAL_LOCKS; i++)
>> -        mutex_unlock(&sbi->fs_lock[i]);
>> +    up_read(&sbi->cp_rwsem);
>>   }
>>
>> -static inline int mutex_lock_op(struct f2fs_sb_info *sbi)
>> +static inline void write_lock_cp_rwsem(struct f2fs_sb_info *sbi)
>>   {
>> -    unsigned char next_lock;
>> -    int i = 0;
>> -
>> -    for (; i < NR_GLOBAL_LOCKS; i++)
>> -        if (mutex_trylock(&sbi->fs_lock[i]))
>> -            return i;
>> -
>> -    next_lock = sbi->next_lock_num++ % NR_GLOBAL_LOCKS;
>> -    mutex_lock(&sbi->fs_lock[next_lock]);
>> -    return next_lock;
>> +    down_write_nest_lock(&sbi->cp_rwsem, &sbi->cp_mutex);
>>   }
>>
>> -static inline void mutex_unlock_op(struct f2fs_sb_info *sbi, int ilock)
>> +static inline void write_unlock_cp_rwsem(struct f2fs_sb_info *sbi)
>>   {
>> -    if (ilock < 0)
>> -        return;
>> -    BUG_ON(ilock >= NR_GLOBAL_LOCKS);
>> -    mutex_unlock(&sbi->fs_lock[ilock]);
>> +    up_write(&sbi->cp_rwsem);
>>   }
>> -
>>   /*
>>    * Check whether the given nid is within node id range.
>>    */
>> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
>> index 02c9069..dcd5a0f 100644
>> --- a/fs/f2fs/file.c
>> +++ b/fs/f2fs/file.c
>> @@ -35,18 +35,18 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
>>       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>>       block_t old_blk_addr;
>>       struct dnode_of_data dn;
>> -    int err, ilock;
>> +    int err;
>>
>>       f2fs_balance_fs(sbi);
>>
>>       sb_start_pagefault(inode->i_sb);
>>
>>       /* block allocation */
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       set_new_dnode(&dn, inode, NULL, NULL, 0);
>>       err = get_dnode_of_data(&dn, page->index, ALLOC_NODE);
>>       if (err) {
>> -        mutex_unlock_op(sbi, ilock);
>> +        read_unlock_cp_rwsem(sbi);
>>           goto out;
>>       }
>>
>> @@ -56,12 +56,12 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
>>           err = reserve_new_block(&dn);
>>           if (err) {
>>               f2fs_put_dnode(&dn);
>> -            mutex_unlock_op(sbi, ilock);
>> +            read_unlock_cp_rwsem(sbi);
>>               goto out;
>>           }
>>       }
>>       f2fs_put_dnode(&dn);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>
>>       file_update_time(vma->vm_file);
>>       lock_page(page);
>> @@ -270,7 +270,7 @@ static int truncate_blocks(struct inode *inode, u64 from)
>>       unsigned int blocksize = inode->i_sb->s_blocksize;
>>       struct dnode_of_data dn;
>>       pgoff_t free_from;
>> -    int count = 0, ilock = -1;
>> +    int count = 0;
>>       int err;
>>
>>       trace_f2fs_truncate_blocks_enter(inode, from);
>> @@ -278,13 +278,13 @@ static int truncate_blocks(struct inode *inode, u64 from)
>>       free_from = (pgoff_t)
>>               ((from + blocksize - 1) >> (sbi->log_blocksize));
>>
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       set_new_dnode(&dn, inode, NULL, NULL, 0);
>>       err = get_dnode_of_data(&dn, free_from, LOOKUP_NODE);
>>       if (err) {
>>           if (err == -ENOENT)
>>               goto free_next;
>> -        mutex_unlock_op(sbi, ilock);
>> +        read_unlock_cp_rwsem(sbi);
>>           trace_f2fs_truncate_blocks_exit(inode, err);
>>           return err;
>>       }
>> @@ -305,7 +305,7 @@ static int truncate_blocks(struct inode *inode, u64 from)
>>       f2fs_put_dnode(&dn);
>>   free_next:
>>       err = truncate_inode_blocks(inode, free_from);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>
>>       /* lastly zero out the first data page */
>>       truncate_partial_data_page(inode, from);
>> @@ -416,16 +416,15 @@ static void fill_zero(struct inode *inode, pgoff_t index,
>>   {
>>       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>>       struct page *page;
>> -    int ilock;
>>
>>       if (!len)
>>           return;
>>
>>       f2fs_balance_fs(sbi);
>>
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       page = get_new_data_page(inode, NULL, index, false);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>
>>       if (!IS_ERR(page)) {
>>           wait_on_page_writeback(page);
>> @@ -484,7 +483,6 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len, int mode)
>>               struct address_space *mapping = inode->i_mapping;
>>               loff_t blk_start, blk_end;
>>               struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>> -            int ilock;
>>
>>               f2fs_balance_fs(sbi);
>>
>> @@ -493,9 +491,9 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len, int mode)
>>               truncate_inode_pages_range(mapping, blk_start,
>>                       blk_end - 1);
>>
>> -            ilock = mutex_lock_op(sbi);
>> +            read_lock_cp_rwsem(sbi);
>>               ret = truncate_hole(inode, pg_start, pg_end);
>> -            mutex_unlock_op(sbi, ilock);
>> +            read_unlock_cp_rwsem(sbi);
>>           }
>>       }
>>
>> @@ -529,13 +527,12 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
>>
>>       for (index = pg_start; index <= pg_end; index++) {
>>           struct dnode_of_data dn;
>> -        int ilock;
>>
>> -        ilock = mutex_lock_op(sbi);
>> +        read_lock_cp_rwsem(sbi);
>>           set_new_dnode(&dn, inode, NULL, NULL, 0);
>>           ret = get_dnode_of_data(&dn, index, ALLOC_NODE);
>>           if (ret) {
>> -            mutex_unlock_op(sbi, ilock);
>> +            read_unlock_cp_rwsem(sbi);
>>               break;
>>           }
>>
>> @@ -543,12 +540,12 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
>>               ret = reserve_new_block(&dn);
>>               if (ret) {
>>                   f2fs_put_dnode(&dn);
>> -                mutex_unlock_op(sbi, ilock);
>> +                read_unlock_cp_rwsem(sbi);
>>                   break;
>>               }
>>           }
>>           f2fs_put_dnode(&dn);
>> -        mutex_unlock_op(sbi, ilock);
>> +        read_unlock_cp_rwsem(sbi);
>>
>>           if (pg_start == pg_end)
>>               new_size = offset + len;
>> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
>> index 9339cd2..0e1289a 100644
>> --- a/fs/f2fs/inode.c
>> +++ b/fs/f2fs/inode.c
>> @@ -214,7 +214,7 @@ int update_inode_page(struct inode *inode)
>>   int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
>>   {
>>       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>> -    int ret, ilock;
>> +    int ret;
>>
>>       if (inode->i_ino == F2FS_NODE_INO(sbi) ||
>>               inode->i_ino == F2FS_META_INO(sbi))
>> @@ -227,9 +227,9 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
>>        * We need to lock here to prevent from producing dirty node pages
>>        * during the urgent cleaning time when runing out of free sections.
>>        */
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       ret = update_inode_page(inode);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>
>>       if (wbc)
>>           f2fs_balance_fs(sbi);
>> @@ -243,7 +243,6 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
>>   void f2fs_evict_inode(struct inode *inode)
>>   {
>>       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>> -    int ilock;
>>
>>       trace_f2fs_evict_inode(inode);
>>       truncate_inode_pages(&inode->i_data, 0);
>> @@ -265,9 +264,9 @@ void f2fs_evict_inode(struct inode *inode)
>>       if (F2FS_HAS_BLOCKS(inode))
>>           f2fs_truncate(inode);
>>
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       remove_inode_page(inode);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>
>>       sb_end_intwrite(inode->i_sb);
>>   no_delete:
>> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
>> index 2a5359c..f614cea 100644
>> --- a/fs/f2fs/namei.c
>> +++ b/fs/f2fs/namei.c
>> @@ -27,19 +27,19 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
>>       nid_t ino;
>>       struct inode *inode;
>>       bool nid_free = false;
>> -    int err, ilock;
>> +    int err;
>>
>>       inode = new_inode(sb);
>>       if (!inode)
>>           return ERR_PTR(-ENOMEM);
>>
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       if (!alloc_nid(sbi, &ino)) {
>> -        mutex_unlock_op(sbi, ilock);
>> +        read_unlock_cp_rwsem(sbi);
>>           err = -ENOSPC;
>>           goto fail;
>>       }
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>
>>       inode->i_uid = current_fsuid();
>>
>> @@ -115,7 +115,7 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>>       struct f2fs_sb_info *sbi = F2FS_SB(sb);
>>       struct inode *inode;
>>       nid_t ino = 0;
>> -    int err, ilock;
>> +    int err;
>>
>>       f2fs_balance_fs(sbi);
>>
>> @@ -131,9 +131,9 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>>       inode->i_mapping->a_ops = &f2fs_dblock_aops;
>>       ino = inode->i_ino;
>>
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       err = f2fs_add_link(dentry, inode);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>       if (err)
>>           goto out;
>>
>> @@ -157,7 +157,7 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
>>       struct inode *inode = old_dentry->d_inode;
>>       struct super_block *sb = dir->i_sb;
>>       struct f2fs_sb_info *sbi = F2FS_SB(sb);
>> -    int err, ilock;
>> +    int err;
>>
>>       f2fs_balance_fs(sbi);
>>
>> @@ -165,9 +165,9 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
>>       ihold(inode);
>>
>>       set_inode_flag(F2FS_I(inode), FI_INC_LINK);
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       err = f2fs_add_link(dentry, inode);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>       if (err)
>>           goto out;
>>
>> @@ -220,7 +220,6 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
>>       struct f2fs_dir_entry *de;
>>       struct page *page;
>>       int err = -ENOENT;
>> -    int ilock;
>>
>>       trace_f2fs_unlink_enter(dir, dentry);
>>       f2fs_balance_fs(sbi);
>> @@ -236,9 +235,9 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
>>           goto fail;
>>       }
>>
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       f2fs_delete_entry(de, page, inode);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>
>>       /* In order to evict this inode,  we set it dirty */
>>       mark_inode_dirty(inode);
>> @@ -254,7 +253,7 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
>>       struct f2fs_sb_info *sbi = F2FS_SB(sb);
>>       struct inode *inode;
>>       size_t symlen = strlen(symname) + 1;
>> -    int err, ilock;
>> +    int err;
>>
>>       f2fs_balance_fs(sbi);
>>
>> @@ -265,9 +264,9 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
>>       inode->i_op = &f2fs_symlink_inode_operations;
>>       inode->i_mapping->a_ops = &f2fs_dblock_aops;
>>
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       err = f2fs_add_link(dentry, inode);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>       if (err)
>>           goto out;
>>
>> @@ -290,7 +289,7 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>>   {
>>       struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
>>       struct inode *inode;
>> -    int err, ilock;
>> +    int err;
>>
>>       f2fs_balance_fs(sbi);
>>
>> @@ -304,9 +303,9 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>>       mapping_set_gfp_mask(inode->i_mapping, GFP_F2FS_ZERO);
>>
>>       set_inode_flag(F2FS_I(inode), FI_INC_LINK);
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       err = f2fs_add_link(dentry, inode);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>       if (err)
>>           goto out_fail;
>>
>> @@ -342,7 +341,6 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
>>       struct f2fs_sb_info *sbi = F2FS_SB(sb);
>>       struct inode *inode;
>>       int err = 0;
>> -    int ilock;
>>
>>       if (!new_valid_dev(rdev))
>>           return -EINVAL;
>> @@ -356,9 +354,9 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
>>       init_special_inode(inode, inode->i_mode, rdev);
>>       inode->i_op = &f2fs_special_inode_operations;
>>
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       err = f2fs_add_link(dentry, inode);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>       if (err)
>>           goto out;
>>
>> @@ -387,7 +385,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>>       struct f2fs_dir_entry *old_dir_entry = NULL;
>>       struct f2fs_dir_entry *old_entry;
>>       struct f2fs_dir_entry *new_entry;
>> -    int err = -ENOENT, ilock = -1;
>> +    int err = -ENOENT;
>>
>>       f2fs_balance_fs(sbi);
>>
>> @@ -402,7 +400,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>>               goto out_old;
>>       }
>>
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>
>>       if (new_inode) {
>>
>> @@ -467,7 +465,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>>           update_inode_page(old_dir);
>>       }
>>
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>       return 0;
>>
>>   put_out_dir:
>> @@ -477,7 +475,7 @@ out_dir:
>>           kunmap(old_dir_page);
>>           f2fs_put_page(old_dir_page, 0);
>>       }
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>   out_old:
>>       kunmap(old_page);
>>       f2fs_put_page(old_page, 0);
>> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
>> index a15d122..6412cb8 100644
>> --- a/fs/f2fs/recovery.c
>> +++ b/fs/f2fs/recovery.c
>> @@ -292,7 +292,6 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
>>       struct f2fs_summary sum;
>>       struct node_info ni;
>>       int err = 0, recovered = 0;
>> -    int ilock;
>>
>>       start = start_bidx_of_node(ofs_of_node(page), fi);
>>       if (IS_INODE(page))
>> @@ -300,12 +299,12 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
>>       else
>>           end = start + ADDRS_PER_BLOCK;
>>
>> -    ilock = mutex_lock_op(sbi);
>> +    read_lock_cp_rwsem(sbi);
>>       set_new_dnode(&dn, inode, NULL, NULL, 0);
>>
>>       err = get_dnode_of_data(&dn, start, ALLOC_NODE);
>>       if (err) {
>> -        mutex_unlock_op(sbi, ilock);
>> +        read_unlock_cp_rwsem(sbi);
>>           return err;
>>       }
>>
>> @@ -356,7 +355,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
>>       recover_node_page(sbi, dn.node_page, &sum, &ni, blkaddr);
>>   err:
>>       f2fs_put_dnode(&dn);
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>
>>       f2fs_msg(sbi->sb, KERN_NOTICE, "recover_data: ino = %lx, "
>>               "recovered_data = %d blocks, err = %d",
>> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
>> index 094ccc6..a3c09d9 100644
>> --- a/fs/f2fs/super.c
>> +++ b/fs/f2fs/super.c
>> @@ -777,7 +777,6 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
>>       struct buffer_head *raw_super_buf;
>>       struct inode *root;
>>       long err = -EINVAL;
>> -    int i;
>>
>>       /* allocate memory for f2fs-specific super block info */
>>       sbi = kzalloc(sizeof(struct f2fs_sb_info), GFP_KERNEL);
>> @@ -835,12 +834,11 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
>>       mutex_init(&sbi->gc_mutex);
>>       mutex_init(&sbi->writepages);
>>       mutex_init(&sbi->cp_mutex);
>> -    for (i = 0; i < NR_GLOBAL_LOCKS; i++)
>> -        mutex_init(&sbi->fs_lock[i]);
>>       mutex_init(&sbi->node_write);
>>       sbi->por_doing = 0;
>>       spin_lock_init(&sbi->stat_lock);
>>       init_rwsem(&sbi->bio_sem);
>> +    init_rwsem(&sbi->cp_rwsem);
>>       init_sb_info(sbi);
>>
>>       /* get an inode for meta space */
>> diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
>> index 3d900ea..b0a0306 100644
>> --- a/fs/f2fs/xattr.c
>> +++ b/fs/f2fs/xattr.c
>> @@ -584,16 +584,13 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
>>               const void *value, size_t value_len, struct page *ipage)
>>   {
>>       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>> -    int ilock;
>>       int err;
>>
>>       f2fs_balance_fs(sbi);
>>
>> -    ilock = mutex_lock_op(sbi);
>> -
>> +    read_lock_cp_rwsem(sbi);
>>       err = __f2fs_setxattr(inode, name_index, name, value, value_len, ipage);
>> -
>> -    mutex_unlock_op(sbi, ilock);
>> +    read_unlock_cp_rwsem(sbi);
>>
>>       return err;
>>   }
>>
> 
> 


