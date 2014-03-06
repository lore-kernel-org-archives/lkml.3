Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaCFTUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:20:32 -0500
Received: from mail-yk0-f170.google.com ([209.85.160.170]:34982 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaCFTUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:20:30 -0500
Date: Thu, 6 Mar 2014 14:20:26 -0500
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 1/5][RFC][CFT] percpu fixes, part 1
Message-ID: <20140306192026.GA14033@htj.dyndns.org>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
 <20140305034919.GA26528@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305034919.GA26528@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Al.

On Wed, Mar 05, 2014 at 03:49:19AM +0000, Al Viro wrote:
> convert ->map[] to array of offsets, cache the "no free areas among the
> first N" in chunk.  Free/in-use is represented by the LSB, a sentry
> element (<free = false, offset = total size of chunk>) is added in
> the end.

Can you please add why this change is necessary to the description?
Also, I think it'd be better to split addition of first_free hint to a
separate patch.

>  static void pcpu_split_block(struct pcpu_chunk *chunk, int i,
> -			     int head, int tail)
> +			     int head, int size, int tail)
>  {
>  	int nr_extra = !!head + !!tail;
> +	int off;
>  
> -	BUG_ON(chunk->map_alloc < chunk->map_used + nr_extra);
> +	BUG_ON(chunk->map_alloc <= chunk->map_used + nr_extra);
>  
>  	/* insert new subblocks */
> -	memmove(&chunk->map[i + nr_extra], &chunk->map[i],
> +	memmove(&chunk->map[i + nr_extra] + 1, &chunk->map[i] + 1,
>  		sizeof(chunk->map[0]) * (chunk->map_used - i));
>  	chunk->map_used += nr_extra;
>  
> -	if (head) {
> -		chunk->map[i + 1] = chunk->map[i] - head;
> -		chunk->map[i++] = head;
> -	}
> -	if (tail) {
> -		chunk->map[i++] -= tail;
> -		chunk->map[i] = tail;
> -	}
> +	off = chunk->map[i];
> +
> +	if (head)
> +		chunk->map[++i] = off += head;
> +	if (tail)
> +		chunk->map[++i] = off += size;
>  }

Do we need to pass @size in the above function?  Isn't that something
which can be easily determined?  If @size is gonna stay, we'll need to
update the function comment too.

>  /**
> @@ -483,19 +483,27 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
>  	int oslot = pcpu_chunk_slot(chunk);
>  	int max_contig = 0;
>  	int i, off;
> +	int seen_free = 0;

bool

> @@ -570,34 +584,50 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
>  static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
>  {
>  	int oslot = pcpu_chunk_slot(chunk);
> -	int i, off;
> -
> -	for (i = 0, off = 0; i < chunk->map_used; off += abs(chunk->map[i++]))
> -		if (off == freeme)
> -			break;
> +	int off = 0;
> +	unsigned i, j;
> +	int to_free = 0;
> +	int *p;
> +
> +	freeme |= 1;
> +
> +	i = 0;
> +	j = chunk->map_used;
> +	while (i != j) {
> +		unsigned k = (i + j) / 2;
> +		off = chunk->map[k];
> +		if (off < freeme)
> +			i = k + 1;
> +		else if (off > freeme)
> +			j = k;
> +		else
> +			i = j = k;
> +	}
>  	BUG_ON(off != freeme);
> -	BUG_ON(chunk->map[i] > 0);

A comment explaining why ignoring the free bit during bin search is
okay would be nice?

> @@ -617,7 +647,9 @@ static struct pcpu_chunk *pcpu_alloc_chunk(void)
>  	}
>  
>  	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
> -	chunk->map[chunk->map_used++] = pcpu_unit_size;
> +	chunk->map[0] = 0;
> +	chunk->map[1] = pcpu_unit_size | 1;
> +	chunk->map_used = 1;
>  
>  	INIT_LIST_HEAD(&chunk->list);
>  	chunk->free_size = pcpu_unit_size;
> @@ -713,6 +745,9 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
>  	unsigned long flags;
>  	void __percpu *ptr;
>  
> +	if (unlikely(align < 2))
> +		align = 2;

Please add a comment explaining why the above min alignment is
necessary.

Other than the above, looks good to me.

Thanks.

-- 
tejun
