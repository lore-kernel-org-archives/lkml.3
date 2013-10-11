Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab3JKUft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:35:49 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42631 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759461Ab3JKUf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:35:29 -0400
Date: Fri, 11 Oct 2013 13:35:36 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [patch 3/4] percpu_ida: add an API to return free tags
Message-ID: <20131011203536.GJ28572@kmo>
References: <20131011071802.148101321@kernel.org>
 <20131011072341.346343362@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011072341.346343362@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 03:18:05PM +0800, Shaohua Li wrote:
> add an API to return free tags, blk-mq-tag will use it

Can you explain how this is going to be used? Seems like something that
could be prone to misuse, try and convince me there isn't a better way
to do what it's for.

> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  include/linux/percpu_ida.h |    1 +
>  lib/percpu_ida.c           |   17 +++++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> Index: master/include/linux/percpu_ida.h
> ===================================================================
> --- master.orig/include/linux/percpu_ida.h	2013-10-11 12:15:06.996416710 +0800
> +++ master/include/linux/percpu_ida.h	2013-10-11 12:15:06.992416749 +0800
> @@ -76,4 +76,5 @@ static inline int percpu_ida_init(struct
>  int percpu_ida_for_each_free(struct percpu_ida *pool,
>  	int (*fn)(int id, void *data), void *data);
>  
> +unsigned percpu_ida_free_tags(struct percpu_ida *pool, int cpu);
>  #endif /* __PERCPU_IDA_H__ */
> Index: master/lib/percpu_ida.c
> ===================================================================
> --- master.orig/lib/percpu_ida.c	2013-10-11 12:15:06.996416710 +0800
> +++ master/lib/percpu_ida.c	2013-10-11 12:15:06.992416749 +0800
> @@ -371,3 +371,20 @@ out:
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(percpu_ida_for_each_free);
> +
> +/**
> + * percpu_ida_free_tags - return free tags number of a specific cpu or global pool
> + * @pool: pool related
> + * @cpu: specific cpu or global pool if @cpu == nr_cpu_ids
> + *
> + * Note: this just returns a snapshot of free tags number.
> + */
> +unsigned percpu_ida_free_tags(struct percpu_ida *pool, int cpu)
> +{
> +	struct percpu_ida_cpu *remote;
> +	if (cpu == nr_cpu_ids)
> +		return pool->nr_free;
> +	remote = per_cpu_ptr(pool->tag_cpu, cpu);
> +	return remote->nr_free;
> +}
> +EXPORT_SYMBOL_GPL(percpu_ida_free_tags);
> 
