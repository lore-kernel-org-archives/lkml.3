Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3KULAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:00:11 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:63148 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3KULAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:00:09 -0500
MIME-Version: 1.0
In-Reply-To: <1385024065-29965-1-git-send-email-zhanghonghui@innofidei.com>
References: <1385024065-29965-1-git-send-email-zhanghonghui@innofidei.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 21 Nov 2013 11:59:44 +0100
Message-ID: <CACQ1gAiLesYEWmHkivAF=t8ekCFM=yDDyzkJTtduavNjp1g6wA@mail.gmail.com>
Subject: Re: [PATCH] Make the mtdblock read/write skip the bad nand sector
To: Hans Zhang <zhanghonghui@innofidei.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        zhouguangming@innofidei.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/21 Hans Zhang <zhanghonghui@innofidei.com>:
>  When read/write the nandblock device, it will abort writing if
>  there's a bad block, it's reasonable to skip the bad block and
>  finish the data writing.
>  The data reading procedure should also skip the bad block since
>  there's no data write to the block.
>
> --v2:
>  use the wrapped mtd_block_isbad instand of mtd->block_isbad
>
> Signed-off-by: Hans Zhang <zhanghonghui@innofidei.com>
> ---
>  drivers/mtd/mtdblock.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
> index 485ea75..4f6acd1 100644
> --- a/drivers/mtd/mtdblock.c
> +++ b/drivers/mtd/mtdblock.c
> @@ -124,6 +124,13 @@ static int write_cached_data (struct mtdblk_dev *mtdblk)
>                         "at 0x%lx, size 0x%x\n", mtd->name,
>                         mtdblk->cache_offset, mtdblk->cache_size);
>
> +retry:
> +       ret = mtd_block_isbad(mtd, mtdblk->cache_offset);
> +       if (ret > 0) {
> +               mtdblk->cache_offset += mtdblk->cache_size;
> +               goto retry;
> +       }
> +
>         ret = erase_write (mtd, mtdblk->cache_offset,
>                            mtdblk->cache_size, mtdblk->cache_data);
>         if (ret)
> @@ -163,6 +170,11 @@ static int do_cached_write (struct mtdblk_dev *mtdblk, unsigned long pos,
>                         size = len;
>
>                 if (size == sect_size) {
> +                       ret = mtd_block_isbad(mtd, pos);
> +                       if (ret > 0) {
> +                               pos += sect_size;
> +                               continue;
> +                       }
>                         /*
>                          * We are covering a whole sector.  Thus there is no
>                          * need to bother with the cache while it may still be
> @@ -242,6 +254,11 @@ static int do_cached_read (struct mtdblk_dev *mtdblk, unsigned long pos,
>                     mtdblk->cache_offset == sect_start) {
>                         memcpy (buf, mtdblk->cache_data + offset, size);
>                 } else {
> +                       ret = mtd_block_isbad(mtd, pos);
> +                       if (ret > 0) {
> +                               pos += sect_size;
> +                               continue;
> +                       }
>                         ret = mtd_read(mtd, pos, size, &retlen, buf);
>                         if (ret)
>                                 return ret;
> --
> 1.7.1
>
>

I don't think it's a good idea to skip bad blocks at mtd level.
That will definitely break the userspace.
The nanddump mtd-tool for instance has a bad block handling argument:
--bb=METHOD, where METHOD can be `padbad', `dumpbad', or `skipbad':
    padbad:  dump flash data, substituting 0xFF for any bad blocks
    dumpbad: dump flash data, including any bad blocks
    skipbad: dump good data, completely skipping any bad blocks (default)

The bad block handling is done by the upper layer (UBI/jffs2...) not by mtd.

So, if you really need to read/write the mtd layer from userspace and
jump bad block, you'll have to use the MEMGETBADBLOCK ioctl to check
if the block is bad before reading/writing.

But using UBI is usually a better option.


Richard.
