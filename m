Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3EHFbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 01:31:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:47623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab3EHFbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 01:31:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,632,1363158000"; 
   d="scan'208";a="238370382"
Date: Wed, 8 May 2013 13:31:34 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/4] f2fs: optimize scan_nat_page()
Message-ID: <20130508053134.GA8705@hli22-desktop>
References: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
 <1367853344-28938-4-git-send-email-haicheng.li@linux.intel.com>
 <1367922988.16581.45.camel@kjgkr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367922988.16581.45.camel@kjgkr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 07:36:28PM +0900, Jaegeuk Kim wrote:
> Hi,
> 
> 2013-05-06 (월), 23:15 +0800, Haicheng Li:
> >  	if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
> > -		return 0;
> > +		return -1;
> 
> We should check all the handler of add_free_nid().
yes, sorry that I missed double checking it while rebasing this patch
from master to dev branch, since there is only one handler on the master branch.

> So, plz see the below modified patch.
> > +		if (blk_addr == NULL_ADDR) {
> > +			cnt = add_free_nid(nm_i, start_nid);
> > +			if (cnt < 0)
> > +				break;
> > +		}
> 
> Here we need to eliminate cnt.
sure, harmless & can reduce the code line.

and the below patch looks good to me. Thanks.
> -----
> From e2da02f0ba045f792d166ac8215d04474c06f319 Mon Sep 17 00:00:00 2001
> From: Haicheng Li <haicheng.li@linux.intel.com>
> Date: Mon, 6 May 2013 23:15:43 +0800
> Subject: [PATCH] f2fs: optimize scan_nat_page()
> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> linux-f2fs-devel@lists.sourceforge.net
> 
> When nm_i->fcnt > 2 * MAX_FREE_NIDS, stop scanning other NAT entries.
> 
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> [Jaegeuk Kim: fix handling the return value of add_free_nid()]
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/node.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 122200e..e42934e 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1254,7 +1254,7 @@ static int add_free_nid(struct f2fs_nm_info *nm_i,
> nid_t nid)
>  	struct free_nid *i;
>  
>  	if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
> -		return 0;
> +		return -1;
>  
>  	/* 0 nid should not be used */
>  	if (nid == 0)
> @@ -1302,12 +1302,16 @@ static void scan_nat_page(struct f2fs_nm_info
> *nm_i,
>  	i = start_nid % NAT_ENTRY_PER_BLOCK;
>  
>  	for (; i < NAT_ENTRY_PER_BLOCK; i++, start_nid++) {
> +
>  		if (start_nid >= nm_i->max_nid)
>  			break;
> -		blk_addr  = le32_to_cpu(nat_blk->entries[i].block_addr);
> +
> +		blk_addr = le32_to_cpu(nat_blk->entries[i].block_addr);
>  		BUG_ON(blk_addr == NEW_ADDR);
> -		if (blk_addr == NULL_ADDR)
> -			add_free_nid(nm_i, start_nid);
> +		if (blk_addr == NULL_ADDR) {
> +			if (add_free_nid(nm_i, start_nid) < 0)
> +				break;
> +		}
>  	}
>  }
>  
> @@ -1655,7 +1659,7 @@ flush_now:
>  		}
>  
>  		if (nat_get_blkaddr(ne) == NULL_ADDR &&
> -					!add_free_nid(NM_I(sbi), nid)) {
> +				add_free_nid(NM_I(sbi), nid) <= 0) {
>  			write_lock(&nm_i->nat_tree_lock);
>  			__del_from_nat_cache(nm_i, ne);
>  			write_unlock(&nm_i->nat_tree_lock);
> -- 
> 1.8.1.3.566.gaa39828
> 
