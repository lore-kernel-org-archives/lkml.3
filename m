Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbaLJQyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:54:49 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44280 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbaLJQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:54:48 -0500
MIME-Version: 1.0
In-Reply-To: <20141210163033.717707217@linux.com>
References: <20141210163017.092096069@linux.com>
	<20141210163033.717707217@linux.com>
Date: Wed, 10 Dec 2014 18:54:47 +0200
X-Google-Sender-Auth: dQaavqE4Iyrc5n6lfIo77q7_6lw
Message-ID: <CAOJsxLFEN_w7q6NvbxkH2KTujB9auLkQgskLnGtN9iBQ4hV9sw@mail.gmail.com>
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm <akpm@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 6:30 PM, Christoph Lameter <cl@linux.com> wrote:
> Avoid using the page struct address on free by just doing an
> address comparison. That is easily doable now that the page address
> is available in the page struct and we already have the page struct
> address of the object to be freed calculated.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
> Index: linux/mm/slub.c
> ===================================================================
> --- linux.orig/mm/slub.c        2014-12-09 12:25:45.770405462 -0600
> +++ linux/mm/slub.c     2014-12-09 12:25:45.766405582 -0600
> @@ -2625,6 +2625,13 @@ slab_empty:
>         discard_slab(s, page);
>  }
>
> +static bool same_slab_page(struct kmem_cache *s, struct page *page, void *p)

Why are you passing a pointer to struct kmem_cache here? You don't
seem to use it.

> +{
> +       long d = p - page->address;
> +
> +       return d > 0 && d < (1 << MAX_ORDER) && d < (compound_order(page) << PAGE_SHIFT);
> +}

Can you elaborate on what this is doing? I don't really understand it.

- Pekka
