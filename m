Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab3CPNDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 09:03:11 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:43844 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3CPNDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 09:03:10 -0400
Date: Sat, 16 Mar 2013 09:03:04 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] introduce zero filled pages handler
Message-ID: <20130316130302.GA5987@konrad-lan.dumpdata.com>
References: <1363255697-19674-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1363255697-19674-2-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363255697-19674-2-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 06:08:14PM +0800, Wanpeng Li wrote:
> Introduce zero-filled pages handler to capture and handle zero pages.
> 
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/zcache-main.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 328898e..b71e033 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -460,6 +460,32 @@ static void zcache_obj_free(struct tmem_obj *obj, struct tmem_pool *pool)
>  	kmem_cache_free(zcache_obj_cache, obj);
>  }
>  
> +static bool page_zero_filled(void *ptr)

Shouldn't this be 'struct page *p' ?
> +{
> +	unsigned int pos;
> +	unsigned long *page;
> +
> +	page = (unsigned long *)ptr;

That way you can avoid this casting.
> +
> +	for (pos = 0; pos < PAGE_SIZE / sizeof(*page); pos++) {
> +		if (page[pos])
> +			return false;

Perhaps allocate a static page filled with zeros and just do memcmp?
> +	}
> +
> +	return true;
> +}
> +
> +static void handle_zero_page(void *page)
> +{
> +	void *user_mem;
> +
> +	user_mem = kmap_atomic(page);
> +	memset(user_mem, 0, PAGE_SIZE);
> +	kunmap_atomic(user_mem);
> +
> +	flush_dcache_page(page);

This is new. Could you kindly explain why it is needed? Thanks.
> +}
> +
>  static struct tmem_hostops zcache_hostops = {
>  	.obj_alloc = zcache_obj_alloc,
>  	.obj_free = zcache_obj_free,
> -- 
> 1.7.7.6
> 
