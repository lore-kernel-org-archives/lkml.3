Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaFQH3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:29:44 -0400
Received: from mx2.parallels.com ([199.115.105.18]:34974 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaFQH3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:29:43 -0400
Date: Tue, 17 Jun 2014 11:29:33 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] slab: fix oops when reading /proc/slab_allocators
Message-ID: <20140617072933.GA26418@esperanza>
References: <1402967392-7003-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1402967392-7003-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 17, 2014 at 10:09:52AM +0900, Joonsoo Kim wrote:
[...]
> To fix the problem, I introduces object status buffer on each slab.
> With this, we can track object status precisely, so slab leak detector
> would not access active object and no kernel oops would occur.
> Memory overhead caused by this fix is only imposed to
> CONFIG_DEBUG_SLAB_LEAK which is mainly used for debugging, so memory
> overhead isn't big problem.
[...]
>  
> +static size_t calculate_freelist_size(int nr_objs, size_t align)
> +{
> +	size_t freelist_size;
> +
> +	freelist_size = nr_objs * sizeof(freelist_idx_t);
> +	if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
> +		freelist_size += nr_objs * sizeof(char);
> +
> +	if (align)
> +		freelist_size = ALIGN(freelist_size, align);
> +
> +	return freelist_size;
> +}
> +
>  static int calculate_nr_objs(size_t slab_size, size_t buffer_size,
>  				size_t idx_size, size_t align)
>  {
>  	int nr_objs;
> +	size_t remained_size;
>  	size_t freelist_size;
> +	int extra_space = 0;
>  
> +	if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
> +		extra_space = sizeof(char);
>  	/*
>  	 * Ignore padding for the initial guess. The padding
>  	 * is at most @align-1 bytes, and @buffer_size is at
> @@ -590,14 +641,15 @@ static int calculate_nr_objs(size_t slab_size, size_t buffer_size,
>  	 * into the memory allocation when taking the padding
>  	 * into account.
>  	 */
> -	nr_objs = slab_size / (buffer_size + idx_size);
> +	nr_objs = slab_size / (buffer_size + idx_size + extra_space);

There is one more function that wants to know how much space per object
is spent for management. It's calculate_slab_order():

	if (flags & CFLGS_OFF_SLAB) {
		/*
		 * Max number of objs-per-slab for caches which
		 * use off-slab slabs. Needed to avoid a possible
		 * looping condition in cache_grow().
		 */
		offslab_limit = size;
		offslab_limit /= sizeof(freelist_idx_t);

		if (num > offslab_limit)
			break;
	}

May be, we should update it too?

Thanks.
