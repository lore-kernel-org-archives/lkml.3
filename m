Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaHTCQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 22:16:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbaHTCQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 22:16:30 -0400
Date: Wed, 20 Aug 2014 04:16:23 +0200
From: Jan Kara <jack@suse.cz>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [PATCHv2 1/3] fs/buffer.c: allocate buffer cache with user
 specific flag
Message-ID: <20140820021623.GB3271@quack.suse.cz>
References: <53F2F3E6.1030901@lge.com>
 <53F2F436.4070307@lge.com>
 <20140819130324.GB27553@quack.suse.cz>
 <53F3DFA3.6040303@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F3DFA3.6040303@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-08-14 08:37:07, Gioh Kim wrote:
> 
> 
> 2014-08-19 오후 10:03, Jan Kara 쓴 글:
> >   Hello,
> >
> >On Tue 19-08-14 15:52:38, Gioh Kim wrote:
> >>A buffer cache is allocated from movable area
> >>because it is referred for a while and released soon.
> >>But some filesystems are taking buffer cache for a long time
> >>and it can disturb page migration.
> >>
> >>A new API should be introduced to allocate buffer cache
> >>with user specific flag.
> >>For instance if user set flag to zero, buffer cache is allocated from
> >>non-movable area.
> >>
> >>Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> >>---
> >>  fs/buffer.c                 |   52 +++++++++++++++++++++++++++++--------------
> >>  include/linux/buffer_head.h |   12 +++++++++-
> >>  2 files changed, 46 insertions(+), 18 deletions(-)
> >>
> >>diff --git a/fs/buffer.c b/fs/buffer.c
> >>index 8f05111..14f2f21 100644
> >>--- a/fs/buffer.c
> >>+++ b/fs/buffer.c
> >>@@ -993,7 +993,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
> >>   */
> >>  static int
> >>  grow_dev_page(struct block_device *bdev, sector_t block,
> >>-               pgoff_t index, int size, int sizebits)
> >>+             pgoff_t index, int size, int sizebits, gfp_t gfp)
> >>  {
> >>         struct inode *inode = bdev->bd_inode;
> >>         struct page *page;
> >>@@ -1002,10 +1002,10 @@ grow_dev_page(struct block_device *bdev, sector_t block,
> >>         int ret = 0;            /* Will call free_more_memory() */
> >>         gfp_t gfp_mask;
> >>
> >>-       gfp_mask = mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
> >>-       gfp_mask |= __GFP_MOVABLE;
> >>+       gfp_mask = (mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS) | gfp;
> >>+
> >   Hum, it seems a bit misleading that the 'gfp' flags are just or-ed to
> >mapping_gfp_mask(inode->i_mapping). Usually, passed gfp mask is just
> >directly used. There are also interfaces like pagecache_get_page() which
> >play more complex tricks with mapping_gfp_mask(). This would be yet another
> >convention which I don't think is desirable. I know Andrew suggested what
> >you wrote so I guess I have to settle this with him. Andrew?
> 
> I don't know mapping_gfp_mask(). I just add gfp at the original code.
> Whould you tell me why it is undesirable?
  Well, it's not that mapping_gfp_mask() would be undesirable. It's that
the interface where you pass in gfp mask but it gets silently combined with
another gfp mask seems a bit error prone to me. So would prefer
grow_dev_page() to just use the gfp mask passed and then do something like:

struct buffer_head *getblk_unmovable(struct block_device *bdev, sector_t block,
            unsigned size)
{
       return __getblk_gfp(bdev, block, size,
			   mapping_gfp_mask(bdev->bd_inode->i_mapping));
}

And similarly in getblk() and other places. But before you go and do this,
I'd like Andrew to say what he thinks about it because maybe he had a good
reason why he wanted it the way you've implemented it.


> >>@@ -1381,12 +1383,7 @@ EXPORT_SYMBOL(__find_get_block);
> >>  struct buffer_head *
> >>  __getblk(struct block_device *bdev, sector_t block, unsigned size)
> >>  {
> >>-       struct buffer_head *bh = __find_get_block(bdev, block, size);
> >>-
> >>-       might_sleep();
> >>-       if (bh == NULL)
> >>-               bh = __getblk_slow(bdev, block, size);
> >>-       return bh;
> >>+       return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
> >>  }
> >>  EXPORT_SYMBOL(__getblk);
> >   Why did you remove the __find_get_block() call? That looks like a bug.
  I'm not sure if you didn't miss this comment....

> I think the common interface is important.
> 
> If sb_getblk_unmovable() is obvious for the filesystem,
> I will add some codes for getblk_unmovable() which calling __getblk_gfp(),
> and sb_bread_unmovable() calling __bread_gfp().
> If so, sb_bread_gfp is not necessary.
> 
> It might be like followings:
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 14f2f21..35caf77 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1088,7 +1088,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int siz
>         return grow_dev_page(bdev, block, index, size, sizebits, gfp);
>  }
> 
> -struct buffer_head *
> +static struct buffer_head *
>  __getblk_gfp(struct block_device *bdev, sector_t block,
>              unsigned size, gfp_t gfp)
>  {
> @@ -1119,7 +1119,13 @@ __getblk_gfp(struct block_device *bdev, sector_t block,
>                         free_more_memory();
>         }
>  }
> -EXPORT_SYMBOL(__getblk_gfp);
> +
> +struct buffer_head *getblk_unmovable(struct block_device *bdev, sector_t block,
> +            unsigned size)
> +{
> +       return __getblk_gfp(bdev, block, size, 0);
> +}
> +EXPORT_SYMBOL(getblk_unmovable);
> 
>  /*
>   * The relationship between dirty buffers and dirty pages:
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index a1d73fd..c5fb4fc 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -177,8 +177,8 @@ struct buffer_head *__find_get_block(struct block_device *bdev, s
>                         unsigned size);
>  struct buffer_head *__getblk(struct block_device *bdev, sector_t block,
>                         unsigned size);
> -struct buffer_head *__getblk_gfp(struct block_device *bdev, sector_t block,
> -                                unsigned size, gfp_t gfp);
> +struct buffer_head *getblk_unmovable(struct block_device *bdev, sector_t block,
> +                                    unsigned size);
>  void __brelse(struct buffer_head *);
>  void __bforget(struct buffer_head *);
>  void __breadahead(struct block_device *, sector_t block, unsigned int size);
> @@ -303,9 +303,9 @@ sb_bread(struct super_block *sb, sector_t block)
>  }
> 
>  static inline struct buffer_head *
> -sb_bread_gfp(struct super_block *sb, sector_t block, gfp_t gfp)
> +sb_bread_unmovable(struct super_block *sb, sector_t block)
>  {
> -       return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, gfp);
> +       return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, 0);
>  }
> 
> Is it better?
  Yes, this is what I meant.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
