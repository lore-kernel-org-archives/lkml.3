Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaAQKtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:49:46 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:43625 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaAQKto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:49:44 -0500
MIME-Version: 1.0
In-Reply-To: <1389948399-26344-1-git-send-email-m.szyprowski@samsung.com>
References: <1389948399-26344-1-git-send-email-m.szyprowski@samsung.com>
Date: Fri, 17 Jan 2014 10:49:43 +0000
X-Google-Sender-Auth: fvAurSrxej6GCI83uvFBXnHI_GY
Message-ID: <CAAq6er2UNBibzKE==fQLROgFZDfdqZhJudcK=JtEYj_iA3sfnQ@mail.gmail.com>
Subject: Re: [PATCH] x86: dma-mapping: fix GFP_ATOMIC macro usage
From: Andy Whitcroft <apw@canonical.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 8:46 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
> flags and LACK of __GFP_WAIT flag. To check if caller wanted to perform an
> atomic allocation, the code must test __GFP_WAIT flag presence. This patch
> fixes the issue introduced in v3.5-rc1
>
> CC: stable@vger.kernel.org
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  arch/x86/kernel/pci-dma.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 872079a..32a81c9 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -100,7 +100,7 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
>         flag |= __GFP_ZERO;
>  again:
>         page = NULL;
> -       if (!(flag & GFP_ATOMIC))
> +       if (flag & __GFP_WAIT)

>From that description should this not actually be:

    if (!(flag & (GFP_ATOMIC|__GFP_WAIT) == GFP_ATOMIC))

Else we will start using this pool for more than __GFP_HIGH allocations?

That said, it is possible this is right and the intent was to allow
__GFP_HIGH allocations (in general) to use this contigious pool, but I
will let someone more intimate with the code comment to that.  I would
have hoped the code would have been as below in that case:

    if (!(flag & __GFP_HIGH))

Either way once this is resolved a nice comment should be added to
make it really clear:

-apw
