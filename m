Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbaLJQ4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:56:36 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53079 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaLJQ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:56:34 -0500
MIME-Version: 1.0
In-Reply-To: <20141210163033.841468065@linux.com>
References: <20141210163017.092096069@linux.com>
	<20141210163033.841468065@linux.com>
Date: Wed, 10 Dec 2014 18:56:33 +0200
X-Google-Sender-Auth: JMIv4vAOFXFbnNIoF2wiXgq9Mw8
Message-ID: <CAOJsxLG2vyY-c08_Jj+Nq+dUoRkiq1TGdpxPaAtDadWY_XBj6A@mail.gmail.com>
Subject: Re: [PATCH 4/7] slub: Avoid using the page struct address in
 allocation fastpath
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
> We can use virt_to_page there and only invoke the costly function if
> actually a node is specified and we have to check the NUMA locality.
>
> Increases the cost of allocating on a specific NUMA node but then that
> was never cheap since we may have to dump our caches and retrieve memory
> from the correct node.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
> Index: linux/mm/slub.c
> ===================================================================
> --- linux.orig/mm/slub.c        2014-12-09 12:27:49.414686959 -0600
> +++ linux/mm/slub.c     2014-12-09 12:27:49.414686959 -0600
> @@ -2097,6 +2097,15 @@ static inline int node_match(struct page
>         return 1;
>  }
>
> +static inline int node_match_ptr(void *p, int node)
> +{
> +#ifdef CONFIG_NUMA
> +       if (!p || (node != NUMA_NO_NODE && page_to_nid(virt_to_page(p)) != node))

You already test that object != NULL before calling node_match_ptr().

> +               return 0;
> +#endif
> +       return 1;
> +}
> +
>  #ifdef CONFIG_SLUB_DEBUG
>  static int count_free(struct page *page)
>  {
> @@ -2410,7 +2419,7 @@ redo:
>
>         object = c->freelist;
>         page = c->page;
> -       if (unlikely(!object || !node_match(page, node))) {
> +       if (unlikely(!object || !node_match_ptr(object, node))) {
>                 object = __slab_alloc(s, gfpflags, node, addr, c);
>                 stat(s, ALLOC_SLOWPATH);
>         } else {
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
