Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab3C0Ssz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:48:55 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:37318 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab3C0Ssv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:48:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130326224309.15072.83839.stgit@djiang5-linux2.ch.intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
	<20130326224309.15072.83839.stgit@djiang5-linux2.ch.intel.com>
Date: Wed, 27 Mar 2013 11:48:50 -0700
X-Google-Sender-Auth: 9fn3lGzZnjXsRQcbS1uf45lNrtI
Message-ID: <CAA9_cmcAwp0g+ybe14Poxdi-7V=USbO8OCJJ++V1Dn0PUHKRKg@mail.gmail.com>
Subject: Re: [PATCH 06/10] ioatdma: Removing PQ val disable for cb3.3
From: Dan Williams <djbw@fb.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 3:43 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> The PQ Val ops work on the newer hardware so we should actually provide support
> for it and remove the disabling bits.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/dma/Kconfig          |    2 -
>  drivers/dma/ioat/dma.h       |    1
>  drivers/dma/ioat/dma_v3.c    |  134 ++++++++++++++++++++++++++++++++++++++----
>  drivers/dma/ioat/registers.h |    2 +
>  4 files changed, 125 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 80b6997..dec088d 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -63,8 +63,6 @@ config INTEL_IOATDMA
>         depends on PCI && X86
>         select DMA_ENGINE
>         select DCA
> -       select ASYNC_TX_DISABLE_PQ_VAL_DMA
> -       select ASYNC_TX_DISABLE_XOR_VAL_DMA
>         help
>           Enable support for the Intel(R) I/OAT DMA engine present
>           in recent Intel Xeon chipsets.
[..]
> @@ -1469,15 +1581,13 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
>         device->cleanup_fn = ioat3_cleanup_event;
>         device->timer_fn = ioat3_timer_event;
>
> -       #ifdef CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA
> -       dma_cap_clear(DMA_PQ_VAL, dma->cap_mask);
> -       dma->device_prep_dma_pq_val = NULL;
> -       #endif
> +       if (is_xeon_cb32(pdev)) {
> +               dma_cap_clear(DMA_XOR_VAL, dma->cap_mask);
> +               dma->device_prep_dma_xor_val = NULL;
>
> -       #ifdef CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA
> -       dma_cap_clear(DMA_XOR_VAL, dma->cap_mask);
> -       dma->device_prep_dma_xor_val = NULL;
> -       #endif
> +               dma_cap_clear(DMA_PQ_VAL, dma->cap_mask);
> +               dma->device_prep_dma_pq_val = NULL;
> +       }

Note that this effectively disables raid offload for is_xeon_cb32()
platforms since DMA_ASYNC_TX will not be set.
