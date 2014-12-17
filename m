Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaLQPJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:09:00 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:56612 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaLQPI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:08:58 -0500
MIME-Version: 1.0
In-Reply-To: <000001d0184a$3f09d580$bd1d8080$@samsung.com>
References: <000001d0184a$3f09d580$bd1d8080$@samsung.com>
Date: Thu, 18 Dec 2014 00:08:55 +0900
Message-ID: <CAN863PvqCJJ-m3NimjX7FKeY941rjSgmzupfPEMHm_qXgRBwfQ@mail.gmail.com>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: merge two uchar variable in struct
 node_info to reduce memory cost
From: Changman Lee <cm224.lee@gmail.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu,

This patch is effective only in 32 bit machine. In case of 64 bit
machine, nat_entry will be aligned in 8 bytes due to pointer variable
(i.e. struct list_head). So it can't get any benefit to reduce memory
usage. In the case of node_info, however, it will be gain in terms of
memory usage.
Hence, I think it's not correct for commit log to describe this patch.

Thanks,

Reviewed-by: Changman Lee <cm224.lee@samsung.com>

2014-12-15 18:33 GMT+09:00 Chao Yu <chao2.yu@samsung.com>:
> This patch moves one member of struct nat_entry: _flag_ to struct node_info,
> so _version_ in struct node_info and _flag_ with unsigned char type will merge
> to one 32-bit space in register/memory. Then the size of nat_entry will reduce
> its size from 28 bytes to 24 bytes and slab memory using by f2fs will be
> reduced.
>
> changes from v1:
>  o introduce inline copy_node_info() to copy valid data from node info suggested
>    by Jaegeuk Kim, it can avoid bug.
>
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/node.c |  4 ++--
>  fs/f2fs/node.h | 33 ++++++++++++++++++++++-----------
>  2 files changed, 24 insertions(+), 13 deletions(-)
>
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index f83326c..5aa54a0 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -268,7 +268,7 @@ static void set_node_addr(struct f2fs_sb_info *sbi, struct node_info *ni,
>         e = __lookup_nat_cache(nm_i, ni->nid);
>         if (!e) {
>                 e = grab_nat_entry(nm_i, ni->nid);
> -               e->ni = *ni;
> +               copy_node_info(&e->ni, ni);
>                 f2fs_bug_on(sbi, ni->blk_addr == NEW_ADDR);
>         } else if (new_blkaddr == NEW_ADDR) {
>                 /*
> @@ -276,7 +276,7 @@ static void set_node_addr(struct f2fs_sb_info *sbi, struct node_info *ni,
>                  * previous nat entry can be remained in nat cache.
>                  * So, reinitialize it with new information.
>                  */
> -               e->ni = *ni;
> +               copy_node_info(&e->ni, ni);
>                 f2fs_bug_on(sbi, ni->blk_addr != NULL_ADDR);
>         }
>
> diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
> index d10b644..eb59167 100644
> --- a/fs/f2fs/node.h
> +++ b/fs/f2fs/node.h
> @@ -29,6 +29,14 @@
>  /* return value for read_node_page */
>  #define LOCKED_PAGE    1
>
> +/* For flag in struct node_info */
> +enum {
> +       IS_CHECKPOINTED,        /* is it checkpointed before? */
> +       HAS_FSYNCED_INODE,      /* is the inode fsynced before? */
> +       HAS_LAST_FSYNC,         /* has the latest node fsync mark? */
> +       IS_DIRTY,               /* this nat entry is dirty? */
> +};
> +
>  /*
>   * For node information
>   */
> @@ -37,18 +45,11 @@ struct node_info {
>         nid_t ino;              /* inode number of the node's owner */
>         block_t blk_addr;       /* block address of the node */
>         unsigned char version;  /* version of the node */
> -};
> -
> -enum {
> -       IS_CHECKPOINTED,        /* is it checkpointed before? */
> -       HAS_FSYNCED_INODE,      /* is the inode fsynced before? */
> -       HAS_LAST_FSYNC,         /* has the latest node fsync mark? */
> -       IS_DIRTY,               /* this nat entry is dirty? */
> +       unsigned char flag;     /* for node information bits */
>  };
>
>  struct nat_entry {
>         struct list_head list;  /* for clean or dirty nat list */
> -       unsigned char flag;     /* for node information bits */
>         struct node_info ni;    /* in-memory node information */
>  };
>
> @@ -63,20 +64,30 @@ struct nat_entry {
>
>  #define inc_node_version(version)      (++version)
>
> +static inline void copy_node_info(struct node_info *dst,
> +                                               struct node_info *src)
> +{
> +       dst->nid = src->nid;
> +       dst->ino = src->ino;
> +       dst->blk_addr = src->blk_addr;
> +       dst->version = src->version;
> +       /* should not copy flag here */
> +}
> +
>  static inline void set_nat_flag(struct nat_entry *ne,
>                                 unsigned int type, bool set)
>  {
>         unsigned char mask = 0x01 << type;
>         if (set)
> -               ne->flag |= mask;
> +               ne->ni.flag |= mask;
>         else
> -               ne->flag &= ~mask;
> +               ne->ni.flag &= ~mask;
>  }
>
>  static inline bool get_nat_flag(struct nat_entry *ne, unsigned int type)
>  {
>         unsigned char mask = 0x01 << type;
> -       return ne->flag & mask;
> +       return ne->ni.flag & mask;
>  }
>
>  static inline void nat_reset_flag(struct nat_entry *ne)
> --
> 2.1.2
>
>
>
> ------------------------------------------------------------------------------
> Download BIRT iHub F-Type - The Free Enterprise-Grade BIRT Server
> from Actuate! Instantly Supercharge Your Business Reports and Dashboards
> with Interactivity, Sharing, Native Excel Exports, App Integration & more
> Get technology previously reserved for billion-dollar corporations, FREE
> http://pubads.g.doubleclick.net/gampad/clk?id=164703151&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
