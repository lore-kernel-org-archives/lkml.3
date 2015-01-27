Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbbA0Ie5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:34:57 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59987 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbbA0Iez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:34:55 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 27 Jan 2015 17:36:12 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sergei Rogachev <rogachevsergei@gmail.com>
Cc: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mm/page_ext: remove unnecessary stack_trace field
Message-ID: <20150127083612.GG11358@js1304-P5Q-DELUXE>
References: <1422309132-28030-1-git-send-email-rogachevsergei@gmail.com>
 <1422309132-28030-2-git-send-email-rogachevsergei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422309132-28030-2-git-send-email-rogachevsergei@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 12:52:12AM +0300, Sergei Rogachev wrote:
> Page owner uses the page_ext structure to keep meta-information
> for every page in the system. The structure also contains a field
> of type 'struct stack_trace', page owner uses this field during
> invocation of the function save_stack_trace. It is easy to notice
> that keeping a copy of this structure for every page in the system
> is very inefficiently in terms of memory.
> 
> The patch removes this unnecessary field of page_ext and forces
> page owner to use a stack_trace structure allocated on the stack.
> 
> Signed-off-by: Sergei Rogachev <rogachevsergei@gmail.com>
> ---
>  include/linux/page_ext.h |  2 +-
>  mm/page_owner.c          | 21 ++++++++++++---------
>  2 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
> index d2a2c84..c42981c 100644
> --- a/include/linux/page_ext.h
> +++ b/include/linux/page_ext.h
> @@ -40,7 +40,7 @@ struct page_ext {
>  #ifdef CONFIG_PAGE_OWNER
>  	unsigned int order;
>  	gfp_t gfp_mask;
> -	struct stack_trace trace;
> +	unsigned int nr_entries;
>  	unsigned long trace_entries[8];
>  #endif
>  };
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 9ab4a9b..f7f3318 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -60,19 +60,19 @@ void __reset_page_owner(struct page *page, unsigned int order)
>  void __set_page_owner(struct page *page, unsigned int order, gfp_t gfp_mask)
>  {
>  	struct page_ext *page_ext;
> -	struct stack_trace *trace;
> +	struct stack_trace trace;
>  
>  	page_ext = lookup_page_ext(page);
>  
> -	trace = &page_ext->trace;
> -	trace->nr_entries = 0;
> -	trace->max_entries = ARRAY_SIZE(page_ext->trace_entries);
> -	trace->entries = &page_ext->trace_entries[0];
> -	trace->skip = 3;
> -	save_stack_trace(&page_ext->trace);
> +	trace.nr_entries = 0;
> +	trace.max_entries = ARRAY_SIZE(page_ext->trace_entries);
> +	trace.entries = &page_ext->trace_entries[0];
> +	trace.skip = 3;
> +	save_stack_trace(&trace);
>  
>  	page_ext->order = order;
>  	page_ext->gfp_mask = gfp_mask;
> +	page_ext->nr_entries = trace.nr_entries;
>  
>  	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
>  }
> @@ -83,6 +83,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  {
>  	int ret;
>  	int pageblock_mt, page_mt;
> +	struct stack_trace trace;
>  	char *kbuf;
>  
>  	kbuf = kmalloc(count, GFP_KERNEL);
> @@ -121,8 +122,10 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  	if (ret >= count)
>  		goto err;
>  
> -	ret += snprint_stack_trace(kbuf + ret, count - ret,
> -					&page_ext->trace, 0);
> +	trace.nr_entries = page_ext->nr_entries;
> +	trace.entries = &page_ext->trace_entries[0];
> +
> +	ret += snprint_stack_trace(kbuf + ret, count - ret, &trace, 0);
>  	if (ret >= count)
>  		goto err;


Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Thanks.
