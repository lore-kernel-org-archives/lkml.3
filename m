Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3BDPTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:19:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab3BDPTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:19:14 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, mgorman@suse.de, bcrl@kvack.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com,
        rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, jiang.liu@huawei.com,
        linux-mm@kvack.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fs/aio.c: use get_user_pages_non_movable() to pin ring pages when support memory hotremove
References: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com>
	<1359972248-8722-3-git-send-email-linfeng@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 04 Feb 2013 10:18:03 -0500
In-Reply-To: <1359972248-8722-3-git-send-email-linfeng@cn.fujitsu.com> (Lin
	Feng's message of "Mon, 4 Feb 2013 18:04:08 +0800")
Message-ID: <x49ehgw85w4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin Feng <linfeng@cn.fujitsu.com> writes:

> This patch gets around the aio ring pages can't be migrated bug caused by
> get_user_pages() via using the new function. It only works as configed with
> CONFIG_MEMORY_HOTREMOVE, otherwise it uses the old version of get_user_pages().
>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
> Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
> ---
>  fs/aio.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 71f613c..0e9b30a 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -138,9 +138,15 @@ static int aio_setup_ring(struct kioctx *ctx)
>  	}
>  
>  	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +	info->nr_pages = get_user_pages_non_movable(current, ctx->mm,
> +					info->mmap_base, nr_pages,
> +					1, 0, info->ring_pages, NULL);
> +#else
>  	info->nr_pages = get_user_pages(current, ctx->mm,
>  					info->mmap_base, nr_pages, 
>  					1, 0, info->ring_pages, NULL);
> +#endif

Can't you hide this in your 1/1 patch, by providing this function as
just a static inline wrapper around get_user_pages when
CONFIG_MEMORY_HOTREMOVE is not enabled?

Cheers,
Jeff
