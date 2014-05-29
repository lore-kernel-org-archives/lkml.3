Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbaE2EyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:54:12 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48160 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450AbaE2EyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:54:09 -0400
Message-ID: <5386BD6A.7020509@linaro.org>
Date: Thu, 29 May 2014 13:54:02 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
CC: Wang Nan <wangnan0@huawei.com>, Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Geng Hui <hui.geng@huawei.com>
Subject: Re: [PATCH RESEND] ARM: kdump: 2nd kernel should use strict pfn_valid
 in SPARSEMEM platform
References: <1401266668-34365-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1401266668-34365-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin, Will

Can we assume that HAVE_ARCH_PFN_VALID is alway yes on arm64?
Looking at arm64/Kconfig,
config ARCH_HAS_HOLES_MEMORYMODEL
	def_bool y if SPARSEMEM
...
config HAVE_ARCH_PFN_VALID
	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM

is this intentional?

-Takahiro AKASHI

On 05/28/2014 05:44 PM, Wang Nan wrote:
> This patch removes an irrational limitation for crash dump kernel on ARM
> platform with SPARSEMEM enabled.
>
> Without this patch, crash reservation area for a crash dump kernel with
> SPARSEMEM selected must occupy a full section plus 1MiB. If not,
> elfcorehdr and some memory space used by the first kernel will unable to
> get accessed. This is caused by pfn_valid: fast pfn_valid ragards any
> pfn in a valid section as valid and prevents it to be ioremapped.
>
> This limitation wastes memory, because sections are always large and
> crash dump kernel should be as small as possible.
>
> This patch selects HAVE_ARCH_PFN_VALID for CRASH_DUMP, makes crash dump
> kernel to use strict version of pfn_valid().
>
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>
> This is the third time I post this patch. The previous records can be
> retrived from:
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/256498.html
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/257472.html
>
> Different from previous version, this patch select HAVE_ARCH_PFN_VALID
> right after CRASH_DUMP config entry.
>
> ---
>
>   arch/arm/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index c57ddcb..d5ffbb1 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -2160,6 +2160,7 @@ config ATAGS_PROC
>
>   config CRASH_DUMP
>   	bool "Build kdump crash kernel (EXPERIMENTAL)"
> +	select HAVE_ARCH_PFN_VALID if SPARSEMEM
>   	help
>   	  Generate crash dump after being started by kexec. This should
>   	  be normally only set in special crash dump kernels which are
>
