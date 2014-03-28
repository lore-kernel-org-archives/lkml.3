Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaC1Spn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:45:43 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47763 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaC1Spl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:45:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140323042050.GA15181@www.outflux.net>
References: <20140323042050.GA15181@www.outflux.net>
Date: Fri, 28 Mar 2014 11:45:41 -0700
Message-ID: <CAGXu5j+GokV1MKv4Otb0AGt4Xvm8WXMLaOvGUUX+BJpo7Myg9g@mail.gmail.com>
Subject: Re: [PATCH v4] ARM: mm: fix reporting of read-only PMD bits
From: Kees Cook <keescook@google.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>, Rob Herring <robherring2@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Steve Capper <steve.capper@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 9:20 PM, Kees Cook <keescook@chromium.org> wrote:
> On non-LPAE ARMv6+, read-only PMD bits are defined with the combination
> "PMD_SECT_APX | PMD_SECT_AP_WRITE". Adjusted the bit masks to correctly
> report this.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v4:
>  - clean up defines for CPU versions; Rob Herring.
> v3:
>  - check for pre-v6 CPUs on the page table report.
> v2:
>  - reorder bits, suggested by Olof.

Can anyone give this a test or ack? I've done build tests for all CPU
combinations, and runtime tests on v6 and LPAE.

Thanks!

-Kees

> ---
>  arch/arm/mm/dump.c |   47 ++++++++++++++++++++++++++++++++---------------
>  1 file changed, 32 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
> index ef69152f9b52..c508f41a43bc 100644
> --- a/arch/arm/mm/dump.c
> +++ b/arch/arm/mm/dump.c
> @@ -120,34 +120,51 @@ static const struct prot_bits pte_bits[] = {
>  };
>
>  static const struct prot_bits section_bits[] = {
> -#ifndef CONFIG_ARM_LPAE
> -       /* These are approximate */
> +#ifdef CONFIG_ARM_LPAE
> +       {
> +               .mask   = PMD_SECT_USER,
> +               .val    = PMD_SECT_USER,
> +               .set    = "USR",
> +       }, {
> +               .mask   = PMD_SECT_RDONLY,
> +               .val    = PMD_SECT_RDONLY,
> +               .set    = "ro",
> +               .clear  = "RW",
> +#elif __LINUX_ARM_ARCH__ >= 6
>         {
> -               .mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
> -               .val    = 0,
> +               .mask   = PMD_SECT_APX | PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
> +               .val    = PMD_SECT_APX | PMD_SECT_AP_WRITE,
>                 .set    = "    ro",
>         }, {
> -               .mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
> +               .mask   = PMD_SECT_APX | PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
>                 .val    = PMD_SECT_AP_WRITE,
>                 .set    = "    RW",
>         }, {
> -               .mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
> +               .mask   = PMD_SECT_APX | PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
>                 .val    = PMD_SECT_AP_READ,
>                 .set    = "USR ro",
>         }, {
> -               .mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
> +               .mask   = PMD_SECT_APX | PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
>                 .val    = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
>                 .set    = "USR RW",
> -#else
> +#else /* ARMv4/ARMv5  */
> +       /* These are approximate */
>         {
> -               .mask   = PMD_SECT_USER,
> -               .val    = PMD_SECT_USER,
> -               .set    = "USR",
> +               .mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
> +               .val    = 0,
> +               .set    = "    ro",
>         }, {
> -               .mask   = PMD_SECT_RDONLY,
> -               .val    = PMD_SECT_RDONLY,
> -               .set    = "ro",
> -               .clear  = "RW",
> +               .mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
> +               .val    = PMD_SECT_AP_WRITE,
> +               .set    = "    RW",
> +       }, {
> +               .mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
> +               .val    = PMD_SECT_AP_READ,
> +               .set    = "USR ro",
> +       }, {
> +               .mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
> +               .val    = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
> +               .set    = "USR RW",
>  #endif
>         }, {
>                 .mask   = PMD_SECT_XN,
> --
> 1.7.9.5
>
>
> --
> Kees Cook
> Chrome OS Security



-- 
Kees Cook
Chrome OS Security
