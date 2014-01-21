Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaAURNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:13:13 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50426 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbaAURNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:13:07 -0500
Message-ID: <52DEAA9F.7010304@bjorling.me>
Date: Tue, 21 Jan 2014 09:13:03 -0800
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, Jeff <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sumanth <sumantk2@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V3 1/2]  null_blk: Null pointer deference problem
 in alloc_page_buffers
References: <1390303800-22422-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <1390303800-22422-2-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
In-Reply-To: <1390303800-22422-2-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 03:29 AM, Raghavendra K T wrote:
>  If we load the null_blk module with bs=8k we get following oops:
> [ 3819.812190] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [ 3819.812387] IP: [<ffffffff81170aa5>] create_empty_buffers+0x28/0xaf
> [ 3819.812527] PGD 219244067 PUD 215a06067 PMD 0
> [ 3819.812640] Oops: 0000 [#1] SMP
> [ 3819.812772] Modules linked in: null_blk(+)
> 
>  Fix that by resetting block size to PAGE_SIZE if it is greater than PAGE_SIZE
> 
> Reported-by: Sumanth <sumantk2@linux.vnet.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  drivers/block/null_blk.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
> index a2e69d2..a01d7f6 100644
> --- a/drivers/block/null_blk.c
> +++ b/drivers/block/null_blk.c
> @@ -622,6 +622,11 @@ static int __init null_init(void)
>  		irqmode = NULL_IRQ_NONE;
>  	}
>  #endif
> +	if (bs > PAGE_SIZE) {
> +		pr_warn("null_blk: invalid block size\n");
> +		pr_warn("null_blk: defaults block size to %lu\n", PAGE_SIZE);
> +		bs = PAGE_SIZE;
> +	}
>  
>  	if (queue_mode == NULL_Q_MQ && use_per_node_hctx) {
>  		if (submit_queues < nr_online_nodes) {
> 

Reviewed-by: Matias Bjorling <m@bjorling.me>
