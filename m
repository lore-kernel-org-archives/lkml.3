Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab3JKUe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:34:28 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47453 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab3JKUeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:34:25 -0400
Date: Fri, 11 Oct 2013 13:34:31 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [patch 2/4] percpu_ida: add percpu_ida_for_each_free
Message-ID: <20131011203431.GI28572@kmo>
References: <20131011071802.148101321@kernel.org>
 <20131011072323.730752659@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011072323.730752659@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 03:18:04PM +0800, Shaohua Li wrote:
> Add a new API to iterate free ids. blk-mq-tag will use it.
> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  include/linux/percpu_ida.h |    3 +++
>  lib/percpu_ida.c           |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> Index: master/include/linux/percpu_ida.h
> ===================================================================
> --- master.orig/include/linux/percpu_ida.h	2013-10-11 12:14:56.932543376 +0800
> +++ master/include/linux/percpu_ida.h	2013-10-11 12:14:56.928543501 +0800
> @@ -73,4 +73,7 @@ static inline int percpu_ida_init(struct
>  		IDA_DEFAULT_PCPU_BATCH_MOVE);
>  }
>  
> +int percpu_ida_for_each_free(struct percpu_ida *pool,
> +	int (*fn)(int id, void *data), void *data);
> +
>  #endif /* __PERCPU_IDA_H__ */
> Index: master/lib/percpu_ida.c
> ===================================================================
> --- master.orig/lib/percpu_ida.c	2013-10-11 12:14:56.932543376 +0800
> +++ master/lib/percpu_ida.c	2013-10-11 12:14:56.928543501 +0800
> @@ -327,3 +327,47 @@ err:
>  	return -ENOMEM;
>  }
>  EXPORT_SYMBOL_GPL(__percpu_ida_init);
> +
> +/**
> + * percpu_ida_for_each_free - iterate free ids of a pool
> + * @pool: pool to iterate
> + * @fn: interate callback function
> + * @data: parameter for @fn
> + *
> + * Note, this doesn't guarantee iterate all free ids restrictly. Some free
> + * ids might be missed, some might be iterated duplicated, and some might
> + * not be free and iterated.
> + */
> +int percpu_ida_for_each_free(struct percpu_ida *pool,
> +	int (*fn)(int id, void *data), void *data)

I'd prefer to make the id parameter unsigned - and use a typedef for the
function pointer argument - but other than that, looks reasonable to me.
