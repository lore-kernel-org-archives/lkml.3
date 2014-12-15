Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaLOH73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:59:29 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52141 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaLOH72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:59:28 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 15 Dec 2014 17:03:38 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
Message-ID: <20141215080338.GE4898@js1304-P5Q-DELUXE>
References: <20141210163017.092096069@linux.com>
 <20141210163033.717707217@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210163033.717707217@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:30:20AM -0600, Christoph Lameter wrote:
> Avoid using the page struct address on free by just doing an
> address comparison. That is easily doable now that the page address
> is available in the page struct and we already have the page struct
> address of the object to be freed calculated.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/mm/slub.c
> ===================================================================
> --- linux.orig/mm/slub.c	2014-12-09 12:25:45.770405462 -0600
> +++ linux/mm/slub.c	2014-12-09 12:25:45.766405582 -0600
> @@ -2625,6 +2625,13 @@ slab_empty:
>  	discard_slab(s, page);
>  }
>  
> +static bool same_slab_page(struct kmem_cache *s, struct page *page, void *p)
> +{
> +	long d = p - page->address;
> +
> +	return d > 0 && d < (1 << MAX_ORDER) && d < (compound_order(page) << PAGE_SHIFT);
> +}
> +

Somtimes, compound_order() induces one more cacheline access, because
compound_order() access second struct page in order to get order. Is there
any way to remove this?

Thanks.

