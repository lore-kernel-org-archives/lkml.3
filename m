Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbbAUIj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:39:27 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47945 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbbAUIjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:39:20 -0500
MIME-Version: 1.0
In-Reply-To: <20150121182908.4d8263e2@canb.auug.org.au>
References: <20150121182908.4d8263e2@canb.auug.org.au>
Date: Wed, 21 Jan 2015 11:39:18 +0300
Message-ID: <CALYGNiPBUFBpUXVjgBWYrOX=hi2hhY03owuZ5K27Ljt7BrDEBg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konstantin Khebnikov <khlebnikov@yandex-team.ru>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:29 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> After merging the akpm-current tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> mm/page-writeback.c: In function 'account_page_cleared':
> mm/page-writeback.c:2122:23: error: 'struct address_space' has no member named 'backing_dev_info'
>    dec_bdi_stat(mapping->backing_dev_info,
>                        ^
>
> Caused by commit d475bc581640 ("page_writeback: cleanup mess around
> cancel_dirty_page()") (hmm, that commit has no Signed-off-by from
> Andrew?) interacting with commit b83ae6d42143 ("fs: remove
> mapping->backing_dev_info") from the block tree.

Andrew, please drop it. I'll rebase and send it again when the dust settles.

>
> I have applied the following fix patch:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 21 Jan 2015 18:23:41 +1100
> Subject: [PATCH] fs: remove mapping->backing_dev_info fix
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  mm/page-writeback.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index a8397a6923be..ab922616e522 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2119,7 +2119,7 @@ void account_page_cleared(struct page *page, struct address_space *mapping)
>  {
>         if (mapping_cap_account_dirty(mapping)) {
>                 dec_zone_page_state(page, NR_FILE_DIRTY);
> -               dec_bdi_stat(mapping->backing_dev_info,
> +               dec_bdi_stat(inode_to_bdi(mapping->host),
>                                 BDI_RECLAIMABLE);
>                 task_io_account_cancelled_write(PAGE_CACHE_SIZE);
>         }
> --
> 2.1.4
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
