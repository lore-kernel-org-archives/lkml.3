Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaGVEWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:22:00 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63114 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaGVEV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:21:59 -0400
MIME-Version: 1.0
In-Reply-To: <1405390206-5081-1-git-send-email-acourbot@nvidia.com>
References: <1405390206-5081-1-git-send-email-acourbot@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 22 Jul 2014 13:21:38 +0900
Message-ID: <CAAVeFuJFCQdRuuJ=WQAL65MMoWzPj03evGiXmfQh=2K7+i5Gdg@mail.gmail.com>
Subject: Re: [PATCH RESEND] drm/ttm: expose CPU address of DMA-allocated pages
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRM maintainers, could I have a comment about this patch? A bunch of
Nouveau changes depend on it.

Thanks,
Alex.

On Tue, Jul 15, 2014 at 11:10 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Pages allocated using the DMA API have a coherent memory mapping. Make
> this mapping visible to drivers so they can decide to use it instead of
> creating their own redundant one.
>
> This is not a mere optimization: for instance, on ARM it is illegal to
> have several memory mappings to the same memory with different protection.
> The mapping provided by dma_alloc_coherent() and exposed by this patch is
> guaranteed to be safe, but subsequent mappings performed by drivers are
> not. Thus drivers using the DMA page allocator should use this mapping
> instead of creating their own.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> This patch was previously part of a series but I figured it would make more
> sense to send it separately. It is to be used by Nouveau (and hopefully
> other drivers) on ARM.
>
>  drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 2 ++
>  drivers/gpu/drm/ttm/ttm_tt.c             | 6 +++++-
>  include/drm/ttm/ttm_bo_driver.h          | 2 ++
>  3 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> index fb8259f69839..0301fac5badd 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> @@ -847,6 +847,7 @@ static int ttm_dma_pool_get_pages(struct dma_pool *pool,
>         if (count) {
>                 d_page = list_first_entry(&pool->free_list, struct dma_page, page_list);
>                 ttm->pages[index] = d_page->p;
> +               ttm_dma->cpu_address[index] = d_page->vaddr;
>                 ttm_dma->dma_address[index] = d_page->dma;
>                 list_move_tail(&d_page->page_list, &ttm_dma->pages_list);
>                 r = 0;
> @@ -978,6 +979,7 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
>         INIT_LIST_HEAD(&ttm_dma->pages_list);
>         for (i = 0; i < ttm->num_pages; i++) {
>                 ttm->pages[i] = NULL;
> +               ttm_dma->cpu_address[i] = 0;
>                 ttm_dma->dma_address[i] = 0;
>         }
>
> diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
> index 75f319090043..341594ede596 100644
> --- a/drivers/gpu/drm/ttm/ttm_tt.c
> +++ b/drivers/gpu/drm/ttm/ttm_tt.c
> @@ -58,6 +58,8 @@ static void ttm_dma_tt_alloc_page_directory(struct ttm_dma_tt *ttm)
>         ttm->ttm.pages = drm_calloc_large(ttm->ttm.num_pages, sizeof(void*));
>         ttm->dma_address = drm_calloc_large(ttm->ttm.num_pages,
>                                             sizeof(*ttm->dma_address));
> +       ttm->cpu_address = drm_calloc_large(ttm->ttm.num_pages,
> +                                           sizeof(*ttm->cpu_address));
>  }
>
>  #ifdef CONFIG_X86
> @@ -228,7 +230,7 @@ int ttm_dma_tt_init(struct ttm_dma_tt *ttm_dma, struct ttm_bo_device *bdev,
>
>         INIT_LIST_HEAD(&ttm_dma->pages_list);
>         ttm_dma_tt_alloc_page_directory(ttm_dma);
> -       if (!ttm->pages || !ttm_dma->dma_address) {
> +       if (!ttm->pages || !ttm_dma->dma_address || !ttm_dma->cpu_address) {
>                 ttm_tt_destroy(ttm);
>                 pr_err("Failed allocating page table\n");
>                 return -ENOMEM;
> @@ -243,6 +245,8 @@ void ttm_dma_tt_fini(struct ttm_dma_tt *ttm_dma)
>
>         drm_free_large(ttm->pages);
>         ttm->pages = NULL;
> +       drm_free_large(ttm_dma->cpu_address);
> +       ttm_dma->cpu_address = NULL;
>         drm_free_large(ttm_dma->dma_address);
>         ttm_dma->dma_address = NULL;
>  }
> diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
> index 202f0a7171e8..1d9f0f1ff52d 100644
> --- a/include/drm/ttm/ttm_bo_driver.h
> +++ b/include/drm/ttm/ttm_bo_driver.h
> @@ -133,6 +133,7 @@ struct ttm_tt {
>   * struct ttm_dma_tt
>   *
>   * @ttm: Base ttm_tt struct.
> + * @cpu_address: The CPU address of the pages
>   * @dma_address: The DMA (bus) addresses of the pages
>   * @pages_list: used by some page allocation backend
>   *
> @@ -142,6 +143,7 @@ struct ttm_tt {
>   */
>  struct ttm_dma_tt {
>         struct ttm_tt ttm;
> +       void **cpu_address;
>         dma_addr_t *dma_address;
>         struct list_head pages_list;
>  };
> --
> 2.0.1
>
