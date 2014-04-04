Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaDDLjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:39:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:65490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaDDLjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:39:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)
Date: Fri, 04 Apr 2014 13:39:33 +0200
Message-ID: <8799740.0uZJLUBGY1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1396610269-11580-1-git-send-email-daniel.thompson@linaro.org>
References: <1396610269-11580-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:d8EeYhR8OLQLNtCCPRjV995j7xr81fA72434rrEnCbn
 +qTjQBFW9PV2TRFd6u35xXqPd1gqHNFH3RRjp5Z8KkUieOq64o
 /0PzGRa9X5LV8rNvBDLOB5pbuKvpoTFtEkCzqFPT0prKxeelqT
 ZLPVcWpgBW0WcB+mtsJHEJxCnagjliZ4kXfK6GMstUVu86IcnZ
 enXljhAwreq9ig+nUymeN7Goy6B79k6YvTF2+49032gkEZqV5/
 bRhBYp95EnTaSxHLX8eD3fJlWNXarbrRdiuIMa9Z6i447UqGl+
 CNzIb1Nsmqonv79jtS1Xz6O1VVU9TOezBips0YAY2pgGPYiCIV
 3xK9M+7BBuBOT9z/O4+4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2014 12:17:49 Daniel Thompson wrote:
> When building a multi_v7_defconfig kernel it is not possible to configure
> DEBUG_LL to use any serial device except a ARM Primecell PL01X, or more
> accurately and worse, it is possible to configure a different serial
> device but KConfig does not honour this request.
> 
> The happens because the multi-platform mode may include ARCH_SPEAR13XX
> and this forcibly engages DEBUG_UART_PL01X to provide some kind of
> compatibility with single platform builds (SPEAr supports both single and
> multi-platform). This in turn causes DEBUG_LL_INCLUDE to wedge at
> debug/pl01x.S.
> 
> Problem is fixed by only deploying the compatibility options for SPEAr
> when ARCH_MULTIPLATFORM is not set.

The assumption is actually wrong: SPEAr does not support single
platform builds any more. The PLAT_SPEAR_SINGLE symbol in Kconfig
is a leftover from an earlier patch I did that never got merged,
and we should just remove that.

> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>  arch/arm/Kconfig.debug | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 0531da8..f10c784 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -991,9 +991,9 @@ config DEBUG_LL_INCLUDE
>  config DEBUG_UART_PL01X
>         def_bool ARCH_EP93XX || \
>                 ARCH_INTEGRATOR || \
> -               ARCH_SPEAR3XX || \
> -               ARCH_SPEAR6XX || \
> -               ARCH_SPEAR13XX || \
> +               (ARCH_SPEAR3XX && !ARCH_MULTIPLATFORM) || \
> +               (ARCH_SPEAR6XX && !ARCH_MULTIPLATFORM) || \
> +               (ARCH_SPEAR13XX && !ARCH_MULTIPLATFORM) || \
>                 ARCH_VERSATILE

Removing the SPEAR lines seems correct here, but the lines
you add don't make any sense.

	Arnd
