Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaLRWGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:06:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaLRWGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:06:31 -0500
Date: Thu, 18 Dec 2014 14:06:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, akpm@linuxfoundation.org,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH] Slab infrastructure for array operations
Message-Id: <20141218140629.393972c7bd8b3b884507264c@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.11.1412181031520.2962@gentwo.org>
References: <alpine.DEB.2.11.1412181031520.2962@gentwo.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014 10:33:23 -0600 (CST) Christoph Lameter <cl@linux.com> wrote:

> This patch adds the basic infrastructure for alloc / free operations
> on pointer arrays.

Please provide the justification/reason for making this change.

> It includes a fallback function.

I don't know what this means.  Something to do with
_HAVE_SLAB_ALLOCATOR_OPERATIONS perhaps.

> Allocators must define _HAVE_SLAB_ALLOCATOR_OPERATIONS in their
> header files in order to implement their own fast version for
> these array operations.

Why?  What's driving this?

The changelog is far too skimpy, sorry.  It makes the patch
unreviewable.

> --- linux.orig/include/linux/slab.h	2014-12-16 09:27:26.369447763 -0600
> +++ linux/include/linux/slab.h	2014-12-18 10:30:33.394927526 -0600
> @@ -123,6 +123,7 @@ struct kmem_cache *memcg_create_kmem_cac
>  void kmem_cache_destroy(struct kmem_cache *);
>  int kmem_cache_shrink(struct kmem_cache *);
>  void kmem_cache_free(struct kmem_cache *, void *);
> +void kmem_cache_free_array(struct kmem_cache *, int, void **);

These declarations are much more useful if they include the argument
names.

> --- linux.orig/mm/slab_common.c	2014-12-12 10:27:49.360799479 -0600
> +++ linux/mm/slab_common.c	2014-12-18 10:25:41.695889129 -0600
> @@ -105,6 +105,31 @@ static inline int kmem_cache_sanity_chec
>  }
>  #endif
> 
> +#ifndef _HAVE_SLAB_ALLOCATOR_ARRAY_OPERATIONS
> +int kmem_cache_alloc_array(struct kmem_cache *s, gfp_t flags, int nr, void **p)
> +{
> +	int i;
> +
> +	for (i=0; i < nr; i++) {
> +		void *x = p[i] = kmem_cache_alloc(s, flags);
> +		if (!x)
> +			return i;
> +	}
> +	return nr;
> +}
> +EXPORT_SYMBOL(kmem_cache_alloc_array);

Please use checkpatch.

This function very much needs documentation.  Particularly concerning
the return value, and the caller's responsibility at cleanup time.

And that return value is weird.  What's the point in returning a
partial result?

Why is the memory exhaustion handling implemented this way rather than
zeroing out the rest of the array, so the caller doesn't have to
remember the return value for kmem_cache_free_array()?

> +void kmem_cache_free_array(struct kmem_cache *s, int nr, void **p)
> +{
> +	int i;
> +
> +	for (i=0; i < nr; i++)
> +		kmem_cache_free(s, p[i]);
> +}
> +EXPORT_SYMBOL(kmem_cache_free_array);

Possibly `nr' and `i' should be size_t, dunno.  They certainly don't
need to be signed.

