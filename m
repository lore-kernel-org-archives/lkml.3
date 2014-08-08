Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbaHHWkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:40:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaHHWkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:40:10 -0400
Date: Fri, 8 Aug 2014 15:40:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Riley <davidriley@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Ritesh Harjain <ritesh.harjani@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv6 2/5] lib/genalloc.c: Add genpool range check function
Message-Id: <20140808154008.4e5183b67d29159a83ffcf25@linux-foundation.org>
In-Reply-To: <1407529397-6642-2-git-send-email-lauraa@codeaurora.org>
References: <1407529397-6642-1-git-send-email-lauraa@codeaurora.org>
	<1407529397-6642-2-git-send-email-lauraa@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Aug 2014 13:23:14 -0700 Laura Abbott <lauraa@codeaurora.org> wrote:

> 
> After allocating an address from a particular genpool,
> there is no good way to verify if that address actually
> belongs to a genpool. Introduce addr_in_gen_pool which
> will return if an address plus size falls completely
> within the genpool range.
> 
> ...
>
>  /**
> + * addr_in_gen_pool - checks if an address falls within the range of a pool
> + * @pool:	the generic memory pool
> + * @start:	start address
> + * @size:	size of the region
> + *
> + * Check if the range of addresses falls within the specified pool.

This description should make it clear that the entire range must be
within the pool - that an overlap is "no".

>     Takes
> + * the rcu_read_lock for the duration of the check.

I don't think this part is worth including.

> + */
> +bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
> +			size_t size)
> +{
> +	bool found = false;
> +	unsigned long end = start + size;
> +	struct gen_pool_chunk *chunk;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(chunk, &(pool)->chunks, next_chunk) {
> +		if (start >= chunk->start_addr && start <= chunk->end_addr) {
> +			if (end <= chunk->end_addr) {
> +				found = true;
> +				break;
> +			}
> +		}
> +	}
> +	rcu_read_unlock();
> +	return found;
> +}

