Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbbAPBRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:17:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbbAPBQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:16:58 -0500
Date: Thu, 15 Jan 2015 17:16:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 2/2] mm: don't use compound_head() in
 virt_to_head_page()
Message-Id: <20150115171646.8fec31e2.akpm@linux-foundation.org>
In-Reply-To: <1421307633-24045-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1421307633-24045-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 16:40:33 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> compound_head() is implemented with assumption that there would be
> race condition when checking tail flag. This assumption is only true
> when we try to access arbitrary positioned struct page.
> 
> The situation that virt_to_head_page() is called is different case.
> We call virt_to_head_page() only in the range of allocated pages,
> so there is no race condition on tail flag. In this case, we don't
> need to handle race condition and we can reduce overhead slightly.
> This patch implements compound_head_fast() which is similar with
> compound_head() except tail flag race handling. And then,
> virt_to_head_page() uses this optimized function to improve performance.
> 
> I saw 1.8% win in a fast-path loop over kmem_cache_alloc/free,
> (14.063 ns -> 13.810 ns) if target object is on tail page.
>
> ...
>
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -453,6 +453,13 @@ static inline struct page *compound_head(struct page *page)
>  	return page;
>  }
>  
> +static inline struct page *compound_head_fast(struct page *page)
> +{
> +	if (unlikely(PageTail(page)))
> +		return page->first_page;
> +	return page;
> +}

Can we please have some code comments which let people know when they
should and shouldn't use compound_head_fast()?  I shouldn't have to say
this :(

>  /*
>   * The atomic page->_mapcount, starts from -1: so that transitions
>   * both from it and to it can be tracked, using atomic_inc_and_test
> @@ -531,7 +538,8 @@ static inline void get_page(struct page *page)
>  static inline struct page *virt_to_head_page(const void *x)
>  {
>  	struct page *page = virt_to_page(x);
> -	return compound_head(page);
> +
> +	return compound_head_fast(page);

And perhaps some explanation here as to why virt_to_head_page() can
safely use compound_head_fast().  There's an assumption here that
nobody will be dismantling the compound page while virt_to_head_page()
is in progress, yes?  And this assumption also holds for the calling
code, because otherwise the virt_to_head_page() return value is kinda
meaningless.

This is tricky stuff - let's spell it out carefully.
