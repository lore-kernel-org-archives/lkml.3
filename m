Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaKEVss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:48:48 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37499 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaKEVsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:48:45 -0500
Date: Wed, 5 Nov 2014 13:48:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH] mm: slub: fix format mismatches in slab_err() callers
In-Reply-To: <1415200341-9619-1-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.10.1411051344490.31575@chino.kir.corp.google.com>
References: <1415200341-9619-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-382633830-1415224123=:31575"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-382633830-1415224123=:31575
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 5 Nov 2014, Andrey Ryabinin wrote:

> Adding __printf(3, 4) to slab_err exposed following:
> 
> mm/slub.c: In function ‘check_slab’:
> mm/slub.c:852:4: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘const char *’ [-Wformat=]
>     s->name, page->objects, maxobj);
>     ^
> mm/slub.c:852:4: warning: too many arguments for format [-Wformat-extra-args]
> mm/slub.c:857:4: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘const char *’ [-Wformat=]
>     s->name, page->inuse, page->objects);
>     ^
> mm/slub.c:857:4: warning: too many arguments for format [-Wformat-extra-args]
> 

Wow, that's an ancient issue, thanks for finding it.

> mm/slub.c: In function ‘on_freelist’:
> mm/slub.c:905:4: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘long unsigned int’ [-Wformat=]
>     "should be %d", page->objects, max_objects);
> 
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  mm/slub.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 80c170e..850a94a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -849,12 +849,12 @@ static int check_slab(struct kmem_cache *s, struct page *page)
>  	maxobj = order_objects(compound_order(page), s->size, s->reserved);
>  	if (page->objects > maxobj) {
>  		slab_err(s, page, "objects %u > max %u",
> -			s->name, page->objects, maxobj);
> +			page->objects, maxobj);
>  		return 0;
>  	}
>  	if (page->inuse > page->objects) {
>  		slab_err(s, page, "inuse %u > max %u",
> -			s->name, page->inuse, page->objects);
> +			page->inuse, page->objects);
>  		return 0;
>  	}
>  	/* Slab_pad_check fixes things up after itself */
> @@ -902,7 +902,7 @@ static int on_freelist(struct kmem_cache *s, struct page *page, void *search)
>  
>  	if (page->objects != max_objects) {
>  		slab_err(s, page, "Wrong number of objects. Found %d but "
> -			"should be %d", page->objects, max_objects);
> +			"should be %ld", page->objects, max_objects);
>  		page->objects = max_objects;
>  		slab_fix(s, "Number of objects adjusted.");
>  	}

Instead of this hunk, I think that max_objects should be declared as int 
rather than unsigned long since that's what order_objects() returns and it 
is being compared to page->objects which is also int.
--531381512-382633830-1415224123=:31575--
