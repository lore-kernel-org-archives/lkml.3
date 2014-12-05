Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628AbaLEDui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:50:38 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:44721 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933269AbaLEDug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:50:36 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44540184"
Message-ID: <548127D9.4030007@cn.fujitsu.com>
Date: Fri, 5 Dec 2014 11:34:49 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/3] f2fs: fix missing kmem_cache_free
References: <1417740583-1681-1-git-send-email-jaegeuk@kernel.org>
In-Reply-To: <1417740583-1681-1-git-send-email-jaegeuk@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk, 
On 12/05/2014 08:49 AM, Jaegeuk Kim wrote:

> This patch fixes missing kmem_cache_free when handling errors.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/node.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index b1466cf..c59341d 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -158,7 +158,7 @@ retry:
>  		head->entry_cnt = 0;
>  
>  		if (radix_tree_insert(&nm_i->nat_set_root, set, head)) {
> -			cond_resched();
> +			kmem_cache_free(nat_entry_set_slab, head);

Why not reuse the allocated entry?
This routine is under nat_tree_lock, so the free_old->research->alloc_new
is needless, because no other ones can race with us.

>  			goto retry;

And radix_tree_insert can only fail -ENOMEM here, IMO, the in-time retry step
makes very little sense here. How about retaining the "cond_resched()" and retry
insert later?

If I misread something, please correct me.:)

Thanks,
Gu

>  		}
>  	}


