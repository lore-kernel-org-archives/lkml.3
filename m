Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab3LZKiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 05:38:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23946 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab3LZKiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 05:38:09 -0500
X-IronPort-AV: E=Sophos;i="4.95,553,1384272000"; 
   d="scan'208";a="9330932"
Message-ID: <52BC075F.6060101@cn.fujitsu.com>
Date: Thu, 26 Dec 2013 18:39:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>, Benjamin <bcrl@kvack.org>
CC: linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aio: optimize free kioctx slot search
References: <52BC0352.2040504@cn.fujitsu.com>
In-Reply-To: <52BC0352.2040504@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/26 18:37:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/26 18:37:25,
	Serialize complete at 2013/12/26 18:37:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On thu, 26 Dec 2013 18:22:10 +0800, Gu Zheng wrote:
> Add a 'next_free' field into kioctx_table to store the next id that
> may be free, in order to reduce the search region when we insert
> kioctx into kioctx table.
> When we take a free slot from kioctx_table, update 'next_free' to
> the next slot. Also when  we free one slot to kioctx_table, update 'next_free'
> to the new free slot if it's smaller than 'next_free'. So that we can
> ensure that the slots before 'next_free' are all used, and the search can start
> from 'next_free' to reduce the search and improve the performance.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

Thanks
Miao

> ---
>  fs/aio.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 062a5f6..489fda6 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -69,6 +69,7 @@ struct aio_ring {
>  struct kioctx_table {
>  	struct rcu_head	rcu;
>  	unsigned	nr;
> +	unsigned	next_free;
>  	struct kioctx	*table[];
>  };
>  
> @@ -548,11 +549,12 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
>  	table = rcu_dereference(mm->ioctx_table);
>  
>  	while (1) {
> -		if (table)
> -			for (i = 0; i < table->nr; i++)
> +		if (table && table->next_free < table->nr)
> +			for (i = table->next_free; i < table->nr; i++)
>  				if (!table->table[i]) {
>  					ctx->id = i;
>  					table->table[i] = ctx;
> +					table->next_free = i + 1;
>  					rcu_read_unlock();
>  					spin_unlock(&mm->ioctx_lock);
>  
> @@ -579,8 +581,10 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
>  		old = rcu_dereference(mm->ioctx_table);
>  
>  		if (!old) {
> +			table->next_free = 0;
>  			rcu_assign_pointer(mm->ioctx_table, table);
>  		} else if (table->nr > old->nr) {
> +			table->next_free = old->nr;
>  			memcpy(table->table, old->table,
>  			       old->nr * sizeof(struct kioctx *));
>  
> @@ -716,6 +720,8 @@ static void kill_ioctx(struct mm_struct *mm, struct kioctx *ctx)
>  
>  		WARN_ON(ctx != table->table[ctx->id]);
>  		table->table[ctx->id] = NULL;
> +		if (ctx->id < table->next_free)
> +			table->next_free = ctx->id;
>  		rcu_read_unlock();
>  		spin_unlock(&mm->ioctx_lock);
>  
> 

