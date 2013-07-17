Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab3GQWjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:39:20 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:34357 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab3GQWjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:39:17 -0400
MIME-Version: 1.0
In-Reply-To: <1371465315.26299.17.camel@x61.thuisdomein>
References: <1371465315.26299.17.camel@x61.thuisdomein>
Date: Wed, 17 Jul 2013 15:39:15 -0700
X-Google-Sender-Auth: uUbJ-fdAUqHgSjuJ2fotBQSss3k
Message-ID: <CAA9_cmc9XWCvU=d2qu6rMaV+_sxBeMgrreZWU5ofzAd3dANT9w@mail.gmail.com>
Subject: Re: [PATCH] ioatdma: silence GCC warnings
From: Dan Williams <djbw@fb.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dave.jiang" <dave.jiang@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 3:35 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Building dma_v3.o triggers two GCC warnings:
>     drivers/dma/ioat/dma_v3.c: In function ‘__ioat3_prep_pq16_lock’:
>     drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
>     drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
>
> These warnings are caused by pq16_set_src(). It uses "int idx" as an
> index to an eight element array. Changing "idx" to unsigned int silences
> these warnings. Apparently GCC can then determine that "idx" will never
> be negative.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---

Seems this is fixed in gcc as of 4.7.2, but we can make things quieter
for build testers on older compilers.

> 0) Compile tested only.
>
> 1) These warning were introduced in v3.10-rc1. That must have been
> through commit 7727eaa449 ("ioatdma: Adding support for 16 src PQ ops
> and super extended descriptors").
>
>  drivers/dma/ioat/dma_v3.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index ca6ea9b..b5102da 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -251,7 +251,7 @@ static bool is_bwd_noraid(struct pci_dev *pdev)
>  }
>
>  static void pq16_set_src(struct ioat_raw_descriptor *desc[3],
> -                       dma_addr_t addr, u32 offset, u8 coef, int idx)
> +                       dma_addr_t addr, u32 offset, u8 coef, unsigned int idx)

"unsigned int" --> "unsigned"

>  {
>         struct ioat_pq_descriptor *pq = (struct ioat_pq_descriptor *)desc[0];
>         struct ioat_pq16a_descriptor *pq16 =

Just do this hunk as the minimal one line change.
