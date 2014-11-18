Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaKRQEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:04:41 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46134 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbaKRQEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:04:39 -0500
Date: Tue, 18 Nov 2014 18:56:29 +0300
From: Azat Khuzhin <a3at.mail@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 1/2] lib: implement ptrset
Message-ID: <20141118155629.GV10766@azat>
References: <20141113220927.GF2598@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113220927.GF2598@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 05:09:27PM -0500, Tejun Heo wrote:
> +int ptrset_add(void *ptr, struct ptrset *set, gfp_t gfp)
> +{
> +	struct ptrset_elem *elem;
> +	struct rb_node *parent, **slot;
> +
> +	elem = kmalloc(sizeof(*elem), gfp);
> +	if (!elem && !in_interrupt())	/* see ptrset_preload() */
> +		elem = this_cpu_xchg(ptrset_preload_elem, NULL);
> +	if (!elem)
> +		return -ENOMEM;
> +	elem->ptr = ptr;
> +
> +	if (ptrset_find_slot(elem->ptr, set, &slot, &parent)) {
> +		kfree(elem);
> +		return -EEXIST;
> +	}

Maybe allocation *after* ptrset_find_slot() will be better?
This will avoid extra kmalloc/kfree if such ptr already exist (and also
will avoid ENOMEM for such cases).
